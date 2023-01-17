<cfset pagefuseact = "textile.list_sample_request">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.category" default="">
<cf_xml_page_edit fuseact="textile.list_sample_request">
<cfparam name="attributes.req_type_id" default="">
<cfif isdefined("attributes.req_id")>
<cfinclude template="../query/get_req.cfm">
<cfset attributes.req_type_id=get_opportunity.req_type_id>
</cfif>


<cfinclude template="/V16/sales/query/get_opp_currencies.cfm">
<cfinclude template="/V16/sales/query/get_commethod_cats.cfm">
<cfinclude template="/V16/sales/query/get_probability_rate.cfm">
<cfinclude template="/V16/sales/query/get_moneys.cfm">
<cfinclude template="/V16/sales/query/get_opportunity_type.cfm">
<cfinclude template="../../../../../V16/objects/query/get_product_cat2.cfm">

<link rel="stylesheet" href="/css/assets/template/fileupload/dropzone.css" type="text/css">
<link rel="stylesheet" href="/css/assets/template/fileupload/fileupload-min.css" type="text/css">

<cfquery name="get_probability" datasource="#dsn3#">
	SELECT * FROM SETUP_PROBABILITY_RATE
</cfquery>

<cfquery name="get_sale_add_option" datasource="#dsn3#">
	SELECT SALES_ADD_OPTION_ID, SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS
</cfquery>
<cfset cmp = createObject("component","V16.settings.cfc.setupCountry") />
<cfset GET_COUNTRY = cmp.getCountry()>
<cfquery name="GET_SALE_ZONES" datasource="#DSN#">
	SELECT
    	SZ_ID,
	    SZ_NAME
    FROM
    	SALES_ZONES
</cfquery>
<cfif isdefined('attributes.cus_help_id') and len(attributes.cus_help_id)>
	<cfquery name="get_help_" datasource="#dsn#">
		SELECT
			COMPANY_ID,
			PARTNER_ID,
			CONSUMER_ID,
			SUBJECT,
			SUBSCRIPTION_ID,
			APP_CAT
		FROM
			CUSTOMER_HELP
		WHERE
			CUS_HELP_ID = #attributes.cus_help_id#
	</cfquery>
	<cfif len(get_help_.company_id)>
		<cfset attributes.cpid = get_help_.company_id>
		<cfset attributes.member_id = get_help_.partner_id>
		<cfset attributes.member_type = "partner">
	<cfelseif len(get_help_.consumer_id)>
		<cfset attributes.cpid = "">
		<cfset attributes.member_id = get_help_.consumer_id>
		<cfset attributes.member_type = "consumer">
	</cfif>
	<cfif len(get_help_.subscription_id)>
		<cfquery name="GET_SUB_NO" datasource="#dsn3#">
			SELECT SUBSCRIPTION_NO,PROJECT_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_help_.subscription_id#">
		</cfquery>
		<cfset attributes.project_id = get_sub_no.project_id>
	</cfif>
	<cfset attributes.opp_detail = get_help_.subject>
	<cfset attributes.commethod_id = get_help_.app_cat>
<cfelseif isdefined('url.service_id')>
	 <cfquery name="GET_SERVICE" datasource="#DSN#">
		SELECT
			SERVICE_HEAD,
			PROJECT_ID,
			SERVICE_CONSUMER_ID,
			SERVICE_COMPANY_ID,
			SERVICE_PARTNER_ID
		FROM
			G_SERVICE
		WHERE
			SERVICE_ID = #url.service_id#
	</cfquery>
	<cfset attributes.project_id = get_service.project_id>
<cfelseif isdefined("attributes.project_id") and len(attributes.project_id)>
	<cfquery name="get_project_info" datasource="#dsn#">
		SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.project_id#
	</cfquery>
	<cfif len(get_project_info.company_id)>
		<cfset attributes.cpid = get_project_info.company_id>
		<cfset attributes.member_id = get_project_info.partner_id>
		<cfset attributes.member_type = "partner">
	<cfelseif len(get_project_info.consumer_id)>
		<cfset attributes.cpid = "">
		<cfset attributes.member_id = get_project_info.consumer_id>
		<cfset attributes.member_type = "consumer">
	</cfif>
