<script type="text/javascript">
	function connectAjax(crtrow,sug_id,yetki)
	{
		var bb = '<cfoutput>#request.self#?fuseaction=product.popup_convert_suggest</cfoutput>&suggest_id='+sug_id+'&form_crntrow='+ crtrow +'&surece_yetki='+ yetki;
		AjaxPageLoad(bb,'ADD_SUGGESTION'+crtrow);
	}
</script>
<!--- Maliyet Önerileri --->
<cfquery name="GET_PRODUCT_COST_SUGGESTION" DATASOURCE="#DSN1#" MAXROWS="5"><!---Ürün tutarları ve para birimi  --->
	SELECT 
		*
	FROM 
		PRODUCT_COST_SUGGESTION
	WHERE 
		COST_SUGGESTION_STATUS = 0 AND 
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PID#">
	ORDER BY 
		START_DATE DESC,
		RECORD_DATE DESC
</cfquery>
<!--- Süreç'e yetkisi yoksa önerilerini maliye çevir butonunu göstermeycez.  --->
<cfquery name="get_faction_control" datasource="#DSN#"><!--- Sistem ekleme sürecine yetkisi olup olmadığını kontrol eder. --->
	SELECT 
		DISTINCT
			PROCESS_TYPE_ROWS.PROCESS_ROW_ID,
			PROCESS_TYPE_ROWS.STAGE,
			PROCESS_TYPE_ROWS.LINE_NUMBER,
			PROCESS_TYPE_ROWS.DISPLAY_FILE_NAME
		FROM
			PROCESS_TYPE PROCESS_TYPE,
			PROCESS_TYPE_OUR_COMPANY PROCESS_TYPE_OUR_COMPANY,
			PROCESS_TYPE_ROWS PROCESS_TYPE_ROWS,
			PROCESS_TYPE_ROWS_POSID PROCESS_TYPE_ROWS_POSID,
			EMPLOYEE_POSITIONS EMPLOYEE_POSITIONS
		WHERE
			PROCESS_TYPE.IS_ACTIVE = 1 AND
			PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID AND
			PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_OUR_COMPANY.PROCESS_ID AND
			PROCESS_TYPE_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			<cfif database_type is 'MSSQL'>
				CAST(PROCESS_TYPE.FACTION AS NVARCHAR(2500))+',' LIKE '%product.form_add_product_cost,%' AND
			<cfelseif database_type is 'DB2'>
				CAST(PROCESS_TYPE.FACTION AS VARGRAPHIC(2500))||',' LIKE '%product.form_add_product_cost,%'AND
			</cfif>
			EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
			PROCESS_TYPE_ROWS_POSID.PROCESS_ROW_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID AND
			EMPLOYEE_POSITIONS.POSITION_ID = PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID
	UNION
		SELECT DISTINCT
			PROCESS_TYPE_ROWS.PROCESS_ROW_ID,
			PROCESS_TYPE_ROWS.STAGE,
			PROCESS_TYPE_ROWS.LINE_NUMBER,
			PROCESS_TYPE_ROWS.DISPLAY_FILE_NAME
		FROM 	
			PROCESS_TYPE  AS PROCESS_TYPE,
			PROCESS_TYPE_OUR_COMPANY PROCESS_TYPE_OUR_COMPANY,
			PROCESS_TYPE_ROWS AS PROCESS_TYPE_ROWS,
			PROCESS_TYPE_ROWS_WORKGRUOP AS PROCESS_TYPE_ROWS_WORKGRUOP,
			PROCESS_TYPE_ROWS_POSID AS PROCESS_TYPE_ROWS_POSID
		WHERE 
			PROCESS_TYPE.IS_ACTIVE = 1 AND
			PROCESS_TYPE_ROWS.PROCESS_ID = PROCESS_TYPE.PROCESS_ID AND
			PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_OUR_COMPANY.PROCESS_ID AND
			PROCESS_TYPE_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			<cfif database_type is 'MSSQL'>
				CAST(PROCESS_TYPE.FACTION AS NVARCHAR(2500))+',' LIKE '%product.form_add_product_cost,%' AND
			<cfelseif database_type is 'DB2'>
				CAST(PROCESS_TYPE.FACTION AS VARGRAPHIC(2500))||',' LIKE '%product.form_add_product_cost,%'AND
			</cfif>													
			 PROCESS_TYPE_ROWS_WORKGRUOP.PROCESS_ROW_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID  AND 
			 PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID IS NOT NULL AND 
			 PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID = PROCESS_TYPE_ROWS_POSID.WORKGROUP_ID AND 
			 PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.POSITION_CODE#">)
		ORDER BY 
			PROCESS_TYPE_ROWS.LINE_NUMBER
</cfquery>
<!--- //Süreç'e yetkisi yoksa önerilerini maliye çevir butonunu göstermeycez.  --->
<cfparam name="attributes.period_id" default="#session.ep.period_id#">
<cfparam name="attributes.act_id" default="">
<cfparam name="attributes.act_type" default="1">
<cfparam name="attributes.cost_date" default="#dateformat(now(),dateformat_style)#">
<cf_date tarih = 'attributes.cost_date'>
<cfinclude template="../query/get_product_cost_param.cfm">
<cfinclude template="../query/get_money.cfm"><!--- SETUP MNYDEN ALINIYOR AMA ELLE MALİYET GİRİLECEĞİNDE TARİHTEDKİ STOKDA KURLARDA O ZAMANDAN ALINMALI --->
<cfscript>
	if(session.ep.isBranchAuthorization and listlen(session.ep.user_location,"-") eq 3)
	{
		departmetn_id = ListGetAt(session.ep.user_location,1,"-");
		location_id = ListGetAt(session.ep.user_location,3,"-");
	}else
	{
		departmetn_id = '';//GET_PRODUCT_COST.DEPARTMENT_ID;
		location_id = '';//GET_PRODUCT_COST.LOCATION_ID;
	}
	spec_main_id = GET_PRODUCT_COST.SPECT_MAIN_ID;
	if(fusebox.circuit is 'product')
	{
		reference_money = GET_PRODUCT_COST.MONEY;
		alis_net_fiyat = GET_PRODUCT_COST.PURCHASE_NET;
		alis_net_fiyat2 = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM;
		alis_net_fiyat_money = GET_PRODUCT_COST.PURCHASE_NET_MONEY;
		alis_ek_maliyet = GET_PRODUCT_COST.PURCHASE_EXTRA_COST;
		alis_ek_maliyet2 = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM;
		alis_ek_maliyet_money = GET_PRODUCT_COST.PURCHASE_NET_MONEY;
		son_st_maliyet = get_product_cost.STANDARD_COST;
		son_st_maliyet_money = get_product_cost.STANDARD_COST_MONEY;
		son_st_maliyet_oran = get_product_cost.STANDARD_COST_RATE;
		fiziksel_yas = get_product_cost.PHYSICAL_DATE;
		finansal_yas = get_product_cost.DUE_DATE;
	}
	else
	{
		reference_money = GET_PRODUCT_COST.MONEY_LOCATION;
		purchase_net_money = GET_PRODUCT_COST.PURCHASE_NET_MONEY_LOCATION;
		alis_net_fiyat = GET_PRODUCT_COST.PURCHASE_NET_LOCATION;
		alis_net_fiyat2 = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_LOCATION;
		alis_net_fiyat_money = GET_PRODUCT_COST.PURCHASE_NET_MONEY_LOCATION;
		alis_ek_maliyet = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_LOCATION;
		alis_ek_maliyet2 = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_LOCATION;
		alis_ek_maliyet_money = GET_PRODUCT_COST.PURCHASE_NET_MONEY_LOCATION;
		son_st_maliyet = get_product_cost.STANDARD_COST_LOCATION;
		son_st_maliyet_money = get_product_cost.STANDARD_COST_MONEY_LOCATION;
		son_st_maliyet_oran = get_product_cost.STANDARD_COST_RATE_LOCATION;
		fiziksel_yas = get_product_cost.PHYSICAL_DATE_LOCATION;
		finansal_yas = get_product_cost.DUE_DATE_LOCATION;
	}
	if (session.ep.period_year gt 2008 and reference_money  is 'YTL')
		reference_money = 'TL';
