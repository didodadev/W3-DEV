<cf_xml_page_edit fuseact="sales.form_add_opportunity">
<cfinclude template="/V16/sales/query/get_opp_currencies.cfm">
<cfinclude template="/V16/sales/query/get_commethod_cats.cfm">
<cfinclude template="/V16/sales/query/get_probability_rate.cfm">
<cfinclude template="/V16/sales/query/get_moneys.cfm">
<cfinclude template="/V16/sales/query/get_opportunity_type.cfm">
	<script src="/AddOns/N1-Soft/ntextile/js/dropzone.js"></script>
	 <link href="/AddOns/N1-Soft/ntextile/js/dropzone.css" rel="stylesheet" />

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
<cf_papers paper_type="OPPORTUNITY">
<cf_catalystHeader>
<cfform name="add_opp" method="post" action="#request.self#?fuseaction=sales.emptypopup_add_opportunity">
        <input type="hidden" name="is_popup" id="is_popup" value="<cfif fuseaction contains 'popup'>1<cfelse>0</cfif>">
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
						 <div class="col col-4 col-md-4 col-sm-12 col-xs-12" type="column" index="1" sort="true">
								 <div class="form-group" id="item-opp_stage">
										<label class="col col-4 col-sm-12"><cf_get_lang_main no='1447.S??re??'> *</label>
										<div class="col col-8 col-sm-12">
											<cf_workcube_process is_upd='0' process_cat_width='140' is_detail='0'>
										</div>
								</div>	
								 <div class="form-group" id="item-opportunity_type_id">
                                    <label class="col col-4 col-sm-12">Numune <cf_get_lang_main no='74.Kategori'>*</label>
                                    <div class="col col-8 col-sm-12">
                                        <select name="opportunity_type_id" id="opportunity_type_id">
                                            <option value=""><cf_get_lang_main no='322.Se??iniz'></option>
                                            <cfoutput query="get_opportunity_type">
                                                <option value="#opportunity_type_id#">#opportunity_type#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
								 <div class="form-group" id="item-opp_date">
                                    <label class="col col-4 col-sm-12"><cf_get_lang no='121.Basvuru tarihi'></label>
                                    <div class="col col-7 col-sm-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="opp_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:70px;">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="opp_date"></span>
                                        </div>
                                    </div>
                                </div>
								 <div class="form-group" id="item-sales_emp_id">
                                    <label class="col col-4 col-sm-12">M????teri Temsilcisi<!---<cf_get_lang no='101.Sat???? Cal????an'>---></label>
                                    <div class="col col-8 col-sm-12">
                                        <input type="hidden" name="sales_emp_id" id="sales_emp_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                                        <div class="input-group">
                                            <input name="sales_emp" type="text" id="sales_emp" onfocus="AutoComplete_Create('sales_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','sales_emp_id','add_opp','3','140');" value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_opp.sales_emp_id&field_name=add_opp.sales_emp&select_list=1','list');"></span>
                                        </div>
                                    </div>
                                </div>
						 </div>
				
						  <div class="col col-4 col-md-4 col-sm-12 col-xs-12" type="column" index="1" sort="true">
								<div id="myAwesomeDropzone" class="dropzone" style="background-color: #F3F4F5; text-align: center; font-size: 30px; font-family: Arial">
								</div>
								<form class="dropzone" id="file-dropzone"></form>
										
							</div>
							
					</div>
					<div class="row" type="row">
						  <div class="col col-4 col-md-4 col-sm-12 col-xs-12" type="column" index="1" sort="true">
								<span><strong><h4>M????teri Detaylar??</h4></strong></span>

									<div class="form-group" id="item-company">
                                    <label class="col col-4 col-sm-12"><cf_get_lang_main no='45.M????teri'> *</label>
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
                                            <cfelse>
                                                <input type="text" id="member" name="member" value="" readonly>
                                            </cfif>
                                        </cfif>
                                    </div>
                                </div>
								 <div class="form-group" id="item-member">
									 <label class="col col-4 col-sm-12">Order No</label>
										<div class="col col-8 col-sm-12">
											<input type="text" name="order_no" >
										</div>
								  </div>
								   <div class="form-group" id="item-member">
									 <label class="col col-4 col-sm-12">Proje No</label>
										<div class="col col-8 col-sm-12">
											<input type="text" name="proje_no" >
										</div>
								  </div>
								   <div class="form-group" id="item-opp_invoice_date">
                                    <label class="col col-4 col-sm-12">Termin Tarihi</label>
                                    <div class="col col-7 col-sm-12">
                                        <div class="input-group">
                                            <input type="text" name="opp_invoice_date" id="opp_invoice_date" value="" validate="#validate_style#" maxlength="10">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="opp_invoice_date"></span>
                                        </div>
                                    </div>
                                </div>
								
						</div>
						 <div class="col col-4 col-md-4 col-sm-12 col-xs-12" type="column" index="1" sort="true">
							<span><h4>??r??n Detaylar??</h4></span>
						
							<div class="form-group" id="item-product_cat_id">
                                    <label class="col col-4 col-sm-12"><cf_get_lang_main no='1604.??r??n Kategorisi'></label>
                                    <div class="col col-8 col-sm-12">
                                        <input type="hidden" name="product_cat_id" id="product_cat_id">
                                        <div class="input-group">
                                            <input type="text" name="product_cat" id="product_cat" value="" onfocus="AutoComplete_Create('product_cat','HIERARCHY,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_cat_id','','3','175');" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&field_id=add_opp.product_cat_id&field_name=add_opp.product_cat</cfoutput>','list');"></span>
                                        </div>
                                    </div>
                                </div>
								  <div class="form-group" id="item-stock_id">
                                    <label class="col col-4 col-sm-12"><cf_get_lang_main no='245.??r??n'></label>
                                    <div class="col col-8 col-sm-12">
                                        <input type="hidden" name="stock_id" id="stock_id" value="">
                                        <div class="input-group">
                                            <input name="stock_name" type="text" id="stock_name"  onfocus="AutoComplete_Create('stock_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','STOCK_ID','stock_id','add_opp','3','200');" value="" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=add_opp.stock_id&field_name=add_opp.stock_name','list');"></span>
                                        </div>
                                    </div>
                                </div>
								 <div class="form-group" id="item-member">
									 <label class="col col-4 col-sm-12">Model No</label>
										<div class="col col-8 col-sm-12">
											<input type="text" name="model_no" >
										</div>
								  </div>
								   <div class="form-group" id="item-member">
									 <label class="col col-4 col-sm-12">M????teri Model No</label>
										<div class="col col-8 col-sm-12">
											<input type="text" name="musteri_model_no" >
										</div>
								  </div>
								   <div class="form-group" id="item-member">
									 <label class="col col-4 col-sm-12">??r??n No</label>
										<div class="col col-8 col-sm-12">
											<input type="text" name="urun_no" >
										</div>
								  </div>
								   <div class="form-group" id="item-member">
									 <label class="col col-4 col-sm-12">Beden Seti</label>
										<div class="col col-8 col-sm-12">
											<input type="text" name="urun_no" >
										</div>
								  </div>
									 <div class="form-group" id="item-member">
									 <label class="col col-4 col-sm-12">??retim Miktar??</label>
										<div class="col col-8 col-sm-12">
											<input type="text" name="urun_no" >
										</div>
								  </div>
						 </div>
					</div>
						<div class="row" type="row" style="display:none;">
                            <div class="col col-4 col-md-4 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                                <div class="form-group" id="item-opp_head">
                                    <label class="col col-4 col-sm-12"><cf_get_lang_main no='68.Konu'> *</label>
                                    <div class="col col-8 col-sm-12">
                                        <cfif isdefined('url.service_id')>
                                            <input type="text" name="opp_head" id="opp_head" value="<cfoutput>#get_service.service_head#</cfoutput>" required="yes" message="#message#">
                                        <cfelseif isdefined('attributes.cus_help_id') and len(attributes.cus_help_id)>
                                            <cfsavecontent variable="opp_head_"><cf_get_lang no ='15.Etkile??im'>: <cfoutput>#attributes.cus_help_id#</cfoutput></cfsavecontent>
                                            <input type="text" name="opp_head" id="opp_head" value="<cfoutput>#opp_head_#</cfoutput>">
                                        <cfelse>
                                            <input type="text" name="opp_head" id="opp_head" value="">
                                        </cfif>
                                    </div>
                                </div>
                             
                                
                               
                                <div class="form-group" id="item-project_id">
                                    <label class="col col-4 col-sm-12"><cf_get_lang_main no='4.Proje'></label>
                                    <div class="col col-8 col-sm-12">
                                        <cfif isdefined("attributes.project_id") and len(attributes.project_id)>
                                            <cfquery name="get_project" datasource="#dsn#">
                                                SELECT PROJECT_ID, PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.project_id#
                                            </cfquery>
                                        </cfif>
                                        <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id") and len(attributes.project_id)><cfoutput>#get_project.project_id#</cfoutput></cfif>">
                                        <div class="input-group">
                                            <input name="project_head" type="text" id="project_head" value="<cfif isdefined("attributes.project_id") and len(attributes.project_id)><cfoutput>#get_project.project_head#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_opp.project_id&project_head=add_opp.project_head','list');"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-probability">
                                    <label class="col col-4 col-sm-12"><cf_get_lang_main no='1240.Olas??l??k'></label>
                                    <div class="col col-8 col-sm-12">
                                        <select name="probability" id="probability">
                                            <option value=""><cf_get_lang_main no='322.Se??iniz'></option>
                                            <cfoutput query="get_probability_rate">
                                                <option value="#probability_rate_id#" <cfif isdefined('attributes.probability_rate_id') and len(attributes.probability_rate_id) and attributes.probability_rate_id eq probability_rate_id>selected</cfif>> #get_probability_rate.probability_name# </option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-sales_add_option">
                                    <label class="col col-4 col-sm-12"><cf_get_lang no ='340.Sat???? ??zel Tan??m'></label>
                                    <div class="col col-8 col-sm-12">
                                        <select name="sales_add_option" id="sales_add_option" size="1">
                                            <option value=""><cf_get_lang_main no='322.Se??iniz'></option>
                                            <cfoutput query="get_sale_add_option">
                                                <option value="#sales_add_option_id#">#sales_add_option_name#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-country_id">
                                    <label class="col col-4 col-sm-12"><cf_get_lang_main no ='807.Ulke'></label>
                                    <div class="col col-8 col-sm-12">
                                        <select name="country_id" id="country_id" onchange="auto_sales_zone()">
                                            <option value=""><cf_get_lang_main no='322.Se??iniz'></option>
                                            <cfoutput query="get_country">
                                                <option value="#country_id#">#country_name#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-sales_zone_id">
                                    <label class="col col-4 col-sm-12"><cf_get_lang_main no ='247.Satis bolgesi'></label>
                                    <div class="col col-8 col-sm-12">
                                        <select name="sales_zone_id" id="sales_zone_id">
                                            <option value=""><cf_get_lang_main no='322.Se??iniz'></option>
                                            <cfoutput query="get_sale_zones">
                                                <option value="#sz_id#">#sz_name#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-12 col-xs-12" type="column" index="2" sort="true">
                            	<div class="form-group" id="item-opp_currency_id">
                                    <label class="col col-4 col-sm-12"><cf_get_lang_main no='70.A??ama'></label>
                                    <div class="col col-8 col-sm-12">
                                        <select name="opp_currency_id" id="opp_currency_id" style="width:140px;">
                                            <option value=""><cf_get_lang_main no ='322.Seciniz'></option>
                                            <cfoutput query="get_opp_currencies">
                                                <option value="#opp_currency_id#">#opp_currency#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-opportunity_type_id">
                                    <label class="col col-4 col-sm-12"><cf_get_lang_main no='74.Kategori'>*</label>
                                    <div class="col col-8 col-sm-12">
                                        <select name="opportunity_type_id" id="opportunity_type_id">
                                            <option value=""><cf_get_lang_main no='322.Se??iniz'></option>
                                            <cfoutput query="get_opportunity_type">
                                                <option value="#opportunity_type_id#">#opportunity_type#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-commethod_id">
                                    <label class="col col-4 col-sm-12"><cf_get_lang_main no='731.Ileti??im'></label>
                                    <div class="col col-8 col-sm-12">
                                        <select name="commethod_id" id="commethod_id">
                                            <option value=""><cf_get_lang_main no='322.Se??iniz'></option>
                                            <cfoutput query="get_commethod_cats">
                                                <option value="#get_commethod_cats.commethod_id#" <cfif isdefined('attributes.commethod_id') and len(attributes.commethod_id) and attributes.commethod_id eq commethod_id>selected</cfif>>#get_commethod_cats.commethod#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-cost">
                                    <label class="col col-4 col-sm-12"><cf_get_lang no ='385.Tahmini Maliyet'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang no ='386.Maliyet Girmelisiniz'></cfsavecontent>
                                            <input type="text" name="cost" value="" message="#message#" class="moneybox"  onkeyup="return(formatcurrency(this,event));">
                                            <span class="input-group-addon">
                                                <select name="money2" id="money2">
                                                    <cfoutput query="get_moneys">
                                                        <option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
                                                    </cfoutput>
                                                </select>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-income">
                                    <label class="col col-4 col-sm-12"><cf_get_lang no='115.Tahmini Gelir'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang no='189.Gelir Girmelisiniz'></cfsavecontent>
                                            <input type="text" id="income" name="income" value="" message="#message#" class="moneybox" onkeyup="return(formatcurrency(this,event));">
                                            <span class="input-group-addon">
                                                <select name="money" id="money">
                                                    <cfoutput query="get_moneys">
                                                        <option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
                                                    </cfoutput>
                                                </select>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="form-group" id="item-activity_time">
                                    <label class="col col-4 col-sm-12"><cf_get_lang no='117.Aksiyon'></label>
                                    <div class="col col-8 col-sm-12">
                                        <select name="activity_time" id="activity_time">
                                            <option value=""><cf_get_lang_main no='322.Se??iniz'></option>
                                            <option value="1"><cf_get_lang no='82.Hemen'></option>
                                            <option value="7">1 <cf_get_lang_main no='1322.Hafta'></option>
                                            <option value="30">1 <cf_get_lang_main no='1312.Ay'></option>
                                            <option value="90">3 <cf_get_lang_main no='1312.Ay'></option>
                                            <option value="180">6 <cf_get_lang_main no='1312.Ay'></option>
                                            <option value="180">6 <cf_get_lang no='80.Aydan Fazla'></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-camp_id">
                                    <label class="col col-4 col-sm-12"><cf_get_lang_main no='34.Kampanya'></label>
                                    <div class="col col-8 col-sm-12">
                                        <cfoutput>
                                            <div class="input-group">
                                                <input type="hidden" name="camp_id" id="camp_id" value="">
                                                <input type="text" name="camp_name" id="camp_name" value="" style="width:140px;">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_campaigns&field_id=add_opp.camp_id&field_name=add_opp.camp_name','list');"></span>
                                            </div>
                                        </cfoutput>
                                    </div>
                                </div>
                               
                            </div>
                            <div class="col col-4 col-md-4 col-sm-12 col-xs-12" type="column" index="3" sort="true">
                               
                                <div class="form-group" id="item-opp_date">
                                    <label class="col col-4 col-sm-12"><cf_get_lang no='121.Basvuru tarihi'></label>
                                    <div class="col col-7 col-sm-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="opp_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:70px;">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="opp_date"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-action_date">
                                    <label class="col col-4 col-sm-12"><cf_get_lang no='22.Kazan??lma Tarihi'></label>
                                    <div class="col col-7 col-sm-12">
                                        <div class="input-group">
                                            <input type="text" name="action_date" id="action_date" value="" validate="#validate_style#" maxlength="10">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="action_date"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-ref_company_id">
                                    <label class="col col-4 col-sm-12"><cf_get_lang_main no='1372.Referans'></label>
                                    <div class="col col-8 col-sm-12">
                                        <input type="hidden" name="ref_company_id" id="ref_company_id" value="">
                                        <input type="hidden" name="ref_partner_id" id="ref_partner_id" value="">
                                        <input type="hidden" name="ref_consumer_id" id="ref_consumer_id" value="">
                                        <input type="hidden" name="ref_employee_id" id="ref_employee_id" value="">
                                        <input type="hidden" name="ref_member_type" id="ref_member_type" value="">
                                        <div class="input-group">
                                            <input name="ref_member_name" type="text" id="ref_member_name"  onfocus="AutoComplete_Create('ref_member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2,3\'','COMPANY_ID,PARTNER_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE,MEMBER_PARTNER_NAME2','ref_company_id,ref_partner_id,ref_consumer_id,ref_employee_id,ref_member_type,ref_member','add_opp','3','250','return_company()');" value="" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_partner=add_opp.ref_partner_id&field_consumer=add_opp.ref_consumer_id&field_comp_id=add_opp.ref_company_id&field_comp_name=add_opp.ref_member_name&field_emp_id=add_opp.ref_employee_id&field_name=add_opp.ref_member&field_type=add_opp.ref_member_type&select_list=1,7,8','list');"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-ref_member">
                                    <label class="col col-4 col-sm-12"><cf_get_lang_main no='1372.Referans'><cf_get_lang_main no='166.Yetkili'></label>
                                    <div class="col col-8 col-sm-12">
                                        <input type="text" name="ref_member" id="ref_member" value="" onkeyup="javascript:if(document.add_opp.ref_member.value=='')document.add_opp.ref_member_name.value='';">
                                    </div>
                                </div>
                                <div class="form-group" id="item-sales_member_id">
                                    <label class="col col-4 col-sm-12"><cf_get_lang no='102.Sat???? Orta????'></label>
                                    <div class="col col-8 col-sm-12">
                                        <input type="hidden" name="sales_member_id" id="sales_member_id" value="">
                                        <input type="hidden" name="sales_member_type" id="sales_member_type" value="">
                                        <div class="input-group">
                                            <input type="text" name="sales_member" id="sales_member" value="" onfocus="AutoComplete_Create('sales_member','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2\'','PARTNER_ID,MEMBER_TYPE','sales_member_id,sales_member_type','','3','250');" autocomplete="off">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=add_opp.sales_member_id&field_name=add_opp.sales_member&field_type=add_opp.sales_member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=7,8','list','popup_list_pars');"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-wrk_add_info">
                                    <label class="col col-4 col-sm-12"><cfoutput>#getLang('main',398)#</cfoutput></label>
                                    <div class="col col-8 col-sm-12">
                                        <cf_wrk_add_info info_type_id="-16" upd_page = "0" colspan="9">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row" type="row">
                            <div class="col col-12 col-xs-12" type="column" index="4" sort="true">
                            <label class="col col-8 col-xs-12"><span class="hide">Edit??r</span></label>
                            <div id="fckedit">
                                    <cfif isdefined('attributes.opp_detail') and len(attributes.opp_detail)>
                                        <cfset detail_ = attributes.opp_detail>
                                    <cfelse>
                                        <cfset detail_ = ''>
                                    </cfif>
                                    <cfmodule
                                        template="/fckeditor/fckeditor.cfm"
                                        toolbarset="WRKContent"
                                        basepath="/fckeditor/"
                                        instancename="opp_detail"
                                        value="#detail_#"
                                        width="100%"
                                        height="270">
                                </div>
                            </div>
                        </div>
                    	<div class="row formContentFooter">
                            <div class="col col-12"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></div>
                        </div>
                    </div>
                </div>
            </div>
