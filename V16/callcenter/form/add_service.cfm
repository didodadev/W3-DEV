<cf_xml_page_edit fuseact="call.add_service">
<cfparam name="attributes.task_person_name" default="">
<cfparam name="attributes.responsible_person" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.partner_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="get_service_detail.applicator_name" default="">
<cfparam name="attributes.service_branch_id" default="">
<cfparam name="attributes.service_status_id" default="">
<cfparam name="attributes.city_id" default="">
<cfquery name="GET_SERVICE_NO" datasource="#DSN#">
	SELECT G_SERVICE_APP_NO, G_SERVICE_APP_NUMBER FROM GENERAL_PAPERS_MAIN
</cfquery>
<cfif not len(get_service_no.g_service_app_no) or not len(get_service_no.g_service_app_number)>
	<br/><font class="txtbold">&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='49248.Call Center Başvurusu Eklemek İçin Öncelikle Şikayet Belge Numaralarını Düzenlemelisiniz'>!</font>
	<cfexit method="exittemplate">
</cfif>
<cfinclude template="../query/get_priority.cfm">
<cfquery name="GET_SERVICE_APPCAT" datasource="#DSN#">
	SELECT
         CASE
            WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
            ELSE SERVICECAT
        END AS SERVICECAT,
        SERVICECAT_ID
    FROM
    	G_SERVICE_APPCAT
        LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = G_SERVICE_APPCAT.SERVICECAT_ID
        AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SERVICECAT">
        AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="G_SERVICE_APPCAT">
        AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
    WHERE
    	IS_STATUS = 1
        AND(
            OUR_COMPANY_ID LIKE '#session.ep.company_id#'
            OR OUR_COMPANY_ID LIKE '%,#session.ep.company_id#'
            OR OUR_COMPANY_ID LIKE '#session.ep.company_id#,%'
            OR OUR_COMPANY_ID LIKE '%,#session.ep.company_id#,%'
            )
    ORDER BY SERVICECAT
</cfquery>
<cfquery name="GET_SERVICE_APPCAT_SUB" datasource="#DSN#">
	SELECT
    	SERVICE_SUB_CAT_ID,
        SERVICE_SUB_CAT,
        SERVICECAT_ID,
        OUR_COMPANY_ID
    FROM
    	G_SERVICE_APPCAT_SUB
	WHERE
    	IS_STATUS = 1
        AND(
            OUR_COMPANY_ID LIKE '#session.ep.company_id#'
            OR OUR_COMPANY_ID LIKE '%,#session.ep.company_id#'
            OR OUR_COMPANY_ID LIKE '#session.ep.company_id#,%'
            OR OUR_COMPANY_ID LIKE '%,#session.ep.company_id#,%'
            )    
    ORDER BY
    	SERVICE_SUB_CAT
</cfquery>
<cfquery name="GET_SERVICE_APPCAT_SUB_STATUS" datasource="#DSN#">
	SELECT
    	SERVICE_SUB_CAT_ID,
        SERVICE_SUB_STATUS_ID,
        SERVICE_SUB_STATUS
    FROM
    	G_SERVICE_APPCAT_SUB_STATUS
    WHERE
    	IS_STATUS = 1
        AND(
            OUR_COMPANY_ID LIKE '#session.ep.company_id#'
            OR OUR_COMPANY_ID LIKE '%,#session.ep.company_id#'
            OR OUR_COMPANY_ID LIKE '#session.ep.company_id#,%'
            OR OUR_COMPANY_ID LIKE '%,#session.ep.company_id#,%'
            )   
    ORDER BY SERVICE_SUB_STATUS
</cfquery>
<cfset app_rows = "">
<cfif isdefined("attributes.mail_id")>
	<cfquery name="GET_MAIL_INFO" datasource="#DSN#">
		SELECT SUBJECT, CONTENT_FILE, MAIL_FROM FROM MAILS WHERE MAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.mail_id#">
	</cfquery>
	<cfquery name="FROM_MAIL_PARTNER" datasource="#DSN#">
		SELECT COMPANY_ID, PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_PARTNER_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_mail_info.mail_from#">
	</cfquery>
	<cfif FileExists("#upload_folder#mails#dir_seperator#in#dir_seperator##get_mail_info.content_file#")> 
		<cffile action="read" file="#upload_folder#mails#dir_seperator#in#dir_seperator##get_mail_info.content_file#" variable="mail_body" charset ="UTF-8">
	</cfif>
	<cfif from_mail_partner.recordcount>
		<cfset attributes.partner_id = from_mail_partner.partner_id>
		<cfset attributes.company_id = from_mail_partner.company_id>
		<cfset attributes.consumer_id = ''>
	<cfelse>
		<cfquery name="FROM_MAIL_CONSUMER" datasource="#DSN#">
			SELECT CONSUMER_ID FROM CONSUMER WHERE CONSUMER_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_mail_info.mail_from#">
		</cfquery>
		<cfif from_mail_consumer.recordcount>
			<cfset attributes.company_id = ''>
			<cfset attributes.partner_id = ''>
			<cfset attributes.consumer_id = from_mail_consumer.consumer_id>
		<cfelse>
			<cfset attributes.company_id = ''>
			<cfset attributes.partner_id = ''>
			<cfset attributes.consumer_id = ''>
		</cfif>
	</cfif>
	<cfset get_service_detail.service_head = get_mail_info.subject>
	<cfset attributes.commethod_id = ''>
	<cfset service_detail = ''>
	<cfset task_emp_id = session.ep.userid>
	<cfset task_emp_name = get_emp_info(session.ep.userid,0,0)>
    <cfset resp_emp_id = session.ep.userid>
    <cfset resp_comp_id = "">
    <cfset resp_cons_id = "">
    <cfset resp_par_id = "">
	<cfset resp_emp_name = get_emp_info(session.ep.userid,0,0)>