</cfscript>
<cfoutput>
	<cfquery name="GET_STOCK" datasource="#DSN3#">
		SELECT
			STOCK_ID,
			STOCK_CODE
		FROM
			STOCKS
		WHERE
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
	</cfquery>
	<!---<table class="dph">
		<tr>
			<td class="detailhead"><cf_get_lang_main no='2277.Ürün Maliyetleri'>:<cfoutput> #get_stock.stock_code# - #get_product.product_name# / #product_unit_name# <cf_get_lang_main no='1189.Bazında'></cfoutput></td>
			<td style="text-align:right">
				<cfif get_product.is_production is 1>		
					<cfif get_stock.recordcount>
						<a href="#request.self#?fuseaction=prod.add_product_tree&stock_id=#get_stock.STOCK_ID#"><img src="/images/tree_bt.gif" border="0" title="<cf_get_lang no='93.Ürün Ağacı'>"></a>
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_list_prod_tree_costs&stock_id=#get_stock.stock_id#</cfoutput>','wide');"><img  border="0"src="/images/money_plus.gif"  title="<cf_get_lang no='74.Maliyet'>"></a>
					</cfif>		
				</cfif>
				<a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#url.pid#"><img src="/images/ship.gif"  title="<cf_get_lang no='121.Stok Detayları'>" border="0"></a> 
				<cfif not listfindnocase(denied_pages,'product.detail_product_price')><a href="#request.self#?fuseaction=product.detail_product_price&pid=#url.pid#"><img src="/images/promo.gif" title="<cf_get_lang no='105.Fiyat Detay'>"  border="0"></a></cfif>
				<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_product&event=det&pid=#attributes.pid#"><img src="/images/properties.gif" width="18" height="21" title="<cf_get_lang_main no='1352.Ürün Detayları'>" border="0"></a>
				<cfif fusebox.circuit is 'product'>
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=product.popup_list_product_cost_detail&pid=#attributes.pid#</cfoutput>','horizantal')"><img src="/images/history.gif"border="0" title="<cf_get_lang no='281.Maliyet Tarihçesi'>"></a>
				</cfif>
			</td>
		</tr>
	</table>--->
