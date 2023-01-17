<cf_get_lang_set module_name="product"><!--- sayfanin en altinda kapanisi var --->
<cf_xml_page_edit fuseaction="product.popup_form_upd_product_cost">
<cfquery name="get_product_cost" datasource="#dsn3#">
	SELECT * FROM PRODUCT_COST WHERE PRODUCT_COST_ID = <cfqueryparam value="#attributes.pcid#">
</cfquery>
<cfif not get_product_cost.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='60518.Kayıtlı bir maliyet bulunamadı'>");
		window.close;
	</script>
	<cfabort>
</cfif>
<!--- maliyet için bir fiyat koruma yapıldı mı --->
<cfquery name="get_comparison" datasource="#dsn2#">
	SELECT CONTRACT_COMPARISON_ROW_ID, COMPANY_ID FROM INVOICE_CONTRACT_COMPARISON WHERE COST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pcid#">
</cfquery>

<!--- hangi belge ise o belgeden kur bilgilerini alıyor --->
<cfquery name="get_per" datasource="#dsn#">
	SELECT PERIOD_YEAR, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_cost.action_period_id#">
</cfquery>
<cfset per_dsn='#dsn#_#get_per.PERIOD_YEAR#_#get_per.OUR_COMPANY_ID#'>
<cfif get_product_cost.action_type eq 1>
	<cfquery name="get_money" datasource="#per_dsn#">
		SELECT RATE1, RATE2, MONEY_TYPE MONEY FROM INVOICE_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_cost.action_id#">
	</cfquery>
<cfelseif get_product_cost.action_type eq 2>
	<cfquery name="get_money" datasource="#per_dsn#">
		SELECT  RATE1, RATE2, MONEY_TYPE MONEY FROM SHIP_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_cost.action_id#">
	</cfquery>
<cfelseif get_product_cost.action_type eq 3>
	<cfquery name="get_money" datasource="#per_dsn#">
		SELECT RATE1, RATE2, MONEY_TYPE MONEY FROM STOCK_FIS_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_cost.action_id#">
	</cfquery>
<cfelse>
	<cfquery name="get_money_history" datasource="#dsn#">
		SELECT RATE2, RATE1, MONEY, VALIDATE_DATE, MONEY_HISTORY_ID FROM MONEY_HISTORY WHERE VALIDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDate(get_product_cost.start_date)#">
	</cfquery>
</cfif>
<cfif not isdefined('get_money') or not get_money.recordcount>
	<cfinclude template="../query/get_money.cfm">
</cfif>
<cfif get_money.recordcount>
	<cfset rate=get_money.rate2/get_money.rate1>
<cfelse>
	<cfset rate=1>
</cfif>
<cfquery name="get_unit" datasource="#dsn#">
	SELECT UNIT FROM SETUP_UNIT WHERE UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_cost.unit_id#">
</cfquery>
<cfoutput query="get_money">
	<cfif isdefined('get_money_history')>
		<cfquery name="get_mny" dbtype="query" maxrows="1">
			SELECT 
				RATE2,
				RATE1
			FROM 
				GET_MONEY_HISTORY
			WHERE
				VALIDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDate(get_product_cost.start_date)#"> AND
				MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MONEY#"> AND
				RATE2 IS NOT NULL
			ORDER BY 
				VALIDATE_DATE DESC,
				MONEY_HISTORY_ID DESC
		</cfquery>
		<cfset rate2_=get_mny.rate2>
		<cfset rate1_=get_mny.rate1>
	</cfif>
	<cfif not isdefined('get_money_history') or not get_mny.recordcount>
		<cfset rate2_=rate2>
		<cfset rate1_=rate1>
	</cfif>
	<cfset "money_#money#" = "#wrk_round(rate2_/rate1_,4)#">
</cfoutput>
<cfquery name="get_stock" datasource="#dsn3#">
	SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_cost.product_id#">
</cfquery>
<cfscript>
	department_id = GET_PRODUCT_COST.DEPARTMENT_ID;
	location_id = GET_PRODUCT_COST.LOCATION_ID;
	spec_main_id = GET_PRODUCT_COST.SPECT_MAIN_ID;
	if(fusebox.circuit is 'product')
	{
		total_maliyet = GET_PRODUCT_COST.PRODUCT_COST;
		total_maliyet_money = GET_PRODUCT_COST.MONEY;
		reference_money = GET_PRODUCT_COST.PURCHASE_NET_MONEY;
		alis_net_fiyat = GET_PRODUCT_COST.PURCHASE_NET;
		alis_net_fiyat_money = "#reference_money#";
		alis_net_fiyat2 = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM;
		alis_net_fiyat2_money = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY;
		alis_ek_maliyet = GET_PRODUCT_COST.PURCHASE_EXTRA_COST;
		alis_ek_maliyet2 = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM;
		alis_net_fiyat2_loc = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM;
		alis_ek_maliyet_money = "#reference_money#";
		son_st_maliyet = get_product_cost.STANDARD_COST;
		son_st_maliyet_money = get_product_cost.STANDARD_COST_MONEY;
		son_st_maliyet_oran = get_product_cost.STANDARD_COST_RATE;
		mevcut_stok = GET_PRODUCT_COST.AVAILABLE_STOCK;
		partner_stok = GET_PRODUCT_COST.PARTNER_STOCK;
		yoldaki_stok = GET_PRODUCT_COST.ACTIVE_STOCK;
		fiyat_koruma = GET_PRODUCT_COST.PRICE_PROTECTION;
		fiyat_koruma_money = GET_PRODUCT_COST.PRICE_PROTECTION_MONEY;
		fiyat_koruma_loc = GET_PRODUCT_COST.PRICE_PROTECTION_LOCATION;
		fiyat_koruma_money_loc = GET_PRODUCT_COST.PRICE_PROTECTION_MONEY_LOCATION;
		fiziksel_yas = get_product_cost.PHYSICAL_DATE;
		finansal_yas = get_product_cost.DUE_DATE;
	}
	else
	{
		total_maliyet = GET_PRODUCT_COST.PRODUCT_COST_LOCATION;
		total_maliyet_money = GET_PRODUCT_COST.MONEY_LOCATION;
		reference_money=GET_PRODUCT_COST.PURCHASE_NET_MONEY_LOCATION;
		alis_net_fiyat = GET_PRODUCT_COST.PURCHASE_NET_LOCATION;
		alis_net_fiyat_money = "#reference_money#";
		alis_net_fiyat2 = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_LOCATION;
		alis_net_fiyat2_money = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_LOCATION;
		alis_ek_maliyet = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_LOCATION;
		alis_ek_maliyet2 = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_LOCATION;
		alis_net_fiyat2_loc = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_LOCATION;
		alis_ek_maliyet_money = "#reference_money#";
		son_st_maliyet = get_product_cost.STANDARD_COST_LOCATION;
		son_st_maliyet_money = get_product_cost.STANDARD_COST_MONEY_LOCATION;
		son_st_maliyet_oran = get_product_cost.STANDARD_COST_RATE_LOCATION;
		mevcut_stok = GET_PRODUCT_COST.AVAILABLE_STOCK_LOCATION;
		partner_stok = GET_PRODUCT_COST.PARTNER_STOCK_LOCATION;
		yoldaki_stok = GET_PRODUCT_COST.ACTIVE_STOCK_LOCATION;
		fiyat_koruma = GET_PRODUCT_COST.PRICE_PROTECTION_LOCATION;
		fiyat_koruma_money = GET_PRODUCT_COST.PRICE_PROTECTION_MONEY_LOCATION;
		fiziksel_yas = get_product_cost.PHYSICAL_DATE_LOCATION;
		finansal_yas = get_product_cost.DUE_DATE_LOCATION;
	}