</cfif>
<cfparam name="attibutes.cpid" default="">
<cfparam name="attributes.probability_rate_id" default="">
<cf_papers_tex paper_type="REQ">
<cf_catalystHeader>
<cfform name="add_opp" method="post" action="#request.self#?fuseaction=textile.emptypopup_add_req" enctype="multipart/form-data">
        <input type="hidden" name="is_popup" id="is_popup" value="<cfif fuseaction contains 'popup'>1<cfelse>0</cfif>">
		<input type="hidden" name="invoice_company_id" id="invoice_company_id" value="<cfoutput>#invoice_company_id#</cfoutput>" readonly>
		<cfif isdefined("attributes.req_id") and len(attributes.req_id)>
		   <input type="hidden" name="is_copy" id="is_copy" value="<cfoutput>#attributes.req_id#</cfoutput>">
		 </cfif>
        <input type="hidden" name="service_id" id="service_id" value="<cfif isdefined("url.service_id")><cfoutput>#url.service_id#</cfoutput></cfif>">
        <cfif isdefined("attributes.event_id") and len(attributes.event_id)>
            <input type="hidden" name="event_id" id="event_id" value="<cfoutput>#attributes.event_id#</cfoutput>"/>
        </cfif>
        <cfif isdefined("attributes.plan_rowid") and len(attributes.plan_rowid)>
            <input type="hidden" name="plan_rowid" id="plan_rowid" value="<cfoutput>#attributes.plan_rowid#</cfoutput>"/>
        </cfif>
         <cfif isdefined("attributes.event_plan_row_id") and len(attributes.event_plan_row_id)>
            <input type="hidden" name="event_plan_row_id" id="event_plan_row_id" value="<cfoutput>#attributes.event_plan_row_id#</cfoutput>"/>
        </cfif>
        <cfif isdefined('attributes.cus_help_id') and len(attributes.cus_help_id)>
            <input type="hidden" name="cus_help_id" id="cus_help_id" value="<cfoutput>#attributes.cus_help_id#</cfoutput>">
        </cfif>
            <div class="row">
                <div class="col col-12 uniqueRow">
                    <div class="row formContent">
						<div class="row" type="row">
							 <div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="1" sort="true">
								 <div class="form-group" id="item-opp_stage">
										<label class="col col-4 col-sm-12"><cf_get_lang_main no='1447.Süreç'> *</label>
										<div class="col col-8 col-sm-12">
											<cf_workcube_process is_upd='0' process_cat_width='140' is_detail='0'>
										</div>
								</div>	
								 <div class="form-group" id="item-opportunity_type_id">
                                    <label class="col col-4 col-sm-12">Numune <cf_get_lang_main no='74.Kategori'>*</label>
                                    <div class="col col-8 col-sm-12">
                                        <select name="opportunity_type_id" id="opportunity_type_id">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="get_opportunity_type">
                                                <option value="#opportunity_type_id#" <cfif opportunity_type_id eq attributes.req_type_id>selected</cfif>>#opportunity_type#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
								 <div class="form-group" id="item-opp_date">
                                    <label class="col col-4 col-sm-12">Talep Tarihi</label>
                                    <div class="col col-8 col-sm-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message">Talep Tarihi Girmelisiniz</cfsavecontent>
                                        <cfinput type="text" name="opp_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:70px;">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="opp_date"></span>
                                        </div>
                                    </div>
                                </div>
								 <div class="form-group" id="item-sales_emp_id">
                                    <label class="col col-4 col-sm-12">Müşteri Temsilcisi</label>
                                    <div class="col col-8 col-sm-12">
                                        <input type="hidden" name="sales_emp_id" id="sales_emp_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                                        <div class="input-group">
                                            <input name="sales_emp" type="text" id="sales_emp" onfocus="AutoComplete_Create('sales_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','sales_emp_id','add_opp','3','140');" value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_opp.sales_emp_id&field_name=add_opp.sales_emp&select_list=1','list');"></span>
                                        </div>
                                    </div>
                                </div>
						 </div>				
						  <div class="col col-4 col-md-4 col-sm-12 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-detail">
								<label class="col col-4 col-sm-12">Açıklama</label>
								<div class="col col-8 col-sm-12">
										<textarea name="req_detail" id="req_detail" ></textarea>
								</div>
							</div>
							<div class="form-group" id="item-desing_emp_id">
								<label class="col col-4 col-sm-12">Tasarımcı</label>
								<div class="col col-8 col-sm-12">
									<input type="hidden" name="desing_emp_id" id="desing_emp_id" value="">
									<div class="input-group">
										<input type="text" name="desing_emp" id="desing_emp" value="" onFocus="AutoComplete_Create('desing_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','desing_emp_id','','3','140');" autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_opp.desing_emp_id&field_name=add_opp.desing_emp&select_list=1','list');"></span>
									</div>
								</div>
							</div>			
						 </div>
					</div>
						<div class="row" type="row">
							<div class="col col-4 col-md-4 col-sm-12 col-xs-12" type="column" index="3" sort="true">
									<span><strong><h4>Müşteri Detayları</h4></strong></span>
										<div class="form-group" id="item-company">
										<label class="col col-4 col-sm-12"><cf_get_lang_main no='45.Müşteri'> *</label>
										<div class="col col-8 col-sm-12">
											<cfif isdefined ('url.service_id')>
												<cfif len(get_service.service_company_id)>
														<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_service.service_company_id#</cfoutput>">
														<input type="hidden" name="member_type" id="member_type" value="partner">
														<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#get_service.service_partner_id#</cfoutput>">
													<div class="input-group">
														<input type="text" name="company" id="company" style="width:140px;" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','company_id,member_type,member_id,member','','3','250',true,'fill_country(0,0)');" value="<cfoutput>#get_par_info(get_service.service_company_id,1,0,0)#</cfoutput>" autocomplete="off">
														<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_partner=add_opp.member_id&field_consumer=add_opp.member_id&field_comp_id=add_opp.company_id&field_comp_name=add_opp.company&field_name=add_opp.member&field_type=add_opp.member_type&select_list=7,8&function_name=fill_country&account_period=1','list');"></span>
													</div>
												<cfelse>
														<input type="hidden" name="company_id" id="company_id" value="">
														<input type="hidden" name="member_type" id="member_type" value="consumer">
														<input type="hidden" name="member_id" id="member_id" value="<cfoutput>#get_service.service_consumer_id#</cfoutput>">
													<div class="input-group">
														<input type="text" name="company" id="company" style="width:140px;" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','company_id,member_type,member_id,member','','3','250',true,'fill_country(0,0)');" value="<cfoutput>#get_cons_info(get_service.service_consumer_id,2,0)#</cfoutput>" autocomplete="off">
														<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_partner=add_opp.member_id&field_consumer=add_opp.member_id&field_comp_id=add_opp.company_id&field_comp_name=add_opp.company&field_name=add_opp.member&field_type=add_opp.member_type&select_list=7,8&function_name=fill_country&account_period=1','list');"></span>
													</div>
												</cfif>
											<cfelseif isdefined('attributes.member_id')>
												<cfoutput>
													<input type="hidden" name="company_id" id="company_id" value="#attributes.cpid#">
													<input type="hidden" name="member_type" id="member_type" value="#attributes.member_type#">
													<input type="hidden" name="member_id" id="member_id" value="#attributes.member_id#">
													<div class="input-group">
														<input type="text" name="company" id="company"  value="#get_par_info(attributes.member_id,0,1,0)#" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','company_id,member_type,member_id,member','','3','250',true,'fill_country(0,0)');" autocomplete="off">
														<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_partner=add_opp.member_id&field_consumer=add_opp.member_id&field_comp_id=add_opp.company_id&field_comp_name=add_opp.company&field_name=add_opp.member&field_type=add_opp.member_type&select_list=7,8&function_name=fill_country&account_period=1','list');"></span>
													</div>
												</cfoutput>
											<cfelseif isdefined("get_opportunity.partner_id") and len(get_opportunity.partner_id)>
														<cfoutput>
													<input type="hidden" name="company_id" id="company_id" value="#get_opportunity.company_id#">
													<input type="hidden" name="member_type" id="member_type" value="partner">
													<input type="hidden" name="member_id" id="member_id" value="#get_opportunity.partner_id#">
													<input type="hidden" name="old_member_id" id="old_member_id" value="#get_opportunity.partner_id#">
													<div class="input-group">
														<input type="text" name="company" id="company" value="#get_par_info(get_opportunity.company_id,1,0,0)#" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','company_id,member_type,member_id,member','','3','250',true,'fill_country(0,0)');" autocomplete="off">
														<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_partner=add_opp.member_id&field_consumer=add_opp.member_id&field_comp_id=add_opp.company_id&field_comp_name=add_opp.company&function_name=fill_country&field_name=add_opp.member&field_type=add_opp.member_type&select_list=7,8','list');"></span>
													</div>
														</cfoutput>
											<cfelseif isdefined("get_opportunity.consumer_id") and  len(get_opportunity.consumer_id)>
												<cfoutput>
													<input type="hidden" name="company_id" id="company_id" value="#get_opportunity.company_id#">
													<input type="hidden" name="member_type" id="member_type" value="consumer">
													<input type="hidden" name="member_id" id="member_id"  value="#get_opportunity.consumer_id#">
													<input type="hidden" name="old_member_id" id="old_member_id" value="#get_opportunity.consumer_id#">
													<div class="input-group">
														<input type="text" name="company" id="company"  value="" readonly onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','company_id,member_type,member_id,member','','3','250',true,'fill_country(0,0)');" autocomplete="off">
														<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_partner=add_opp.member_id&field_consumer=add_opp.member_id&field_comp_id=add_opp.company_id&field_comp_name=add_opp.company&function_name=fill_country&field_name=add_opp.member&field_type=add_opp.member_type&select_list=7,8','list');"></span>
													</div>
												</cfoutput>
											<cfelse>
												<input type="hidden" name="company_id" id="company_id" value="">
												<input type="hidden" name="member_type" id="member_type" value="">
												<input type="hidden" name="member_id" id="member_id" value="">
												<div class="input-group">
													<input name="company" type="text" id="company" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','company_id,member_type,member_id,member','','3','250',true,'fill_country(0,0)');" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_partner=add_opp.member_id&field_consumer=add_opp.member_id&field_comp_id=add_opp.company_id&field_comp_name=add_opp.company&function_name=fill_country&field_name=add_opp.member&field_type=add_opp.member_type&select_list=7,8','list');"></span>
												</div>
											</cfif>
										</div>
									</div>
									<div class="form-group" id="item-member">
										<label class="col col-4 col-sm-12"><cf_get_lang_main no='166.Yetkili'></label>
										<div class="col col-8 col-sm-12">
											<cfif isdefined ('url.service_id')>
												<cfif len(get_service.service_company_id)>
													<input type="text" id="member" name="member" value="<cfoutput>#get_par_info(get_service.service_partner_id,0,-1,0)#</cfoutput>" readonly>
												<cfelse>
													<input type="text" id="member" name="member" value="<cfoutput>#get_cons_info(get_service.service_consumer_id,0,0)#</cfoutput>" readonly>
												</cfif>
											<cfelse>
												
												<cfif isdefined('attributes.member_id') and len(attributes.member_id) and attributes.member_type eq 'partner'>
													<input type="text" id="member" name="member" value="<cfoutput>#get_par_info(attributes.member_id,0,-1,0)#</cfoutput>" readonly>
												<cfelseif isdefined('attributes.member_id') and len(attributes.member_id) and attributes.member_type eq 'consumer' >
													<input type="text" id="member" name="member" value="<cfoutput>#get_cons_info(attributes.member_id,0,0)#</cfoutput>" readonly>
												<cfelseif isdefined("get_opportunity.partner_id") and len(get_opportunity.partner_id)>
													<input type="text" name="member" id="member" value="<cfoutput>#get_par_info(get_opportunity.partner_id,0,-1,0)#</cfoutput>" readonly>
												<cfelseif isdefined("get_opportunity.consumer_id") and len(get_opportunity.consumer_id)>
													<input type="text" name="member" id="member" value="<cfoutput>#get_cons_info(get_opportunity.consumer_id,0,0,0)#</cfoutput>" readonly>
												<cfelse>
													<input type="text" id="member" name="member" value="" readonly>
												</cfif>
											</cfif>
										</div>
									</div>	
						</div>
						 <div class="col col-4 col-md-4 col-sm-12 col-xs-12" type="column" index="4" sort="true">
							<span><h4>Ürün Detayları</h4></span>
							<div class="form-group" id="item-product_cat_id">
                                    <label class="col col-4 col-sm-12"><cf_get_lang_main no='1604.Ürün Kategorisi'>*</label>
                                    <div class="col col-8 col-sm-12">
										<select name="product_cat_id" class="supplier-product-cat" id="product_cat_id">
											<option value="">Seçiniz</option>
											<cfif GET_PRODUCT_CAT.recordCount>
												<cfoutput query="GET_PRODUCT_CAT">
													<option value="#GET_PRODUCT_CAT.product_catid#" <cfif isdefined("get_opportunity.product_cat_id") and len(get_opportunity.product_cat_id) and get_opportunity.product_cat_id eq GET_PRODUCT_CAT.product_catid>selected</cfif>>#GET_PRODUCT_CAT.product_cat#</option>
												</cfoutput>
											</cfif>
										</select>
										<!--- <cfif isdefined("get_opportunity.product_cat_id") and len(get_opportunity.product_cat_id)>
											<cfset attributes.id = get_opportunity.product_cat_id>
											<cfinclude template="/V16/product/query/get_product_cat.cfm">
											<input type="hidden" name="product_cat_id" id="product_cat_id" value="<cfoutput>#get_opportunity.product_cat_id#</cfoutput>">
											<div class="input-group" style="font-size: 14px;">
												<!---<cfif not len(get_product_cat.product_cat)>--->
													<input type="text" name="product_cat" id="product_cat" value="<cfoutput>#get_product_cat.hierarchy# #get_product_cat.product_cat#</cfoutput>" onFocus="AutoComplete_Create('product_cat','HIERARCHY,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_cat_id','','3','175');" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_id=add_opp.product_cat_id&field_name=add_opp.product_cat','list');"></span>
												<!---<cfelse>
													<input type="hidden" name="product_cat" id="product_cat" value="<cfoutput>#get_product_cat.hierarchy# #get_product_cat.product_cat#</cfoutput>">
													<cfoutput>#get_product_cat.hierarchy# #get_product_cat.product_cat#</cfoutput>
												</cfif>--->
											</div>
										<cfelse>
                                        <input type="hidden" name="product_cat_id" id="product_cat_id">
                                        <div class="input-group">
                                            <input type="text" name="product_cat" id="product_cat" value="" onfocus="AutoComplete_Create('product_cat','HIERARCHY,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_cat_id','','3','175');" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&field_id=add_opp.product_cat_id&field_name=add_opp.product_cat</cfoutput>','list');"></span>
                                        </div>
										</cfif> --->
                                    </div>
                                </div>
							
								<div class="form-group" id="item-short_code_name">
										<label class="col col-4 col-sm-12"><cf_get_lang_main no='813.Model'></label>
													<cfset deger = "">
										<div class="col col-8 col-sm-12">
																	<cf_wrkproductmodel
														returninputvalue="short_code_id,short_code,short_code_name"
														returnqueryvalue="MODEL_ID,MODEL_CODE,MODEL_NAME"
														width="140"
														fieldname="short_code_name"
														fieldid="short_code_id"
														fieldcode="short_code"
														compenent_name="getProductModel"            
														boxwidth="300"
														boxheight="150"
														control_field_id="#deger#"
														control_field_name="brand_name"
														control_field_message="Marka Seçiniz!"
														model_id="">
														<input type="hidden" name="old_short_code" id="old_short_code" value="">
										</div>
									</div>
								   <div class="form-group" id="item-model-no">
									 <label class="col col-4 col-sm-12">Müşteri Model No</label>
										<div class="col col-8 col-sm-12">
											<input type="text" name="musteri_model_no" >
										</div>
								  </div>
						 </div>
					</div>
                    	<div class="row formContentFooter">
                            <div class="col col-12"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></div>
                        </div>
                    </div>
                </div>
                <!---<div class="col col-3 uniqueRow">
                        <cf_box>
                            <div class="col col-11 col-xs-11" type="column" index="5" sort="true">
                            <cfset foldername =createUUID()>
                                <div id="fileUpload" class="fileUpload">
                                    <cfoutput>
                                    <div  class=" col col-12 col-md-12 col-sm-10 col-xs-12 offset-1">
                                        <!-- Nav tabs -->
                                        <input type="hidden" name="foldername" value="#foldername#">
                                        <input type="hidden" name="asset" id="asset" value="">
                                        <div class="dropzone dz-clickable dropzonescroll" style="heigth:5mm;" id="file-dropzone">
                                        <div class="dz-default dz-message">
                                                 <span>Numune resimlerinizi sürükleyerek bırakın ya da burayı tıklayarak seçin.</span>
                                            </div>
                                        </div>
                                                            
                                    </div>  
                                    </cfoutput>      
                                </div> 
                            </div> 
                        </cf_box>
                </div>--->
            </div>