</cfoutput>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='30074.Ürün Maliyetleri'></cfsavecontent>
<cfset pageHead = "#message# - #GET_PRODUCT.PRODUCT_CODE# / #GET_PRODUCT.PRODUCT_NAME#">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform action="#request.self#?fuseaction=#fusebox.Circuit#.emptypopup_add_product_cost" method="post" name="product_cost">
			<input type="hidden" name="cost_control" id="cost_control" value="0">
			<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#pid#</cfoutput>">
			<input type="hidden" name="unit_id" id="unit_id" value="<cfoutput>#product_unit#</cfoutput>">
			<input type="hidden" name="action_id" id="action_id" value="">
			<input type="hidden" name="action_type" id="action_type" value=""><!--- 1: FATURA, 2: SİPARİŞ 3:ÜRETİM TİPİ 4:stok virman--->
			<input type="hidden" name="action_period_id" id="action_period_id" value="<cfoutput>#session.ep.period_id#</cfoutput>">
			<input type="hidden" name="action_ids" id="action_ids" value="">
			<input type="hidden" name="round_number" id="round_number" value="<cfoutput>#round_number#</cfoutput>">
			<input type="hidden" name="pid" id="pid" value="<cfoutput>#attributes.pid#</cfoutput>">
			<cfoutput query="GET_MONEY">
				<input type="hidden" name="money_#money#" id="money_#money#" value="#wrk_round(rate2/rate1,round_number)#">
			</cfoutput>
			<input type="hidden" name="reference_money" id="reference_money" value="<cfoutput>#reference_money#</cfoutput>">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-old_start_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="old_start_date" id="old_start_date" value="<cfoutput>#dateformat(attributes.cost_date,dateformat_style)#</cfoutput>">
								<!---<cfsavecontent variable="message"><cf_get_lang_main no='326.Baslama tarihi girmelisiniz'></cfsavecontent>--->
								<cfinput type="text" name="start_date" value="#dateformat(attributes.cost_date,dateformat_style)#" readonly required="Yes" validate="#validate_style#" onBlur="return(get_stock());">
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date" call_function="get_stock"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-process">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
						</div>
					</div>
					<div class="form-group" id="item-inventory_calc_type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37510.Envanter Yöntemi'></label>
						<div class="col col-8 col-xs-12">
							<select name="inventory_calc_type" id="inventory_calc_type" style="width:150px;" disabled>
								<option value="3"><cf_get_lang dictionary_id='37082.Ağırlıklı Ortalama'></option><!--- 3:gpa --->
								<!---<option value="1"><cf_get_lang no='69.İlk Giren İlk Çıkar'></option> 1:fifo --->
								<!--- <option value="2"<cfif get_product.inventory_calc_type eq 2> selected</cfif>><cf_get_lang no='70.Son Giren İlk Çıkar'></option><!--- 2:lifo --->
								<option value="4"<cfif get_product.inventory_calc_type eq 4> selected</cfif>><cf_get_lang no='72.Son Alış Fiyatı'></option><!--- 4:lpp --->
								<option value="5"<cfif get_product.inventory_calc_type eq 5> selected</cfif>><cf_get_lang no='73.İlk Alış Fiyatı'></option><!--- 5:fpp --->
								<option value="6"<cfif get_product.inventory_calc_type eq 6> selected</cfif>><cf_get_lang_main no='1310.Standart Alış'></option><!--- 6:st --->
								<option value="7"<cfif get_product.inventory_calc_type eq 7> selected</cfif>><cf_get_lang_main no='1309.Standart Satış'></option><!--- 7:st --->
								<option value="8"<cfif get_product.inventory_calc_type eq 8> selected</cfif>><cf_get_lang no='74.Üretim Maliyeti'></option><!--- 8:urt ---> --->
							</select>	
						</div>
					</div>
					<div class="form-group" id="item-spect_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57647.Spec'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif len(spec_main_id)>
									<cfquery name="GET_SPECT_MAIN_NAME" datasource="#DSN3#">
										SELECT SPECT_MAIN_ID, SPECT_MAIN_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#spec_main_id#">
									</cfquery>
								</cfif>
								<input type="hidden" name="spect_main_id" id="spect_main_id" value="<cfoutput>#spec_main_id#</cfoutput>">
								<input type="text" name="spect_name" id="spect_name" value="<cfif isdefined("GET_SPECT_MAIN_NAME")><cfoutput>#GET_SPECT_MAIN_NAME.SPECT_MAIN_NAME#</cfoutput></cfif>" style="width:150px;">
								<span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="open_spec_popup();"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-td_company">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="td_company_id" id="td_company_id" value="">
								<input type="text" name="td_company" id="td_company" value="">
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=product_cost.td_company&field_comp_id=product_cost.td_company_id&select_list=2&keyword='+encodeURIComponent(document.product_cost.td_company.value));"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-cost_description">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea style="width:150px; height:50px" name="cost_description" id="cost_description"></textarea>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-standard_cost">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37511.Sabit Maliyet'></label>
						<cfif session.ep.period_year gt 2008 and alis_net_fiyat_money  is 'YTL'><cfset alis_net_fiyat_money = 'TL'></cfif>
						<cfif session.ep.period_year gt 2008 and son_st_maliyet_money  is 'YTL'><cfset son_st_maliyet_money = 'TL'></cfif>
						<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="text" name="standard_cost" id="standard_cost" class="moneybox" onkeyup='return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));' onBlur="hesapla();" value="<cfoutput>#tlformat(son_st_maliyet,round_number)#</cfoutput>"> 
							<span class="input-group-addon width">
							<select name="standard_cost_money" id="standard_cost_money" onBlur="hesapla();">
								<cfloop query="get_money">
									<option value="<cfoutput>#money#</cfoutput>" <cfif son_st_maliyet_money eq money>selected</cfif>><cfoutput>#money#</cfoutput></option>								
								</cfloop>
							</select>
						</span>
						</div></div>
					</div>
					<div class="form-group" id="item-standard_cost_rate">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37513.Sabit Maliyet Oran'> % </label>
						<div class="col col-8 col-xs-12">
							<input type="text" class="moneybox" name="standard_cost_rate" id="standard_cost_rate" onkeyup='return(FormatCurrency(this,event));' onBlur="hesapla();" value="<cfoutput>#tlformat(son_st_maliyet_oran)#</cfoutput>">
							<cfif len(departmetn_id)>
								<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
									SELECT DEPARTMENT_HEAD FROM  DEPARTMENT WHERE DEPARTMENT_ID = #departmetn_id#
								</cfquery>
								<cfif len(location_id)>
									<cfquery name="GET_LOCATION" datasource="#DSN#">
										SELECT COMMENT FROM STOCKS_LOCATION WHERE LOCATION_ID = #location_id# AND DEPARTMENT_ID = #departmetn_id#
									</cfquery>
								</cfif>
							</cfif>
						</div>
					</div>
					<div class="form-group" id="item-purchase_net">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37515.Alışlardan Net Maliyet'> </label>
						<div class="col col-8 col-xs-12">
							<input type="hidden" name="old_purchase_net" id="old_purchase_net" value="<cfoutput>#tlformat(alis_net_fiyat,round_number)#</cfoutput>">
							<input type="hidden" name="old_purchase_net_money" id="old_purchase_net_money" value="<cfoutput>#alis_net_fiyat_money#</cfoutput>">
							<div class="input-group">	
							<input type="text" name="purchase_net" id="purchase_net" class="moneybox" onkeyup='return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));' onBlur="hesapla();" value="<cfoutput>#tlformat(alis_net_fiyat,round_number)#</cfoutput>">
							<span class="input-group-addon width">
							<select name="purchase_net_money" id="purchase_net_money" onBlur="hesapla();">
								<cfloop query="get_money">
									<option value="<cfoutput>#money#</cfoutput>" <cfif alis_net_fiyat_money eq money>selected</cfif>><cfoutput>#money#</cfoutput></option>								
								</cfloop>
							</select>
						</div>	
					</div>
					</div>
					<div class="form-group" id="item-purchase_extra_cost">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37517.Alışlardan Ek Maliyet'></label>
						<div class="col col-8 col-xs-12">
							<input type="hidden" name="old_purchase_extra_cost" id="old_purchase_extra_cost" value="<cfoutput>#alis_ek_maliyet#</cfoutput>">
							<input type="text" name="purchase_extra_cost" id="purchase_extra_cost" class="moneybox" onkeyup='return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));' onBlur="hesapla();" value="<cfoutput>#tlformat(wrk_round(alis_ek_maliyet,round_number,1),round_number)#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-purchase_net_system">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37572.Sistem Maliyet'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
							<input type="text" name="purchase_net_system" id="purchase_net_system" value="<cfoutput>#tlformat(alis_net_fiyat2,round_number)#</cfoutput>" onkeyup='return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));' class="moneybox" style="width:91px">
							<span class="input-group-addon width">
							<select name="purchase_net_system_money" id="purchase_net_system_money" disabled="disabled" >
								<cfloop query="get_money">
									<option value="<cfoutput>#money#</cfoutput>" <cfif session.ep.money eq money>selected</cfif>><cfoutput>#money#</cfoutput></option>								
								</cfloop>
							</select>
						</span>
							<input type="hidden" name="purchase_net_system_location" id="purchase_net_system_location" value="<cfoutput>#tlformat(alis_net_fiyat2,round_number)#</cfoutput>">
						</div>
					</div>
					</div>
					<div class="form-group" id="item-purchase_extra_cost_system">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37573.Sistem Ekstra Maliyet'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="purchase_extra_cost_system" id="purchase_extra_cost_system" value="<cfoutput>#tlformat(wrk_round(alis_ek_maliyet2,round_number,1),round_number)#</cfoutput>" class="moneybox" readonly="yes">
						</div>
					</div>
					<div class="form-group" id="item-product_cost_">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37497.Toplam Maliyet'></label>
						<div class="col col-8 col-xs-12">
							<cfif not len(alis_net_fiyat_money)><cfset alis_net_fiyat_money = '#session.ep.money#'></cfif>
							<div class="input-group">
							<input type="text" name="product_cost_" id="product_cost_" class="moneybox" onkeyup='return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));' readonly="readonly" value="">
							<span class="input-group-addon width">
							<select name="product_cost_money" id="product_cost_money" disabled>
								<cfloop query="get_money">
									<option value="<cfoutput>#money#</cfoutput>" <cfif alis_net_fiyat_money eq money>selected</cfif>><cfoutput>#money#</cfoutput></option>								
								</cfloop>
							</select>
						</span>
						</div>
					</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-location_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'></label>
						<div class="col col-8 col-xs-12">
							<cfif len(departmetn_id)>
								<cf_wrkdepartmentlocation 
									returnInputValue="location_id,department,department_id"
									returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
									fieldName="txt_departman_"
									fieldid="location_id"
									department_fldId="department_id"
									location_id="#location_id#"
									department_id="#departmetn_id#"
									location_name="#GET_DEPARTMENT.DEPARTMENT_HEAD# - #GET_LOCATION.COMMENT#"
									user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
									width="150">
							<cfelse>
								<cf_wrkdepartmentlocation 
									returnInputValue="location_id,department,department_id"
									returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
									fieldName="department"
									fieldid="location_id"
									department_fldId="department_id"
									user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
									width="150">
							</cfif>
						</div>
					</div>
					<div class="form-group" id="item-available_stock">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37512.Mevcut Stok'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" style="width:90px" class="moneybox" name="available_stock" id="available_stock" onkeyup='return(FormatCurrency(this,event));' onBlur="stock_total();">
						</div>
					</div>
					<div class="form-group" id="item-partner_stock">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37514.İş Ortakları Stoğu'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" style="width:90px" class="moneybox" name="partner_stock" id="partner_stock" onkeyup='return(FormatCurrency(this,event));' value="<cfoutput>#TLFormat(0)#</cfoutput>"  onblur="stock_total();">
						</div>
					</div>
					<div class="form-group" id="item-">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58047.Yoldaki Stok'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" style="width:90px" name="active_stock" id="active_stock" class="moneybox" onkeyup='return(FormatCurrency(this,event));' onBlur="stock_total();">
						</div>
					</div>
					<div class="form-group" id="item-total_stock">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29512.Toplam Stok'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" style="width:90px" name="total_stock" id="total_stock" class="moneybox" value="" readonly>
						</div>
					</div>
					<div class="form-group" id="item-due_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37615.Finansal Yaş'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='37724.Finansal Yaş İçin Tarih Giriniz'></cfsavecontent>
								<cfinput type="text" name="due_date" id="due_date" value="#dateformat(finansal_yas,dateformat_style)#" validate="#validate_style#" message="#message#" style="width:70px;">
								<span class="input-group-addon"><cf_wrk_date_image date_field="due_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-physical_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37616.Fiziksel Yaş'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='37738.Fiziksel Yaş İçin Tarih Giriniz'></cfsavecontent>
								<cfinput type="text" name="physical_date" id="physical_date" value="#dateformat(fiziksel_yas,dateformat_style)#" validate="#validate_style#" message="#message#" style="width:70px;">
								<span class="input-group-addon"><cf_wrk_date_image date_field="physical_date"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_elements>

			<cfsavecontent variable="message"><cf_get_lang dictionary_id='37617.Maliyet Düzenleme Kriterleri'></cfsavecontent>
			<cf_seperator id="maliyet_duzenleme_kriterleri" header="#message#">
			<cf_box_elements id="maliyet_duzenleme_kriterleri">
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-price_protection">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37618.Birim Tutar'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
							<input type="text" name="price_protection" id="price_protection" class="moneybox" onkeyup='return(FormatCurrency(this,event,<cfoutput>#round_number#</cfoutput>));' onBlur="total_price_protection_hesapla(3);hesapla();">
							<span class="input-group-addon width">
							<select name="price_protection_money" id="price_protection_money" onBlur="hesapla();">
								<cfloop query="get_money">
									<option value="<cfoutput>#money#</cfoutput>" <cfif session.ep.money eq money>selected</cfif>><cfoutput>#money#</cfoutput></option>								
								</cfloop>
							</select>
						</span>
						</div>
					</div>
					</div>
					<div class="form-group" id="item-cost_type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37658.Düzenleme Tipi'></label>
						<div class="col col-8 col-xs-12">
							<select name="cost_type" id="cost_type">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfquery name="GET_COST_TYPE" datasource="#DSN#">
									SELECT COST_TYPE_ID,COST_TYPE_NAME FROM SETUP_COST_TYPE 
								</cfquery>
								<cfoutput query="GET_COST_TYPE"><option value="#COST_TYPE_ID#">#COST_TYPE_NAME#</option></cfoutput>
							</select> 
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="5" sort="true">
					<div class="form-group" id="item-price_prot_amount">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57635.Miktar'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="price_prot_amount" id="price_prot_amount" style="width:91px;" value="" onBlur="total_price_protection_hesapla(2)" class="moneybox" onkeyup='return(FormatCurrency(this,event,4));'>
						</div>
					</div>
					<div class="form-group" id="item-price_protection_type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37620.Hesaplama Yöntemi'></label>
						<div class="col col-8 col-xs-12">
							<select name="price_protection_type" id="price_protection_type" style="width:90px" onChange="hesapla();">
								<option value="1"><cf_get_lang dictionary_id='37622.Azalt'></option><!--- zaten hesaplamada cıkarma yaptığı için -1 artırda--->
								<option value="-1"><cf_get_lang dictionary_id='37623.Artır'></option>
							</select> 
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="6" sort="true">
					<div class="form-group" id="item-total_price_prot">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29534.Toplam Tutar'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="total_price_prot" id="total_price_prot" style="width:90px;" value="<cfoutput>#TLFormat(0)#</cfoutput>" onBlur="total_price_protection_hesapla(1)" class="moneybox" onkeyup='return(FormatCurrency(this,event,4));'>
						</div>
					</div>
					<cfif session.ep.isBranchAuthorization eq 0>
						<div class="form-group" id="item-price_protection_location">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37621.Lokasyona Yansıyan Birim Tutar'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
								<input type="text" name="price_protection_location" id="price_protection_location" style="width:90px" class="moneybox" onkeyup='return(FormatCurrency(this,event,4));' onBlur="hesapla();">
								<span class="input-group-addon width">
								<select name="price_protection_money_location" id="price_protection_money_location" onBlur="hesapla();">
									<cfloop query="get_money">
										<option value="<cfoutput>#money#</cfoutput>" <cfif session.ep.money eq money>selected</cfif>><cfoutput>#money#</cfoutput></option>
									</cfloop>
								</select>
							</span>
							</div>
						</div>
					</div>
					</cfif>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function='temizle_virgul()' insert_info='#getLang('','Maliyet Ekle',37522)#'>
			</cf_box_footer>
		</cfform>
		<cfquery name="product_total_stock" datasource="#dsn2#">
			SELECT
				SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK
			FROM
				STOCKS_ROW SR
			WHERE
				SR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND
				PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.cost_date#">
				<cfif len(spec_main_id)>
					AND SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#spec_main_id#">
				</cfif>
		</cfquery>
		<cfif product_total_stock.recordcount and len(product_total_stock.product_total_stock)>
			<cfset mevcut_son_alislar = product_total_stock.product_total_stock>
		<cfelse>
			<cfset mevcut_son_alislar = 0>
		</cfif>
		<cfif session.ep.isBranchAuthorization eq 0>
			<!--- <cfif isdefined("xml_mevcut_son_alislar") and xml_mevcut_son_alislar eq 1>
			<cf_medium_list>
				<thead>
					<tr>
						<th colspan="13"><cf_get_lang no='517.Mevcut Stoğa Göre Son Alışlar'>: <cfoutput>#tlformat(mevcut_son_alislar)#</cfoutput></th>
					</tr>
					<tr>
						<th><cf_get_lang_main no='75.No'></th>
						<th><cf_get_lang_main no='330.Tarih'></th>
						<th><cf_get_lang_main no='1736.Tedarikçi'></th>
						<th style="text-align:right;"><cf_get_lang no='30.Alış Fiyatı'></th>
						<th style="text-align:right;"><cf_get_lang no='519.Sistem 2 Döviz'></th>
						<th><cf_get_lang no='515.İskontolar'></th>
						<th style="text-align:right;"><cf_get_lang no='516.Net Fiyat'></th>
						<th style="text-align:right;"><cf_get_lang no='172.Ek Maliyet'></th>
						<th style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
					</tr>
					<cfif product_total_stock.recordcount and len(product_total_stock.product_total_stock) and product_total_stock.product_total_stock gt 0>					
						<cfset kalan_stok = product_total_stock.product_total_stock>
					</cfif>
				</thead>
			</cf_medium_list>
			</cfif> --->
			<cfif isdefined("xml_maliyet_onerileri") and xml_maliyet_onerileri eq 1>
				<br/><!--- Maliyet Önerileri --->
				<cf_medium_list>
					<thead>
						<tr>
							<th><a href="javascript://"  onBlur="cevir();" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_add_product_cost_suggestion&pid=<cfoutput>#attributes.pid#</cfoutput>','list')"><img src="/images/plus_list.gif" align="absmiddle" border="0" title="<cf_get_lang no ='653.Maliyet Önerisi Ekle'>"></a></th>
							<th colspan="<cfif session.ep.isBranchAuthorization>17<cfelse>16</cfif>">
								<cf_get_lang dictionary_id='37576.Maliyet Önerileri'>	
							</th>
						</tr>
						<tr class="color-list">
							<th></td>
							<th align="left"><cf_get_lang dictionary_id='57487.No'></th>
							<th align="left"><cf_get_lang dictionary_id='57742.Tarih'></th>
							<th align="left"><cf_get_lang dictionary_id='37510.Envanter Yöntemi'></th>
							<cfif session.ep.isBranchAuthorization>
								<th align="center"><cf_get_lang dictionary_id='57572.Departman'></th>
							</cfif>
							<th><cf_get_lang dictionary_id='37523.Alış Net Maliyet'></th>
							<th><cf_get_lang dictionary_id='37183.Ek Maliyet'></th>
							<th><cf_get_lang dictionary_id='37574.Sistem Alış Net Maliyet'></th>
							<th><cf_get_lang dictionary_id='37575.Sistem Ek Maliyet'></th>
							<th><cf_get_lang dictionary_id='37524.Std Maliyet'></th>
							<th><cf_get_lang dictionary_id='37524.Std Maliyet'> %</th>
							<th><cf_get_lang dictionary_id='37518.Fiyat Koruma'></th>
							<th><cf_get_lang dictionary_id='58258.Maliyet'></th>
							<th><cf_get_lang dictionary_id='37512.Mevcut Stok'></th>
							<th><cf_get_lang dictionary_id='37514.İş Ortakları Stoğu'></th>
							<th><cf_get_lang dictionary_id='58047.Yoldaki Stok'></th>
							<th align="center"><cf_get_lang dictionary_id='54850.Spec ID'></th>
						</tr>
					</thead>
					<tbody>
					<cfoutput query="GET_PRODUCT_COST_SUGGESTION">
						<tr id="row_suggestion#currentrow#" onClick="gizle_goster(suggestion#currentrow#);connectAjax('#currentrow#','#PRODUCT_COST_SUGGESTION_ID#','#get_faction_control.recordcount#')">
							<td align="center">
								<img id="onerı_goster#currentrow#" src="/images/listele.gif" border="0" title="<cf_get_lang dictionary_id ='58596.Göster'>">
								<img id="onerı_gizle#currentrow#" src="/images/listele_down.gif" border="0" title="<cf_get_lang dictionary_id ='58628.Gizle'>" style="display:none">
							</td>	
							<td>#PRODUCT_COST_SUGGESTION_ID#</td>
							<td>#dateformat(START_DATE,dateformat_style)#</td>
							<td>
								<cfif inventory_calc_type eq 1><cf_get_lang dictionary_id='37080.İlk Giren İlk Çıkar'></cfif>
								<cfif inventory_calc_type eq 2><cf_get_lang dictionary_id='37081.Son Giren İlk Çıkar'></cfif>
								<cfif inventory_calc_type eq 3><cf_get_lang dictionary_id='37082.Ağırlıklı Ortalama'></cfif>
								<cfif inventory_calc_type eq 4><cf_get_lang dictionary_id='37083.Son Alış Fiyatı'></cfif>
								<cfif inventory_calc_type eq 5><cf_get_lang dictionary_id='37084.İlk Alış Fiyatı'></cfif>
								<cfif inventory_calc_type eq 6><cf_get_lang dictionary_id='58722.Standart Alış'></cfif>
								<cfif inventory_calc_type eq 7><cf_get_lang dictionary_id='58721.Standart Satış'></cfif>
								<cfif inventory_calc_type eq 8><cf_get_lang dictionary_id='37085.Üretim Maliyeti'></cfif>
							</td>
							<cfif session.ep.isBranchAuthorization>
								<td>#DEPARTMENT#</td>
								<td style="text-align:right;">#tlformat(PURCHASE_NET_LOCATION,round_number)# #PURCHASE_NET_MONEY_LOCATION#</td>
								<td style="text-align:right;">#tlformat(wrk_round(PURCHASE_EXTRA_COST_LOCATION,round_number,1),round_number)# #PURCHASE_NET_MONEY_LOCATION#</td>
								<td style="text-align:right;">#tlformat(PURCHASE_NET_SYSTEM_LOCATION,round_number)# #PURCHASE_NET_SYSTEM_MONEY_LOCATION#</td>
								<td style="text-align:right;">#tlformat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_LOCATION,round_number,1),round_number)# #PURCHASE_NET_SYSTEM_MONEY_LOCATION#</td>
								<td style="text-align:right;">#tlformat(STANDARD_COST_LOCATION,round_number)# #STANDARD_COST_MONEY_LOCATION#</td>
								<td style="text-align:right;">% #tlformat(STANDARD_COST_RATE_LOCATION)#</td>
								<td style="text-align:right;">#tlformat(PRICE_PROTECTION_LOCATION,4)# #PRICE_PROTECTION_MONEY_LOCATION#</td>
								<td style="text-align:right;">#tlformat(PRODUCT_COST_LOCATION,4)# #MONEY_LOCATION#</td>
								<td style="text-align:right;">#tlformat(AVAILABLE_STOCK_LOCATION)#</td>
								<td style="text-align:right;">#tlformat(PARTNER_STOCK_LOCATION)#</td>
								<td style="text-align:right;">#tlformat(ACTIVE_STOCK_LOCATION)#</td>
							<cfelse>
								<td style="text-align:right;">#tlformat(PURCHASE_NET,round_number)# #PURCHASE_NET_MONEY#</td>
								<td style="text-align:right;">#tlformat(wrk_round(PURCHASE_EXTRA_COST,round_number,1),round_number)# #PURCHASE_NET_MONEY#</td>
								<td style="text-align:right;">#tlformat(PURCHASE_NET_SYSTEM,round_number)# #PURCHASE_NET_SYSTEM_MONEY#</td>
								<td style="text-align:right;">#tlformat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM,round_number,1),round_number)# #PURCHASE_NET_SYSTEM_MONEY#</td>
								<td style="text-align:right;">#tlformat(STANDARD_COST,round_number)# #STANDARD_COST_MONEY#</td>
								<td style="text-align:right;">% #tlformat(STANDARD_COST_RATE)#</td>
								<td style="text-align:right;">#tlformat(PRICE_PROTECTION,4)# #PRICE_PROTECTION_MONEY#</td>
								<td style="text-align:right;">#tlformat(PRODUCT_COST,4)# #MONEY#</td>
								<td style="text-align:right;">#tlformat(AVAILABLE_STOCK)#</td>
								<td style="text-align:right;">#tlformat(PARTNER_STOCK)#</td>
								<td style="text-align:right;">#tlformat(ACTIVE_STOCK)#</td>
							</cfif>
							<td style="text-align:right;">#SPECT_MAIN_ID#</td>
						</tr>
						<tr id="suggestion#currentrow#" class="nohover" style="display:none">
							<td colspan="16">
								<div align="left" id="ADD_SUGGESTION#currentrow#" class="nohover_div"></div>
							</td>
						</tr>
					</cfoutput>
					</tbody>
				</cf_medium_list>
			</cfif>
		</cfif>
	</cf_box>
	<cf_box title="#getlang('','Maliyet Tarihçesi','37292')#">
		<cf_grid_list>
			<thead>
				<tr>
					<th></th>
					<!--- Satirlardaki Veriler Degisken Olarak Geliyor --->
					<cfloop list="#ListDeleteDuplicates(xml_stock_based_cost_rows)#" index="xlr">
						<cfswitch expression="#xlr#">
							<cfcase value="1">
								<th style="text-align:left"><cf_get_lang dictionary_id='57487.No'></th>
							</cfcase>
							<cfcase value="2">
								<th style="text-align:left"><cf_get_lang dictionary_id='57742.Tarih'></th>
							</cfcase>
							<cfcase value="3">
								<th style="text-align:left"><cf_get_lang dictionary_id='37510.Envanter Yöntemi'></th>
							</cfcase>
							<cfcase value="4">
								<cfif session.ep.isBranchAuthorization>
									<th align="center"><cf_get_lang dictionary_id='57572.Departman'></th>
								</cfif>
							</cfcase>
							<cfcase value="5">
								<th><cf_get_lang dictionary_id='37358.Net Maliyet'></th>
							</cfcase>
							<cfcase value="6">
								<th><cf_get_lang dictionary_id='37183.Ek Maliyet'></th>
							</cfcase>
							<cfcase value="7">
								<th><cf_get_lang dictionary_id='37358.Net Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
							</cfcase>
							<cfcase value="8">
								<th><cf_get_lang dictionary_id='37183.Ek Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
							</cfcase>
							<cfcase value="9">
								<th><cf_get_lang dictionary_id='37358.Net Maliyet'> (<cfoutput>#session.ep.money#</cfoutput>)</th>
							</cfcase>
							<cfcase value="10">
								<th><cf_get_lang dictionary_id='37183.Ek Maliyet'> (<cfoutput>#session.ep.money#</cfoutput>)</th>
							</cfcase>
							<cfcase value="11">
								<th><cf_get_lang dictionary_id='37524.Std Maliyet'></th>
							</cfcase>
							<cfcase value="12">
								<th><cf_get_lang dictionary_id='37524.Std Maliyet'> %</th>
							</cfcase>
							<cfcase value="13">
								<th><cf_get_lang dictionary_id='37518.Fiyat Koruma'></th>
							</cfcase>
							<cfcase value="14">
								<th><cf_get_lang dictionary_id='37497.Maliyet'></th>
							</cfcase>
							<cfcase value="15">
								<th><cf_get_lang dictionary_id='37497.Maliyet'> (<cfoutput>#session.ep.money2#</cfoutput>)</th>
							</cfcase>
							<cfcase value="16">
								<th><cf_get_lang dictionary_id='37497.Maliyet'> (<cfoutput>#session.ep.money#</cfoutput>)</th>
							</cfcase>
							<cfcase value="17">
								<th><cf_get_lang dictionary_id='37512.Mevcut Stok'></th>
							</cfcase>
							<cfcase value="18">
								<th><cf_get_lang dictionary_id='37514.İş Ortakları Stoğu'></th>
							</cfcase>
							<cfcase value="19">
								<th><cf_get_lang dictionary_id='58047.Yoldaki Stok'></th>
							</cfcase>
							<cfcase value="20">
								<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
									<th style="text-align:center"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
								</cfif>
							</cfcase>
							<cfcase value="21">
								<th style="text-align:center"><cf_get_lang dictionary_id='54850.Spec ID'></th>
							</cfcase>
							<cfcase value="22">
								<th style="text-align:center"><cf_get_lang dictionary_id='37615.Finansal Yaş'></th>
							</cfcase>
							<cfcase value="23">
								<th style="text-align:center"><cf_get_lang dictionary_id='37616.Fiziksel Yaş'></th>
							</cfcase>
							<cfcase value="24">
								<th><cf_get_lang dictionary_id="47561.Yansıyan Maliyet"></th>
							</cfcase>
							<cfcase value="25">
								<th><cf_get_lang dictionary_id="47560.İşçilik Maliyet"></th>
							</cfcase>
							<cfcase value="26">
								<th><cf_get_lang dictionary_id="47561.Yansıyan Maliyet">(<cfoutput>#session.ep.money2#</cfoutput>)</th>
							</cfcase>
							<cfcase value="27">
								<th><cf_get_lang dictionary_id="47560.İşçilik Maliyet">(<cfoutput>#session.ep.money2#</cfoutput>)</th>
							</cfcase>
							<cfcase value="28">
								<th><cf_get_lang dictionary_id="47561.Yansıyan Maliyet"> (<cfoutput>#session.ep.money#</cfoutput>)</th>
							</cfcase>
							<cfcase value="29">
								<th><cf_get_lang dictionary_id="47560.İşçilik Maliyet">(<cfoutput>#session.ep.money#</cfoutput>)</th>
							</cfcase>
						</cfswitch>
					</cfloop>
				</tr>
			</thead>
			<tbody>
			<cfoutput query="get_product_cost">
				<cfif price_protection_type eq 1><cfset type_price = "-"><cfelse><cfset type_price = "+"></cfif>
				<tr>
					<td width="15" align="center"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_form_upd_product_cost&pcid=#PRODUCT_COST_ID#')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='514.Maliyet Güncelle'>"></i></a></td>
					<!--- Satirlardaki Veriler Degisken Olarak Geliyor --->
					<cfloop list="#ListDeleteDuplicates(xml_stock_based_cost_rows)#" index="xlr">
						<cfswitch expression="#xlr#">
							<cfcase value="1"><!--- No --->
								<td>#PRODUCT_COST_ID#</td>
							</cfcase>
							<cfcase value="2"><!--- Tarih --->
								<td>#dateformat(START_DATE,dateformat_style)#</td>
							</cfcase>
							<cfcase value="3"><!--- Envanter Yöntemi --->
								<td>
									<cfif inventory_calc_type eq 1><cf_get_lang dictionary_id='37080.İlk Giren İlk Çıkar'></cfif>
									<cfif inventory_calc_type eq 2><cf_get_lang dictionary_id='37081.Son Giren İlk Çıkar'></cfif>
									<cfif inventory_calc_type eq 3><cf_get_lang dictionary_id='37082.Ağırlıklı Ortalama'></cfif>
									<cfif inventory_calc_type eq 4><cf_get_lang dictionary_id='37083.Son Alış Fiyatı'></cfif>
									<cfif inventory_calc_type eq 5><cf_get_lang dictionary_id='37084.İlk Alış Fiyatı'></cfif>
									<cfif inventory_calc_type eq 6><cf_get_lang dictionary_id='58722.Standart Alış'></cfif>
									<cfif inventory_calc_type eq 7><cf_get_lang dictionary_id='58721.Standart Satış'></cfif>
									<cfif inventory_calc_type eq 8><cf_get_lang dictionary_id='37085.Üretim Maliyeti'></cfif>
								</td>
							</cfcase>
							<cfcase value="4"><!--- Departman --->
								<cfif session.ep.isBranchAuthorization><td>#DEPARTMENT#</td></cfif>
							</cfcase>
							<cfcase value="5"><!--- Net Maliyet --->
								<td style="text-align:right;"><cfif session.ep.isBranchAuthorization>#tlformat(PURCHASE_NET_LOCATION,round_number)# #PURCHASE_NET_MONEY_LOCATION#<cfelse>#tlformat(PURCHASE_NET,round_number)# #PURCHASE_NET_MONEY#</cfif></td>
							</cfcase>
							<cfcase value="6"><!--- Ek Maliyet --->
								<td style="text-align:right;"><cfif session.ep.isBranchAuthorization>#tlformat(wrk_round(PURCHASE_EXTRA_COST_LOCATION,round_number,1),round_number)# #PURCHASE_NET_MONEY_LOCATION#<cfelse>#tlformat(wrk_round(PURCHASE_EXTRA_COST,round_number,1),round_number)# #PURCHASE_NET_MONEY#</cfif></td>
							</cfcase>
							<cfcase value="7"><!--- Net Maliyet (<cfoutput>#session.ep.money2#</cfoutput>)--->
								<td style="text-align:right;">
									<cfif session.ep.isBranchAuthorization>
										#tlformat(PURCHASE_NET_SYSTEM_2_LOCATION,round_number)# #session.ep.money2#
									<cfelse>
										#tlformat(PURCHASE_NET_SYSTEM_2,round_number)# #session.ep.money2#
									</cfif>
								</td>
							</cfcase>
							<cfcase value="8"><!--- Ek Maliyet (<cfoutput>#session.ep.money2#</cfoutput>)--->
								<td style="text-align:right;">
									<cfif session.ep.isBranchAuthorization>
										#tlformat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,round_number,1),round_number)# #session.ep.money2#
									<cfelse>
										#tlformat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,round_number,1),round_number)# #session.ep.money2#
									</cfif>
								</td>
							</cfcase>
							<cfcase value="9"><!--- Maliyet --->
								<td style="text-align:right;"><cfif session.ep.isBranchAuthorization>#tlformat(PURCHASE_NET_SYSTEM_LOCATION,round_number)# #PURCHASE_NET_SYSTEM_MONEY_LOCATION#<cfelse>#tlformat(PURCHASE_NET_SYSTEM,round_number)# #PURCHASE_NET_SYSTEM_MONEY#</cfif></td>
							</cfcase>
							<cfcase value="10"><!--- Ek Maliyet (<cfoutput>#session.ep.money#</cfoutput>) --->
								<td style="text-align:right;"><cfif session.ep.isBranchAuthorization>#tlformat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM_LOCATION,round_number,1),round_number)# #PURCHASE_NET_SYSTEM_MONEY_LOCATION#<cfelse>#tlformat(wrk_round(PURCHASE_EXTRA_COST_SYSTEM,round_number,1),round_number)# #PURCHASE_NET_SYSTEM_MONEY#</cfif></td>
							</cfcase>
							<cfcase value="11"><!--- Std Maliyet --->
								<td style="text-align:right;"><cfif session.ep.isBranchAuthorization>#tlformat(STANDARD_COST_LOCATION,round_number)# #STANDARD_COST_MONEY_LOCATION#<cfelse>#tlformat(STANDARD_COST,round_number)# #STANDARD_COST_MONEY#</cfif></td>
							</cfcase>
							<cfcase value="12"><!--- Std Maliyet % --->
								<td style="text-align:right;"><cfif session.ep.isBranchAuthorization>% #tlformat(STANDARD_COST_RATE_LOCATION)#<cfelse>% #tlformat(STANDARD_COST_RATE)#</cfif></td>
							</cfcase>
							<cfcase value="13"><!--- Fiyat Koruma --->
								<td style="text-align:right;"><cfif session.ep.isBranchAuthorization>#tlformat(PRICE_PROTECTION_LOCATION,4)# #PRICE_PROTECTION_MONEY_LOCATION#<cfelse>#tlformat(PRICE_PROTECTION,4)# #PRICE_PROTECTION_MONEY#</cfif></td>
							</cfcase>
							<cfcase value="14"><!--- Maliyet --->
								<td style="text-align:right;">
									<cfif session.ep.isBranchAuthorization>
										#tlformat(PURCHASE_NET_LOCATION_ALL+wrk_round(PURCHASE_EXTRA_COST_LOCATION,round_number,1),round_number)# #MONEY_LOCATION#
									<cfelse>
										#tlformat(PURCHASE_NET_ALL+wrk_round(PURCHASE_EXTRA_COST,round_number,1),round_number)# #PURCHASE_NET_MONEY#
									</cfif>
								</td>
							</cfcase>
							<cfcase value="15"><!--- Toplam Maliyet  (<cfoutput>#session.ep.money2#</cfoutput>)--->
								<td style="text-align:right;">
									<cfif session.ep.isBranchAuthorization>
										#tlformat(PURCHASE_NET_SYSTEM_2_LOCATION_ALL+wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,round_number,1),round_number)# #session.ep.money2#
									<cfelse>
										#tlformat(PURCHASE_NET_SYSTEM_2_ALL+wrk_round(PURCHASE_EXTRA_COST_SYSTEM_2,round_number,1),round_number)# #session.ep.money2#
									</cfif>
								</td>
							</cfcase>
							<cfcase value="16"><!--- Toplam Maliyet (<cfoutput>#session.ep.money#</cfoutput>) --->
								<td style="text-align:right;">
									<cfif session.ep.isBranchAuthorization>
										#tlformat(PURCHASE_NET_SYSTEM_LOCATION_ALL+wrk_round(PURCHASE_EXTRA_COST_SYSTEM_LOCATION,round_number,1),round_number)# #session.ep.money#
									<cfelse>
										#tlformat(PURCHASE_NET_SYSTEM_ALL+wrk_round(PURCHASE_EXTRA_COST_SYSTEM,round_number,1),round_number)# #session.ep.money#
									</cfif>
								</td>
							</cfcase>
							<cfcase value="17"><!--- Mevcut Stok --->
								<td style="text-align:right;"><cfif session.ep.isBranchAuthorization>#tlformat(AVAILABLE_STOCK_LOCATION)#<cfelse>#tlformat(AVAILABLE_STOCK)#</cfif></td>
							</cfcase>
							<cfcase value="18"><!--- İş Ortakları Stoğu --->
								<td style="text-align:right;"><cfif session.ep.isBranchAuthorization>#tlformat(PARTNER_STOCK_LOCATION)#<cfelse>#tlformat(PARTNER_STOCK)#</cfif></td>
							</cfcase>
							<cfcase value="19"><!--- Yoldaki Stok --->
								<td style="text-align:right;"><cfif session.ep.isBranchAuthorization>#tlformat(ACTIVE_STOCK_LOCATION)#<cfelse>#tlformat(ACTIVE_STOCK)#</cfif></td>
							</cfcase>
							<cfcase value="20"><!--- Stok Kodu --->
								<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
									<td style="text-align:right;" nowrap>#STOCK_CODE#</td>
								</cfif>
							</cfcase>
							<cfcase value="21"><!--- Spec ID --->
								<td style="text-align:right;">#SPECT_MAIN_ID#</td>
							</cfcase>
							<cfcase value="22"><!--- Finansal Yaş --->
								<td style="text-align:right;"><cfif session.ep.isBranchAuthorization><cfif len(DUE_DATE_LOCATION)>#dateformat(DUE_DATE_LOCATION,dateformat_style)#</cfif><cfelse><cfif len(DUE_DATE)>#dateformat(DUE_DATE,dateformat_style)#</cfif></cfif></td>
							</cfcase>
							<cfcase value="23"><!--- Fiziksel Yaş --->
								<td style="text-align:right;"><cfif session.ep.isBranchAuthorization><cfif len(PHYSICAL_DATE_LOCATION)>#dateformat(PHYSICAL_DATE_LOCATION,dateformat_style)#</cfif><cfelse><cfif len(PHYSICAL_DATE)>#dateformat(PHYSICAL_DATE,dateformat_style)#</cfif></cfif></td>
							</cfcase>
							<cfcase value="24">
								<td style="text-align:right;"><cfif session.ep.isBranchAuthorization>#tlformat(wrk_round(STATION_REFLECTION_COST_LOCATION,round_number,1),round_number)# #PURCHASE_NET_MONEY_LOCATION#<cfelse>#tlformat(wrk_round(STATION_REFLECTION_COST,round_number,1),round_number)# #PURCHASE_NET_MONEY#</cfif></td>
							</cfcase>
							<cfcase value="25">
								<td style="text-align:right;"> <cfif session.ep.isBranchAuthorization>#tlformat(wrk_round(LABOR_COST_LOCATION,round_number,1),round_number)# #PURCHASE_NET_MONEY_LOCATION#<cfelse>#tlformat(wrk_round(LABOR_COST,round_number,1),round_number)# #PURCHASE_NET_MONEY#</cfif></td>
							</cfcase>
							<cfcase value="26">
								<td style="text-align:right;">
									<cfif session.ep.isBranchAuthorization>
										#tlformat(wrk_round(STATION_REFLECTION_COST_SYSTEM_2_LOCATION,round_number,1),round_number)# #session.ep.money2#
									<cfelse>
										#tlformat(wrk_round(STATION_REFLECTION_COST_SYSTEM_2,round_number,1),round_number)# #session.ep.money2#
									</cfif>
								</td>
							</cfcase>
							<cfcase value="27">
								<td style="text-align:right;">
									<cfif session.ep.isBranchAuthorization>
										#tlformat(wrk_round(LABOR_COST_SYSTEM_2_LOCATION,round_number,1),round_number)# #session.ep.money2#
									<cfelse>
										#tlformat(wrk_round(LABOR_COST_SYSTEM_2,round_number,1),round_number)# #session.ep.money2#
									</cfif>
								</td>
							</cfcase>
							<cfcase value="28">
								<td style="text-align:right;">
									<cfif session.ep.isBranchAuthorization>
										#tlformat(wrk_round(STATION_REFLECTION_COST_SYSTEM_LOCATION,round_number,1),round_number)# #PURCHASE_NET_SYSTEM_MONEY_LOCATION#
									<cfelse>
										#tlformat(wrk_round(STATION_REFLECTION_COST_SYSTEM,round_number,1),round_number)# #PURCHASE_NET_SYSTEM_MONEY#
									</cfif>
								</td>
							</cfcase>
							<cfcase value="29">
								<td style="text-align:right;">
									<cfif session.ep.isBranchAuthorization>
										#tlformat(wrk_round(LABOR_COST_SYSTEM_LOCATION,round_number,1),round_number)# #PURCHASE_NET_SYSTEM_MONEY_LOCATION#
									<cfelse>
										#tlformat(wrk_round(LABOR_COST_SYSTEM,round_number,1),round_number)# #PURCHASE_NET_SYSTEM_MONEY#
									</cfif>
								</td>
							</cfcase>
						</cfswitch>
					</cfloop>
				</tr>
			</cfoutput>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>
<!--- //ANLAŞMA --->
<cfquery name="get_sevk" datasource="#DSN2#">
	SELECT 
		SUM(STOCK_OUT-STOCK_IN) AS MIKTAR 
	FROM 
		STOCKS_ROW 
	WHERE
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND
		PROCESS_TYPE = 81
		<cfif len(spec_main_id)>
			AND SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#spec_main_id#">
		</cfif>
</cfquery>
<cfif get_sevk.recordcount and len(get_sevk.MIKTAR)>
	<cfset yoldaki_stoklar = get_sevk.MIKTAR>
<cfelse>
	<cfset yoldaki_stoklar = 0>
</cfif>
<script type="text/javascript">
	round_number = document.getElementById('round_number').value;
	function cevir(){
		
		document.getElementById('purchase_net_system').value =  parseFloat(filterNum(document.getElementById('purchase_net_system').value,round_number));
	document.getElementById('purchase_extra_cost_system').value =  parseFloat(filterNum(document.getElementById('purchase_extra_cost_system').value,round_number));
	document.getElementById('purchase_net_system_location').value =  parseFloat(filterNum(document.getElementById('purchase_net_system_location').value,round_number));
	
		
	}
	function open_spec_popup(frm_name)
	{
		if (frm_name == undefined)
		{
			var _form_name_ = 'product_cost';
			var _field_main_id_ = 'product_cost.spect_main_id';
			var _field_name_ = 'product_cost.spect_name';
		}	
		else
		{
			var _form_name_ = frm_name;
			var _field_main_id_ =_form_name_+'.spect_main_id';
			var _field_name_ =_form_name_+'.spect_name';
		}
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=' + _field_main_id_ + '&field_name=' + _field_name_+ '&is_display=1&stock_id=<cfoutput>#GET_STOCK.STOCK_ID#</cfoutput>&function_name=get_stock&function_form_name='+ _form_name_ +'','list');
	}
	function history_money(frm_name)
	{
		if (frm_name == undefined)
		{
			var _form_name_ = 'product_cost';
		}	
		else
		{
			var _form_name_ = frm_name;
		}
		var h_date=js_date(document.getElementById('start_date').value);
		<cfoutput query="GET_MONEY">
			var get_his_rate=wrk_query("SELECT (RATE2/RATE1) RATE,MONEY MONEY_TYPE FROM MONEY_HISTORY WHERE VALIDATE_DATE <= "+h_date+" AND MONEY = '#money#' AND PERIOD_ID = #session.ep.period_id# ORDER BY VALIDATE_DATE DESC,MONEY_HISTORY_ID DESC","dsn");
			if(get_his_rate.recordcount)
				document.getElementById('money_#money#').value=get_his_rate.RATE[0];
			else
				document.getElementById('money_#money#').value=#wrk_round(rate2/rate1,'#session.ep.our_company_info.rate_round_num#')#;
		</cfoutput>
		hesapla();
		return true;
	}
	function hesapla(frm_name)
	{	
	document.getElementById('purchase_net_system').value =  parseFloat(filterNum(document.getElementById('purchase_net_system').value,round_number));
	document.getElementById('purchase_extra_cost_system').value =  parseFloat(filterNum(document.getElementById('purchase_extra_cost_system').value,round_number));
	document.getElementById('purchase_net_system_location').value =  parseFloat(filterNum(document.getElementById('purchase_net_system_location').value,round_number));
		if (frm_name == undefined)
			var _form_name_ = 'product_cost';
		else
			var _form_name_ = frm_name;
		var t1 = parseFloat(filterNum(document.getElementById('purchase_net').value,round_number));
		var t2 = parseFloat(filterNum(document.getElementById('purchase_extra_cost').value,round_number));
		var t3 = parseFloat(filterNum(document.getElementById('standard_cost').value,round_number));
		var t4 = parseFloat(filterNum(document.getElementById('standard_cost_rate').value,round_number));
		var t5 = parseFloat(filterNum(document.getElementById('price_protection').value,round_number));
		
		if(document.getElementById('price_protection_type')!=undefined)
			t5 = t5*document.getElementById('price_protection_type').value;
		
		if (isNaN(t1)) {t1 = 0; document.getElementById('purchase_net').value = 0;}
		if (isNaN(t2)) {t2 = 0; document.getElementById('purchase_extra_cost').value = 0;}
		if (isNaN(t3)) {t3 = 0; document.getElementById('standard_cost').value = 0;}
		if (isNaN(t4)) {t4 = 0;	document.getElementById('standard_cost_rate').value = 0;}
		if (isNaN(t5)) {t5 = 0; document.getElementById('price_protection').value = 0;}
		var q=0;
		if(document.getElementById('reference_money').value != '' && (document.getElementById('money_'+document.getElementById('reference_money').value))!=undefined)
			q=eval(document.getElementById('money_'+document.getElementById('reference_money').value)).value;
		if(document.getElementById('purchase_net_money').value != '' && document.getElementById('money_'+document.getElementById('purchase_net_money').value)!=undefined)
			purchase_money_rate=document.getElementById('money_'+document.getElementById('purchase_net_money').value).value;
		if(!q>0)q=1;
		t1 = (t1 * document.getElementById('money_'+document.getElementById('purchase_net_money').value).value) / q;
		t2 = (t2 * document.getElementById('money_'+document.getElementById('purchase_net_money').value).value) / q;
		t3 = (t3 * document.getElementById('money_'+document.getElementById('standard_cost_money').value).value) / q;
		t5 = (t5 * document.getElementById('money_'+document.getElementById('price_protection_money').value).value) / q;
		var t1_ = parseFloat(filterNum(document.getElementById('purchase_net').value,round_number));
		var t2_ = parseFloat(filterNum(document.getElementById('purchase_extra_cost').value,round_number));
		var t3_ = parseFloat(filterNum(document.getElementById('standard_cost').value,round_number));
		var t4_ = parseFloat(filterNum(document.getElementById('standard_cost_rate').value,round_number));
		var t5_ = parseFloat(filterNum(document.getElementById('price_protection').value,round_number));
		//alert(t1+t2+t3+((t1*t4)/100)-t5); alert(q);
		available_stock = filterNum(document.getElementById('available_stock').value);
		price_prot_amount = filterNum(document.getElementById('price_prot_amount').value);
		if(available_stock != 0)
			t5 = t5*price_prot_amount/available_stock;
		else
			t5 = 0;
		order_total = t1_+t2_+t3_+((t1_*t4_)/100)-t5_;
		document.getElementById('product_cost_').value = commaSplit(order_total,round_number);// input product_cost idi, getElementById ile alindignda form adiyla ayni oldugu icin karistiriyordu.  input adina "_" ekledik. hgul
		document.getElementById('purchase_net_system').value = commaSplit((t1-t5)*q,round_number);
		document.getElementById('purchase_extra_cost_system').value = commaSplit((t2+t3+(t1*t4)/100)*q,round_number);//TolgaS 20070410 Ömer Turhan isteği ile muhasebede sorun olacak diye ek maliyete sabit maliyetler eklendi daha once alış maliyetine idi
		
		<cfif fusebox.Circuit eq 'product'>
			var t5_location = parseFloat(filterNum(document.getElementById('price_protection_location').value,round_number));
			if (isNaN(t5_location)) {t5_location = 0; document.getElementById('price_protection_location').value = 0;}
			if(document.getElementById('money_'+document.getElementById('price_protection_money_location').value) != undefined)
				t5_location = (t5_location * document.getElementById('money_'+document.getElementById('price_protection_money_location').value).value) / q;
			document.getElementById('purchase_net_system_location').value = commaSplit((t1-t5_location)*q,round_number);
		</cfif>
	}
	var ses_period_year = <cfoutput>#session.ep.period_year#</cfoutput>;//ytl tl sorunu olmasın daha sonra kaldırılacak...
	function temizle_virgul(frm_name)
	{
		
		var form_date_year = list_getat(document.getElementById('start_date').value,3,'/');
		if(form_date_year != ses_period_year){
			alert("<cf_get_lang dictionary_id ='37954.Maliyet Tarihi İle Bulunduğunuz Dönem Farklı Maliyet Ekleyemezsiniz'>!");
			return false;
		}
		if (frm_name != undefined)
			var _form_name_ = frm_name;
		else
			var _form_name_ = product_cost;
		<cfif session.ep.isBranchAuthorization>
			if(document.getElementById('department').value=='' || document.getElementById('department_id').value=='' || document.getElementById('location_id').value=='')
			{
				alert("<cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'>");
				return false;
			}
		</cfif>
		if(process_cat_control() == false) return false;
		if(parseFloat(filterNum(document.getElementById('price_protection').value)) > 0 && price_protection_control())//fiyat koruma yapilsinmi
		{
			if(document.getElementById('td_company').value=='' || document.getElementById('td_company_id').value=='')
			{
				alert("<cf_get_lang dictionary_id ='37734.Fiyat Koruma Girecekseniz Tedarikçi Seçmelisiniz'>!");
				return false;
			}
			document.getElementById('cost_control').value=1;
		}
		else 
		{
			document.getElementById('cost_control').value=0;
		}

		if(document.getElementById('standard_cost').value == '')
			document.getElementById('standard_cost').value = 0;
		if(document.getElementById('purchase_net').value == '')
			document.getElementById('purchase_net').value = 0;
		if(document.getElementById('standard_cost_rate').value == '')
			document.getElementById('standard_cost_rate').value = 0;
		if(document.getElementById('purchase_extra_cost').value == '')
			document.getElementById('purchase_extra_cost').value = 0;
		if(document.getElementById('price_protection').value == '')
			document.getElementById('price_protection').value = 0;
		if(document.getElementById('purchase_net_system').value == '')
			document.getElementById('purchase_net_system').value = 0;
		if(document.getElementById('purchase_extra_cost_system').value == '')
			document.getElementById('purchase_extra_cost_system').value = 0;
		if(document.getElementById('purchase_net_system_location').value == '')
			document.getElementById('purchase_net_system_location').value = 0;

		document.getElementById('standard_cost').value = filterNum(document.getElementById('standard_cost').value,round_number);
		document.getElementById('purchase_net').value = filterNum(document.getElementById('purchase_net').value,round_number);
		document.getElementById('available_stock').value = filterNum(document.getElementById('available_stock').value);
		document.getElementById('standard_cost_rate').value = filterNum(document.getElementById('standard_cost_rate').value);
		document.getElementById('purchase_extra_cost').value = filterNum(document.getElementById('purchase_extra_cost').value,round_number);
		document.getElementById('partner_stock').value = filterNum(document.getElementById('partner_stock').value);
		document.getElementById('price_protection').value = filterNum(document.getElementById('price_protection').value,round_number);
		document.getElementById('active_stock').value = filterNum(document.getElementById('active_stock').value);
		document.getElementById('product_cost_').value = filterNum(document.getElementById('product_cost_').value);
		document.getElementById('purchase_net_system').value = filterNum(document.getElementById('purchase_net_system').value,round_number);
		document.getElementById('purchase_extra_cost_system').value = filterNum(document.getElementById('purchase_extra_cost_system').value,round_number);
		document.getElementById('purchase_net_system_location').value = filterNum(document.getElementById('purchase_net_system_location').value,round_number);
		
		if(document.getElementById('price_protection_location')!=undefined)
		{
			if(document.getElementById('price_protection_location').value == '')document.getElementById('price_protection_location').value = 0;
			document.getElementById('price_protection_location').value = filterNum(document.getElementById('price_protection_location').value,round_number);
		}
		if(document.getElementById('total_price_prot')!=undefined)
		{
			if(document.getElementById('total_price_prot').value == '') document.getElementById('total_price_prot').value = 0;
			document.getElementById('total_price_prot').value = filterNum(document.getElementById('total_price_prot').value,round_number);
			if(document.getElementById('price_prot_amount').value == '') document.getElementById('price_prot_amount').value = 0;
			document.getElementById('price_prot_amount').value = filterNum(document.getElementById('price_prot_amount').value,round_number);
		}
		document.getElementById('inventory_calc_type').disabled = false;
		document.getElementById('product_cost_money').disabled = false;
		return true;
	}
	function price_protection_control(frm_name)
	{
		if(confirm("<cf_get_lang dictionary_id ='37735.Fiyat Koruma için Fiyat Farkı Faturası Emri Verilsin mı'>?"))
			return true;
		else
			return false;
	}
	function get_stock(frm_name)
	{
	
	if (frm_name == undefined)
		var _form_name_ = 'product_cost';
	else
		var _form_name_ = frm_name;
		<cfif session.ep.isBranchAuthorization>
			var dep_sql='AND STORE ='+ document.getElementById("department_id").value +' AND STORE_LOCATION ='+ document.getElementById("location_id").value;
		<cfelse>
			var dep_sql='';
		</cfif>
		if(document.getElementById('spect_main_id').value!="" && document.getElementById('spect_name').value!="")
			var spec_query='AND SPECT_VAR_ID='+document.getElementById('spect_main_id').value;
		else
			var spec_query='';
		var gt_stoc=wrk_query('SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK FROM STOCKS_ROW SR WHERE SR.PRODUCT_ID = <cfoutput>#attributes.pid#</cfoutput> AND PROCESS_DATE <='+js_date(document.getElementById('start_date').value)+' '+spec_query+' '+dep_sql,'dsn2');
		if(gt_stoc.PRODUCT_TOTAL_STOCK=="")gt_stoc.PRODUCT_TOTAL_STOCK=0;
		if(gt_stoc.recordcount)
			document.getElementById('available_stock').value = commaSplit(gt_stoc.PRODUCT_TOTAL_STOCK);
		else
			document.getElementById('available_stock').value = '<cfoutput>#tlformat(0)#</cfoutput>';
		
		var get_sevk=wrk_query('SELECT SUM(STOCK_OUT-STOCK_IN) AS MIKTAR FROM STOCKS_ROW WHERE PRODUCT_ID = <cfoutput>#attributes.pid#</cfoutput> AND PROCESS_TYPE = 81 AND PROCESS_DATE <='+js_date(document.getElementById('start_date').value)+' '+spec_query+' '+dep_sql,'dsn2')
		if(get_sevk.MIKTAR=="")get_sevk.MIKTAR=0;
		if(get_sevk.recordcount)
			document.getElementById('active_stock').value= commaSplit(get_sevk.MIKTAR);
		else
			document.getElementById('active_stock').value ='<cfoutput>#tlformat(0)#</cfoutput>';
		document.product_cost.price_prot_amount.value=commaSplit(parseFloat(get_sevk.MIKTAR)+parseFloat(gt_stoc.PRODUCT_TOTAL_STOCK));
		return history_money();
	}
	document.getElementById('available_stock').value = '<cfoutput>#tlformat(mevcut_son_alislar)#</cfoutput>';
	document.getElementById('active_stock').value = '<cfoutput>#tlformat(yoldaki_stoklar)#</cfoutput>';
	document.getElementById('price_prot_amount').value='<cfoutput>#tlformat(mevcut_son_alislar+yoldaki_stoklar)#</cfoutput>';
	document.getElementById('total_stock').value='<cfoutput>#tlformat(mevcut_son_alislar+yoldaki_stoklar)#</cfoutput>';
	hesapla();
	
	function stock_total()
	{
		document.getElementById('total_stock').value=commaSplit(parseFloat(filterNum(document.getElementById('available_stock').value))+parseFloat(filterNum(document.getElementById('active_stock').value))+parseFloat(filterNum(document.getElementById('partner_stock').value)),2);
	}
	function total_price_protection_hesapla(type)
	{
		if(document.getElementById('price_prot_amount').value=="" || document.getElementById('price_prot_amount').value==0) 
			document.getElementById('price_prot_amount').value = 1;
		document.getElementById('price_prot_amount').value=filterNum(document.getElementById('price_prot_amount').value,round_number);
		document.getElementById('total_price_prot').value=filterNum(document.getElementById('total_price_prot').value,round_number);
		document.getElementById('price_protection').value=filterNum(document.getElementById('price_protection').value,round_number);
		if(type == 1)
		{
			 document.getElementById('price_protection').value = document.getElementById('total_price_prot').value / document.getElementById('price_prot_amount').value;
		}else if(type == 2)
		{
			if(document.getElementById('total_price_prot').value!="")
				document.getElementById('price_protection').value = document.getElementById('total_price_prot').value / document.getElementById('price_prot_amount').value;
			else if(document.getElementById('price_protection').value!="")
				document.getElementById('total_price_prot').value = document.getElementById('price_protection').value * document.getElementById('price_prot_amount').value;
		}else if(type == 3)
		{
			if(document.getElementById('price_protection').value!="")
				document.getElementById('total_price_prot').value = document.getElementById('price_protection').value * document.getElementById('price_prot_amount').value;
		}
		document.getElementById('price_prot_amount').value= (isNaN(document.getElementById('price_prot_amount').value))?0:commaSplit(document.getElementById('price_prot_amount').value,round_number);
		document.getElementById('price_protection').value=(isNaN(document.getElementById('price_protection').value))?0:commaSplit(document.getElementById('price_protection').value,round_number);
		document.getElementById('total_price_prot').value=(isNaN(document.getElementById('total_price_prot').value))?0:commaSplit(document.getElementById('total_price_prot').value,round_number);
		hesapla();
	}
</script>