</cfscript>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37525.Maliyet Güncelle'></cfsavecontent>
<cfsavecontent variable="message2"><cf_get_lang dictionary_id='58601.Bazında '> <cf_get_lang dictionary_id='57487.No'></cfsavecontent>
	
<cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform action="#request.self#?fuseaction=#fusebox.Circuit#.emptypopup_upd_product_cost" method="post" name="product_cost2">
<cf_box_elements>
	<cfoutput>
	<input type="hidden" name="cost_control" id="cost_control" value="0">
	<input type="hidden" name="pcid" id="pcid" value="#get_product_cost.product_cost_id#">
	<input type="hidden" name="product_id" id="product_id" value="#get_product_cost.product_id#">
	<input type="hidden" name="unit_id" id="unit_id" value="#get_product_cost.unit_id#">
	<input type="hidden" name="action_id" id="action_id" value="#get_product_cost.action_id#">
	<input type="hidden" name="action_type" id="action_type" value="#get_product_cost.action_type#"><!--- 1: FATURA, 2: İRSALİYE,3: STOK FİŞ, 4: ÜRETİM --->
	<input type="hidden" name="action_period_id" id="action_period_id" value="#get_product_cost.action_period_id#">
	<input type="hidden" name="start_date" id="start_date" value="">
	<input type="hidden" name="due_date" id="due_date" value="">
	<input type="hidden" name="physical_date" id="physical_date" value="">
    <input type="hidden" name="round_number" id="round_number" value="<cfoutput>#round_number#</cfoutput>">
	<cfloop query="get_money">
		<input type="hidden" name="money_#money#" id="money_#money#" value="#wrk_round(evaluate('money_#money#'),round_number)#">
	</cfloop>
	<input type="hidden" name="reference_money" id="reference_money" value="#get_product_cost.money#">
	</cfoutput>
    	<div class="row">
        	<div class="col col-12 uniqueRow">
            	<div class="row">
                	<div class="row" type="row">
                    	<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        	<div class="form-group" id="item-start_date2">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
                                    	<!---<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Baslangic Tarihi Girmelisiniz'></cfsavecontent>--->
										<cfinput type="text" name="start_date2" value="#dateformat(get_product_cost.START_DATE,dateformat_style)#" readonly required="Yes" validate="#validate_style#" onBlur="return(get_stock2());">
                                    	<span class="input-group-addon"><cf_wrk_date_image date_field="start_date2" call_function="get_stock2"></span>
                                    </div>
                            	</div>
                            </div>
                            <div class="form-group" id="item-process">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                                <div class="col col-8 col-xs-12">
                                	<cfif len(GET_PRODUCT_COST.PROCESS_STAGE)>
									<cf_workcube_process is_upd='0' select_value='#GET_PRODUCT_COST.PROCESS_STAGE#' process_cat_width='149' is_detail='1'>
									<cfelse>
									-
									</cfif>
                            	</div>
                            </div>
                            <div class="form-group" id="item-inventory_calc_type">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37510.Envanter Yöntemi'></label>
                                <div class="col col-8 col-xs-12">
									<select name="inventory_calc_type" id="inventory_calc_type"  style="width:149px;" disabled>
										<option value="1"<cfif get_product_cost.inventory_calc_type eq 1> selected</cfif>><cf_get_lang dictionary_id='37080.İlk Giren İlk Çıkar'></option><!--- 1:fifo --->
										<option value="3"<cfif get_product_cost.inventory_calc_type eq 3> selected</cfif>><cf_get_lang dictionary_id='37082.Ağırlıklı Ortalama'></option><!--- 3:gpa --->
									</select>	
                            	</div>
                            </div>
                            <div class="form-group" id="item-spect_name">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57647.Spec'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
                                    	<cfif len(spec_main_id)>
											<cfquery name="GET_SPECT_MAIN_NAME" datasource="#dsn3#">
												SELECT SPECT_MAIN_ID, SPECT_MAIN_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#spec_main_id#">
											</cfquery>
										</cfif>
										<input type="hidden" name="spect_main_id" id="spect_main_id" value="<cfoutput>#spec_main_id#</cfoutput>">
										<input type="text" name="spect_name" id="spect_name" value="<cfif isdefined("GET_SPECT_MAIN_NAME")><cfoutput>#GET_SPECT_MAIN_NAME.SPECT_MAIN_NAME#</cfoutput></cfif>" style="width:150px;">
                                    	<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="open_spec_popup2();"></span>
                                    </div>
                            	</div>
                            </div>
                            <div class="form-group" id="item-td_company">
	                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
	                            <div class="col col-8 col-xs-12">
	                                <div class="input-group">
							            <input type="hidden" name="td_company_id" id="td_company_id" value="<cfif GET_COMPARISON.RECORDCOUNT and len(GET_COMPARISON.COMPANY_ID)><cfoutput>#GET_COMPARISON.COMPANY_ID#</cfoutput></cfif>">
										<input type="text" name="td_company" id="td_company" style="width:150px;" value="<cfif GET_COMPARISON.RECORDCOUNT and len(GET_COMPARISON.COMPANY_ID)><cfoutput>#get_par_info(GET_COMPARISON.COMPANY_ID,1,1,0)#</cfoutput></cfif>">
										<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=product_cost2.td_company&field_comp_id=product_cost2.td_company_id&select_list=2&keyword='+encodeURIComponent(document.product_cost2.td_company.value),'list');"></span>
                                	</div>
                            	</div>
                        	</div>
                            <div class="form-group" id="item-cost_description">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                <div class="col col-8 col-xs-12">
                                	<textarea style="width:150px; height:50px" name="cost_description" id="cost_description"><cfoutput>#get_product_cost.cost_description#</cfoutput></textarea>
                            	</div>
                            </div>
          				</div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        	<div class="form-group" id="item-standard_cost">
	                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37511.Sabit Maliyet'></label>
									<span class="input-group-addon no-bg bold col col-4 text-right"><cfoutput>#tlformat(get_product_cost.standard_cost,round_number)# #get_product_cost.standard_cost_money#</cfoutput></span>
	                                <div class="input-group col col-5 col-xs-12">
                                    	<input type="text" name="standard_cost" id="standard_cost" class="moneybox" style="width:91px" onkeyup='return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));' onBlur="hesapla2();" value="<cfoutput>#tlformat(son_st_maliyet,round_number)#</cfoutput>"> 
	                                    <span class="input-group-addon width">
                                        <select name="standard_cost_money" id="standard_cost_money" onBlur="hesapla2();" style="width:55px;">
											<cfoutput query="get_money">
												<option value="#money#" <cfif son_st_maliyet_money eq money>selected</cfif>>#money#</option>
											</cfoutput>
										</select>
                                        </span>
                                	</div>
                        	</div>
                            <div class="form-group" id="item-standard_cost_rate">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37513.Sabit Maliyet Oran'> % </label>
									<span class="input-group-addon no-bg bold col col-4 text-right"><cfoutput>#tlformat(get_product_cost.standard_cost_rate)#</cfoutput></span>
                                <div class="input-group col col-5 col-xs-12">
                                    	<input type="text" style="width:91px" name="standard_cost_rate" id="standard_cost_rate" class="moneybox" onkeyup='return(FormatCurrency(this,event));' onBlur="hesapla2();" value="<cfoutput>#tlformat(son_st_maliyet_oran)#</cfoutput>">
                            	</div>
                            </div>
                            <div class="form-group" id="item-purchase_net">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37515.Alışlardan Net Maliyet'></label>
									<span class="input-group-addon no-bg bold col col-4 text-right"><cfoutput> #tlformat(alis_net_fiyat,4)# #alis_net_fiyat_money#</cfoutput></span>
									<div class="col col-5 col-xs-12 input-group">
                                    	<input type="hidden" name="old_purchase_net" id="old_purchase_net" value="<cfoutput>#tlformat(alis_net_fiyat,round_number)#</cfoutput>"><!--- get_product_cost.purchase_net ---> 
										<input type="hidden" name="old_purchase_net_money" id="old_purchase_net_money" value="<cfoutput>#alis_net_fiyat_money#</cfoutput>">
										<input type="text" name="purchase_net" id="purchase_net" class="moneybox" style="width:91px" onkeyup='return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));' onBlur="hesapla2();" value="<cfoutput>#tlformat(alis_net_fiyat,round_number)#</cfoutput>"><!--- get_product_cost.purchase_net --->
	                                    <span class="input-group-addon width">
                                        	<select name="purchase_net_money" id="purchase_net_money" onBlur="hesapla2();" style="width:55px;">
											<cfoutput query="get_money">
												<option value="#money#" <cfif alis_net_fiyat_money eq money>selected</cfif>>#money#</option>
											</cfoutput>
											</select>
                                        </span>
                            	</div>
                            </div>
                            <div class="form-group" id="item-purchase_extra_cost">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37517.Alışlardan Ek Maliyet'></label>
									<label class="input-group-addon no-bg bold col col-4 text-right"><cfoutput>#tlformat(alis_ek_maliyet,round_number)# #alis_net_fiyat_money#</cfoutput></label>
									<div class="col col-5 col-xs-12 input-group">
                                    	<input type="hidden" name="old_purchase_extra_cost" id="old_purchase_extra_cost" value="<cfoutput>#tlformat(alis_ek_maliyet,round_number)#</cfoutput>">
										<input type="text" name="purchase_extra_cost" id="purchase_extra_cost" class="moneybox" style="width:91px" onkeyup='return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));' onBlur="hesapla2();" value="<cfoutput>#tlformat(wrk_round(alis_ek_maliyet,round_number,1),round_number)#</cfoutput>"><!--- get_product_cost.purchase_extra_cost --->
                            	</div>
                            </div>
                            <div class="form-group" id="item-purchase_net_system">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37572.Sistem Maliyet'></label>
									<label class="input-group-addon no-bg bold col col-4 text-right"></label>
                                <div class="col col-5 col-xs-12 input-group">
                                    	<input type="text" name="purchase_net_system" id="purchase_net_system" value="<cfoutput>#tlformat(alis_net_fiyat2,round_number)#</cfoutput>" class="moneybox" style="width:91px">
	                                    <span class="input-group-addon width">
                                        	<select name="purchase_net_system_money" id="purchase_net_system_money" disabled="disabled" style="width:55px;">
												<option value="<cfoutput>#alis_net_fiyat2_money#</cfoutput>"><cfoutput>#alis_net_fiyat2_money#</cfoutput></option>								
											</select>
											<input type="hidden" name="purchase_net_system_location" id="purchase_net_system_location" value="<cfoutput>#tlformat(alis_net_fiyat2_loc,round_number)#</cfoutput>">
                                        </span>
                                	</div>
                            </div>
                            <div class="form-group" id="item-purchase_net_system">
                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37573.Sistem Ekstra Maliyet'></label>
								<label class="col col-4"></label>
                                   <div class="input-group col col-5">
                                    	<input type="text" name="purchase_extra_cost_system" id="purchase_extra_cost_system" value="<cfoutput>#tlformat(wrk_round(alis_ek_maliyet2,round_number,1),round_number)#</cfoutput>" class="moneybox"  readonly="yes">
                                	</div>
                            </div>
                            <div class="form-group" id="item-product_cost_">
	                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37497.Toplam Maliyet'></label>
									<label class="input-group-addon no-bg bold col col-4 text-right"><cfoutput>#tlformat(total_maliyet,4)# #total_maliyet_money#</cfoutput></label>
	                            <div class="col col-5 col-xs-12 input-group">
                                    	<input type="text" name="product_cost_" id="product_cost_" style="width:91px" class="moneybox" onkeyup='return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));' readonly="yes" value="<cfoutput>#tlformat(total_maliyet,round_number)#</cfoutput>"> 
	                                    <span class="input-group-addon width">
                                        <select name="product_cost_money" id="product_cost_money" disabled  style="width:55px;">
											<option value="<cfoutput>#total_maliyet_money#</cfoutput>"><cfoutput>#total_maliyet_money#</cfoutput></option>								
										</select>
                                        </span>
                            	</div>
                        	</div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        	<div class="form-group" id="item-department_id">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'></label>
                                <div class="col col-8 col-xs-12">
                                	<cfif len(department_id)>
							<cfquery name="get_department" datasource="#dsn#">
								SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_id#">
							</cfquery>
							<cfif len(location_id)>
								<cfquery name="get_location" datasource="#dsn#">
									SELECT COMMENT FROM STOCKS_LOCATION WHERE LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#location_id#"> AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_id#">
								</cfquery>
							</cfif>
						</cfif>
						<cfif len(department_id)>
							<cf_wrkdepartmentlocation 
								returnInputValue = "location_id,department,department_id"
								returnQueryValue = "LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
								fieldName = "department"
								fieldId = "location_id"
								department_fldId = "department_id"
								department_id = "#department_id#"
								location_id="#location_id#"
								location_name = "#GET_DEPARTMENT.DEPARTMENT_HEAD#- #GET_LOCATION.COMMENT#"
								user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
								user_location = "0"
								width="90">
						<cfelse>
							<cf_wrkdepartmentlocation 
                                returnInputValue="location_id,department,department_id"
                                returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                                fieldName="department"
                                fieldid="location_id"
                                department_fldId="department_id"
                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                width="90">
						</cfif>
                            	</div>
                            </div>
                            <div class="form-group" id="item-available_stock">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37512.Mevcut Stok'></label>
                                <div class="col col-8 col-xs-12">
                                	<input type="text" style="width:90px" name="available_stock" id="available_stock" class="moneybox" onkeyup='return(FormatCurrency(this,event));' value="<cfoutput>#tlformat(mevcut_stok)#</cfoutput>" onblur="stock_total2();">
                            	</div>
                            </div>
                            <div class="form-group" id="item-partner_stock">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37514.İş Ortakları Stoğu'></label>
                                <div class="col col-8 col-xs-12">
                                	<input type="text" style="width:90px" name="partner_stock" id="partner_stock" class="moneybox" onkeyup='return(FormatCurrency(this,event));' value="<cfoutput>#tlformat(partner_stok)#</cfoutput>" onblur="stock_total2();">
                            	</div>
                            </div>
                            <div class="form-group" id="item-active_stock">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58047.Yoldaki Stok'></label>
                                <div class="col col-8 col-xs-12">
                                	<input type="text" style="width:90px" name="active_stock" id="active_stock" class="moneybox" onkeyup='return(FormatCurrency(this,event));' value="<cfoutput>#tlformat(yoldaki_stok)#</cfoutput>" onblur="stock_total2();">
                            	</div>
                            </div>
                            <div class="form-group" id="item-total_stock">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29512.Toplam Stok'></label>
                                <div class="col col-8 col-xs-12">
                                	<input type="text" style="width:90px" name="total_stock" id="total_stock" class="moneybox" value="" readonly>
                            	</div>
                            </div>
                            <div class="form-group" id="item-due_date2">
	                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37615.Finansal Yaş'></label>
	                            <div class="col col-8 col-xs-12">
	                                <div class="input-group">
	                                    <!---<cfsavecontent variable="message"><cf_get_lang dictionary_id ='37724.Finansal Yaş İçin Tarih Giriniz'></cfsavecontent>--->
										<cfinput type="text" name="due_date2" value="#dateformat(finansal_yas,dateformat_style)#" validate="#validate_style#">
	                                    <span class="input-group-addon"><cf_wrk_date_image date_field="due_date2"></span>
                                	</div>
                            	</div>
                        	</div>
                            <div class="form-group" id="item-physical_date2">
	                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37616.Fiziksel Yaş'></label>
	                            <div class="col col-8 col-xs-12">
	                                <div class="input-group">
                                    	<!---<cfsavecontent variable="message"><cf_get_lang dictionary_id ='37724.Finansal Yaş İçin Tarih Giriniz'></cfsavecontent>--->
										<cfinput type="text" name="physical_date2" value="#dateformat(fiziksel_yas,dateformat_style)#" validate="#validate_style#">
	                                    <span class="input-group-addon"><cf_wrk_date_image date_field="physical_date2"></span>
                                	</div>
                            	</div>
                        	</div>
                        </div>
        			</div>
        		</div>
        	</div>
        </div>
			
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='37617.Maliyet Düzenleme Kriterleri'></cfsavecontent>
           <cf_seperator id="maliyet_duzenleme_kriterleri_" header="#message#">
			<div id="maliyet_duzenleme_kriterleri_" class="col col-12">
	          
					            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					                <div class="form-group" id="item-price_prot_amount">
		                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57635.Miktar'><cf_get_lang dictionary_id='57636.Birim'>*</label>
		                                <div class="col col-8 col-xs-12">
											<input type="text" name="price_prot_amount" id="price_prot_amount" style="width:90px;" value="<cfoutput>#TLFormat(GET_PRODUCT_COST.PRICE_PROTECTION_AMOUNT)#</cfoutput>" onblur="total_price_protection_hesapla2(2)" class="moneybox" onkeyup='return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));'>
		                            	</div>
		                            </div>
	                            	<div class="form-group" id="item-price_protection_type">
		                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37620.Hesaplama Yöntemi'></label>
		                                <div class="col col-8 col-xs-12">
											<select name="price_protection_type" id="price_protection_type" style="width:90px" onchange="hesapla2();">
												<option value="1" <cfif get_product_cost.price_protection_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='37622.Azalt'></option><!--- zaten hesaplamada cıkarma yaptığı için -1 artırda--->
												<option value="-1" <cfif get_product_cost.price_protection_type eq -1>selected</cfif>><cf_get_lang dictionary_id ='37623.Artır'></option>
											</select>	
		                            	</div>
		                            </div>
					            </div>
	                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					                <div class="form-group" id="item-price_protection">
			                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37618.Birim Tutar'></label>
											<label class="col col-4 input-group-addon no-bg bold text-right"><cfoutput>#tlformat(fiyat_koruma,round_number)# #fiyat_koruma_money#</cfoutput></label>
			                            <div class="form-group col-5 col-xs-12">
			                                <div class="input-group">
		                                    	<input type="text" name="price_protection" id="price_protection" class="moneybox" style="width:91px" onkeyup='return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));' onBlur="total_price_protection_hesapla(3);hesapla2();" value="<cfoutput>#tlformat(fiyat_koruma,round_number)#</cfoutput>"> 
			                                    <span class="input-group-addon width">
		                                        <select name="price_protection_money" id="price_protection_money" onBlur="hesapla2();" style="width:55px;">
												<cfoutput query="get_money">
													<option value="#money#" <cfif fiyat_koruma_money eq money>selected</cfif>>#money#</option>
												</cfoutput>
												</select>
		                                        </span>
		                                	</div>
		                            	</div>
	                        		</div>
					                <div class="form-group" id="item-COST_TYPE ">
		                            	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37658.Düzenleme Tipi'></label>
											<label class="no-bg bold input-group-addon col col-4 text-right"><cfoutput>#tlformat(get_product_cost.standard_cost_rate)#</cfoutput></label>
											<div class="input-group col col-5" id="item-COST_TYPE ">
											<select name="cost_type" id="cost_type" >
													<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
													<cfquery name="GET_COST_TYPE" datasource="#dsn#">
														SELECT COST_TYPE_ID,COST_TYPE_NAME FROM SETUP_COST_TYPE 
													</cfquery>
													<cfoutput query="GET_COST_TYPE">
														<option value="#COST_TYPE_ID#" <cfif COST_TYPE_ID eq get_product_cost.COST_TYPE_ID>selected</cfif>>#COST_TYPE_NAME#</option>
													</cfoutput>
												</select>
		                            	</div>
		                            </div>
					            </div>
					            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					                <div class="form-group" id="item-total_price_prot">
		                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29534.Toplam Tutar'></label>
		                                <div class="col col-8 col-xs-12">
		                                    <input type="text" name="total_price_prot" id="total_price_prot" style="width:91px;" value="<cfoutput>#TLFormat(GET_PRODUCT_COST.PRICE_PROTECTION_TOTAL)#</cfoutput>" onblur="total_price_protection_hesapla2(1)" class="moneybox" onkeyup='return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));'>
		                            	</div>
		                            </div>
	                                <cfif fusebox.Circuit eq 'product'>
	                                <div class="form-group" id="item-price_protection_location">
			                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37649.Lokasyon Fiyat Koruma'></label>
			                            <div class="col col-8 col-xs-12">
			                                <div class="input-group">
		                                    	<input type="text" name="price_protection_location" id="price_protection_location" style="width:91px" class="moneybox" onkeyup='return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));' value="<cfoutput>#tlformat(fiyat_koruma_loc,round_number)#</cfoutput>"> 
			                                    <span class="input-group-addon width">
		                                        <select name="price_protection_money_location" id="price_protection_money_location" style="width:55px;">
													<cfoutput query="get_money">
														<option value="#money#" <cfif fiyat_koruma_money_loc eq money>selected</cfif>>#money#</option>
													</cfoutput>
												</select>
	                                            </span>
		                                	</div>
		                            	</div>
		                        	</div>
	                                </cfif>
					            </div>
			</div>
            
				
			<div class="col col-12">
            <table>
            	<tr height="20">
					<td colspan="8" class="txtbold">
					<cf_get_lang dictionary_id ='37725.Bu maliyet'>,<!--- typelara göre ayarlanmalı iade v.s. --->
					<cfset kontrol_delete = 0>
					<cfif get_product_cost.action_type eq 1>
						<a href="javascript://" onclick="open_action2(1);"><cf_get_lang dictionary_id ='37726.Faturadan'></a>
					<cfelseif get_product_cost.action_type eq 2>
						<cfif get_product_cost.action_process_type eq 811>
							<a href="javascript://" onclick="open_action2(12);"><cf_get_lang dictionary_id='29588.İthal Mal Girişinden'></a>
						<cfelseif get_product_cost.action_process_type eq 81>
							<a href="javascript://" onclick="open_action2(13);"><cf_get_lang dictionary_id='45391.Depolararası Sevk İrsaliyesinden'></a>
						<cfelse>	
							<a href="javascript://" onclick="open_action2(2);"><cf_get_lang dictionary_id ='37727.İrsaliyeden'></a>
						</cfif>
					<cfelseif get_product_cost.action_type eq 3>
						<cfif get_product_cost.action_procesS_type eq 114><!--- Açılış --->
							<a href="javascript://" onclick="open_action2(3);"><cf_get_lang dictionary_id ='37728.Stok Fişinden'></a>
						<cfelseif get_product_cost.action_procesS_type eq 118><!--- demirbaş stok fişi --->
							<a href="javascript://" onclick="open_action2(10);"><cf_get_lang dictionary_id='58602.Demirbaş'> <cf_get_lang dictionary_id ='37728.Stok Fişinden'></a>
						<cfelseif get_product_cost.action_procesS_type eq 1182><!--- demirbaş stok iade fişi --->
							<a href="javascript://" onclick="open_action2(11);"><cf_get_lang dictionary_id='29637.Demirbaş Stok İade Fişinden'></a>
						<cfelse>
							<a href="javascript://" onclick="open_action2(9);"><cf_get_lang dictionary_id ='37728.Stok Fişinden'></a>
						</cfif>
					<cfelseif get_product_cost.action_type eq 4>
						<cfquery name="get_prod_order_result" datasource="#dsn3#">
							SELECT P_ORDER_ID FROM PRODUCTION_ORDER_RESULTS WHERE PR_ORDER_ID = #get_product_cost.action_id#
						</cfquery>
						<cfset p_orderid = get_prod_order_result.P_ORDER_ID>
						<a href="javascript://" onclick="open_action2(4,<cfoutput>#p_orderid#</cfoutput>);"><cf_get_lang dictionary_id ='37729.Üretimden'></a>
					<cfelseif get_product_cost.action_type eq 7>
						<a href="javascript://" onclick="open_action2(7);"><cf_get_lang dictionary_id ='37730.Stok Virmandan'></a>
					<cfelseif get_product_cost.action_type eq 8>
						<a href="javascript://" onclick="open_action2(8);"><cf_get_lang dictionary_id ='60519.Fiyat Farkı Ekranından'></a>
                    <cfelseif get_product_cost.action_type eq -1>
                    	<cf_get_lang dictionary_id ='60520.Excel Aktarımdan'>
					<cfelse>
						<cfset kontrol_delete = 1>
						<cf_get_lang dictionary_id ='37731.Elle'>
					</cfif>
					<cfif len(get_product_cost.IS_SUGGEST)>(<cf_get_lang dictionary_id='46277.Önerilen'>)</cfif>
					<cf_get_lang dictionary_id ='37732.oluşturulmuştur'>.
					<!--- Bu maliyet, toplam <cfoutput>#get_products_cost_inv_rows.recordcount#</cfoutput> alış fatura satırından dolayı oluşturulmuştur. --->
					</td>
				</tr>
            </table>
		</div>
	</cf_box_elements>
	<cf_box_footer>
	<cf_record_info query_name='get_product_cost'>
	<cfsavecontent variable="upd_cost"><cf_get_lang dictionary_id ='37525.Maliyet Güncelle'></cfsavecontent>
		<cfif kontrol_delete eq 1>
		<cf_workcube_buttons is_upd='1' add_function='temizle_virgul2()' insert_info='#upd_cost#' delete_page_url = '#request.self#?fuseaction=product.emptypopup_del_product_cost&cost_id=#get_product_cost.PRODUCT_COST_ID#&product_id=#get_product_cost.PRODUCT_ID#&spec_main_id=#get_product_cost.SPECT_MAIN_ID#'>
		</cfif>
	</cf_box_footer>
