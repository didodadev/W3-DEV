<!--- Detayli Satis Teklif Raporu FBS 20090619 --->
<cf_xml_page_edit fuseact="report.detail_sale_offer_report">
<cfparam name="attributes.module_id_control" default="20,11">
<cfinclude template="report_authority_control.cfm">
<cf_get_lang_set module_name="report">
<cfparam name="attributes.product_cat_id" default="">
<cfparam name="attributes.sales_partner_id" default="">
<cfparam name="attributes.sales_partner" default="">
<cfparam name="attributes.product_cat_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.product_employee_id" default="">
<cfparam name="attributes.product_employee_name" default="">
<cfparam name="attributes.product_target_market" default="">
<cfparam name="attributes.sale_employee_id" default="">
<cfparam name="attributes.sale_employee_name" default="">
<cfparam name="attributes.provider_id" default="">
<cfparam name="attributes.provider_name" default="">
<cfparam name="attributes.customer_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.customer_position_code" default="">
<cfparam name="attributes.customer_position_name" default="">
<cfparam name="attributes.customer_value" default="">
<cfparam name="attributes.customer_cat_type" default="">
<cfparam name="attributes.customer_relation_type" default="">
<cfparam name="attributes.customer_sector_cat" default="">
<cfparam name="attributes.city" default="">
<cfparam name="attributes.country" default="">
<cfparam name="attributes.sales_zone" default="">
<cfparam name="attributes.reference_customer_id" default="">
<cfparam name="attributes.reference_consumer_id" default="">
<cfparam name="attributes.reference_member_name" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_name" default="">
<cfparam name="attributes.to_convert_order" default="">
<cfparam name="attributes.private_definition" default="">
<cfparam name="attributes.offer_start_date" default="">
<cfparam name="attributes.offer_finish_date" default="">
<cfparam name="attributes.valid_start_date" default="">
<cfparam name="attributes.valid_finish_date" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.report_type" default="">
<cfparam name="attributes.graph_type" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.other_money2" default="">
<cfparam name="attributes.kdv_deger" default="">
<cfparam name="attributes.order_quantity" default="">
<cfparam name="attributes.probability" default="">
<cfquery name="get_product_target_market" datasource="#dsn1#">
	SELECT PRODUCT_SEGMENT_ID,PRODUCT_SEGMENT FROM PRODUCT_SEGMENT ORDER BY PRODUCT_SEGMENT
</cfquery>
<cfquery name="get_customer_value" datasource="#dsn#">
	SELECT CUSTOMER_VALUE_ID,CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
</cfquery>
<cfquery name="GET_SALE_ZONES" datasource="#DSN#">
    SELECT SZ_ID,SZ_NAME FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
</cfquery>
<cfquery name="GET_OFFER_ROW_TAX" datasource="#dsn3#">
	SELECT 
		TAX, 
		PRICE, 
		OFFER_ID, 
		DISCOUNT_1, 
		DISCOUNT_2, 
		DISCOUNT_3, 
		DISCOUNT_4, 
		DISCOUNT_5, 
		DISCOUNT_6, 
		DISCOUNT_7,
		DISCOUNT_8, 
		DISCOUNT_9, 
		DISCOUNT_10,
		QUANTITY,
		EXTRA_PRICE_TOTAL,
		ISNULL(DISCOUNT_COST,0) AS ROW_DISC_COST 
	FROM 
		OFFER_ROW
</cfquery>
<cfquery name="get_customer_cat" datasource="#dsn#">
	SELECT DISTINCT	
		COMPANYCAT_ID,
		COMPANYCAT
	FROM
		GET_MY_COMPANYCAT
	WHERE
		EMPLOYEE_ID = #session.ep.userid# AND
		OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY
		COMPANYCAT
</cfquery>
<cfquery name="get_consumer_cat" datasource="#dsn#">
	SELECT DISTINCT	
		CONSCAT_ID,
		CONSCAT,
		HIERARCHY
	FROM
		GET_MY_CONSUMERCAT
	WHERE
		EMPLOYEE_ID = #session.ep.userid# AND
		OUR_COMPANY_ID = #session.ep.company_id#
	ORDER BY
		HIERARCHY		
</cfquery>
<cfquery name="get_customer_sector_cat" datasource="#dsn#">
	SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS ORDER BY SECTOR_CAT
</cfquery>
<cfquery name="get_city_name" datasource="#dsn#">
	SELECT CITY_ID,CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfquery name="get_country_name" datasource="#dsn#">
	SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfquery name="get_private_definition" datasource="#dsn3#">
	SELECT SALES_ADD_OPTION_ID,SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS ORDER BY SALES_ADD_OPTION_NAME
</cfquery>
<cfquery name="get_process_stage" datasource="#dsn#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		(PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.list_offer%"> OR PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.detail_offer_tv%">)
	ORDER BY
		PTR.LINE_NUMBER,
		PTR.STAGE
</cfquery>
<cfquery name="setup_system_money" datasource="#dsn#">
	SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS = 1 AND PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfif isdefined("attributes.form_submitted")>
<cffunction name="hesapla_total">
	<cfargument name="int_off_id" type="numeric">
	<cfargument name="price_type" type="numeric" default="1">
	<cfif len(arguments.int_off_id)>
	   <cfquery name="GET_TOTAL" datasource="#DSN3#">
			SELECT
				SUM(PRICE) AS PRICE,
				SUM(PRICE*QUANTITY) NET_PRICE
			FROM
				OFFER_ROW
			WHERE
				OFFER_ID = #arguments.int_off_id#
	   </cfquery>
	   <cfif price_type eq 1>
		   <cfreturn GET_TOTAL.PRICE>
		<cfelse>
			<cfreturn GET_TOTAL.NET_PRICE>
	   </cfif>
	<cfelse>
		<cfreturn "yok">
	</cfif>
