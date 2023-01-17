<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.pos_manager" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfquery name="GET_PRODUCT_CAT" datasource="#dsn1#">
	SELECT 
		PRODUCT_CAT.PRODUCT_CATID, 
		PRODUCT_CAT.HIERARCHY, 
		PRODUCT_CAT.PRODUCT_CAT
	FROM 
		PRODUCT_CAT,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = #session.ep.company_id# 
	ORDER BY 
		HIERARCHY
</cfquery>
<cfquery name="get_all_period" datasource="#dsn#">
	SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>
<cfset method_name_list = 'Hareketli Ortalama (3 AY),Hareketli Ortalama (4 AY),Hareketli Ortalama (5 AY),Hareketli Ortalama (6 AY),Ağırlıklı Hareketli Ortalama (3 AY),Ağırlıklı Hareketli Ortalama (4 AY),Ağırlıklı Hareketli Ortalama (5 AY),Ağırlıklı Hareketli Ortalama (6 AY),Üstel Düzeltme,Trend Analizi,Mevsimsel Tahmin'>

<cf_catalystHeader>
<cfform name="add_assemption" method="post" action="#request.self#?fuseaction=prod.add_demand_assemption">
	<input type="hidden" name="form_submitted" id="form_submitted" value="1">
	<input type="hidden" name="method_type" id="method_type" value="">
	<input type="hidden" name="show_products" id="show_products" value="0">
	<cf_basket_form id="demand_assemption">
		<div class="row">
			<div class="col col-12 uniqueRow">
				<div class="row formContent">
					<div class="row" type="row">
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        	<div class="form-group" id="item-product_name">
	                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
	                            <div class="col col-9 col-xs-12">
	                                <div class="input-group">
	                                    <input type="hidden" name="stock_id" id="stock_id" <cfif isdefined("attributes.stock_id")>value="<cfoutput>#attributes.stock_id#</cfoutput>"</cfif>>
										<input type="hidden" name="product_id" id="product_id" <cfif isdefined("attributes.product_id")>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
										<input type="text"   name="product_name" id="product_name" style="width:150px;"  <cfif isdefined("attributes.product_name")>value="<cfoutput>#attributes.product_name#</cfoutput>"</cfif> onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','3','225');" autocomplete="off">
	                                    <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&stock_and_spect=1&field_id=add_assemption.stock_id&product_id=add_assemption.product_id&field_name=add_assemption.product_name&keyword='+encodeURIComponent(document.add_assemption.product_name.value),'list');"></span>
                                	</div>
                            	</div>
                        	</div>
                            <div class="form-group" id="item-brand_id">
	                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
	                            <div class="col col-9 col-xs-12">
	                                <cf_wrkProductBrand
										width="150"
										compenent_name="getProductBrand"               
										boxwidth="240"
										boxheight="150"
										brand_ID="#attributes.brand_id#">
                            	</div>
                        	</div>
                            <div class="form-group" id="item-short_code_id">
	                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58225.Model'></label>
	                            <div class="col col-9 col-xs-12">
	                                <cf_wrkProductModel
										returnInputValue="short_code_id,short_code_name"
										returnQueryValue="MODEL_ID,MODEL_NAME"
										width="150"
										fieldName="short_code_name"
										fieldId="short_code_id"
										compenent_name="getProductModel"            
										boxwidth="300"
										boxheight="150"                        
										model_ID="#attributes.short_code_id#">
                            	</div>
                        	</div>
						</div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        	<div class="form-group" id="item-member_name">
	                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
	                            <div class="col col-9 col-xs-12">
	                                <div class="input-group">
										<input type="hidden" name="company_id"  id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
										<input type="text"   name="member_name" id="member_name" style="width:155px;" value="<cfoutput>#attributes.member_name#</cfoutput>" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','COMPANY_ID','company_id','','3','250');" autocomplete="off">
	                                    <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=add_assemption.company_id&field_member_name=add_assemption.member_name&select_list=7&keyword='+encodeURIComponent(document.add_assemption.member_name.value),'list');"></span>
                                	</div>
                            	</div>
                        	</div>
                            <div class="form-group" id="item-pos_manager">
	                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
	                            <div class="col col-9 col-xs-12">
	                                <div class="input-group">
										<input type="hidden" name="pos_code"  id="pos_code" value="<cfif isdefined("attributes.pos_code")><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
										<input name="pos_manager" type="text" id="pos_manager" style="width:155px;" onFocus="AutoComplete_Create('pos_manager','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','pos_code','','3','130');" value="<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)><cfoutput>#attributes.pos_manager#</cfoutput></cfif>" maxlength="255" autocomplete="off">
	                                    <span class="input-group-addon icon-ellipsis btnPointer" title="" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_assemption.pos_code&field_name=add_assemption.pos_manager<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.add_assemption.pos_manager.value),'list','popup_list_positions');"></span>
                                	</div>
                            	</div>
                        	</div>
                            <div class="form-group" id="item-">
	                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
	                            <div class="col col-9 col-xs-12">
                                	<div class="input-group">
                                    	<cfoutput>
											<input type="text" name="start_date" id="start_date" maxlength="10" validate="#validate_style#" style="width:65px;" <cfif isdefined("attributes.start_date") and len(attributes.start_date)>value="#dateformat(attributes.start_date,dateformat_style)#"</cfif>>
	                                    	<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                            <span class="input-group-addon no-bg"></span>
                                    		<input type="text" name="finish_date" id="finish_date" <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>value="#dateformat(attributes.finish_date,dateformat_style)#"</cfif> validate="#validate_style#" style="width:65px;">		
										</cfoutput>
	                                    <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
	                                </div>
	                            </div>
	                        </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        	<div class="form-group" id="item-product_cat">
	                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></label>
	                            <div class="col col-9 col-xs-12">
                                    <select name="product_cat" id="product_cat" style="width:200px;height:80px;" multiple="multiple">
                                        <cfoutput query="get_product_cat">
                                        <cfif listlen(HIERARCHY,".") lte 3>
                                            <option value="#HIERARCHY#" <cfif isdefined("attributes.product_cat") and listfind(attributes.product_cat,HIERARCHY)>selected</cfif>>#HIERARCHY#-#product_cat#</option>
                                        </cfif>
                                        </cfoutput>
                                    </select>	
                               	</div>
                            </div>
                        </div>
					</div>
                    <div class="row formContentFooter">
	                    <div class="col col-12 text-right">
	                        <cf_wrk_search_button button_type='1' is_excel='0' search_function="kontrol_form()">
	                    </div>
                	</div>
				</div>
			</div>
		</div>
	</cf_basket_form>