<cfelseif isdefined("attributes.service_id")>
	<cfquery name="GET_SERVICE_DETAIL" datasource="#DSN#">
		SELECT 
			SERVICE_EMPLOYEE_ID,
			SERVICE_COMPANY_ID,
			SERVICE_CONSUMER_ID,
			SERVICE_PARTNER_ID,
			SERVICE_BRANCH_ID,
			SERVICE_HEAD,
			SERVICE_DETAIL,
			SERVICECAT_ID,
			APPLICATOR_NAME,
			APPLY_DATE,
			START_DATE,
			PRIORITY_ID,
			COMMETHOD_ID,
			PROJECT_ID,
			SUBSCRIPTION_ID,
			REF_NO,
            SERVICE_STATUS_ID,
            CAMPAIGN_ID,
            RESP_EMP_ID,
            RESP_PAR_ID,
            RESP_COMP_ID,
            RESP_CONS_ID,
            NOTIFY_EMPLOYEE_ID,
            NOTIFY_PARTNER_ID,
            NOTIFY_CONSUMER_ID
		FROM
			G_SERVICE
		WHERE 
			SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
	</cfquery>
   	<cfset attributes.company_id = get_service_detail.service_company_id>
	<cfset attributes.consumer_id = get_service_detail.service_consumer_id>
	<cfset attributes.partner_id = get_service_detail.service_partner_id>
	<cfset attributes.employee_id = get_service_detail.service_employee_id>
	<cfset attributes.service_head = get_service_detail.service_head>
	<cfset attributes.branch_id = get_service_detail.service_branch_id>
	<cfset attributes.subscription_id = get_service_detail.subscription_id>
	<cfset attributes.commethod_id = get_service_detail.commethod_id>
    <cfset attributes.service_status_id = get_service_detail.service_status_id>
	<cfset attributes.campaign_id = get_service_detail.campaign_id>
    <cfset attributes.notify_employee_id = get_service_detail.notify_employee_id>
    <cfset attributes.notify_partner_id = get_service_detail.notify_partner_id>
    <cfset attributes.notify_consumer_id = get_service_detail.notify_consumer_id>
    <cfif len(attributes.subscription_id)>
		<cfquery name="GET_SUB_NO" datasource="#DSN3#">
			SELECT SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
		</cfquery>
		<cfset attributes.subscription_no = get_sub_no.subscription_no>
	</cfif>
	<cfset service_detail = get_service_detail.service_detail>
	<cfset task_emp_id = ''>
	<cfset task_emp_name = ''>
    <cfset resp_comp_id = get_service_detail.resp_comp_id>
	<cfset resp_par_id = get_service_detail.resp_par_id>
	<cfset resp_cons_id = get_service_detail.resp_cons_id>
	<cfset resp_emp_id = get_service_detail.resp_emp_id>
	<cfif len(get_service_detail.resp_emp_id)>
		<cfset resp_emp_name = get_emp_info(get_service_detail.resp_emp_id,0,0)>
    <cfelseif len(get_service_detail.resp_par_id)>
		<cfset resp_emp_name = get_par_info(get_service_detail.resp_par_id,0,0,0)>
   	<cfelseif len(get_service_detail.resp_cons_id)>
    	<cfset resp_emp_name = get_cons_info(get_service_detail.resp_cons_id,0,0)>
    <cfelse>
    	<cfset resp_emp_name = "">
    </cfif>
	<cfset attributes.servicecat_id = get_service_detail.servicecat_id>	
	<cfquery name="GET_SERVICE_APP_ROWS" datasource="#DSN#">
		SELECT SERVICE_SUB_STATUS_ID, SERVICE_SUB_CAT_ID FROM G_SERVICE_APP_ROWS WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
	</cfquery>
	<cfset app_rows = valuelist(get_service_app_rows.service_sub_status_id,',')>
<cfelseif isdefined('attributes.cus_help_id') and len(attributes.cus_help_id)>
	<cfquery name="GET_HELP_" datasource="#DSN#">
		SELECT COMPANY_ID, PARTNER_ID, CONSUMER_ID, SUBJECT, SUBSCRIPTION_ID, APP_CAT FROM CUSTOMER_HELP WHERE CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#">
	</cfquery>
	<cfset attributes.consumer_id = get_help_.consumer_id>
	<cfset attributes.partner_id = get_help_.partner_id>
	<cfset attributes.company_id = get_help_.company_id>
	<cfset attributes.subscription_id = get_help_.subscription_id>
	<cfset service_detail = get_help_.subject>
	<cfset attributes.commethod_id = get_help_.app_cat>
	<cfset task_emp_id = ''>
	<cfset task_emp_name = ''>
    <cfset resp_comp_id = ''>
	<cfset resp_par_id = ''>
    <cfset resp_cons_id = ''>
	<cfset resp_emp_id = ''>
	<cfset resp_emp_name = ''>
	<cfif len(attributes.subscription_id)>
		<cfquery name="GET_SUB_NO" datasource="#DSN3#">
			SELECT SUBSCRIPTION_NO,PROJECT_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
		</cfquery>
		<cfset attributes.subscription_no = get_sub_no.subscription_no>
		<cfset get_service_detail.project_id = GET_SUB_NO.project_id>
	</cfif>