</cfform>
</cf_box>
<script type="text/javascript">
	function open_spec_popup2()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=product_cost2.spect_main_id&field_name=product_cost2.spect_name&is_display=1&stock_id=<cfoutput>#GET_STOCK.STOCK_ID#</cfoutput>&function_name=get_stock2','list');
	}
	function history_money2(){
		var round_number = $('#product_cost2 #round_number').val();
		var h_date=js_date(document.product_cost2.start_date2.value);
		<cfoutput query="GET_MONEY">
			var get_his_rate=wrk_query("SELECT (RATE2/RATE1) RATE,MONEY MONEY_TYPE FROM MONEY_HISTORY WHERE VALIDATE_DATE <= "+h_date+" AND MONEY = '#money#' AND PERIOD_ID = #session.ep.period_id# ORDER BY VALIDATE_DATE DESC,MONEY_HISTORY_ID DESC","dsn");
			if(get_his_rate.recordcount)
				eval('document.product_cost2.money_#money#').value=get_his_rate.RATE[0];
			else
				eval('document.product_cost2.money_#money#').value=#wrk_round(rate2/rate1,round_number)#;
		</cfoutput>
		hesapla2();
		return true;
	}
	function open_action2(type,pid)
	{
		/*
			1- alış faturası ve satış faturası
			2-alış irsaliyesi
			3-stok açılış fişi
			4-üretim sonucu
			7-stok virman
			8-//fiyat farkı ekranından... hem alış hemde satış
			9-stok açılış fişi
			10-demirbaş fişi
			11-demirbaş iade fişi
		*/
		
		if(type == 1)
		{
			<cfif get_product_cost.action_process_type eq 62>
			<cfif not isdefined("attributes.draggable")>opener.</cfif>window.location='<cfoutput>#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#get_product_cost.action_id#</cfoutput>';
			<cfelse>
			<cfif not isdefined("attributes.draggable")>opener.</cfif>window.location='<cfoutput>#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=#get_product_cost.action_id#</cfoutput>';
			</cfif>
		}
		else if(type == 2)
			<cfif not isdefined("attributes.draggable")>opener.</cfif>window.location='<cfoutput>#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=#get_product_cost.action_id#</cfoutput>';
		else if(type == 12)
			<cfif not isdefined("attributes.draggable")>opener.</cfif>window.location='<cfoutput>#request.self#?fuseaction=stock.add_stock_in_from_customs&event=upd&ship_id=#get_product_cost.action_id#</cfoutput>';
		else if(type == 13)
			<cfif not isdefined("attributes.draggable")>opener.</cfif>window.location='<cfoutput>#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=#get_product_cost.action_id#</cfoutput>';
		else if(type == 9)
			<cfif not isdefined("attributes.draggable")>opener.</cfif>window.location='<cfoutput>#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=#get_product_cost.action_id#</cfoutput>';
		else if(type == 3)
			<cfif not isdefined("attributes.draggable")>opener.</cfif>window.location='<cfoutput>#request.self#?fuseaction=stock.form_add_ship_open_fis&event=upd&upd_id=#get_product_cost.action_id#</cfoutput>';
		else if(type == 10)
			<cfif not isdefined("attributes.draggable")>opener.</cfif>window.location='<cfoutput>#request.self#?fuseaction=invent.add_invent_stock_fis&event=upd&fis_id=#get_product_cost.action_id#</cfoutput>';
		else if(type == 11)
			<cfif not isdefined("attributes.draggable")>opener.</cfif>window.location='<cfoutput>#request.self#?fuseaction=invent.add_invent_stock_fis_return&event=upd&fis_id=#get_product_cost.action_id#</cfoutput>';
		else if(type == 7)
			<cfif not isdefined("attributes.draggable")>opener.</cfif>window.location='<cfoutput>#request.self#?fuseaction=stock.form_add_stock_exchange&event=upd&exchange_id=#get_product_cost.action_id#</cfoutput>';
		else if(type == 8)//fiyat farkı ekranından...
			<cfif get_product_cost.action_process_type eq 58>
				<cfif not isdefined("attributes.draggable")>opener.</cfif>window.location='<cfoutput>#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#get_product_cost.action_id#</cfoutput>';
			<cfelse>
				<cfif not isdefined("attributes.draggable")>opener.</cfif>window.location='<cfoutput>#request.self#?fuseaction=invoice.form_add_bill_purchas&event=upd&iid=#get_product_cost.action_id#</cfoutput>';
			</cfif>		
		else if(type == 4)
		{
		var p_orderid = pid;
		<cfif not isdefined("attributes.draggable")>opener.</cfif>window.location='<cfoutput>#request.self#?fuseaction=prod.list_results&event=upd&p_order_id='+ p_orderid +'&pr_order_id=#get_product_cost.action_id#</cfoutput>';
		}
	}
	function hesapla2()
	{ 
		var round_number = $('#product_cost2 #round_number').val();
		var t1 = parseFloat(filterNum(product_cost2.purchase_net.value,round_number));
		var t2 = parseFloat(filterNum(product_cost2.purchase_extra_cost.value,round_number));
		var t3 = parseFloat(filterNum(product_cost2.standard_cost.value,round_number));
		var t4 = parseFloat(filterNum(product_cost2.standard_cost_rate.value,round_number));
		var t5 = parseFloat(filterNum(product_cost2.price_protection.value,round_number));
		
		if(product_cost2.price_protection_type!=undefined)
			t5 = t5*product_cost2.price_protection_type.value;
			
		if (isNaN(t1)) {t1 = 0; product_cost2.purchase_net.value = 0;}
		if (isNaN(t2)) {t2 = 0; product_cost2.purchase_extra_cost.value = 0;}
		if (isNaN(t3)) {t3 = 0; product_cost2.standard_cost.value = 0;}
		if (isNaN(t4)) {t4 = 0; product_cost2.standard_cost_rate.value = 0;}	
		if (isNaN(t5)) {t5 = 0; product_cost2.price_protection.value = 0;}
	
		t1 = (t1 * $('#product_cost2 #money_'+product_cost2.purchase_net_money.value).val()) / $('#product_cost2 #money_'+product_cost2.reference_money.value).val();
		t2 = (t2 * $('#product_cost2 #money_'+product_cost2.purchase_net_money.value).val()) / $('#product_cost2 #money_'+product_cost2.reference_money.value).val();
		t3 = (t3 * $('#product_cost2 #money_'+product_cost2.standard_cost_money.value).val()) / $('#product_cost2 #money_'+product_cost2.reference_money.value).val();
		t5 = (t5 * $('#product_cost2 #money_'+product_cost2.price_protection_money.value).val()) / $('#product_cost2 #money_'+product_cost2.reference_money.value).val();
		order_total = t1+t2+t3+((t1*t4)/100)-t5;
		product_cost2.product_cost_.value = commaSplit(order_total,round_number);
		product_cost2.purchase_net_system.value = commaSplit((t1-t5)*$('#product_cost2 #money_'+product_cost2.reference_money.value).val(),round_number);
		product_cost2.purchase_extra_cost_system.value = commaSplit((t2+t3+(t1*t4)/100)*$('#product_cost2 #money_'+product_cost2.reference_money.value).val(),round_number);
		<cfif fusebox.Circuit eq 'product'>
			var t5_location = parseFloat(filterNum(product_cost2.price_protection_location.value,round_number));
			if (isNaN(t5_location)) {t5_location = 0; product_cost2.price_protection_location.value = 0;}
			t5_location = (t5_location * $('#product_cost2 #money_'+product_cost2.price_protection_money_location.value).val()) / $('#product_cost2 #money_'+product_cost2.reference_money.value).val();
			product_cost2.purchase_net_system_location.value = commaSplit((t1-t5_location)* $('#product_cost2 #money_'+product_cost2.reference_money.value).val(),round_number);
		</cfif>
	}

	function temizle_virgul2()
	{
		var round_number = $('#product_cost2 #round_number').val();
		<cfif session.ep.isBranchAuthorization>
			if(product_cost2.department.value=='' || product_cost2.department_id.value=='' || product_cost2.location_id.value=='')
			{
				alert("<cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'>");
				return false;
			}
		</cfif>
		if(typeof(process_cat_control) == 'function' && process_cat_control() == false) return false;
		if(parseFloat(filterNum(product_cost2.price_protection.value)) > 0 && price_protection_control2())//fiyat koruma yapilsinmi
		{
			if(product_cost2.td_company.value=='' || product_cost2.td_company_id.value=='')
			{
				alert("<cf_get_lang dictionary_id ='37734.Fiyat Koruma Girecekseniz Tedarikçi Seçmelisiniz'>!");
				return false;
			}
			product_cost2.cost_control.value=1;
		}
		else 
		{
			product_cost2.cost_control.value=0;
		}
		
		if(product_cost2.standard_cost.value == '')
			product_cost2.standard_cost.value = 0;
		if(product_cost2.purchase_net.value == '')
			product_cost2.purchase_net.value = 0;
		if(product_cost2.standard_cost_rate.value == '')
			product_cost2.standard_cost_rate.value = 0;
		if(product_cost2.purchase_extra_cost.value == '')
			product_cost2.purchase_extra_cost.value = 0;
		if(product_cost2.price_protection.value == '')
			product_cost2.price_protection.value = 0;
		if(product_cost2.purchase_net_system.value == '')
			product_cost2.purchase_net_system.value = 0;
		if(product_cost2.purchase_extra_cost_system.value == '')
			product_cost2.purchase_extra_cost_system.value = 0;

		product_cost2.standard_cost.value = filterNum(product_cost2.standard_cost.value,round_number);
		product_cost2.purchase_net.value = filterNum(product_cost2.purchase_net.value,round_number);
		product_cost2.available_stock.value = filterNum(product_cost2.available_stock.value);
		product_cost2.standard_cost_rate.value = filterNum(product_cost2.standard_cost_rate.value);
		product_cost2.purchase_extra_cost.value = filterNum(product_cost2.purchase_extra_cost.value,round_number);
		product_cost2.partner_stock.value = filterNum(product_cost2.partner_stock.value);
		product_cost2.price_protection.value = filterNum(product_cost2.price_protection.value,round_number);
		product_cost2.active_stock.value = filterNum(product_cost2.active_stock.value);
		product_cost2.product_cost_.value = filterNum(product_cost2.product_cost_.value);
		product_cost2.purchase_net_system.value = filterNum(product_cost2.purchase_net_system.value,round_number);
		product_cost2.purchase_extra_cost_system.value = filterNum(product_cost2.purchase_extra_cost_system.value,round_number);
		product_cost2.purchase_net_system_location.value = filterNum(product_cost2.purchase_net_system_location.value,round_number);
		if(product_cost2.price_protection_location!=undefined)
		{
			if(product_cost2.price_protection_location.value == '') product_cost2.price_protection_location.value = 0;
			product_cost2.price_protection_location.value = filterNum(product_cost2.price_protection_location.value,round_number);
		}
		
		if(product_cost2.total_price_prot!=undefined)
		{
			if(product_cost2.total_price_prot.value == '') product_cost2.total_price_prot.value = 0;
			product_cost2.total_price_prot.value = filterNum(product_cost2.total_price_prot.value,round_number);
			if(product_cost2.price_prot_amount.value == '') product_cost2.price_prot_amount.value = 0;
			product_cost2.price_prot_amount.value = filterNum(product_cost2.price_prot_amount.value,round_number);
		}
		product_cost2.inventory_calc_type.disabled = false;
		product_cost2.product_cost_money.disabled = false;
		product_cost2.start_date.value = product_cost2.start_date2.value;
		product_cost2.due_date.value = product_cost2.due_date2.value;
		product_cost2.physical_date.value = product_cost2.physical_date2.value;
		return true;
	}
	function get_stock2()
	{
		<cfif session.ep.isBranchAuthorization>
			var dep_sql='AND STORE ='+ product_cost2.department_id.value +' AND STORE_LOCATION ='+ product_cost2.location_id.value;
		<cfelse>
			var dep_sql='';
		</cfif>
		if(product_cost2.spect_main_id.value!="" && product_cost2.spect_name.value!="")
			var spec_query='AND SPECT_VAR_ID='+product_cost2.spect_main_id.value;
		else
			var spec_query='';
		var gt_stoc=wrk_query('SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK FROM STOCKS_ROW SR WHERE SR.PRODUCT_ID = <cfoutput>#get_product_cost.product_id#</cfoutput> AND PROCESS_DATE <='+js_date(product_cost2.start_date2.value)+' '+spec_query+' '+dep_sql,'dsn2');
		if(gt_stoc.recordcount)
			product_cost2.available_stock.value = commaSplit(gt_stoc.PRODUCT_TOTAL_STOCK);
		else
			product_cost2.available_stock.value = '<cfoutput>#tlformat(0)#</cfoutput>';
		
		var get_sevk=wrk_query('SELECT SUM(STOCK_OUT-STOCK_IN) AS MIKTAR FROM STOCKS_ROW WHERE PRODUCT_ID = <cfoutput>#get_product_cost.product_id#</cfoutput> AND PROCESS_TYPE = 81 AND PROCESS_DATE <='+js_date(product_cost2.start_date2.value)+' '+spec_query+' '+dep_sql,'dsn2')
		if(get_sevk.recordcount)
			product_cost2.active_stock.value= commaSplit(get_sevk.MIKTAR);
		else
			product_cost2.active_stock.value ='<cfoutput>#tlformat(0)#</cfoutput>';

		return history_money2()
	}
	
	function price_protection_control2()
	{
		if(confirm("<cf_get_lang dictionary_id ='37735.Fiyat Koruma için Fiyat Farkı Faturası Emri Verilsin mı'>?"))
			return true;
		else
			return false;
	}
	
	function total_price_protection_hesapla2(type)
	{    
	    var round_number = $('#product_cost2 #round_number').val(); 
		if(product_cost2.price_prot_amount.value=="" || product_cost2.price_prot_amount.value==0) product_cost2.price_prot_amount.value = 1;
		product_cost2.price_prot_amount.value=filterNum(product_cost2.price_prot_amount.value,round_number);
		product_cost2.price_protection.value=filterNum(product_cost2.price_protection.value,round_number);
		product_cost2.total_price_prot.value=filterNum(product_cost2.total_price_prot.value,round_number);
		if(type == 1)
		{
			 product_cost2.price_protection.value = product_cost2.total_price_prot.value / product_cost2.price_prot_amount.value;
		}else if(type == 2)
		{
			if(product_cost2.total_price_prot.value!="")
				product_cost2.price_protection.value = product_cost2.total_price_prot.value / product_cost2.price_prot_amount.value;
			else if(product_cost2.price_protection.value!="")
				product_cost2.total_price_prot.value = product_cost2.price_protection.value * product_cost2.price_prot_amount.value;
		}else if(type == 3)
		{
			if(product_cost2.price_protection.value!="")
			product_cost2.total_price_prot.value = product_cost2.price_protection.value * product_cost2.price_prot_amount.value;
		}
		product_cost2.price_prot_amount.value= commaSplit(product_cost2.price_prot_amount.value,round_number);
		product_cost2.price_protection.value=commaSplit(product_cost2.price_protection.value,round_number);
		product_cost2.total_price_prot.value=commaSplit(product_cost2.total_price_prot.value,round_number);
	}
	function stock_total2()
	{
		product_cost2.total_stock.value=commaSplit(parseFloat(filterNum(product_cost2.available_stock.value))+parseFloat(filterNum(product_cost2.active_stock.value))+parseFloat(filterNum(product_cost2.partner_stock.value)),2);
	}

	stock_total2();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