</cfform>
<script type="text/javascript">
function kontrol()
{
	/*if (document.add_opp.opp_head.value == '')
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='68.Konu'> !");
		return false;
	}

	if (document.add_opp.opportunity_type_id[add_opp.opportunity_type_id.selectedIndex].value == '')
	{
		alert ("<cf_get_lang_main no='1535.Kategori Se??melisiniz'>!");
		return false;
	}*/
	if (document.add_opp.member_id.value == '')
	{
		alert ("<cf_get_lang no='254.Cari Hesap Se??melisiniz'>!");
		return false;
	}

	if(document.getElementById('action_date').value != "")
	{
		if (!date_check(document.add_opp.opp_date,document.add_opp.action_date,"Kazan??lma Tarihi, Ba??vuru Tarihinden ??nce Olamaz !"))
		return false;
	}
	if(document.getElementById('opp_invoice_date').value != "")
	{
		if (!date_check(document.add_opp.opp_date,document.add_opp.opp_invoice_date,"Fatura Tarihi, Ba??vuru Tarihinden ??nce Olamaz !"))
		return false;
	}
	return (process_cat_control() && unformat_fields());
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
		document.getElementById('country_id').value='';
		document.getElementById('sales_zone_id').value='';
		if(type == 1)
		{
			var sql = "SELECT COUNTRY,SALES_COUNTY FROM COMPANY WHERE COMPANY_ID = " + member_id;
			get_country = wrk_query(sql,'dsn');
			if(get_country.COUNTRY!='' && get_country.COUNTRY!='undefined')
				document.getElementById('country_id').value=get_country.COUNTRY;
			if(get_country.SALES_COUNTY!='' && get_country.SALES_COUNTY!='undefined')
				document.getElementById('sales_zone_id').value=get_country.SALES_COUNTY;
		}
		else if(type == 2)
		{
			var sql = "select SALES_COUNTY,TAX_COUNTRY_ID from CONSUMER WHERE CONSUMER_ID = " + member_id;
			get_country= wrk_query(sql,'dsn');
			if(get_country.TAX_COUNTRY_ID!='' && get_country.TAX_COUNTRY_ID!='undefined')
				document.getElementById('country_id').value=get_country.TAX_COUNTRY_ID;
			if(get_country.SALES_COUNTY!='' && get_country.TAX_COUNTRY_ID!='undefined')
				document.getElementById('sales_zone_id').value=get_country.SALES_COUNTY;
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
		alert("<cf_get_lang no ='150.??lke ile ??li??kili Sat???? B??lgesi Bulunamad??'> !");
		return false;
	}
	else if(get_sales_zone_id.recordcount > 1)
	{
		alert("<cf_get_lang no ='153.??lke ile ??li??kili Birden Fazla Sat???? B??lgesi Bulunmaktad??r'> !");
		return false;
	}
}