</cffunction>
	<cfif isdate(attributes.offer_start_date)><cf_date tarih = "attributes.offer_start_date"></cfif>
	<cfif isdate(attributes.offer_finish_date)><cf_date tarih = "attributes.offer_finish_date"></cfif>
	<cfif isdate(attributes.valid_start_date)><cf_date tarih = "attributes.valid_start_date"></cfif>
	<cfif isdate(attributes.valid_finish_date)><cf_date tarih = "attributes.valid_finish_date"></cfif>
	<cfinclude template="../query/get_detail_sale_offer.cfm">
	<cfif (attributes.report_type eq 1 or attributes.report_type eq 2) and len(get_detail_sale_offer.offer_id)>
		<cfquery name="get_offer_money" datasource="#dsn3#">
			SELECT ACTION_ID,IS_SELECTED,CASE WHEN MONEY_TYPE ='YTL' THEN 'TL' ELSE MONEY_TYPE END AS MONEY_TYPE,RATE2 FROM OFFER_MONEY WHERE ACTION_ID IN (#ValueList(get_detail_sale_offer.offer_id,',')#) ORDER BY ACTION_ID
		</cfquery>
	</cfif>
<cfelse>
	<cfset get_detail_sale_offer.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_detail_sale_offer.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdate(attributes.offer_start_date)><cfset attributes.offer_start_date = dateformat(attributes.offer_start_date, dateformat_style)></cfif>
<cfif isdate(attributes.offer_finish_date)><cfset attributes.offer_finish_date = dateformat(attributes.offer_finish_date, dateformat_style)></cfif>
<cfif isdate(attributes.valid_start_date)><cfset attributes.valid_start_date = dateformat(attributes.valid_start_date, dateformat_style)></cfif>
<cfif isdate(attributes.valid_finish_date)><cfset attributes.valid_finish_date = dateformat(attributes.valid_finish_date, dateformat_style)></cfif>
<cfform name="rapor" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">	
<cfsavecontent variable="title"><cf_get_lang dictionary_id='40554.Detaylı Teklif Raporu'></cfsavecontent>
<cf_report_list_search title="#title#">
	<cf_report_list_search_area>
		<div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="product_cat_id" id="product_cat_id" value="<cfif len(attributes.product_cat_name)><cfoutput>#attributes.product_cat_id#</cfoutput></cfif>">
											<input type="text" name="product_cat_name" id="product_cat_name" value="<cfif len(attributes.product_cat_name)><cfoutput>#attributes.product_cat_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('product_cat_name','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','HIERARCHY','product_cat_code','','3','200');">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_id=rapor.product_cat_id&field_name=rapor.product_cat_name&is_sub_category=1');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined('attributes.consumer_id') and len(attributes.member_name)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
											<input type="hidden" name="customer_id" id="customer_id" value="<cfif len(attributes.member_name)><cfoutput>#attributes.customer_id#</cfoutput></cfif>">
											<input type="text" name="member_name" id="member_name" value="<cfif len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=rapor.member_name&field_comp_id=rapor.customer_id&field_consumer=rapor.consumer_id&field_member_name=rapor.member_name&select_list=2,3','list');"></span>
										
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39364.Satışı Yapan'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="sale_employee_id" id="sale_employee_id" value="<cfif len(attributes.sale_employee_name)><cfoutput>#attributes.sale_employee_id#</cfoutput></cfif>">
											<input type="text" name="sale_employee_name" id="sale_employee_name" value="<cfif len(attributes.sale_employee_name)><cfoutput>#attributes.sale_employee_name#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('sale_employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE,MEMBER_NAME','employee_id,employee','','3','135');">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=rapor.sale_employee_id&field_name=rapor.sale_employee_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<!--- <input type="hidden" name="provider_id" id="provider_id" value="<cfif len(attributes.provider_name)><cfoutput>#attributes.provider_id#</cfoutput></cfif>">
											<input type="text" name="provider_name" id="provider_name" value="<cfif len(attributes.provider_name)><cfoutput>#attributes.provider_name#</cfoutput></cfif>">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=rapor.provider_name&field_comp_id=rapor.provider_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2','list');"></span> --->
											<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
											<input name="company" type="text" id="company" style="width:100px;" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','150');" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfoutput>#get_par_info(attributes.company_id,1,1,0)#</cfoutput></cfif>" autocomplete="off">
											<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=search_product.company&field_comp_id=search_product.company_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2&keyword='+encodeURIComponent(document.search_product.company.value),'list','popup_list_pars');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58795.Müşteri Temsilcisi'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="customer_position_code" id="customer_position_code" value="<cfif len(attributes.customer_position_name) and len(attributes.customer_position_code)><cfoutput>#attributes.customer_position_code#</cfoutput></cfif>">
											<input type="text" name="customer_position_name" id="customer_position_name" value="<cfif len(attributes.customer_position_name) and len(attributes.customer_position_code)><cfoutput>#get_emp_info(attributes.customer_position_code,1,0)#</cfoutput></cfif>">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=rapor.customer_position_code&field_name=rapor.customer_position_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58448.Ürün Sorumlusu'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="product_employee_id" id="product_employee_id" value="<cfif len(attributes.product_employee_name)><cfoutput>#attributes.product_employee_id#</cfoutput></cfif>">
											<input type="text" name="product_employee_name" id="product_employee_name" value="<cfif len(attributes.product_employee_name)><cfoutput>#attributes.product_employee_name#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('product_employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','125');">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=rapor.product_employee_id&field_name=rapor.product_employee_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>">
											<input type="text" name="project_name" id="project_name" value="<cfif isdefined('attributes.project_name') and  len(attributes.project_name)><cfoutput>#attributes.project_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('project_name','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=rapor.project_id&project_head=rapor.project_name');"></span>
										</div>
									</div>
								</div>	
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='49283.satış Ortağı'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="sales_partner_id" id="sales_partner_id" value="<cfoutput>#attributes.sales_partner_id#</cfoutput>">
                                    		<input name="sales_partner" type="text" id="sales_partner" onFocus="AutoComplete_Create('sales_partner','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2\',\'<cfif session.ep.isBranchAuthorization>1<cfelse>0</cfif>\',0,0','MEMBER_ID','sales_partner_id','','3','250');" value="<cfoutput>#attributes.sales_partner#</cfoutput>" autocomplete="off">
                                   			<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=rapor.sales_partner_id&field_name=rapor.sales_partner&select_list=2,3','list');"></span>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="form-group">
									<cfif xml_probability eq 1>
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58652.Olasılık'></label> 
										<div class="col col-12 col-xs-12">
											<select name="probability" id="probability" multiple>
												<option value=""><cf_get_lang dictionary_id='39473.Yüzde'></option>
												<cfoutput>
													<cfloop from="0" to="100" index="i" step="5">
														<option value="#i#" <cfif listfind(attributes.probability,i)>selected</cfif>>#i#</option>
													</cfloop>
												</cfoutput>
											</select>
										</div>
									</cfif>
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="product_id" id="product_id" value="<cfif len(attributes.product_name)><cfoutput>#attributes.product_id#</cfoutput></cfif>">
											<input type="text" name="product_name" id="product_name" value="<cfoutput>#attributes.product_name#</cfoutput>" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','form','3','200');">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=rapor.product_id&field_name=rapor.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>										
									<cf_wrk_list_items  table_name ='PRODUCT_BRANDS' wrk_list_object_id='BRAND_ID' wrk_list_object_name='BRAND_NAME' sub_header_name="#getLang('main',1435)#" header_name="#getLang('report',1818)#" width='300' datasource ="#dsn1#">
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58636.Referans Üye'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="reference_consumer_id" id="reference_consumer_id" value="<cfif isdefined('attributes.reference_consumer_id') and len(attributes.reference_member_name)>#attributes.reference_consumer_id#</cfif>">
											<input type="hidden" name="reference_customer_id" id="reference_customer_id" value="<cfif len(attributes.reference_member_name)><cfoutput>#attributes.reference_customer_id#</cfoutput></cfif>">
											<input type="text" name="reference_member_name" id="reference_member_name" value="<cfif len(attributes.reference_member_name)><cfoutput>#attributes.reference_member_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('reference_member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=rapor.reference_member_name&field_comp_id=rapor.reference_customer_id&field_consumer=rapor.reference_consumer_id&field_member_name=rapor.reference_member_name&select_list=7,8','list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58552.Müşteri Değeri'></label> 
									<div class="col col-12 col-xs-12">
									<cfoutput>
											<select name="customer_value" id="customer_value">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfloop query="get_customer_value">
													<option value="#customer_value_id#" <cfif attributes.customer_value eq customer_value_id>selected</cfif>>#customer_value#</option>
												</cfloop>
											</select>	
									</cfoutput>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39224.İlişki Tipi'></label> 
									<div class="col col-12 col-xs-12">
										<cfoutput>
											<cf_wrk_combo
												name="customer_relation_type"
												query_name="GET_PARTNER_RESOURCE"
												option_name="resource"
												option_value="resource_id"
												value="#attributes.customer_relation_type#"
												width="130">
										</cfoutput>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label> 
									<div class="col col-12 col-xs-12">
										<select name="report_type" id="report_type">
											<option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
											<option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57612.Fırsat'><cf_get_lang dictionary_id='57989.ve'><cf_get_lang dictionary_id='57452.Stok'><cf_get_lang dictionary_id='58601.Bazında'></option>
											<option value="3" <cfif attributes.report_type eq 3>selected</cfif>><cf_get_lang dictionary_id='39685.Belge ve Stok Bazinda'></option>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39370.Hedef Pazar'></label> 
									<div class="col col-12 col-xs-12">
									<cfoutput>
										<select name="product_target_market" id="product_target_market">
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfloop query="get_product_target_market">
												<option value="#PRODUCT_SEGMENT_ID#" <cfif attributes.product_target_market eq PRODUCT_SEGMENT_ID>Selected</cfif>>#PRODUCT_SEGMENT#</option>
											</cfloop>
										</select>
									</cfoutput>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">											
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57579.Sektör'></label> 
									<div class="col col-12 col-xs-12">
										<select name="customer_sector_cat" id="customer_sector_cat">
											<cfoutput>
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfloop query="get_customer_sector_cat">
												<option value="#sector_cat_id#" <cfif sector_cat_id eq attributes.customer_sector_cat>selected</cfif>>#sector_cat#</option>
											</cfloop>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39282.Özel Tanım'></label> 
									<div class="col col-12 col-xs-12">
									<select name="private_definition" id="private_definition">
										<cfoutput>
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfloop query="get_private_definition">
												<option value="#sales_add_option_id#" <cfif sales_add_option_id eq attributes.private_definition>selected</cfif>>#sales_add_option_name#</option>
											</cfloop>
										</cfoutput>
									</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label> 
									<div class="col col-12 col-xs-12">
										<cfoutput>
											<select name="country" id="country">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfloop query="get_country_name">
													<option value="#country_id#" <cfif attributes.country eq country_id>selected</cfif>>#country_name#</option>
												</cfloop>
											</select>
										</cfoutput>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58608.İl'></label> 
									<div class="col col-12 col-xs-12">
										<cfoutput>
											<select name="city" id="city">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfloop query="get_city_name">
													<option value="#city_id#" <cfif attributes.city eq city_id>selected</cfif>>#city_name#</option>
												</cfloop>
											</select>
										</cfoutput>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></label> 
									<div class="col col-12 col-xs-12">
										<cfoutput>
											<select name="sales_zone" id="sales_zone">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfloop query="GET_SALE_ZONES">
													<option value="#sz_id#" <cfif attributes.sales_zone eq sz_id>selected</cfif>>#sz_name#</option>
												</cfloop>
											</select>
										</cfoutput>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='40555.Sipariş Durumu'></label> 
									<div class="col col-12 col-xs-12">
										<cfoutput>
											<select name="to_convert_order" id="to_convert_order">
												<option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<option value="1" <cfif attributes.to_convert_order eq 1>selected</cfif>><cf_get_lang dictionary_id='60693.Siparişe Dönüşmüş'></option>
												<option value="0" <cfif attributes.to_convert_order eq 0>selected</cfif>><cf_get_lang dictionary_id='60694.Siparişe Dönüşmemiş'></option>
											</select>
										</cfoutput>
									</div>
								</div>
								
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57950.Grafik Format'></label>
									<div class="col col-6">
											<select name="graph_type" id="graph_type">
												<option value="" selected><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<option value="radar" <cfif attributes.graph_type eq 'radar'> selected</cfif>><cf_get_lang dictionary_id='60666.Radar'></option>
												<option value="pie"<cfif attributes.graph_type eq 'pie'> selected</cfif>><cf_get_lang dictionary_id='58728.Pasta'></option>
												<option value="bar"<cfif attributes.graph_type eq 'bar'> selected</cfif>><cf_get_lang dictionary_id='57663.Bar'></option>
											</select>
										</div>
										<div class="col col-6">
											<select name="status" id="status">
												<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
												<option value="0"<cfif attributes.status eq 0> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
												<option value="1"<cfif attributes.status eq 1> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
											</select>	
										</div>		
									
								</div>							
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58054.Süreç-Aşama'></label> 
									<div class="col col-12 col-xs-12">
									<cfoutput>
											<select name="process_stage" id="process_stage" multiple>
												<cfloop query="get_process_stage">
													<option value="#process_row_id#"<cfif listfind(attributes.process_stage,process_row_id)>selected</cfif>>#stage#</option>
												</cfloop>
											</select>
									</cfoutput>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></label> 
									<div class="col col-12 col-xs-12">
									<cfoutput>
											<select name="customer_cat_type" id="customer_cat_type" multiple>
												<optgroup label="<cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'>">
													<cfloop query="get_customer_cat">
														<option value="1-#companycat_id#" <cfif listfind(attributes.customer_cat_type,'1-#companycat_id#',',')>selected</cfif>>&nbsp;&nbsp;#companycat#</option>
													</cfloop>						
												</optgroup>
												<optgroup label="Bireysel Üye Kategorileri">
													<cfloop query="get_consumer_cat">
														<option value="2-#conscat_id#" <cfif listfind(attributes.customer_cat_type,'2-#conscat_id#',',')>selected</cfif>>&nbsp;&nbsp;#conscat#</option>
													</cfloop>						
												</optgroup>
											</select>		
									</cfoutput>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='46831.Teklif Tarihi'></label>
									<div class="col col-6">
										<div class="input-group">
											<cfinput type="text" name="offer_start_date" value="#attributes.offer_start_date#" validate="#validate_style#" maxlength="10">
											<span class="input-group-addon"><cf_wrk_date_image date_field="offer_start_date"></span>
										</div>
									</div>	
									<div class="col col-6">
										<div class="input-group">
											<cfinput type="text" name="offer_finish_date" value="#attributes.offer_finish_date#" validate="#validate_style#" maxlength="10">
											<span class="input-group-addon"><cf_wrk_date_image date_field="offer_finish_date"></span>
										</div>	
									</div>	
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'></label>
									<div class="col col-6">
										<div class="input-group">	
											<cfinput type="text" name="valid_start_date" value="#attributes.valid_start_date#" validate="#validate_style#" maxlength="10">
											<span class="input-group-addon"><cf_wrk_date_image date_field="valid_start_date"></span>
										</div>
									</div>
									<div class="col col-6">
										<div class="input-group">											
											<cfinput type="text" name="valid_finish_date" value="#attributes.valid_finish_date#" validate="#validate_style#" maxlength="10">
											<span class="input-group-addon"><cf_wrk_date_image date_field="valid_finish_date"></span>
										</div>		
									</div>
								</div>
								<div class="form-group">
									<div class="col col-12 col-xs-12"></div>
										<div class="col col-12 col-xs-12">
											<label class="col col-12"><cf_get_lang dictionary_id='39059.Kdv Dahil'><input name="kdv_deger" id="kdv_deger" type="checkbox" value="1" <cfif isdefined("attributes.kdv_deger") and (attributes.kdv_deger eq 1)>checked</cfif>></label>
											<label class="col col-12"><cf_get_lang dictionary_id='40754.Sipariş Miktarı Gelsin'><input name="order_quantity" id="order_quantity" type="checkbox" value="1" <cfif isdefined("attributes.order_quantity") and (attributes.order_quantity eq 1)>checked</cfif>></label>
										</div>
									
								</div>
							</div>							
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
						    <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" required="yes" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" required="yes" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
							<input type="hidden" name="form_submitted" id="form_submitted" value="">
							<cf_wrk_report_search_button search_function='kontrol_form()' insert_info='#message#' button_type='1' is_excel="1"> 
						</div>
					</div>
				</div>
		</div>
	</cf_report_list_search_area>
</cf_report_list_search>
</cfform>	
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
<!--- <cfset filename = "#createuuid()#"> --->
	<cfset filename = "detayli_firsat_raporu#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<cfset type_ = 1>
		<cfset attributes.startrow=1>
		<cfset attributes.maxrows=get_detail_sale_offer.recordcount>
	<cfelse>
		<cfset type_ = 0>
	</cfif>
<cfif isdefined("attributes.form_submitted")>
<cf_report_list>
		<thead>
			<tr>
				<th width="25">&nbsp;<cfif attributes.report_type eq 3><cf_get_lang dictionary_id="57487.No"></cfif></th>
				<cfif attributes.report_type eq 1>
					<!--- Belge Bazinda --->
					<th nowrap><cf_get_lang dictionary_id='58212.Teklif No'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id="58794.Ref No"></th>
					<th><cf_get_lang dictionary_id='57480.Konu'></th>
					<th><cf_get_lang dictionary_id='57578.Yetkili'></th>
					<th><cf_get_lang dictionary_id='49283.satış Ortağı'></th>
					<th><cf_get_lang dictionary_id='40294.Satış Çalışanı'></th>
					<th><cf_get_lang dictionary_id='29472.Yöntem'></th>
					<th><cf_get_lang dictionary_id='58054.Süreç- Aşama'></th>
					<th><cf_get_lang dictionary_id='39282.Özel Tanım'></th>				
					<cfif xml_country eq 1>
						<th><cf_get_lang dictionary_id='58219.Ülke'></th>
						<th><cf_get_lang dictionary_id='57659.Satış Bölgesi'></th>
					</cfif>
					<cfif attributes.kdv_deger eq 1>
						<th><cf_get_lang dictionary_id="54859.KDV Tutar"></th>
						<th><cf_get_lang dictionary_id="39432.Net Tutar"></th>
					</cfif>
					<th><cf_get_lang dictionary_id='57673.Tutar'></th>
					<th><cf_get_lang dictionary_id='58474.P Birimi'></th>
					<cfif xml_probability eq 1> <th><cf_get_lang dictionary_id='58652.Olasılık'> %</th></cfif>
				<cfelseif attributes.report_type eq 2>
					<th><cf_get_lang dictionary_id='57416.Proje'><!--- Firsatin Projesi ---></th>
					<th><cf_get_lang dictionary_id='57612.Fırsat'><!--- Basligi ---></th>
					<th><cf_get_lang dictionary_id='57457.Müşteri'><!--- Firsatin ---></th>
					<th><cf_get_lang dictionary_id='57578.Yetkili'><!--- Firsatin ---></th>
					<th><cf_get_lang dictionary_id='49283.satış Ortağı'></th>	 
					<th><cf_get_lang dictionary_id='40285.Satış Yapan'></th>
					<th><cf_get_lang dictionary_id='57612.Fırsat'><cf_get_lang dictionary_id='58593.Tarihi'></th>
					<th><cf_get_lang dictionary_id='57545.Teklif'><cf_get_lang dictionary_id='58593.Tarihi'></th>
					<th><cf_get_lang dictionary_id='57480.Başlık'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
					<th><cf_get_lang dictionary_id='29401.Ürün Kategorisi'></th>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th><cf_get_lang dictionary_id='39282.Özel Tanım'></th>								
					<cfif xml_country eq 1>
						<th><cf_get_lang dictionary_id='58219.Ülke'></th>
						<th><cf_get_lang dictionary_id='57659.Satış Bölgesi'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th><cf_get_lang dictionary_id='57636.Birim'></th>
					<th><cf_get_lang dictionary_id='58084.Fiyat'></th>
					<th><cf_get_lang dictionary_id='57673.Tutar'></th>
					<th><cf_get_lang dictionary_id='58474.P Birimi'></th>
					<cfoutput>
						<th>#session.ep.money2# <cf_get_lang dictionary_id='57673.Tutar'><!--- Teklif Tarihindeki Kurdan satırdaki net döviz fiyatın Euro Karşılığı ---></th>
						<th>#DateFormat(now(),'dd/mm/yy')# #session.ep.money2# <cf_get_lang dictionary_id='57673.Tutar'><!--- Bugünün tarihindeki Kurdan satırdaki net döviz fiyatın  Euro Karşılığı ---></th>
						<th>%</th>
						<th>% #session.ep.money2#</th>
					</cfoutput>
					<th><cf_get_lang dictionary_id='57612.Fırsat'><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th><cf_get_lang dictionary_id='29533.Tedarikçi'></th>
					<th><cf_get_lang dictionary_id='58779.Rakip'></th>
					<th><cf_get_lang dictionary_id='57545.Teklif'><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
				<cfelse>
					<th><cf_get_lang dictionary_id='58212.Teklif No'></th>
					<th><cf_get_lang dictionary_id='57545.Teklif'><cf_get_lang dictionary_id='58593.Tarihi'></th>
					<th><cf_get_lang dictionary_id="58794.Ref No"></th>
					<th><cf_get_lang dictionary_id='57480.Başlık'></th>
					<th width="150"><cf_get_lang dictionary_id='57574.Şirket'> - <cf_get_lang dictionary_id='57578.Yetkili'></th>
					<th><cf_get_lang dictionary_id='49283.satış Ortağı'></th>
					<th width="150"><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id='58847.Marka'></th>
					<th><cf_get_lang dictionary_id='58225.Model'></th>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th><cf_get_lang dictionary_id='39282.Özel Tanım'></th>								
					<cfif xml_country eq 1>
						<th><cf_get_lang dictionary_id='58219.Ülke'></th>
						<th><cf_get_lang dictionary_id='57659.Satış Bölgesi'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='57635.Miktar'></th>
					<cfif attributes.order_quantity eq 1>
						<th><cf_get_lang dictionary_id='40755.Sipariş Edilen Miktar'></th>
						<th><cf_get_lang dictionary_id='40270.Kalan Miktar'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='57636.Birim'></th>
					<th><cf_get_lang dictionary_id='58084.Fiyat'></th>
					<th><cf_get_lang dictionary_id='38843.Net Fiyat'></th>
					<th><cf_get_lang dictionary_id='40569.Fiyat'></th>
					<th><cf_get_lang dictionary_id='39411.Döviz Net Fiyat'></th>
					<cfif attributes.kdv_deger eq 1>
						<th><cf_get_lang dictionary_id="54859.KDV Tutar"></th>
					</cfif>
					<th><cf_get_lang dictionary_id='58474.P Birimi'></th>
					<th><cf_get_lang dictionary_id='57673.Tutar'></th>
					<th><cf_get_lang dictionary_id='39432.Net Tutar'></th>
					<th><cf_get_lang dictionary_id="39656.Döviz Tutar"></th>
					<th><cf_get_lang dictionary_id="40700.Döviz Net Tutar"></th>
					<th><cf_get_lang dictionary_id='39697.İskonto Tutarı'></th>
				</cfif>
				<cfif xml_net_maliyet eq 1>
					<th><cf_get_lang dictionary_id='58258.Maliyet'></th>
				</cfif>
			</tr>
        </thead>
		<cfif get_detail_sale_offer.recordcount>
			<cfset partner_id_list = "">
			<cfset company_id_list = "">
			<cfset consumer_id_list = "">
			<cfset employee_id_list = "">
			<cfset offer_stage_list = "">
			<cfset related_opp_list = "">
			<cfset product_id_list = "">
			<cfset product_cat_id_list = "">
			<cfset product_brand_id_list = "">
			<cfset product_model_id_list = "">
			<cfset sales_partner_list = "">
			<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
				<cfset attributes.startrow=1>
				<cfset attributes.maxrows=get_detail_sale_offer.recordcount>
			</cfif>
			<cfoutput query="get_detail_sale_offer" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(partner_id) and not listFindnocase(partner_id_list,partner_id)>
					<cfset partner_id_list = listappend(partner_id_list,partner_id)>
				</cfif>
				<cfif len(company_id) and not listFindnocase(company_id_list,company_id)>
					<cfset company_id_list=listappend(company_id_list,company_id)>
				</cfif>
				<cfif len(consumer_id) and not listFindnocase(consumer_id_list,consumer_id)>
					<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
				</cfif>
				<cfif ListLen(offer_to_partner,',')>
					<cfset partner_id_list=listappend(partner_id_list,offer_to_partner)>
				</cfif>
				<cfif len(sales_emp_id) and not listfind(employee_id_list,sales_emp_id)>
					<cfset employee_id_list = Listappend(employee_id_list,sales_emp_id)>
				</cfif>
				<cfif len(offer_stage) and not listfind(offer_stage_list,offer_stage)>
					<cfset offer_stage_list=listappend(offer_stage_list,offer_stage)>
				</cfif>
				<cfif attributes.report_type eq 2>
					<cfif len(opp_id) and not listfind(related_opp_list,opp_id)>
						<cfset related_opp_list=listappend(related_opp_list,opp_id)>
					</cfif>
					<cfif len(product_id) and not listfind(product_id_list,product_id)>
						<cfset product_id_list=listappend(product_id_list,product_id)>
					</cfif>
				</cfif>
				<cfif attributes.report_type eq 3>
					<cfif len(brand_id) and not listfind(product_brand_id_list,brand_id) >
						<cfset product_brand_id_list=listappend(product_brand_id_list,brand_id)>
					</cfif>
					<cfif len(short_code_id) and not listfind(product_model_id_list,short_code_id) >
						<cfset product_model_id_list=listappend(product_model_id_list,short_code_id)>
					</cfif>
					<cfif len(product_catid) and not listfind(product_cat_id_list,product_catid)>
						<cfset product_cat_id_list=listappend(product_cat_id_list,product_catid)>
					</cfif>
				</cfif>
			</cfoutput>
			<cfif attributes.report_type eq 3>
				<cfif ListLen(product_cat_id_list)>
					<cfset product_cat_id_list=listsort(product_cat_id_list,"numeric","ASC",",")>
					<cfquery name="get_product_cat_name" datasource="#dsn3#">
						SELECT PRODUCT_CATID,PRODUCT_CAT FROM  PRODUCT_CAT  WHERE PRODUCT_CATID IN (#product_cat_id_list#) ORDER BY PRODUCT_CATID
					</cfquery>
					<cfset product_cat_id_list = ListSort(ListDeleteDuplicates(ValueList(get_product_cat_name.product_catid,',')),"numeric","asc",",")>
				</cfif>
				<cfif ListLen(product_brand_id_list)>
				<cfset product_brand_id_list=listsort(product_brand_id_list,"numeric","ASC",",")>
					<cfquery name="get_pro_brand" datasource="#dsn1#">
						SELECT BRAND_ID,BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID IN (#product_brand_id_list#) ORDER BY BRAND_ID
					</cfquery>
					<cfset product_brand_id_list = ListSort(ListDeleteDuplicates(ValueList(get_pro_brand.brand_id,',')),"numeric","asc",",")>
				</cfif>
				<cfif ListLen(product_model_id_list)>
				<cfset product_model_id_list=listsort(product_model_id_list,"numeric","ASC",",")>
					<cfquery name="get_pro_model" datasource="#dsn1#">
						SELECT MODEL_ID,MODEL_NAME FROM PRODUCT_BRANDS_MODEL WHERE MODEL_ID IN (#product_model_id_list#) ORDER BY MODEL_ID
					</cfquery>
					<cfset product_model_id_list = ListSort(ListDeleteDuplicates(ValueList(get_pro_model.model_id,',')),"numeric","asc",",")>
				</cfif>
			</cfif>
			<cfif listlen(partner_id_list)>
				<cfset partner_id_list=listsort(partner_id_list,"numeric","ASC",",")>
				<cfquery name="get_partner_detail" datasource="#dsn#">
					SELECT
						CP.COMPANY_PARTNER_NAME,
						CP.COMPANY_PARTNER_SURNAME,
						CP.PARTNER_ID,						
						C.FULLNAME,
						C.NICKNAME,
						C.COMPANY_ID
					FROM 
						COMPANY_PARTNER CP,
						COMPANY C
					WHERE 
						CP.PARTNER_ID IN (#partner_id_list#) AND
						CP.COMPANY_ID = C.COMPANY_ID
					ORDER BY
						CP.PARTNER_ID
				</cfquery>
				<cfset partner_id_list = listsort(listdeleteduplicates(valuelist(get_partner_detail.partner_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif listlen(company_id_list)>
				<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
				<cfquery name="get_company_detail" datasource="#dsn#">
					SELECT COMPANY_ID,NICKNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
				</cfquery>
				<cfset main_company_id_list = listsort(listdeleteduplicates(valuelist(get_company_detail.company_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif listlen(consumer_id_list)>
				<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
				<cfquery name="get_consumer_detail" datasource="#dsn#">
					SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
				</cfquery>
				<cfset consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer_detail.consumer_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(employee_id_list)>
				<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
				<cfquery name="get_position" datasource="#dsn#">
					SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
				</cfquery>
				<cfset employee_id_list=listsort(listdeleteduplicates(ValueList(get_position.EMPLOYEE_ID,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(offer_stage_list)>
				<cfset offer_stage_list=listsort(offer_stage_list,"numeric","ASC",",")>
				<cfquery name="process_type" datasource="#dsn#">
					SELECT PROCESS_ROW_ID,STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#offer_stage_list#) ORDER BY PROCESS_ROW_ID
				</cfquery>
				<cfset offer_stage_list=listsort(ListDeleteDuplicates(ValueList(process_type.process_row_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif attributes.report_type eq 2>
				<cfif ListLen(related_opp_list)>
					<cfset opp_info_list = "">
					<cfset opp_project_list = "">
					<cfset opp_rival_company_list = "">
					<cfset opp_partner_list = "">
					<cfset opp_consumer_list = "">
					<cfset related_opp_list=listsort(related_opp_list,"numeric","ASC",",")>
					<cfquery name="get_opp_info" datasource="#dsn3#">
						SELECT
							O.OPP_ID,
							O.OPP_HEAD,
							O.OPP_DATE,
							<!--- O.PROBABILITY, --->
							PTR.STAGE,
							(SELECT PROBABILITY_RATE FROM SETUP_PROBABILITY_RATE WHERE PROBABILITY_RATE_ID = O.PROBABILITY) PROBABILITY 
						FROM
							OPPORTUNITIES O,
							#dsn_alias#.PROCESS_TYPE_ROWS PTR
						WHERE
							O.OPP_STAGE = PTR.PROCESS_ROW_ID AND
							O.OPP_ID IN (#related_opp_list#)
						ORDER BY
							O.OPP_ID
					</cfquery>
					<cfset opp_info_list = ListSort(ListDeleteDuplicates(ValueList(get_opp_info.opp_id,',')),"numeric","asc",",")>
					
					<cfquery name="get_opp_project" datasource="#dsn3#">
						SELECT
							O.OPP_ID,
							P.PROJECT_ID,
							P.PROJECT_HEAD
						FROM
							OPPORTUNITIES O,
							#dsn_alias#.PRO_PROJECTS P
						WHERE
							O.PROJECT_ID = P.PROJECT_ID AND
							O.OPP_ID IN (#related_opp_list#)
						ORDER BY
							O.OPP_ID
					</cfquery>
					<cfset opp_project_list = ListSort(ListDeleteDuplicates(ValueList(get_opp_project.opp_id,',')),"numeric","asc",",")>
					
					<cfquery name="get_opp_rival_company" datasource="#dsn3#">
						SELECT
							O.OPP_ID,
							C.COMPANY_ID,
							C.FULLNAME,
							CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME PARTNER_NAME
						FROM
							OPPORTUNITIES O,
							#dsn_alias#.COMPANY C,
							#dsn_alias#.COMPANY_PARTNER CP
						WHERE
							O.RIVAL_PARTNER_ID = CP.PARTNER_ID AND
							CP.COMPANY_ID = C.COMPANY_ID AND
							O.OPP_ID IN (#related_opp_list#)
						ORDER BY
							O.OPP_ID
					</cfquery>
					<cfset opp_rival_company_list = ListSort(ListDeleteDuplicates(ValueList(get_opp_rival_company.opp_id,',')),"numeric","asc",",")>
				
					<cfquery name="get_opp_partner" datasource="#dsn3#">
						SELECT
							O.OPP_ID,
							C.COMPANY_ID,
							CP.PARTNER_ID,
							C.FULLNAME,
							CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME PARTNER_NAME
						FROM
							OPPORTUNITIES O,
							#dsn_alias#.COMPANY C,
							#dsn_alias#.COMPANY_PARTNER CP
						WHERE
							O.PARTNER_ID = CP.PARTNER_ID AND
							CP.COMPANY_ID = C.COMPANY_ID AND
							O.OPP_ID IN (#related_opp_list#)
						ORDER BY
							O.OPP_ID
					</cfquery>
					<cfset opp_partner_list = ListSort(ListDeleteDuplicates(ValueList(get_opp_partner.opp_id,',')),"numeric","asc",",")>
										
					<cfquery name="get_opp_consumer" datasource="#dsn3#">
						SELECT
							O.OPP_ID,
							C.CONSUMER_ID,
							C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME CONSUMER_NAME
						FROM
							OPPORTUNITIES O,
							#dsn_alias#.CONSUMER C
						WHERE
							O.CONSUMER_ID = C.CONSUMER_ID AND
							O.OPP_ID IN (#related_opp_list#)
						ORDER BY
							O.OPP_ID
					</cfquery>
					<cfset opp_consumer_list = ListSort(ListDeleteDuplicates(ValueList(get_opp_consumer.opp_id,',')),"numeric","asc",",")>
				</cfif>
				<cfif ListLen(product_id_list)>
					<cfset product_id_list=listsort(product_id_list,"numeric","ASC",",")>
					<cfquery name="get_product_cat" datasource="#dsn3#">
						SELECT P.PRODUCT_ID, PC.PRODUCT_CAT FROM PRODUCT P, PRODUCT_CAT PC WHERE P.PRODUCT_CATID = PC.PRODUCT_CATID AND P.PRODUCT_ID IN (#product_id_list#) ORDER BY P.PRODUCT_ID
					</cfquery>
					<cfset product_id_list = ListSort(ListDeleteDuplicates(ValueList(get_product_cat.product_id,',')),"numeric","asc",",")>
				</cfif>
			</cfif>
			<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
				<cfset attributes.startrow=1>
				<cfset attributes.maxrows=get_detail_sale_offer.recordcount>
			</cfif>
			<cfset page_total_money2 = 0>
			<cfset page_total_money2_now = 0>
			<cfset page_total_prob = 0>
			<cfset page_total_prob_money2 = 0>
			<cfset om_list = "">
			<cfset sepet_total = 0>
			<cfset sepet_toplam_indirim = 0>
			<cfset sepet_total_tax = 0>
			<cfset sepet_net_total = 0>
			<cfoutput query="get_detail_sale_offer">
				<cfset 'total_value_#other_money#' = 0>
			</cfoutput>
        	<tbody>
			<cfoutput query="get_detail_sale_offer" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td style="text-align:center;">#currentrow#</td>
					<cfquery name="get_money_" datasource="#dsn3#">
						SELECT RATE1,RATE2 FROM OFFER_MONEY WHERE ACTION_ID = #offer_id# AND MONEY_TYPE = '#session.ep.money2#'
					</cfquery>
					<!--- Bugunun Kur Bilgileri - Oturumdaki para birimi --->
					<cfquery name="get_today_money2" dbtype="query">
						SELECT RATE1,RATE2,MONEY FROM setup_system_money WHERE MONEY = '#session.ep.money2#'
					</cfquery>
					<cfif Len(get_money_.RATE1)>
						<cfset rate_1 = get_money_.RATE1>
					<cfelse>
						<cfset rate_1 = get_today_money2.RATE1>
					</cfif>

					<cfif Len(get_money_.RATE2)>
						<cfset rate_2 = get_money_.RATE2>
					<cfelse>
						<cfset rate_2 = get_today_money2.RATE2>
					</cfif>
					<cfif attributes.report_type eq 2 or attributes.report_type eq 3>
						<cfif len(discount_1)><cfset indirim1 = discount_1><cfelse><cfset indirim1 =0></cfif>
						<cfif len(discount_2)><cfset indirim2 = discount_2><cfelse><cfset indirim2 =0></cfif>
						<cfif len(discount_3)><cfset indirim3 = discount_3><cfelse><cfset indirim3 =0></cfif>
						<cfif len(discount_4)><cfset indirim4 = discount_4><cfelse><cfset indirim4 =0></cfif>
						<cfif len(discount_5)><cfset indirim5 = discount_5><cfelse><cfset indirim5 =0></cfif>
						<cfif len(discount_6)><cfset indirim6 = discount_6><cfelse><cfset indirim6 =0></cfif>
						<cfif len(discount_7)><cfset indirim7 = discount_7><cfelse><cfset indirim7 =0></cfif>
						<cfif len(discount_8)><cfset indirim8 = discount_8><cfelse><cfset indirim8 =0></cfif>
						<cfif len(discount_9)><cfset indirim9 = discount_9><cfelse><cfset indirim9 =0></cfif>
						<cfif len(discount_10)><cfset indirim10 = discount_10><cfelse><cfset indirim10 =0></cfif>
						<cfset indirim_carpan = (100-indirim1) * (100-indirim2) * (100-indirim3) * (100-indirim4) * (100-indirim5) * (100-indirim6) * (100-indirim7) * (100-indirim8) * (100-indirim9) * (100-indirim10)>
						<cfset row_total = (quantity * price) + extra_price_total>
						<cfset row_nettotal = row_total - (ROW_DISC_COST * rate_2 / rate_1 * quantity)>
						<cfset row_nettotal = wrk_round((row_nettotal * indirim_carpan)/100000000000000000000,2)>
						<cfset row_taxtotal = wrk_round((row_nettotal * (tax/100)),2)>
					</cfif>
					<cfif attributes.report_type eq 1>
						<td style="text-align:center;">
							<cfif type_ eq 1>
								#offer_number#
							<cfelse>
								<a href="#request.self#?fuseaction=sales.list_offer&event=upd&offer_id=#offer_id#">#offer_number#</a>							
							</cfif>
						</td>
						
						<td style="text-align:center;">#dateformat(offer_date,dateformat_style)#</td>
						<td>#ref_no#</td>
						<td>
							<cfif type_ eq 1>
								<cfif attributes.is_excel neq 1>#Left(offer_head,33)#<cfelse>#offer_head#</cfif>
							<cfelse>
								<a href="#request.self#?fuseaction=sales.list_offer&event=upd&offer_id=#offer_id#" <cfif Len(offer_head) gt 33>title="#offer_head#"</cfif> ><cfif attributes.is_excel neq 1>#Left(offer_head,33)#<cfelse>#offer_head#</cfif></a>
							</cfif>
						</td>
						<!---şirket--->
						<td>
							<cfif len(company_id) and not Listlen(offer_to_partner)>
								<cfif type_ eq 1>
									#get_company_detail.nickname[listfind(main_company_id_list,company_id,',')]#
								<cfelse>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');" >#get_company_detail.nickname[listfind(main_company_id_list,company_id,',')]#</a>								
								</cfif>								
							</cfif>
							<cfif len(consumer_id)>
								<cfif type_ eq 1>
									#get_consumer_detail.consumer_name[listfind(consumer_id_list,consumer_id,',')]#&nbsp; #get_consumer_detail.consumer_surname[listfind(consumer_id_list,consumer_id,',')]#
								<cfelse>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&consumer_id=#consumer_id#','medium');" >#get_consumer_detail.consumer_name[listfind(consumer_id_list,consumer_id,',')]#&nbsp; #get_consumer_detail.consumer_surname[listfind(consumer_id_list,consumer_id,',')]#</a>
								</cfif>								
							</cfif>
							<cfif Listlen(offer_to_partner)>
								<cfloop list="#offer_to_partner#" index="i">
									<cfif type_ eq 1>
										#get_partner_detail.nickname[listfind(partner_id_list,i,',')]# - #get_partner_detail.company_partner_name[listfind(partner_id_list,i,',')]# #get_partner_detail.company_partner_surname[listfind(partner_id_list,i,',')]#
									<cfelse>
										<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_partner_detail.company_id[listfind(partner_id_list,i,',')]#','medium');">#get_partner_detail.nickname[listfind(partner_id_list,i,',')]#</a> -
										<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#i#','medium');">#get_partner_detail.company_partner_name[listfind(partner_id_list,i,',')]# #get_partner_detail.company_partner_surname[listfind(partner_id_list,i,',')]#</a>									
									</cfif>
								</cfloop>
							</cfif>
						</td>
						<!---şirket--->
						<td>
							<cfif len(sales_partner_id)>  
								<cfif type_ eq 1>
									#get_par_info(sales_partner_id,0,-1,0)#-#get_par_info(sales_partner_id,0,1,0)#
								<cfelse>
									#get_par_info(sales_partner_id,0,-1,0)#-#get_par_info(sales_partner_id,0,1,1)#							
								</cfif>		
											
							</cfif>
						</td>
						<td>
							<cfif type_ eq 1>
								#get_position.employee_name[listfind(employee_id_list,get_detail_sale_offer.sales_emp_id,',')]#&nbsp;#get_position.employee_surname[listfind(employee_id_list,get_detail_sale_offer.sales_emp_id,',')]#
							<cfelse>
								<cfif len(sales_emp_id)><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_position.employee_id[listfind(employee_id_list,get_detail_sale_offer.sales_emp_id,',')]#','medium');">#get_position.employee_name[listfind(employee_id_list,get_detail_sale_offer.sales_emp_id,',')]#&nbsp;#get_position.employee_surname[listfind(employee_id_list,get_detail_sale_offer.sales_emp_id,',')]#</a></cfif>
							</cfif>
						</td>
						<td><cfif is_partner_zone eq 1><cf_get_lang dictionary_id='58885.Partner'></cfif><cfif is_partner_zone eq 1 and is_public_zone eq 1>&amp;</cfif><cfif is_public_zone eq 1><cf_get_lang dictionary_id='39565.Public'></cfif></td>
						<td><cfif len(offer_stage)>#process_type.stage[listfind(offer_stage_list,offer_stage,',')]#</cfif></td>
						<td>
							<cfif isdefined('attributes.private_definition') and len(attributes.private_definition)>
								<cfquery name="private_definition_row" datasource="#dsn3#">
									SELECT SALES_ADD_OPTION_ID,SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS WHERE SALES_ADD_OPTION_ID = #attributes.private_definition#
								</cfquery>
								#private_definition_row.SALES_ADD_OPTION_NAME#
							<cfelse>	
								<cfset SALES_ADD_OPTION_ID_ = "#SALES_ADD_OPTION_ID#">
								<cfif len(SALES_ADD_OPTION_ID_)>
									<cfquery name="private_definition_row" datasource="#dsn3#">
										SELECT SALES_ADD_OPTION_ID,SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS WHERE SALES_ADD_OPTION_ID = #SALES_ADD_OPTION_ID_#
									</cfquery>
										#private_definition_row.SALES_ADD_OPTION_NAME#
								</cfif>
							</cfif>
						</td>
						<cfif xml_country eq 1>
                            <td style="text-align:right;">#COUNTRY_NAME#</td>
                            <td style="text-align:right;">#SZ_NAME#</td>
                        </cfif>
						<cfif attributes.kdv_deger eq 1>
							<!---<td style="text-align:right;">#TLFormat(row_taxtotal/OTHER_MONEY_RATE)#</td>
							<td style="text-align:right;"><cfif len(HESAPLA_TOTAL(offer_id,2))>#TLFormat(HESAPLA_TOTAL(offer_id,2)/OTHER_MONEY_RATE)#<cfelse>#TLFormat(0)#</cfif></td>
							--->
							<cfquery name="get_offer_row_tax_" dbtype="query">
								SELECT 
									TAX, 
									PRICE,  
									DISCOUNT_1, 
									DISCOUNT_2, 
									DISCOUNT_3, 
									DISCOUNT_4, 
									DISCOUNT_5, 
									DISCOUNT_6, 
									DISCOUNT_7,
									DISCOUNT_8, 
									DISCOUNT_9, 
									DISCOUNT_10,
									QUANTITY,
									EXTRA_PRICE_TOTAL,
									ROW_DISC_COST  
								FROM 
									GET_OFFER_ROW_TAX 
								WHERE OFFER_ID = #OFFER_ID#
							</cfquery>
							<cfset row_taxtotal = 0>
							<cfloop query="get_offer_row_tax_">
								<cfif len(discount_1)><cfset indirim1 = discount_1><cfelse><cfset indirim1 =0></cfif>
								<cfif len(discount_2)><cfset indirim2 = discount_2><cfelse><cfset indirim2 =0></cfif>
								<cfif len(discount_3)><cfset indirim3 = discount_3><cfelse><cfset indirim3 =0></cfif>
								<cfif len(discount_4)><cfset indirim4 = discount_4><cfelse><cfset indirim4 =0></cfif>
								<cfif len(discount_5)><cfset indirim5 = discount_5><cfelse><cfset indirim5 =0></cfif>
								<cfif len(discount_6)><cfset indirim6 = discount_6><cfelse><cfset indirim6 =0></cfif>
								<cfif len(discount_7)><cfset indirim7 = discount_7><cfelse><cfset indirim7 =0></cfif>
								<cfif len(discount_8)><cfset indirim8 = discount_8><cfelse><cfset indirim8 =0></cfif>
								<cfif len(discount_9)><cfset indirim9 = discount_9><cfelse><cfset indirim9 =0></cfif>
								<cfif len(discount_10)><cfset indirim10 = discount_10><cfelse><cfset indirim10 =0></cfif>
								<cfset indirim_carpan = (100-indirim1) * (100-indirim2) * (100-indirim3) * (100-indirim4) * (100-indirim5) * (100-indirim6) * (100-indirim7) * (100-indirim8) * (100-indirim9) * (100-indirim10)>
								<cfset row_total = (quantity * price) + extra_price_total>
								<cfset row_nettotal = row_total - (ROW_DISC_COST * rate_2 / rate_1 * quantity)>
								<cfset row_nettotal = wrk_round((row_nettotal * indirim_carpan)/100000000000000000000,2)>
								<cfset row_taxtotal = wrk_round(row_taxtotal + (row_nettotal * (tax/100)),2)>
							</cfloop>
							<cfquery name="get_mny_" dbtype="query">
								SELECT RATE2 FROM get_offer_money WHERE IS_SELECTED = 1 AND ACTION_ID = #OFFER_ID#
							</cfquery>
							<cfset row_taxtotal = row_taxtotal / get_mny_.rate2>
							<td style="text-align:right;" format="numeric">#TLFormat(wrk_round(row_taxtotal,2),2)#</td>
							<td style="text-align:right;" format="numeric">#TLformat((other_money_value-row_taxtotal),2)#</td>
						</cfif>
						<td style="text-align:right;" format="numeric">#TLformat(other_money_value,2)#</td>
						<td style="text-align:center;">#other_money#</td>
						<cfset 'total_value_#other_money#' = Evaluate('total_value_#other_money#') + other_money_value>
						<cfif len(other_money) and not ListFind(om_list,other_money)>
							<cfset om_list = ListAppend(om_list,other_money)>
						</cfif>
                        <cfif xml_probability eq 1><td style="text-align:center;">#probability#</td></cfif>
					<cfelseif attributes.report_type eq 2>
						<td><cfif len(opp_id) and len(related_opp_list)>#get_opp_project.project_head[ListFind(opp_project_list,opp_id,',')]#</cfif></td>
						<td>
							<cfif len(opp_id) and len(related_opp_list)>
                               	<cfif type_ neq 1>
									<a href="#request.self#?fuseaction=sales.list_opportunity&event=det&opp_id=#opp_id#" target="_blank" >#get_opp_info.opp_head[ListFind(opp_info_list,opp_id,',')]#</a>
                                <cfelse>
	                                #get_opp_info.opp_head[ListFind(opp_info_list,opp_id,',')]#
                                </cfif>
							</cfif>
						</td>
						<td>
                        	<cfif type_ neq 1>
								<cfif len(opp_id) and len(related_opp_list)>
                                    <cfif Len(get_opp_partner.company_id[ListFind(opp_partner_list,opp_id,',')])>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_opp_partner.company_id[ListFind(opp_partner_list,opp_id,',')]#','medium');" >#get_opp_partner.fullname[ListFind(opp_partner_list,opp_id,',')]#</a>
                                    <cfelseif Len(get_opp_consumer.consumer_id[ListFind(opp_consumer_list,opp_id,',')])>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_opp_consumer.consumer_id[ListFind(opp_consumer_list,opp_id,',')]#','medium');" >#get_opp_consumer.consumer_name[ListFind(opp_consumer_list,opp_id,',')]#</a>
                                    </cfif>
                                </cfif>
                            <cfelse>
								<cfif len(opp_id) and len(related_opp_list)>
                                    <cfif Len(get_opp_partner.company_id[ListFind(opp_partner_list,opp_id,',')])>
                                        #get_opp_partner.fullname[ListFind(opp_partner_list,opp_id,',')]#
                                    <cfelseif Len(get_opp_consumer.consumer_id[ListFind(opp_consumer_list,opp_id,',')])>
                                        #get_opp_consumer.consumer_name[ListFind(opp_consumer_list,opp_id,',')]#
                                    </cfif>
                                </cfif>
                            </cfif>
						</td>
						<td>
							<cfif len(opp_id) and len(related_opp_list)>
								<cfif type_ neq 1>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_opp_partner.partner_id[ListFind(opp_partner_list,opp_id,',')]#','medium');" >#get_opp_partner.partner_name[ListFind(opp_partner_list,opp_id,',')]#</a>
                                <cfelse>
                                    #get_opp_partner.partner_name[ListFind(opp_partner_list,opp_id,',')]#
                                </cfif>
							</cfif>
						</td>
						<td>
							<cfif len(sales_partner_id)>  
								<cfif type_ eq 1>
									#get_par_info(sales_partner_id,0,-1,0)#-#get_par_info(sales_partner_id,0,1,0)#
								<cfelse>
									#get_par_info(sales_partner_id,0,-1,0)#-#get_par_info(sales_partner_id,0,1,1)#							
								</cfif>								
							</cfif>
						</td>
						<td><cfif type_ neq 1><cfif len(sales_emp_id)><a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_position.employee_id[listfind(employee_id_list,get_detail_sale_offer.sales_emp_id,',')]#','medium');">#get_position.employee_name[listfind(employee_id_list,get_detail_sale_offer.sales_emp_id,',')]#&nbsp;#get_position.employee_surname[listfind(employee_id_list,get_detail_sale_offer.sales_emp_id,',')]#</a></cfif><cfelse>#get_position.employee_name[listfind(employee_id_list,get_detail_sale_offer.sales_emp_id,',')]#&nbsp;#get_position.employee_surname[listfind(employee_id_list,get_detail_sale_offer.sales_emp_id,',')]#</cfif></td>
						<td style="text-align:center;"><cfif len(opp_id)>#DateFormat(get_opp_info.opp_date[ListFind(related_opp_list,opp_id,',')],dateformat_style)#</cfif></td>
						<td style="text-align:center;">#dateformat(offer_date,dateformat_style)#</td>
						<td><cfif type_ neq 1><a href="#request.self#?fuseaction=sales.list_offer&event=upd&offer_id=#offer_id#" >#left(offer_head,25)#<cfif len(offer_head) gt 25>...</cfif></a><cfelse>#left(offer_head,25)#<cfif len(offer_head) gt 25>...</cfif></cfif></td>						
						<td><cfif offer_status eq 1><cf_get_lang dictionary_id='81.Aktif'><cfelseif offer_status eq 0><cf_get_lang dictionary_id='82.Pasif'></cfif></td>
						<td><cfif Len(product_id)>#get_product_cat.product_cat[ListFind(product_id_list,product_id,',')]#</cfif></td>
						<td>#product_name#</td>
						<td>
							<cfif isdefined('attributes.private_definition') and len(attributes.private_definition)>
								<cfquery name="private_definition_row" datasource="#dsn3#">
									SELECT SALES_ADD_OPTION_ID,SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS WHERE SALES_ADD_OPTION_ID = #attributes.private_definition#
								</cfquery>
								#private_definition_row.SALES_ADD_OPTION_NAME#
							<cfelse>	
								<cfset SALES_ADD_OPTION_ID_ = "#SALES_ADD_OPTION_ID#">
								<cfif len(SALES_ADD_OPTION_ID_)>
									<cfquery name="private_definition_row" datasource="#dsn3#">
										SELECT SALES_ADD_OPTION_ID,SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS WHERE SALES_ADD_OPTION_ID = #SALES_ADD_OPTION_ID_#
									</cfquery>
										#private_definition_row.SALES_ADD_OPTION_NAME#
								</cfif>
							</cfif>
						</td>
						<cfif xml_country eq 1>
                        	<td style="text-align:right;">#COUNTRY_NAME#</td>
                            <td style="text-align:right;">#SZ_NAME#</td>
                        </cfif>
						<td style="text-align:center;">#quantity#</td>
						<td style="text-align:center;">#unit#</td>
						<td style="text-align:right;" format="numeric">#TLFormat(row_price_other,2)#</td>
						<td style="text-align:right;" format="numeric">#TLFormat(row_other_money_value,2)#</td>
						<td style="text-align:center;"><cfif len(row_other_money_value)>#row_other_money#</cfif></td>
						<cfif Len(row_other_money_value) and row_other_money_value gt 0>
							<!--- Teklif Tarihinin Kur Bilgileri --->
							<cfquery name="get_money2" dbtype="query">
								SELECT RATE2 FROM get_offer_money WHERE ACTION_ID = #offer_id# AND MONEY_TYPE = '#session.ep.money2#'
							</cfquery>
							<cfquery name="get_other_money" dbtype="query">
								SELECT RATE2 FROM get_offer_money WHERE ACTION_ID = #offer_id# AND MONEY_TYPE = '#row_other_money#'
							</cfquery>
							<cfif len(get_money2.rate2)>
								<cfset system_other_money_value_ = row_other_money_value/get_money2.rate2>
							<cfelse>
								<cfset system_other_money_value_ = 0>
							</cfif>
							<cfif get_other_money.recordcount>
								<cfset system_other_money_value_ = system_other_money_value_*get_other_money.rate2>
							</cfif>
							<!--- Bugunun Kur Bilgileri - Diğer para birimleri --->
							<cfset system_money2_value_ = row_other_money_value/get_today_money2.rate2>								
							<cfquery name="get_today_other_money" dbtype="query">
								SELECT RATE2,MONEY FROM setup_system_money WHERE MONEY = '#row_other_money#'
							</cfquery>
							<cfif get_today_other_money.recordcount>
								<cfset system_money2_value_ = system_money2_value_*get_today_other_money.rate2>
							</cfif>
						</cfif>
						<td style="text-align:right;" format="numeric"><cfif Len(row_other_money_value) and row_other_money_value gt 0>#TlFormat(system_other_money_value_)#</cfif><!--- Teklif Tarihi Kurundan satır net döviz fiyatın money2 Karşılığı ---></td>
						<td style="text-align:right;" format="numeric"><cfif Len(row_other_money_value)and row_other_money_value gt 0>#TLformat(system_money2_value_,2)#</cfif><!--- Bugunun Kurundan satır net döviz fiyatın  money2 Karşılığı ---></td>
						<td style="text-align:center;" format="numeric"><cfif len(opp_id) and len(related_opp_list)>#get_opp_info.probability[ListFind(opp_info_list,opp_id,',')]#</cfif></td>
						<td style="text-align:center;" format="numeric"><cfif len(opp_id) and isdefined("system_money2_value_") and len(get_opp_info.probability[ListFind(opp_info_list,opp_id,',')])>#TlFormat(system_money2_value_*get_opp_info.probability[ListFind(opp_info_list,opp_id,',')]/100)#</cfif><!--- Bugünkü kur tutarı(sistem ikinci para birimi)* Olasılık/100 ---></td>
						<td><cfif len(opp_id) and len(related_opp_list)>#get_opp_info.stage[ListFind(opp_info_list,opp_id,',')]#</cfif></td>
						<td>#get_par_info(row_provider_id,1,0,0)#</td>
						<td><cfif len(opp_id) and len(related_opp_list)>#get_opp_rival_company.fullname[ListFind(opp_rival_company_list,opp_id,',')]#</cfif></td>
						<td><cfif len(offer_stage)>#process_type.stage[listfind(offer_stage_list,offer_stage,',')]#</cfif></td>
						<td>#offer_detail#</td>
						<cfif Len(row_other_money_value)and row_other_money_value gt 0>
							<cfset page_total_money2 = page_total_money2 + system_other_money_value_>
							<cfset page_total_money2_now = page_total_money2_now + system_money2_value_>
						</cfif>
						<cfif len(opp_id) and len(get_opp_info.probability[ListFind(opp_info_list,opp_id,',')])>
							<cfset page_total_prob = page_total_prob + (get_opp_info.probability[ListFind(opp_info_list,opp_id,',')])>
							<cfset page_total_prob_money2 = page_total_prob_money2 + (setup_system_money.rate2*get_opp_info.probability[ListFind(opp_info_list,opp_id,',')]/100)>
						</cfif>
					<cfelse>
						<cfif not get_money_.recordcount>
							<cfquery name="get_money_" datasource="#dsn#">
								SELECT RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY = '#session.ep.money2#' AND  COMPANY_ID = #session.ep.company_id# AND PERIOD_ID = #session.ep.period_id#
							</cfquery>
						</cfif>
							<cfset sepet_total_tax = sepet_total_tax + row_taxtotal>
							<cfset float_price_net = (row_nettotal/quantity)>
							<cfset float_price_net_doviz = float_price_net/get_money_.RATE2>
							<cfset discount_total = row_total - row_nettotal>
							<cfset float_price_net = 0>
							<cfset float_price_net_doviz = 0>
							<cfset discount_total = 0>
						<td>
                        	<cfif type_ neq 1>
                            	<a href="#request.self#?fuseaction=sales.list_offer&event=upd&offer_id=#offer_id#" >#offer_number#</a>
                            <cfelse>
                            	#offer_number#
                            </cfif>
						</td>							
						<td>#dateformat(offer_date,dateformat_style)#</td>
						<td>#ref_no#</td>
						<td>
							<cfif type_ eq 1>
								<cfif attributes.is_excel neq 1>#Left(offer_head,33)#<cfelse>#offer_head#</cfif>
							<cfelse>
								<a href="#request.self#?fuseaction=sales.list_offer&event=upd&offer_id=#offer_id#" <cfif Len(offer_head) gt 33>title="#offer_head#"</cfif> ><cfif attributes.is_excel neq 1>#Left(offer_head,33)#<cfelse>#offer_head#</cfif></a>
							</cfif>
						</td>
						<td style="text-align:left;">
                        	<cfif type_ neq 1>
								<cfif len(company_id) and not Listlen(offer_to_partner)>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');" >#get_company_detail.nickname[listfind(main_company_id_list,company_id,',')]#</a>
                                </cfif>
                                <cfif len(consumer_id)>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&consumer_id=#consumer_id#','medium');" >#get_consumer_detail.consumer_name[listfind(consumer_id_list,consumer_id,',')]#&nbsp; #get_consumer_detail.consumer_surname[listfind(consumer_id_list,consumer_id,',')]#</a>
                                </cfif>	
                            <cfelse>
								<cfif len(company_id) and not Listlen(offer_to_partner)>
                                    #get_company_detail.nickname[listfind(main_company_id_list,company_id,',')]#
                                </cfif>
                                <cfif len(consumer_id)>
                                    #get_consumer_detail.consumer_name[listfind(consumer_id_list,consumer_id,',')]#&nbsp; #get_consumer_detail.consumer_surname[listfind(consumer_id_list,consumer_id,',')]#
                                </cfif>	
                            </cfif>
						</td>
						<td>
							<cfif len(sales_partner_id)>  
								<cfif type_ eq 1>
									#get_par_info(sales_partner_id,0,-1,0)#-#get_par_info(sales_partner_id,0,1,0)#
								<cfelse>
									#get_par_info(sales_partner_id,0,-1,0)#-#get_par_info(sales_partner_id,0,1,1)#								
								</cfif>								
							</cfif>
						</td>
						<td style="text-align:left;">#offer_detail#</td>
						<td>#stock_code#</td>
						<td><cfif len(product_catid)>#get_product_cat_name.product_cat[ListFind(product_cat_id_list,product_catid,',')]#</cfif></td>
						<td><cfif len(brand_id)>#get_pro_brand.brand_name[ListFind(product_brand_id_list,brand_id,',')]#</cfif></td>
						<td><cfif len(short_code_id)>#get_pro_model.model_name[ListFind(product_model_id_list,short_code_id,',')]#</cfif></td>
						<td>#product_name#</td>
						<td>
							<cfif isdefined('attributes.private_definition') and len(attributes.private_definition)>
								<cfquery name="private_definition_row" datasource="#dsn3#">
									SELECT SALES_ADD_OPTION_ID,SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS WHERE SALES_ADD_OPTION_ID = #attributes.private_definition#
								</cfquery>
								#private_definition_row.SALES_ADD_OPTION_NAME#
							<cfelse>	
								<cfset SALES_ADD_OPTION_ID_ = "#SALES_ADD_OPTION_ID#">
								<cfif len(SALES_ADD_OPTION_ID_)>
									<cfquery name="private_definition_row" datasource="#dsn3#">
										SELECT SALES_ADD_OPTION_ID,SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS WHERE SALES_ADD_OPTION_ID = #SALES_ADD_OPTION_ID_#
									</cfquery>
										#private_definition_row.SALES_ADD_OPTION_NAME#
								</cfif>
							</cfif>
						</td>
						<cfif xml_country eq 1>
                        	<td style="text-align:right;">#COUNTRY_NAME#</td>
                            <td style="text-align:right;">#SZ_NAME#</td>
                        </cfif>
						<td style="text-align:center;" format="numeric">#quantity#</td>
						<cfif attributes.order_quantity eq 1>
							<td style="text-align:center;" format="numeric">#order_quantity#</td>
							<td style="text-align:center;" format="numeric"><cfif len(quantity) and len(order_quantity)>#quantity-order_quantity#</cfif></td>
						</cfif>
						<td style="text-align:center;">#unit#</td>
						<td style="text-align:right;" format="numeric">#TLFormat(price)#</td>
						<td style="text-align:right;" format="numeric">#TLFormat(row_nettotal/quantity)#</td>
						<td style="text-align:right;" format="numeric">#TLFormat(row_price_other)#</td>
						<cfquery name="getMoneyOfferRow" datasource="#dsn3#">
							SELECT RATE1,ISNULL(RATE2,1) RATE2 FROM OFFER_MONEY WHERE ACTION_ID = #offer_id# AND MONEY_TYPE = '#row_money_type#'
						</cfquery>
						<cfif not getMoneyOfferRow.recordcount><cfset new_RATE2 = 1><cfelse><cfset new_RATE2 = getMoneyOfferRow.RATE2></cfif>
						<td style="text-align:right;" format="numeric"><cfif row_nettotal gt 0>#TLFormat((row_nettotal/quantity)/new_RATE2)#<cfelse>#TLformat(0)#</cfif></td>
						<cfif attributes.kdv_deger eq 1>
							<td style="text-align:right;" format="numeric">#TLFormat(row_taxtotal)#</td>
						</cfif>
						<td style="text-align:center;">#row_money_type#</td>
						<td style="text-align:right;" format="numeric">#TLFormat(row_total + row_taxtotal)#</td>
						<td style="text-align:right;" format="numeric">#TLFormat(row_nettotal)#</td>
						<td style="text-align:right;" format="numeric">#TLFormat(row_price_other*quantity)#</td>
						<td style="text-align:right;" format="numeric">#TLFormat(row_other_money_value)#</td>
						<td style="text-align:right;" format="numeric">#TLFormat(discount_total)#</td>
						<cfset page_total_money2_now = page_total_money2_now +row_nettotal>
						<cfset page_total_prob = page_total_prob + (net_maliyet*quantity)>
						<cfset page_total_money2 = page_total_money2 + row_total> 
					</cfif>
					<cfif xml_net_maliyet eq 1>
						<td style="text-align:right;" format="numeric">#TLFormat(net_maliyet)# </td>
					</cfif>
				</tr>
				<cfset currentrow_ = currentrow>
			</cfoutput>
			<cfoutput>
			<tr>
				<cfif attributes.report_type eq 1>
					<cfif attributes.kdv_deger eq 1>
						<cfset colspan_ = 11>
					<cfelse>
						<cfset colspan_ = 10>
					</cfif>
					 <cfif xml_country eq 1>
                         <cfset colspan_ =colspan_ + 2>
                     </cfif>
					<td colspan="#colspan_#">&nbsp;</td>
					<td style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id="39183.Sayfa Toplam"></td>
					<td style="text-align:right;" class="txtbold" format="numeric"><cfloop list="#om_list#" index="q">#TLFormat(Evaluate('total_value_#q#'))#<br/></cfloop></td>
					<td style="text-align:center;" class="txtbold"><cfloop list="#om_list#" index="q">#q#<br/></cfloop></td>
					<cfif xml_net_maliyet eq 1><td style="text-align:right;" class="txtbold" format="numeric">&nbsp;</td></cfif>
                    <cfif xml_probability eq 1><td style="text-align:right;" class="txtbold" format="numeric">&nbsp;</td></cfif>
				<cfelseif  attributes.report_type eq 2>
                	<cfset colspan_=18>
                    <cfif xml_country eq 1>
                    	<cfset colspan_=colspan_+2>
                    </cfif>
					<td colspan="#colspan_#">&nbsp;</td>
					<td style="text-align:right;" class="txtbold" format="numeric">#TLFormat(page_total_money2)#</td>
					<td style="text-align:right;" class="txtbold" format="numeric">#TLFormat(page_total_money2_now)#</td>
					<td style="text-align:right;" class="txtbold" format="numeric">#TLFormat(page_total_prob)#</td>
					<td style="text-align:right;" class="txtbold" format="numeric">#TLFormat(page_total_prob_money2)#</td>
					<td colspan="5">&nbsp;</td>
				<cfelse>
					<cfif attributes.kdv_deger eq 1 and attributes.order_quantity eq 1>
						<cfset colspan_ = 23>
					<cfelseif attributes.kdv_deger eq 1>
						<cfset colspan_ = 21>
					<cfelseif attributes.order_quantity eq 1>
						<cfset colspan_ = 22>
					<cfelse>
						<cfset colspan_ = 20>
					</cfif>
                    <cfif xml_country eq 1>
						<cfset colspan_ = colspan_+2>
					</cfif>
					<td colspan="#colspan_#">&nbsp;</td>
					<td style="text-align:right;" class="txtbold" format="numeric">#TLFormat(page_total_money2_now)#</td>
					<td colspan="5">&nbsp;</td>

				</cfif> 
			</tr>
			</cfoutput>
            </tbody>
			<cfif (get_detail_sale_offer.recordcount eq currentrow_) and (attributes.report_type eq 1)>
				<cfquery name="get_money_end" dbtype="query">
					SELECT SUM(OTHER_MONEY_VALUE) OMV, OTHER_MONEY OM FROM get_detail_sale_offer WHERE OTHER_MONEY_VALUE IS NOT NULL GROUP BY OTHER_MONEY ORDER BY OTHER_MONEY_VALUE
				</cfquery>
                <tbody>
				<tr>
				<cfif attributes.kdv_deger eq 1>
					<cfset colspan_=12>
				<cfelse>
					<cfset colspan_=9>
				</cfif>
					<cfif xml_country eq 1>
                         <cfset colspan_ =colspan_ +2>
                     </cfif>
					<td colspan="<cfoutput>#colspan_#</cfoutput>">&nbsp;</td>
					<td style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id="57680.Genel Toplam"></td>
					<td style="text-align:right;" class="txtbold" format="numeric"><cfoutput query="get_money_end">#TLFormat(omv)#<br/></cfoutput></td>
					<td style="text-align:center;" class="txtbold"><cfoutput query="get_money_end">#om#<br/></cfoutput></td>  
				</tr>
                </tbody>
			</cfif>
		<cfelse>
			<tr> 
				<cfif attributes.report_type eq 1>
					<cfset colspan_ = 14>
				<cfelse>
					<cfset colspan_ = 28>
				</cfif>
			 <tbody>
				    <td colspan="<cfoutput>#colspan_#</cfoutput>"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
		    </tbody> 
		 </tr>
		</cfif>
</cf_report_list>
</cfif>
	<cfset adres = "">
	<cfif isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.maxrows>
		<cfset adres = "#attributes.fuseaction#&form_submitted=1">
		<cfif len(attributes.product_cat_id) and len(attributes.product_cat_name)>
			<cfset adres = "#adres#&product_cat_id=#attributes.product_cat_id#&product_cat_name=#attributes.product_cat_name#">
		</cfif>
		<cfif len(attributes.product_id) and len(attributes.product_name)>
			<cfset adres = "#adres#&product_id=#attributes.product_id#&product_name=#attributes.product_name#">
		</cfif>
		<cfif len(attributes.brand_id) and len(attributes.brand_name)>
			<cfset adres = "#adres#&brand_id=#attributes.brand_id#&brand_name=#attributes.brand_name#">
		</cfif>
		<cfif len(attributes.product_employee_id) and len(attributes.product_employee_name)>
			<cfset adres = "#adres#&product_employee_id=#attributes.product_employee_id#&product_employee_name=#attributes.product_employee_name#">
		</cfif>
		<cfif len(attributes.product_target_market)>
			<cfset adres = "#adres#&product_target_market=#attributes.product_target_market#">
		</cfif>
		<cfif len(attributes.sale_employee_id) and len(attributes.sale_employee_name)>
			<cfset adres = "#adres#&sale_employee_id=#attributes.sale_employee_id#&sale_employee_name=#attributes.sale_employee_name#">
		</cfif>
		<cfif len(attributes.provider_id) and len(attributes.provider_name)>
			<cfset adres = "#adres#&provider_id=#attributes.provider_id#&provider_name=#attributes.provider_name#">
		</cfif>
		<cfif len(attributes.customer_id) and len(attributes.member_name)>
			<cfset adres = "#adres#&member_name=#attributes.member_name#&customer_id=#attributes.customer_id#">
		<cfelseif len(attributes.consumer_id) and len(attributes.member_name)>
			<cfset adres = "#adres#&member_name=#attributes.member_name#&consumer_id=#attributes.consumer_id#">
		</cfif>
		<cfif len(attributes.customer_position_code) and len(attributes.customer_position_name)>
			<cfset adres = "#adres#&customer_position_code=#attributes.customer_position_code#&customer_position_name=#attributes.customer_position_name#">
		</cfif>
		<cfif len(attributes.customer_value)>
			<cfset adres = "#adres#&customer_value=#attributes.customer_value#">
		</cfif>
		<cfif len(attributes.customer_cat_type)>
			<cfset adres = "#adres#&customer_cat_type=#attributes.customer_cat_type#">
		</cfif>
		<cfif len(attributes.customer_relation_type)>
			<cfset adres = "#adres#&customer_relation_type=#attributes.customer_relation_type#">
		</cfif>
		<cfif len(attributes.customer_sector_cat)>
			<cfset adres = "#adres#&customer_sector_cat=#attributes.customer_sector_cat#">
		</cfif>
		<cfif len(attributes.city)>
			<cfset adres = "#adres#&city=#attributes.city#">
		</cfif>
		<cfif len(attributes.country)>
            <cfset adres="#adres#&country=#attributes.country#">
        </cfif>
        <cfif len(attributes.sales_zone)>
            <cfset adres="#adres#&sales_zone=#attributes.sales_zone#">
        </cfif>
		<cfif len(attributes.reference_customer_id) and len(attributes.reference_member_name)>
			<cfset adres = "#adres#&reference_customer_id=#attributes.reference_customer_id#&reference_member_name=#attributes.reference_member_name#">
		<cfelseif len(attributes.reference_consumer_id) and len(attributes.reference_member_name)>
			<cfset adres = "#adres#&reference_consumer_id=#attributes.reference_consumer_id#&reference_member_name=#attributes.reference_member_name#">
		</cfif>
		<cfif len(attributes.project_id) and len(attributes.project_name)>
			<cfset adres = "#adres#&project_id=#attributes.project_id#&project_name=#attributes.project_name#">
		</cfif>
		<cfif len(attributes.to_convert_order)>
			<cfset adres = "#adres#&to_convert_order=#attributes.to_convert_order#">
		</cfif>
		<cfif len(attributes.private_definition)>
			<cfset adres = "#adres#&private_definition=#attributes.private_definition#">
		</cfif>
		<cfif len(attributes.process_stage)>
			<cfset adres = "#adres#&process_stage=#attributes.process_stage#">
		</cfif>
		<cfif len(attributes.status)>
			<cfset adres = "#adres#&status=#attributes.status#">
		</cfif>
		<cfif len(attributes.report_type)>
			<cfset adres = "#adres#&report_type=#attributes.report_type#">
		</cfif>
		<cfif len(attributes.graph_type)>
			<cfset adres = "#adres#&graph_type=#attributes.graph_type#">
		</cfif>
		<cfif len(attributes.is_excel)>
			<cfset adres = "#adres#&is_excel=#attributes.is_excel#">
		</cfif>
		<cfif len(attributes.offer_start_date)>
			<cfset adres = "#adres#&offer_start_date=#attributes.offer_start_date#">
		</cfif>
		<cfif len(attributes.offer_finish_date)>
			<cfset adres = "#adres#&offer_finish_date=#attributes.offer_finish_date#">
		</cfif>
		<cfif len(attributes.valid_start_date)>
			<cfset adres = "#adres#&valid_start_date=#attributes.valid_start_date#">
		</cfif>
		<cfif len(attributes.valid_finish_date)>
			<cfset adres = "#adres#&valid_finish_date=#attributes.valid_finish_date#">
		</cfif>
		<cfif len(attributes.kdv_deger)>
			<cfset adres = "#adres#&kdv_deger=#attributes.kdv_deger#">
		</cfif>
		<cfif len(attributes.order_quantity)>
			<cfset adres = "#adres#&order_quantity=#attributes.order_quantity#">
		</cfif>
		<cfif isdefined("attributes.probability") and len(attributes.probability)>
			<cfset adres = "#adres#&probability=#attributes.probability#">
		</cfif>
		<cfif len("attributes.sales_partner_id") and len("attributes.sales_partner")>
			<cfset adres = "#adres#&sales_partner_id=#attributes.sales_partner_id#&sales_partner=#attributes.sales_partner#">
		</cfif>
       <cfif attributes.totalrecords gt attributes.maxrows>	
		<cf_paging
		page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="#adres#">
	</cfif>
</cfif>
<br/>
<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
<cfif isdefined('attributes.form_submitted') and get_detail_sale_offer.recordcount and len(attributes.graph_type)>
	<tr class="nohover">
			<cfset product_grap_list = "">
			<cfoutput query="get_detail_sale_offer" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(attributes.product_name) and not listfind(product_grap_list,product_name,',')>
					<cfset product_grap_list = Listappend(product_grap_list,product_name,',')>
				</cfif>
			</cfoutput>
			
			<cfset graph_type = form.graph_type>
			<cfif graph_type is 'pie'>
				<cfset graph_height = 300 + (ListLen(product_grap_list,',')*20)>
			<cfelse>
				<cfset graph_height = 500> 
			</cfif>
					<cfset system_money2_value_ = 0>
					<cfoutput query="get_detail_sale_offer">
						<cfset 'same_product_id_#attributes.product_id#' = 0>
					</cfoutput>
					<cfoutput query="get_detail_sale_offer">
						<cfif attributes.report_type eq 2 and Len(row_other_money_value) and row_other_money_value gt 0>
							<!--- Bugunun Kur Bilgileri --->
							<cfquery name="get_today_money2" dbtype="query">
								SELECT RATE2,MONEY FROM setup_system_money WHERE MONEY = '#session.ep.money2#'
							</cfquery>
							<cfset system_money2_value_ = row_other_money_value/get_today_money2.rate2>								
							<cfquery name="get_today_other_money" dbtype="query">
								SELECT RATE2,MONEY FROM setup_system_money WHERE MONEY = '#row_other_money#'
							</cfquery>
							<cfif get_today_other_money.recordcount>
								<cfset system_money2_value_ = system_money2_value_*get_today_other_money.rate2>
							</cfif>
						</cfif>
						<cfset 'same_product_id_#attributes.product_id#' = Evaluate('same_product_id_#attributes.product_id#') + system_money2_value_>
						<!--- Belge Bazında --->
						<cfif  attributes.report_type eq 1>
							<cfset item_value = offer_number>
							<cfset value_ = wrk_round(other_money_value,2)>
						<!--- Firsat ve Stok Bazında --->
						<cfelse>
							<cfset item_value = product_name>
							<cfset value_ = Evaluate('same_product_id_#attributes.product_id#')>
						</cfif>
							<cfset 'item_#currentrow#' = "#item_value#">
							<cfset 'value_#currentrow#' = "#value_#">
					</cfoutput>
				<script src="JS/Chart.min.js" style="width:100%;"></script> 
                <canvas id="myChart"></canvas>
				<script>
					var ctx = document.getElementById('myChart');
						var myChart = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: [<cfloop from="1" to="#get_detail_sale_offer.recordcount#" index="jj">
												 <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
									label: "Detaylı Teklif",
									backgroundColor: [<cfloop from="1" to="#get_detail_sale_offer.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#get_detail_sale_offer.recordcount#" index="jj"><cfoutput>#NumberFormat(evaluate("value_#jj#"),'00')#</cfoutput>,</cfloop>],
								}]
							},
							options: {}
					});
				</script>
	</tr>

</cfif>
</div>
<script type="text/javascript">
function kontrol_form()
{		if ((document.rapor.offer_start_date.value != '') && (document.rapor.offer_finish_date.value != '') &&
	    !date_check(rapor.offer_start_date,rapor.offer_finish_date," <cf_get_lang dictionary_id='57545.Teklif'> <cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
		if ((document.rapor.valid_start_date.value != '') && (document.rapor.valid_finish_date.value != '') &&
	    !date_check(rapor.valid_start_date,rapor.valid_finish_date," <cf_get_lang  dictionary_id='33134.Teklif'> <cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
		if(document.rapor.maxrows.value > 1000)
		{
			alert ("<cf_get_lang dictionary_id ='40286.Görüntüleme Sayısı 1000 den fazla olamaz'>!");
			return false;
		}
		if(document.rapor.is_excel.checked==false)
		{
			document.rapor.action="<cfoutput>#request.self#?fuseaction=report.detail_sale_offer_report</cfoutput>"
			return true;
		}
		else
			document.rapor.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_detail_sale_offer_report</cfoutput>"
	
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