</cfform>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_product" datasource="#dsn3#">
		SELECT
			STOCK_ID,
			PRODUCT_ID,
			PRODUCT_NAME,
			SUM(SALE_AMOUNT) AMOUNT
		FROM
		(
			SELECT
				S.STOCK_ID,
				S.PRODUCT_ID,
				S.PRODUCT_NAME,
				MS.SALE_AMOUNT
			FROM
				STOCKS S,
				MONTHLY_SALES_AMOUNT MS
			WHERE
				S.STOCK_ID = MS.STOCK_ID
				<cfif isdefined("attributes.stock_id") and len(attributes.stock_id) and len(attributes.product_name)>
					AND S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> 
				</cfif>
				<cfif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_manager)>
					AND S.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> 
				</cfif>
				<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and len(attributes.brand_name)>
					AND S.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"> 
				</cfif>
				<cfif isdefined("attributes.short_code_id") and len(attributes.short_code_id) and len(attributes.short_code_name)>
					AND S.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_code_id#"> 
				</cfif>				
				<cfif isdefined("attributes.product_cat") and len(attributes.product_cat)>
					 AND
						(
							<cfloop from="1" to="#listlen(attributes.product_cat)#" index="c"> 
							(S.PRODUCT_CODE LIKE '#ListGetAt(attributes.product_cat,c,',')#.%')
							<cfif C neq listlen(attributes.product_cat)>OR</cfif>
							</cfloop>
						)
				</cfif>
				<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.member_name)>
					AND S.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> 
				</cfif>
				<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
					AND MS.MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#month(attributes.start_date)#"> 
					AND MS.YEAR >= <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.start_date)#"> 
				</cfif>
				<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
					AND MS.MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#month(attributes.finish_date)#"> 
					AND MS.YEAR <= <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.finish_date)#"> 
				</cfif>
			UNION ALL
			SELECT
				S.STOCK_ID,
				S.PRODUCT_ID,
				S.PRODUCT_NAME,
				SR.STOCK_OUT SALE_AMOUNT
			FROM
				STOCKS S,
				#dsn2_alias#.STOCKS_ROW SR
			WHERE
				S.STOCK_ID = SR.STOCK_ID
				AND SR.PROCESS_TYPE = 71
				<cfif isdefined("attributes.stock_id") and len(attributes.stock_id) and len(attributes.product_name)>
					AND S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> 
				</cfif>
				<cfif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_manager)>
					AND S.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> 
				</cfif>
				<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and len(attributes.brand_name)>
					AND S.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"> 
				</cfif>
				<cfif isdefined("attributes.short_code_id") and len(attributes.short_code_id) and len(attributes.short_code_name)>
					AND S.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_code_id#"> 
				</cfif>				
				<cfif isdefined("attributes.product_cat") and len(attributes.product_cat)>
					 AND
						(
							<cfloop from="1" to="#listlen(attributes.product_cat)#" index="c"> 
							(S.PRODUCT_CODE LIKE '#ListGetAt(attributes.product_cat,c,',')#.%')
							<cfif C neq listlen(attributes.product_cat)>OR</cfif>
							</cfloop>
						)
				</cfif>
				<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.member_name)>
					AND S.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> 
				</cfif>
				<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
					AND SR.PROCESS_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#"> 
				</cfif>
				<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
					AND SR.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#"> 
				</cfif>
			UNION ALL
			SELECT
				S.STOCK_ID,
				S.PRODUCT_ID,
				S.PRODUCT_NAME,
				-1*SR.STOCK_IN SALE_AMOUNT
			FROM
				STOCKS S,
				#dsn2_alias#.STOCKS_ROW SR
			WHERE
				S.STOCK_ID = SR.STOCK_ID
				AND SR.PROCESS_TYPE = 74
				<cfif isdefined("attributes.stock_id") and len(attributes.stock_id) and len(attributes.product_name)>
					AND S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> 
				</cfif>
				<cfif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_manager)>
					AND S.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> 
				</cfif>
				<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and len(attributes.brand_name)>
					AND S.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"> 
				</cfif>
				<cfif isdefined("attributes.short_code_id") and len(attributes.short_code_id) and len(attributes.short_code_name)>
					AND S.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_code_id#"> 
				</cfif>				
				<cfif isdefined("attributes.product_cat") and len(attributes.product_cat)>
					 AND
						(
							<cfloop from="1" to="#listlen(attributes.product_cat)#" index="c"> 
							(S.PRODUCT_CODE LIKE '#ListGetAt(attributes.product_cat,c,',')#.%')
							<cfif C neq listlen(attributes.product_cat)>OR</cfif>
							</cfloop>
						)
				</cfif>
				<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.member_name)>
					AND S.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> 
				</cfif>
				<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
					AND SR.PROCESS_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.start_date#"> 
				</cfif>
				<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
					AND SR.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finish_date#"> 
				</cfif>
		)T1
		GROUP BY
			STOCK_ID,
			PRODUCT_ID,
			PRODUCT_NAME	
	</cfquery>
	<cf_basket id="demand_assemption_bask">
		<cfif attributes.show_products eq 0>
			<table>
				<cfif get_product.recordcount>
					<cfoutput>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id="36450.Toplam Ürün Sayısı"></td>
							<td>: #get_product.recordcount#</td>
							<cfif not len(attributes.method_type)>
								<td><input type="button" name="calc_products" id="calc_products" value="<cf_get_lang dictionary_id='36544.Hesaplama Başlat'>" onClick="calc_products_func(1)"></td>
							</cfif>
						</tr>
					</cfoutput>
					<cfif len(attributes.method_type)>
						<tr>
							<td class="txtbold"><cf_get_lang dictionary_id="29472.Yöntem"></td>
							<td>: <cfoutput>#listgetat(method_name_list,attributes.method_type)#</cfoutput></td>
						</tr>
						<cfif listfind('1,2,3,4',attributes.method_type)><!--- haraketli ortalama yöntemleri --->
							<cfinclude template="add_demand_assemption_1.cfm">
						<cfelseif listfind('5,6,7,8',attributes.method_type)><!--- ağırlıklı ortalama yöntemleri --->
							<cfinclude template="add_demand_assemption_2.cfm">
						<cfelseif attributes.method_type eq 9><!--- üstel düzeltme --->
							<cfinclude template="add_demand_assemption_3.cfm">
						<cfelseif attributes.method_type eq 10><!--- trend analizi --->
							<cfinclude template="add_demand_assemption_4.cfm">
						<cfelseif attributes.method_type eq 11><!--- mevsimsel trend analizi --->
							<cfinclude template="add_demand_assemption_5.cfm">
						</cfif>
					</cfif>
				<cfelse>
					<tr>
						<td><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
					</tr>	
				</cfif>
			</table>
		<cfelse>
			<cfinclude template="show_demand_assemption.cfm">
		</cfif>
		<cfif len(attributes.method_type)>
			<cf_basket_footer>
				<cfoutput>
					<cfif attributes.method_type neq 11>
						<input type="button" name="calc_products" id="calc_products" value="Devam Et" onClick="calc_products_func(#attributes.method_type#+1);">
					<cfelse>
						<input type="button" name="show_products" id="show_products" value="Metod Karşılaştırma" onClick="show_products();">
					</cfif>
				</cfoutput>
			</cf_basket_footer>
		</cfif>
	</cf_basket>