<cfelse>
	<!--- üyeden,sistemden vs gelen kayıtlarda dolu geliyor, kaybetmemesi için.. --->
	<cfif not isDefined("attributes.company_id")><cfset attributes.company_id = ''></cfif>
	<cfif not isDefined("attributes.consumer_id")><cfset attributes.consumer_id = ''></cfif>
	<cfif not isDefined("attributes.partner_id")><cfset attributes.partner_id = ''></cfif>
	<cfif not isdefined("attributes.service_head")><cfset attributes.service_head = ''></cfif>
	<cfset attributes.commethod_id = ''>
	<cfset service_detail = ''>
	<cfset task_emp_id = ''>
	<cfset task_emp_name = ''>
    <cfset resp_cons_id = ''>
    <cfset resp_comp_id = ''>
	<cfset resp_par_id = ''>
	<cfset resp_emp_id = session.ep.userid>
	<cfset resp_emp_name = get_emp_info(session.ep.userid,0,0)>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_service" method="post" action="#request.self#?fuseaction=call.emptypopup_add_service_act&#xml_str#">
            <cfoutput>
                <cfif isdefined("url.tmarket_id")>
                    <input type="hidden" name="tmarket_id" id="tmarket_id" value="#url.tmarket_id#" />
                    <input type="hidden" name="target_record_id" id="target_record_id" value="#url.target_record_id#" />
                </cfif>
                <input type="hidden"  name="service_default_no" id="service_default_no" value="#x_paper_no#">
                <input type="hidden" name="my_fuseaction" id="my_fuseaction" value="#fusebox.fuseaction#">
                <input type="hidden" name="temp_service_sub_cat_id" id="temp_service_sub_cat_id" value="">
                <input type="hidden" name="listParam" id="listParam" value="#ValueList(get_service_appcat_sub.servicecat_id,',')#">
                <input type="hidden" name="old_app_rows" id="old_app_rows" value="<cfif isdefined("attributes.service_id")>#app_rows#</cfif>">
                <cfif isdefined('attributes.cus_help_id') and len(attributes.cus_help_id)>
                    <input type="hidden" name="cus_help_id" id="cus_help_id" value="#attributes.cus_help_id#">
                </cfif>
            </cfoutput>
            <cf_box_elements vertical="1">
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12 padding-0" type="column" index="1" sort="true">
                    <cfoutput>
                        <div class="form-group" id="item-member_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29514.Başvuru Yapan'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="partner_id" id="partner_id" value="#attributes.partner_id#">
                                    <input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
                                    <input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">
                                    <input type="hidden" name="employee_id" id="employee_id" value="#attributes.employee_id#">
                                    <input type="hidden" name="x_is_sub_tree_single_select" id="x_is_sub_tree_single_select" value="#x_is_sub_tree_single_select#">
                                    <input type="hidden" name="x_subs_team_mail" id="x_subs_team_mail" value="#x_subs_team_mail#">
                                    <cfif len(attributes.consumer_id)>
                                        <cfquery name="GET_CONS_DETAIL" datasource="#DSN#">
                                            SELECT MEMBER_CODE FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                                        </cfquery>
                                    </cfif>
                                    <input type="text" name="member_company" id="member_company" value="<cfif len(attributes.company_id)>#get_par_info(attributes.company_id,1,1,0)#<cfelseif len(attributes.consumer_id)>#get_cons_detail.member_code#</cfif>" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2\',0,0,0','PARTNER_ID,COMPANY_ID,CONSUMER_ID,MEMBER_NAME2','partner_id,company_id,consumer_id,member_company','','3','250','return_member_code()');" autocomplete="off">
                                    <span class="input-group-addon no-bg"></span>
                                    <input type="text" name="member_name" id="member_name"  value="<cfif len(attributes.consumer_id)>#get_cons_info(attributes.consumer_id,0,0)#<cfelseif len(attributes.partner_id)>#get_par_info(attributes.partner_id,0,-1,0)#<cfelseif isdefined('attributes.employee_id') and len(attributes.employee_id)>#get_emp_info(attributes.employee_id,0,0)#</cfif>" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2\',0,0,0<cfif is_notify_popup eq 1>,2,1,0,0,0,1</cfif>','PARTNER_ID,COMPANY_ID,CONSUMER_ID,MEMBER_NAME2<cfif is_notify_popup eq 1>,MEMBER_TYPE,WORKGROUP_EMP_ID,WORKGROUP_EMP_NAME</cfif>','partner_id,company_id,consumer_id,member_company<cfif is_notify_popup eq 1>,notify_app_type,notify_app_id,notify_app_name</cfif>','','3','250','return_member_code()');" autocomplete="off">
                                    <cfset str_linke_ait_2 = ""> <!---"&field_city=add_service.city&&field_city_id=add_service.city_id&field_county_id=add_service.county_id&field_county=add_service.county&sales_part=add_service.sales_part" --->
                                    <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='29514.Başvuru Yapan'>" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars#str_linke_ait_2#&is_period_kontrol=0&field_emp_id=add_service.employee_id&field_consumer=add_service.consumer_id&field_partner=add_service.partner_id&field_comp_id=add_service.company_id&field_comp_name=add_service.member_company<cfif is_notify_popup eq 1>&field_notify_app_type=add_service.notify_app_type&field_notify_app_id=add_service.notify_app_id&field_notify_app_name=add_service.notify_app_name</cfif>&field_cons_code=add_service.member_company&field_pos_name=add_service.member_company&field_name=add_service.member_name&select_list=7,8,9&function_name=info_comp&keyword='+encodeURIComponent(document.add_service.member_company.value),'list');"></span>
                                </div>

                            </div>
                        </div>
                        <div class="form-group" id="item-notify_app_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='38725.Başvuruyu Bildiren'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="notify_app_type" id="notify_app_type" value="<cfif isdefined('attributes.notify_employee_id') and len(attributes.notify_employee_id)>employee<cfelseif isdefined('attributes.notify_partner_id') and len(attributes.notify_partner_id)>partner<cfelseif isdefined('attributes.notify_consumer_id') and len(attributes.notify_consumer_id)>consumer</cfif>">
                                    <input type="hidden" name="notify_app_id" id="notify_app_id" value="<cfif isdefined('attributes.notify_partner_id') and len(attributes.notify_partner_id)>#attributes.notify_partner_id#<cfelseif isdefined('attributes.notify_consumer_id') and len(attributes.notify_consumer_id)>#attributes.notify_consumer_id#</cfif>">
                                    <input type="text" name="notify_company_name" id="notify_company_name" value="<cfif isdefined('attributes.notify_partner_id') and len(attributes.notify_partner_id)>#get_par_info(attributes.notify_partner_id,0,1,0)#</cfif>">
                                    <span class="input-group-addon no-bg"></span>
                                    <input type="text" name="notify_app_name" id="notify_app_name" value="<cfif isdefined('attributes.notify_partner_id') and len(attributes.notify_partner_id)>#get_par_info(attributes.notify_partner_id,0,-1,0)#<cfelseif isdefined('attributes.notify_consumer_id') and len(attributes.notify_consumer_id)>#get_cons_info(attributes.notify_consumer_id,0,0)#<cfelseif isdefined('attributes.notify_employee_id') and len(attributes.notify_employee_id)>#get_emp_info(attributes.notify_employee_id,0,0)#</cfif>">
                                    <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='38725.Başvuruyu Bildiren'>" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&is_period_kontrol=0&field_id=add_service.notify_app_id&field_comp_name=add_service.notify_company_name&field_name=add_service.notify_app_name&field_type=add_service.notify_app_type&field_emp_id=add_service.notify_app_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,2,3','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-service_branch_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinclude template="../query/get_branch.cfm">
                                <select name="service_branch_id" id="service_branch_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="get_branch">
                                        <option value="#branch_id#" <cfif isdefined("attributes.branch_id") and (attributes.branch_id eq branch_id)>selected</cfif>>#branch_name#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-priority_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57485.Öncelik'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="priority_id" id="priority_id">
                                    <cfloop query="get_priority">
                                        <option value="#priority_id#" <cfif isdefined("attributes.service_id") and get_service_detail.priority_id eq priority_id>selected</cfif>>#priority#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-process">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfif isdefined('attributes.service_id') and len(attributes.service_id)>
                                    <cf_workcube_process is_upd='0' process_cat_width='140' is_detail='0' select_value='#attributes.service_status_id#'>
                                <cfelse>
                                    <cf_workcube_process is_upd='0' process_cat_width='140' is_detail='0'>
                                </cfif>  
                            </div>
                        </div>
                        <div class="form-group" id="item-appcat_id">
                            <cfif isdefined("attributes.service_id")>
                                <cfquery name="GET_SUB_QUERY" dbtype="query">
                                    SELECT
                                        SERVICE_SUB_CAT_ID,
                                        SERVICE_SUB_CAT,
                                        SERVICECAT_ID
                                    FROM
                                        GET_SERVICE_APPCAT_SUB
                                    WHERE
                                        SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.servicecat_id#">
                                </cfquery>
                                <cfquery name="GET_SUB_TREE_QUERY" dbtype="query">
                                    SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_STATUS_ID,SERVICE_SUB_STATUS FROM GET_SERVICE_APPCAT_SUB_STATUS WHERE SERVICE_SUB_CAT_ID <cfif len(get_service_app_rows.service_sub_cat_id)>= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_app_rows.service_sub_cat_id#"><cfelse>IS NULL</cfif>
                                </cfquery>
                            </cfif>
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="hidden" value="<cfif isdefined("get_service_detail.servicecat_id")and len (get_service_detail.servicecat_id)>#get_service_detail.servicecat_id#</cfif>" name="old_appcat_id" id="old_appcat_id">
                                <select name="appcat_id" id="appcat_id" onchange="kategori_getir();">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="get_service_appcat">
                                        <option value="#servicecat_id#"<cfif isdefined("get_service_detail.servicecat_id")and get_service_detail.servicecat_id eq servicecat_id>selected</cfif>>#servicecat#</option>
                                    </cfloop>
                                </select>		
                            </div>
                        </div>
                        <cfif x_is_sub_tree_single_select eq 1>
                            <div class="form-group" id="item-servicecat_sub_id">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31061.Alt Kategori'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="servicecat_sub_id" id="servicecat_sub_id" onchange="rel_tree_cat(<cfif isdefined("attributes.service_id")>#get_service_app_rows.service_sub_cat_id#</cfif>)&sub_kategori_getir();">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfif isdefined("attributes.service_id")>
                                            <cfloop query="get_sub_query">
                                                <option value="#service_sub_cat_id#" <cfif get_service_app_rows.service_sub_cat_id eq service_sub_cat_id>selected</cfif>>#service_sub_cat#</option>
                                            </cfloop>
                                        </cfif>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-servicecat_sub_tree_id">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang  dictionary_id='38732.Alt Tree Kategori'> </label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="servicecat_sub_tree_id" id="servicecat_sub_tree_id" onchange="rel_tree_cat(<cfif isdefined("attributes.service_id")>#get_service_app_rows.service_sub_cat_id#</cfif>);">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfif isdefined("attributes.service_id")>
                                            <cfloop query="get_sub_tree_query">
                                                <option value="#service_sub_status_id#" <cfif get_service_app_rows.service_sub_status_id eq service_sub_status_id>selected</cfif>>#service_sub_status#</option>
                                            </cfloop>
                                        </cfif>
                                    </select>
                                </div>
                            </div>
                        </cfif>
                        <div class="form-group" id="item-ComMethod_Id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58143.İletişim'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_wrkComMethod width="140" ComMethod_Id="#attributes.Commethod_Id#" isDefault="1">
                            </div>
                        </div>
                        <div class="form-group" id="item-ref_no">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58794.Referans No'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" name="ref_no" id="ref_no" maxlength="50" value="<cfif isdefined('get_service_detail.ref_no') and len(get_service_detail.ref_no)>#get_service_detail.ref_no#</cfif>">
                            </div>
                        </div>
                    </cfoutput>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12 padding-0" type="column" index="2" sort="true">
                    <cfoutput>
                        <div class="form-group" id="item-apply_date">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='49292.Başvuru Tarihi'> *</label>
                            <div  id="form_ul_apply_date" extra_select="apply_hour,apply_minute">
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <div class="input-group">
                                        <cfif isdefined("get_service_detail.apply_date") and len(get_service_detail.apply_date)>
                                            <cfset adate=date_add("H",session.ep.time_zone,get_service_detail.apply_date)>
                                            <cfset ahour=datepart("H",adate)>
                                            <cfset aminute=datepart("N",adate)>
                                            <cfset apply_date_ = dateformat(date_add("H",session.ep.time_zone,get_service_detail.apply_date),dateformat_style)>
                                        <cfelse>
                                            <cfset adate="">
                                            <cfset ahour="">
                                            <cfset aminute="">
                                            <cfset apply_date_ = dateformat(now(),dateformat_style)>
                                        </cfif>
                                        <cfsavecontent variable="message_apply"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='49292.Başvuru Tarihi'>!</cfsavecontent>
                                        <cfinput type="text" name="apply_date" id="apply_date" value="#apply_date_#" validate="#validate_style#" required="yes" message="#message_apply#">
                                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="apply_date"></span>
                                    </div>
                                </div>
                                <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                    <cfif isdefined("get_service_detail.apply_date") and len(get_service_detail.apply_date)>
                                            <cf_wrkTimeFormat name="apply_hour" id="apply_hour" value="#ahour#">
                                    <cfelse>
                                            <cf_wrkTimeFormat name="apply_hour" id="apply_hour" value="#NumberFormat("#timeformat(date_add("h",session.ep.time_zone,now()),'HH')#",00)#">
                                    </cfif>	
                                </div>
                                <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                    <select name="apply_minute" id="apply_minute">
                                        <cfloop from="0" to="55" step="5" index="app_min">
                                            <option value="#NumberFormat(app_min,00)#" <cfif isdefined("get_service_detail.apply_date") and len(get_service_detail.apply_date)><cfif app_min eq aminute>selected</cfif><cfelse><cfif app_min eq 00>selected</cfif></cfif>>#NumberFormat(app_min,00)#</option>
                                        </cfloop>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-start_date">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='49293.Kabul Tarihi'> *</label>
                            <div id="form_ul_start_date1" extra_select="start_hour,start_minute" >
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <div class="input-group">
                                        <cfif isdefined("get_service_detail.start_date") and len(get_service_detail.start_date)>
                                            <cfset sdate=date_add("H",session.ep.time_zone,get_service_detail.start_date)>
                                            <cfset shour=datepart("H",sdate)>
                                            <cfset sminute=datepart("N",sdate)>
                                            <cfset start_date_ = dateformat(date_add("H",session.ep.time_zone,get_service_detail.start_date),dateformat_style)>
                                        <cfelse>
                                            <cfset sdate="">
                                            <cfset shour="">
                                            <cfset sminute="">
                                            <cfset start_date_ = dateformat(now(),dateformat_style)>
                                        </cfif>
                                        <cfsavecontent variable="message_startdate"><cf_get_lang dictionary_id ='49206.Kabul Tarihi Girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="start_date1" value="#start_date_#" validate="#validate_style#" required="yes" message="#message_startdate#">
                                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date1"></span>
                                    </div>
                                </div>
                                <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                    <cfif isdefined("get_service_detail.start_date") and len(get_service_detail.start_date)>
                                        <cf_wrkTimeFormat name="start_hour" id="start_hour" value="#shour#">
                                    <cfelse>
                                        <cf_wrkTimeFormat name="start_hour" id="start_hour" value="#NumberFormat("#timeformat(date_add("h",session.ep.time_zone+1,now()),'HH')#",00)#">
                                    </cfif>	
                                </div>
                                <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                    <select name="start_minute" id="start_minute">
                                        <cfloop from="0" to="55" step="5" index="sta_min">
                                            <option value="#NumberFormat(sta_min,00)#" <cfif isdefined("get_service_detail.start_date") and len(get_service_detail.start_date)><cfif sta_min eq sminute>selected</cfif><cfelse><cfif sta_min eq 00>selected</cfif></cfif>>#NumberFormat(sta_min,00)#</option>
                                        </cfloop>
                                    </select> 
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-task_person_name">
                            <label for="" class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57569.Görevli'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfif x_is_related_tree_cat eq 1>
                                        <cfinput type="text" name="task_person_name" id="task_person_name" value="#task_emp_name#">
                                    <cfelse>
                                        <cfinput type="text" name="task_person_name" id="task_person_name" value="#task_emp_name#" onFocus="AutoComplete_Create('task_person_name','FULLNAME','FULLNAME','get_emp_pos','','EMPLOYEE_ID','task_emp_id','','3','160');">
                                    </cfif>
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="tree_gonder();" title="<cf_get_lang dictionary_id='57569.Görevli'>"></span>
                                    <input type="hidden" name="task_emp_id" id="task_emp_id" value="#task_emp_id#">	
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-responsible_person">
                            <label for="" class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="resp_emp_id" id="resp_emp_id" value="#resp_emp_id#">
                                    <input type="hidden" name="resp_cons_id" id="resp_cons_id" value="#resp_cons_id#">
                                    <input type="hidden" name="resp_par_id" id="resp_par_id" value="#resp_par_id#">
                                    <input type="hidden" name="resp_comp_id" id="resp_comp_id" value="#resp_comp_id#">
                                    <cfinput type="text" name="responsible_person" id="responsible_person" value="#resp_emp_name#" onFocus="AutoComplete_Create('responsible_person','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',0,0','COMPANY_ID,PARTNER_ID,CONSUMER_ID,EMPLOYEE_ID','resp_comp_id,resp_par_id,resp_cons_id,resp_emp_id','','3','160',true,'fill_country(0,0)');">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="tree_gonder1();" title="<cf_get_lang dictionary_id='57544.Sorumlu'>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-project_head">
                            <label for="" class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('get_service_detail.project_id') and len(get_service_detail.project_id)>#get_service_detail.project_id#<cfelseif isdefined('attributes.project_id') and len(attributes.project_id)>#attributes.project_id#</cfif>">
                                    <input type="text" name="project_head" id="project_head" value="<cfif isdefined('get_service_detail.project_id') and len(get_service_detail.project_id)>#get_project_name(get_service_detail.project_id)#<cfelseif isdefined('attributes.project_id') and len(attributes.project_id)>#get_project_name(attributes.project_id)#</cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','148');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=add_service.project_id&project_head=add_service.project_head');" title="<cf_get_lang dictionary_id='57416.Proje'>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-camp_name">
                            <label for="" class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfif isdefined('attributes.campaign_id') and len(attributes.campaign_id)>
                                        <cfquery name="GET_CAMP_INFO" datasource="#DSN3#">
                                            SELECT CAMP_ID,CAMP_HEAD FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.campaign_id#">
                                        </cfquery>
                                    <cfelse>
                                        <cfset get_camp_info.camp_head = ''>
                                    </cfif>
                                    <input type="hidden" name="camp_id" id="camp_id" value="<cfif isdefined('attributes.campaign_id') and len(attributes.campaign_id)>#attributes.campaign_id#</cfif>">
                                    <input type="text" name="camp_name" id="camp_name" value="<cfif len(get_camp_info.camp_head)>#get_camp_info.camp_head#</cfif>">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_campaigns&field_id=add_service.camp_id&field_name=add_service.camp_name','list');" title="<cf_get_lang dictionary_id='57446.Kampanya'>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-subscription_no">
                            <label for="" class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29502.Sistem No'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="subscription_id" id="subscription_id" value="<cfif isdefined("attributes.subscription_id")>#attributes.subscription_id#</cfif>">
                                    <input type="text" name="subscription_no" id="subscription_no" value="<cfif isdefined("attributes.subscription_no")>#attributes.subscription_no#</cfif>"  onfocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','200');" autocomplete="off">
                                    <cfset str_subscription_link="field_partner=&field_id=add_service.subscription_id&field_no=add_service.subscription_no">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_subscription&#str_subscription_link#','list','popup_list_subscription');" title="<cf_get_lang dictionary_id='29502.Sistem No'>"></span>
                                    <span class="input-group-addon btnPointer icon-question" onclick="call_sub_id()" title="<cf_get_lang dictionary_id='30003.Aboneler'>"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-add_info">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_wrk_add_info info_type_id="-24" upd_page = "0" colspan="9">
                            </div>
                        </div>
                    </cfoutput>
                </div>
                <cfif x_is_sub_tree_single_select eq 0>
                    <cfoutput query="get_service_appcat" group="servicecat_id">
                        <cfquery name="GET_SERVICE_APPCAT_SUB_ORD" dbtype="query">
                            SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_CAT,SERVICECAT_ID FROM GET_SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_appcat.servicecat_id#">
                        </cfquery>
                        <div id="anakategori_#servicecat_id#" style="#iif(isDefined('attributes.servicecat_id') and attributes.servicecat_id eq servicecat_id , DE('display:block;') , DE('display:none;'))#" class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="false">
                                <fieldset>
                                    <legend>#servicecat#</legend>        
                                    <cfoutput>
                                        <cfloop query="get_service_appcat_sub_ord">
                                            <cfquery name="GET_SERVICE_APPCAT_SUB_STATUS_ORD" dbtype="query">
                                                SELECT SERVICE_SUB_STATUS_ID,SERVICE_SUB_CAT_ID,SERVICE_SUB_STATUS FROM GET_SERVICE_APPCAT_SUB_STATUS WHERE SERVICE_SUB_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_appcat_sub_ord.service_sub_cat_id#">
                                            </cfquery>
                                            <div class="form-group" id="form_ul_service_sub_cat_id_#service_sub_cat_id#" sort="false">
                                                <label for="" class="col col-4 col-md-4 col-sm-4 col-xs-12">#service_sub_cat#</label>
                                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                                    <div class="input-group">
                                                        <input type="hidden" name="old_appcat_id" id="old_appcat_id" value="<cfif isdefined("get_service_appcat_sub_status_ord.service_sub_status_id")><cfoutput>#get_service_appcat_sub_status_ord.service_sub_status_id#</cfoutput></cfif>">
                                                        <select name="service_sub_cat_id_#service_sub_cat_id#" id="service_sub_cat_id_#service_sub_cat_id#" onchange="rel_tree_cat(#service_sub_cat_id#);">
                                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                            <cfloop query="get_service_appcat_sub_status_ord">
                                                                <option value="#service_sub_status_id#" <cfif isdefined("attributes.service_id") and listfindnocase(app_rows,service_sub_status_id,',')>selected</cfif>>#service_sub_status#</option>
                                                            </cfloop>
                                                        </select>
                                                        <cfif x_is_mail_send_tree_list eq 1>
                                                            <span class="input-group-addon btnPointer catalyst-list bold"  onclick="send_tree_mail(#service_sub_cat_id#);" title="<cf_get_lang dictionary_id='49300.Gönderi Listesi'>"></span>
                                                        <cfelse>
                                                            <span class="input-group-addon btnPointer catalyst-list bold"  onclick="windowopen('#request.self#?fuseaction=call.popup_sub_cat_people&service_sub_cat_id=#service_sub_cat_id#&branch_id='+add_service.service_branch_id.value,'medium');" title="<cf_get_lang dictionary_id='49300.Gönderi Listesi'>"></span>
                                                        </cfif>
                                                    </div>
                                                </div>
                                            </div>
                                        </cfloop>
                                    </cfoutput>
                                </fieldset>
                        </div>
                    </cfoutput>
                </cfif>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="4" sort="true">
                    <cfoutput>
                        <div class="form-group" id="item-service_head">
                            <label><cf_get_lang dictionary_id='57480.Konu'> *</label>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57480.Konu'>!</cfsavecontent>
                            <cfif isdefined("get_service_detail.service_head")>
                                <cfinput type="text" name="service_head" id="service_head" value="#get_service_detail.service_head#" required="yes" message="#message#" maxlength="50">
                            <cfelseif isdefined('attributes.cus_help_id') and len(attributes.cus_help_id)>
                                <cfsavecontent variable="service_head_"><cf_get_lang dictionary_id='49270.Etkileşim'>: #attributes.cus_help_id#</cfsavecontent>
                                <cfinput type="text" name="service_head" id="service_head" value="#service_head_#" required="yes" message="#message#" maxlength="50"> 
                            <cfelse>
                                    <cfinput type="text" name="service_head" id="service_head" value="" required="yes" message="#message#" maxlength="50"> 
                            </cfif>
                        </div>
                        <div class="form-group" id="item-service_detail">
                            <label style="display:none!important;"><cf_get_lang dictionary_id='57629.Açıklama'> *</label>	
                            <cfmodule                                                
                                    template="/fckeditor/fckeditor.cfm" 
                                    toolbarSet="Basic" 
                                    basePath="/fckeditor/" 
                                    instanceName="service_detail" 
                                    value="#service_detail#" 
                                    width="587" 
                                    height="180">
                                    
                        </div>
                    </cfoutput>
                </div>
            </cf_box_elements>
            <div class="ui-form-list-btn">
                <cf_workcube_buttons type_format='1' is_upd='0' add_function='chk_form()'>
            </div>
        </cfform>
    </cf_box>
</div>

<script type="text/javascript">
    function call_sub_id(){
        subscription_id = document.getElementById("subscription_id").value;
        if(subscription_id != ''){
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=sales.list_subscription_contract&event=upd&subscription_id='+subscription_id,'wwide');
        }else{
            alert("<cf_get_lang dictionary_id = '41400.Abone seçiniz'>!");
        }
	}
function info_comp(member_id,type)
	{
		
		document.getElementById('resp_emp_id').value='';
		document.getElementById('responsible_person').value='';
		if(member_id==0)
		{
			if(document.getElementById('partner_id').value!='')
			{
				member_id=document.getElementById('company_id').value;
				type=1;
			}
			else if(document.getElementById('consumer_id').value!='')
			{
				member_id=document.getElementById('consumer_id').value;
				type=2;
			}
		}
		//document.getElementById("div_city_county_info").innerHTML ="<TABLE><tr><td></td></tr></TABLE>";
		if(type == 1)
		{
			get_info_sales=wrk_query("select SZ_NAME,RESPONSIBLE_POSITION_CODE from SALES_ZONES,COMPANY where SALES_ZONES.SZ_ID=COMPANY.SALES_COUNTY AND COMPANY.COMPANY_ID=" + member_id,"dsn");
			get_info_city=wrk_query("select CITY_NAME from SETUP_CITY,COMPANY where SETUP_CITY.CITY_ID=COMPANY.CITY AND  COMPANY.COMPANY_ID=" + member_id,"dsn");
	    	get_info_county= wrk_query("select COUNTY_NAME from SETUP_COUNTY,COMPANY where SETUP_COUNTY.COUNTY_ID=COMPANY.COUNTY AND COMPANY.COMPANY_ID=" + member_id,"dsn");
			/*document.getElementById("div_city_county_info").innerHTML ="";
			if(get_info_sales.recordcount || get_info_city.recordcount || get_info_county.recordcount)
			{
				document.getElementById("div_city_county_info").innerHTML = "<table>"
				if(get_info_city.recordcount)
					document.getElementById("div_city_county_info").innerHTML += "<br/><tr><td class='txtbold'>Şehir:</td><td>"+get_info_city.CITY_NAME+"</td></tr>"
				if(get_info_county.recordcount)
					document.getElementById("div_city_county_info").innerHTML += "<br/><tr><td>İlçe:</td><td>"+get_info_county.COUNTY_NAME+"</td></tr>"
				if(get_info_sales.recordcount)
					document.getElementById("div_city_county_info").innerHTML +="<br/><tr><td>Satış bölgesi:</td><td>"+get_info_sales.SZ_NAME+"</td></tr>"
				document.getElementById("div_city_county_info").innerHTML += "</table>"
			}*/
		}
		else if(type == 2)
		{
			get_info_sales=wrk_query("select SZ_NAME,RESPONSIBLE_POSITION_CODE from SALES_ZONES,CONSUMER where SALES_ZONES.SZ_ID=CONSUMER.SALES_COUNTY AND CONSUMER.CONSUMER_ID=" + member_id,"dsn");
			get_info_city=wrk_query("select CITY_NAME from SETUP_CITY,CONSUMER where SETUP_CITY.CITY_ID=CONSUMER.WORK_CITY_ID AND  CONSUMER.CONSUMER_ID=" + member_id,"dsn");
	    	get_info_county= wrk_query("select COUNTY_NAME from SETUP_COUNTY,CONSUMER where SETUP_COUNTY.COUNTY_ID=CONSUMER.WORK_COUNTY_ID AND CONSUMER.CONSUMER_ID=" + member_id,"dsn");
			/*if(get_info_sales.recordcount || get_info_city.recordcount || get_info_county.recordcount)
			{
				document.getElementById("div_city_county_info").innerHTML = "<table>"
				if(get_info_city.recordcount)
					document.getElementById("div_city_county_info").innerHTML += "<br/><tr><td class='txtbold'>Şehir:</td><td>"+get_info_city.CITY_NAME+"</td></tr>"
				if(get_info_county.recordcount)
					document.getElementById("div_city_county_info").innerHTML += "<br/><tr><td>İlçe:</td><td>"+get_info_county.COUNTY_NAME+"</td></tr>"
				if(get_info_sales.recordcount)
					document.getElementById("div_city_county_info").innerHTML +="<br/><tr><td>Satış bölgesi:</td><td>"+get_info_sales.SZ_NAME+"</td></tr>"
				document.getElementById("div_city_county_info").innerHTML += "</table>"
			}*/
		}
		if(get_info_sales.recordcount)
		{
		
			// SATIŞ BÖLGESİNİN YÖNETİCİSİ SORUMLU KISMINA ATANIYOR
			get_info_manager=wrk_query("SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE="+get_info_sales.RESPONSIBLE_POSITION_CODE,"dsn");
			document.getElementById('resp_emp_id').value=get_info_manager.EMPLOYEE_ID;
			document.getElementById('responsible_person').value=get_info_manager.EMPLOYEE_NAME +' '+get_info_manager.EMPLOYEE_SURNAME;
		}
	}

	var x_is_related_tree_cat = '<cfoutput>#x_is_related_tree_cat#</cfoutput>';
	var x_is_mail_send_tree_list = '<cfoutput>#x_is_mail_send_tree_list#</cfoutput>';
	
	var tree_category_list = "";
	if(document.getElementById('old_app_rows').value != "")
		tree_category_list = document.getElementById('old_app_rows').value;
	
	//gorevli alt tree kategoriye bagli olsun secilirse tree_idlerini gondermek icin FS
	function rel_tree_cat(ssci)
	{
		<cfif isdefined('x_is_multiple_select') and x_is_multiple_select eq 0>
			
			if(document.getElementById('temp_service_sub_cat_id').value != '')
			{	
				myval = document.getElementById('service_sub_cat_id_'+ssci).value;
				var temp_sel = document.getElementById('temp_service_sub_cat_id').value;
				document.getElementById('service_sub_cat_id_'+temp_sel).value ="";
				document.getElementById('service_sub_cat_id_'+ssci).value = myval;		
			}
			
			if(ssci != undefined)
			document.getElementById('temp_service_sub_cat_id').value = parseInt(ssci);
			else
			document.getElementById('temp_service_sub_cat_id').value = '';	
			
		</cfif>
		tree_category_list = "";
		if(x_is_related_tree_cat == 1)
		{
			<cfif x_is_sub_tree_single_select neq 1>
				<cfoutput query="get_service_appcat" group="servicecat_id">
					<cfquery name="get_service_appcat_sub_ord" dbtype="query">
						SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_CAT,SERVICECAT_ID FROM GET_SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = #get_service_appcat.servicecat_id#
					</cfquery>
					<cfoutput>
						<cfloop query="GET_SERVICE_APPCAT_SUB_ORD">
							if(document.getElementById('service_sub_cat_id_#service_sub_cat_id#').value != "")
							{
								tree_category_list = tree_category_list  + (document.getElementById('service_sub_cat_id_#service_sub_cat_id#').value)+ ",";
							}
						</cfloop>
					</cfoutput>
				</cfoutput>
			<cfelse>
				if(document.getElementById('servicecat_sub_tree_id').value != "")
					tree_category_list = tree_category_list  + document.getElementById('servicecat_sub_tree_id').value + ",";
			</cfif>
		}
	}
	//gorevli linkini ve zorunlulugunu kontrol ediyor yukardaki fonksiyonla baglantili FS
	function tree_gonder()
	{
		 if(x_is_related_tree_cat == 0)
		{
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=add_service.task_person_name&field_emp_id=add_service.task_emp_id&select_list=1</cfoutput>&process_date='+document.add_service.start_date1.value+'&keyword='+encodeURIComponent(document.add_service.task_person_name.value),'list');		
		}
		else if(tree_category_list != "")
		{
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=add_service.task_person_name&field_emp_id=add_service.task_emp_id&select_list=1</cfoutput>&process_date='+document.add_service.start_date1.value+'&tree_category_id='+tree_category_list+'&keyword='+encodeURIComponent(document.add_service.task_person_name.value),'list');
		}
	}
	function tree_gonder1()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=add_service.responsible_person&field_emp_id=add_service.resp_emp_id&field_consumer=add_service.resp_cons_id&field_partner=add_service.resp_par_id&field_comp_id=add_service.resp_comp_id&select_list=1,7,8</cfoutput>&keyword='+encodeURIComponent(document.add_service.responsible_person.value),'list');
	}
	<cfif x_is_mail_send_tree_list eq 1 and x_is_sub_tree_single_select eq 0>
	//gonderi listesi alt tree kategoriden gelsin secilirse FS
		function send_tree_mail(x)
		{
			service_sub_status_id_ = list_getat(eval("document.getElementById('service_sub_cat_id_"+x+"')").value,1,',');
			if(service_sub_status_id_ == "")
			{
				alert("<cf_get_lang dictionary_id='49198.Alt Tree Kategory Seçmelisiniz '>!");
				return false;
			}
			else
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=call.popup_sub_status_people&service_sub_status_id='+service_sub_status_id_+'&branch_id='+add_service.service_branch_id.value,'medium');
		}
	</cfif>

	//kategori secimine gore alt kategorileri getirir
	function kategori_getir()
	{
		category_value = document.getElementById('appcat_id').value;
		<cfif x_is_sub_tree_single_select neq 1>
			if(category_value != '')
			{
				<cfoutput query="get_service_appcat">
					gizle(anakategori_#servicecat_id#);
				</cfoutput>
				goster(eval('anakategori_' + category_value));
			}
			else
			{
				<cfoutput query="get_service_appcat">
					gizle(anakategori_#servicecat_id#);
				</cfoutput>		
			}
		<cfelse>
			if(category_value != '')
			{
				<cfif x_is_related_upper_cat>
					var get_sub_category = wrk_safe_query('clcr_get_sub_category','dsn',0,category_value);
				<cfelse>
					var get_sub_category = wrk_safe_query('clcr_get_sub_category','dsn',0,'');
				</cfif>
				var option_count = document.getElementById('servicecat_sub_id').options.length; 
				for(x=option_count;x>=0;x--)
					document.getElementById('servicecat_sub_id').options[x] = null;
					document.getElementById('servicecat_sub_id').options[0] = new Option('Seçiniz','');
				for(sc=0;sc<get_sub_category.recordcount;sc++)
					document.getElementById('servicecat_sub_id').options[sc+1]=new Option(get_sub_category.SERVICE_SUB_CAT[sc],get_sub_category.SERVICE_SUB_CAT_ID[sc]);
			}
		</cfif>
	}
	//alt kategori secimine gore alt tree kategorileri getirir
	<cfif x_is_sub_tree_single_select eq 1>
	function sub_kategori_getir()
	{
		if(document.getElementById('servicecat_sub_id').value!= '')
		{
			<cfif x_is_related_upper_cat>
				var get_sub_tree_category = wrk_safe_query('clcr_get_sub_tree_category','dsn',0,document.getElementById('servicecat_sub_id').value);
			<cfelse>
				var get_sub_tree_category = wrk_safe_query('clcr_get_sub_tree_category','dsn',0,'');
			</cfif>
			var option_count_sub = document.getElementById('servicecat_sub_tree_id').options.length; 
				for(y=option_count_sub;y>=0;y--)
					document.getElementById('servicecat_sub_tree_id').options[y] = null;
					
			document.getElementById('servicecat_sub_tree_id').options[0] = new Option('Seçiniz','');
			for(stc=0;stc<get_sub_tree_category.recordcount;stc++)
				document.getElementById('servicecat_sub_tree_id').options[stc+1]=new Option(get_sub_tree_category.SERVICE_SUB_STATUS[stc],get_sub_tree_category.SERVICE_SUB_STATUS_ID[stc]);
		}
	}
	</cfif>
	function chk_form()
	{
		if(document.getElementById('process_stage').value == "")
		{
			alert("<cf_get_lang dictionary_id='57976.Lütfen Süreçlerinizi Tanımlayınız ve/veya Tanımlanan Süreçler Üzerinde Yetkiniz Yok'>!");
			return false;
		}
		if((document.getElementById('member_name').value=="") || (document.getElementById('employee_id').value=="" && document.getElementById('partner_id').value=="" && document.getElementById('consumer_id').value=="" && document.getElementById('company_id').value==""))
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29514.Başvuru Yapan'>!");
			return false;
		}	
		if(document.getElementById('priority_id').value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='49298.Öncelik Kategorisi'>");
			return false;
		}
		if(document.getElementById('appcat_id').value=="")
		{
			alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57486.Kategori'>");
			return false;
		}

        var service_detail = CKEDITOR.instances.service_detail.getData();
        var service_detail_= service_detail.replace(/<[^>]+>/g, '');
		if (service_detail_.length <= 10 )
		{ 
			alert ("<cf_get_lang dictionary_id='57425.uyarı'>:<cf_get_lang dictionary_id='57629.Açıklama'><cf_get_lang dictionary_id='49304.En Az 10 Karakter'>!");
			return false;
		}
		if (document.getElementById('start_date1') !=undefined && document.getElementById('start_date1').value !='' && document.getElementById('apply_date').value !='')
		{
			if (!time_check(document.getElementById('apply_date'),document.getElementById('apply_hour'), document.getElementById('apply_minute'),document.getElementById('start_date1'),document.getElementById('start_hour'),document.getElementById('start_minute'),"<cf_get_lang dictionary_id='49301.Başvuru Tarihi Kabul Tarihinden Önce Olmalıdır'>!"))
			return false;
		}
		//document.getElementById('apply_hour').disabled = false;
		//document.getElementById('apply_minute').disabled = false;
		
		return process_cat_control();
	}
	function return_member_code()
	{
		var consumer_id=document.getElementById('consumer_id').value;
		if(consumer_id!='')
		{
			get_consumer=wrk_safe_query('clcr_get_consumer','dsn',0,consumer_id);;
			document.getElementById('member_company').value=get_consumer.MEMBER_CODE;
		}
		else
			return false;
	}
	document.getElementById('member_company').focus();
</script>