// jQuery

        $(document).ready(function () {
            Dropzone.autoDiscover = false;
            Dropzone.options.myAwesomeDropzone = false;          
             $("#myAwesomeDropzone").dropzone({
                uploadMultiple: true,
                autoProcessQueue: false,
                addRemoveLinks: true,
                paramName: "file", 
                maxFilesize: 20000, // MB
                parallelUploads: 10,
                clickable: true,
                maxFiles: 10,
					dictDefaultMessage : 'Model resmini s??r??kle veya t??kla se??',
					dictRemoveFile:'Sil',
                autoProcessQueue: false,
                url: "cfc/components.cfc?method=GET_FILE_UPLOAD"
            });
            Dropzone.options.myDropzone = {
                init: function () {
                    this.on("addedfile", function () {                     
                            this.removeFile(this.files[0]);                       
                    })
                }
            };
              $('#button').on('click', function (e) {
               /* var yer = document.getElementById("<%=txt_Yer.ClientID%>").value;
                var trh = document.getElementById("<%=txt_Tarih.ClientID%>").value;*/
              //  myAwesomeDropzone.dropzone.options.url = "FileUploader.aspx?tid=<%=Request.QueryString["tid"]%>&trh="+trh+"&yer="+yer
                myAwesomeDropzone.dropzone.processQueue();
            });
        });
 

</script>
    <style>
        .dropzone {
            border: 2px dashed #d3d3d3;
        }
    </style>
		 <script src="/AddOns/N1-Soft/ntextile/js/custom.js"></script>