</cfif>
<script language="javascript">
	function show_products()
	{
		add_assemption.show_products.value = 1;
		add_assemption.submit();
	}
	function calc_products_func(type)
	{
		
		method_name = list_getat("<cfoutput>#method_name_list#</cfoutput>",type);
		alert(method_name);
		if(confirm("<cf_get_lang dictionary_id='60572.Seçilen Ürünler İçin Hesaplama Yapılacak Emin misiniz'>? <cf_get_lang dictionary_id='29472.Yöntem'>:" +method_name))
		{
			add_assemption.method_type.value = type;
			add_assemption.submit();
		}
		else
			return false;
	}
	function kontrol_form()
	{
		if(add_assemption.product_cat.value.length == 0 && (add_assemption.short_code_id.value.length == 0 || add_assemption.short_code_name.value.length == 0) && (add_assemption.stock_id.value.length == 0 || add_assemption.product_name.value.length == 0) && (add_assemption.brand_id.value.length == 0 || add_assemption.brand_name.value.length == 0) && (add_assemption.pos_code.value.length == 0 || add_assemption.pos_manager.value.length == 0) && (add_assemption.company_id.value.length == 0 || add_assemption.member_name.value.length == 0))
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58950.En az bir alanda filtre etmelisiniz '>!</cfoutput>"}) 
			return false;
		}		
		else
			return true;
	}
</script>