</cfform>
<script type="text/javascript">
function kontrol()
{
	

	if (document.add_opp.opportunity_type_id[add_opp.opportunity_type_id.selectedIndex].value == '')
	{
		alert ("<cf_get_lang_main no='1535.Kategori Seçmelisiniz'>!");
		return false;
	}
	if (document.add_opp.sales_emp_id.value == '' || document.add_opp.sales_emp.value == '')
		{
			alert ("Müşteri Temsilcisi Seçiniz");
			return false;
		}
	if(document.add_opp.product_cat.value=='' || document.add_opp.product_cat_id.value=='')
	{
		alert ("Ürün <cf_get_lang_main no='1535.Kategori Seçmelisiniz'>!");
		return false;
	}

	if (document.add_opp.member_id.value == '')
	{
		alert ("Cari Hesap Seçmelisiniz!");
		return false;
	}
	
	if(document.getElementById('action_date').value != "")
	{
		if (!date_check(document.add_opp.opp_date,document.add_opp.action_date,"Kazanılma Tarihi, Başvuru Tarihinden Önce Olamaz !"))
		return false;
	}
	
	return (process_cat_control());
}
function fill_country(member_id,type)
{
		if(member_id==0)
		{
			if(document.getElementById('member_type').value=='partner')
			{
				member_id=document.getElementById('company_id').value;
				type=1;
			}
			else if(document.getElementById('member_type').value=='consumer')
			{
				member_id=document.getElementById('member_id').value;
				type=2;
			}
		}
	
}
function unformat_fields()
{
	add_opp.income.value = filterNum(add_opp.income.value);
	add_opp.cost.value = filterNum(add_opp.cost.value);
	return true;
}
function return_company()
{
	if(document.getElementById('ref_member_type').value=='employee')
	{
		var emp_id=document.getElementById('ref_employee_id').value;
		var GET_COMPANY=wrk_safe_query('sls_get_cmpny','dsn',0,emp_id);
		document.getElementById('ref_company_id').value=GET_COMPANY.COMP_ID;
	}
	else
		return false;
}
function auto_sales_zone()
{
    var sql = "SELECT SZ.SZ_ID FROM SALES_ZONES_TEAM SZT,SALES_ZONES SZ WHERE SZ.SZ_ID = SZT.SALES_ZONES AND SZT.COUNTRY_ID = " + document.getElementById('country_id').value;
	get_sales_zone_id = wrk_query(sql,'dsn');
    if(get_sales_zone_id.recordcount == 1)
    {
    	document.getElementById('sales_zone_id').value = get_sales_zone_id.SZ_ID;
		return false;
    }
	else if(get_sales_zone_id.recordcount == 0)
	{
		alert("<cf_get_lang no ='150.Ülke ile İlişkili Satış Bölgesi Bulunamadı'> !");
		return false;
	}
	else if(get_sales_zone_id.recordcount > 1)
	{
		alert("<cf_get_lang no ='153.Ülke ile İlişkili Birden Fazla Satış Bölgesi Bulunmaktadır'> !");
		return false;
	}
}

// jQuery

        $(document).ready(function () {
			$(".supplier-product-cat").select2();
        });
 

</script>
 
         <script src="/AddOns/N1-Soft/textile/js/custom.js"></script>
         <script type="text/javascript" src="/JS/fileupload/dropzone.js"></script>
<script type="text/javascript" src="/JS/fileupload/fileupload-min.js"></script>