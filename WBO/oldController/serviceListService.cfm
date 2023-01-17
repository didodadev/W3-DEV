<cf_get_lang_set module_name="service">
<cfinclude template="../service/query/get_priority.cfm">
<cfinclude template="../service/query/get_branch.cfm">
<cfset paper_num = ''>
<cfquery name="GET_ACCESSORY" datasource="#DSN3#">
    SELECT ACCESSORY_ID,ACCESSORY FROM SERVICE_ACCESSORY
</cfquery>
<cfquery name="GET_PHY_DAM" datasource="#DSN3#">
    SELECT PHYSICAL_DAMAGE_ID,PHYSICAL_DAMAGE FROM SERVICE_PHYSICAL_DAMAGE
</cfquery>
<cfquery name="GET_SERVICE_APPCAT" datasource="#DSN3#">
    SELECT SERVICECAT,SERVICECAT_ID FROM SERVICE_APPCAT ORDER BY SERVICECAT
</cfquery>
<cfquery name="get_sale_zones" datasource="#dsn#">
    SELECT SZ_ID,SZ_NAME FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
</cfquery>
<cfquery name="GET_SERVICE_ADD_OPTION" datasource="#DSN3#">
    SELECT SERVICE_ADD_OPTION_ID,SERVICE_ADD_OPTION_NAME FROM SETUP_SERVICE_ADD_OPTIONS
</cfquery>
<cfquery name="GET_CITY" datasource="#DSN#">
    SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID,PLATE_CODE FROM SETUP_CITY ORDER BY PRIORITY,CITY_NAME
</cfquery>
<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list')>
	<cfset action_date = ''>
	<cf_xml_page_edit fuseact="service.list_service">
    <cfset list_subid="">
    <cfparam name="attributes.task_par_id" default="">
    <cfparam name="attributes.task_cmp_id" default="">
    <cfparam name="attributes.task_employee_id" default="">
    <cfparam name="attributes.task_person_name" default="">
    <cfparam name="attributes.service_add_option" default="">
    <cfparam name="attributes.adress_keyword" default="">
    <cfparam name="attributes.adress_keyword" default="">
    <cfparam name="attributes.related_company_id" default="">
    <cfparam name="attributes.related_company" default="">
    <cfparam name="attributes.brand_name" default="">
    <cfparam name="attributes.brand_id" default="">
    <cfparam name="attributes.product_cat" default="">
    <cfparam name="attributes.product_cat_id" default="">
    <cfparam name="attributes.service_substatus_id" default="">
    <cfparam name="attributes.start_date2" default="">
    <cfparam name="attributes.finish_date2" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.record_emp_id" default="">
    <cfparam name="attributes.record_emp_name" default="">
    <cfparam name="attributes.service_status" default="1">
    <cfparam name="attributes.accessory" default="">
    <cfparam name="attributes.accessory_select" default="">
    <cfparam name="attributes.physical" default="">
    <cfparam name="attributes.physical_select" default="">
    <cfparam name="attributes.sales_zone_id" default="">
    <cfif isdefined("session.service_reply")>
		<cfscript>structdelete(session,"service_reply");</cfscript>
	</cfif>
	<cfif isdefined("session.service_task")>
		<cfscript>structdelete(session,"service_task");</cfscript>	
	</cfif>
    <cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR WITH (NOLOCK),
            PROCESS_TYPE_OUR_COMPANY PTO WITH (NOLOCK),
            PROCESS_TYPE PT WITH (NOLOCK)
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%service.list_service%">
        ORDER BY 
            PTR.LINE_NUMBER
    </cfquery> 
    <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
        <cf_date tarih = "attributes.start_date">
    <cfelse>
        <cfset attributes.start_date = "">
    </cfif>
    <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
        <cf_date tarih = "attributes.finish_date">
    <cfelse>
        <cfset attributes.finish_date = "">
    </cfif>
    <cfif isdefined("attributes.start_date1") and isdate(attributes.start_date1)>
        <cf_date tarih = "attributes.start_date1">
    <cfelse>
        <cfset attributes.start_date1 = "">
    </cfif>
    <cfif isdefined("attributes.finish_date1") and isdate(attributes.finish_date1)>
        <cf_date tarih = "attributes.finish_date1">
    <cfelse>
        <cfset attributes.finish_date1 = "">
    </cfif>
    <cfif isdefined("attributes.start_date2") and isdate(attributes.start_date2)>
        <cf_date tarih = "attributes.start_date2">
    <cfelse>
        <cfset attributes.start_date2 = "">
    </cfif>
    <cfif isdefined("attributes.finish_date2") and isdate(attributes.finish_date2)>
        <cf_date tarih = "attributes.finish_date2">
    <cfelse>
        <cfset attributes.finish_date2 = "">
    </cfif>      
        <cfset branch_list = valuelist(get_branch.branch_id)>
    
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    
    <cfif isdefined("attributes.form_submitted")>
        <cfinclude template="../service/query/get_service.cfm">
    <cfelse>
        <cfset get_service.recordcount = 0>	
        <cfset get_service.QUERY_COUNT = 0>
    </cfif>
    
    <cfparam name="attributes.keyword" default=''>
    <cfparam name="attributes.keyword_no" default=''>
    <cfparam name="attributes.keyword_detail" default=''>
    <cfparam name="attributes.serial_no" default="">
    <cfparam name="attributes.doc_number" default="">
    <cfparam name="attributes.totalrecords" default="#get_service.QUERY_COUNT#">
    <cfquery name="GET_PRIORITIES" datasource="#DSN#">
        SELECT PRIORITY_ID, PRIORITY FROM SETUP_PRIORITY ORDER BY PRIORITY_ID
    </cfquery>  
    
	<cfif isdefined("attributes.service_county_id") and len(attributes.service_county_id) and len(attributes.service_county_name)>
        <cfquery name="GET_COUNTY" datasource="#DSN#">
        SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_county_id#">
            </cfquery>
        <cfset county_ = get_county.county_name>
    <cfelse>
        <cfset county_ = "">
    </cfif>
<cfelseif IsDefined("attributes.event") and ListFindNoCase('add,upd,det',attributes.event)>
	<cf_xml_page_edit fuseact="service.add_service">
	<cfif x_is_show_service_workgroups eq 1>
        <cfquery name="GET_WORKGROUPS" datasource="#DSN#">
            SELECT 
                WORKGROUP_ID,
                WORKGROUP_NAME
            FROM 
                WORK_GROUP
            WHERE
                STATUS = 1
                AND HIERARCHY IS NOT NULL  AND
                ONLINE_HELP = 1
            ORDER BY 
                HIERARCHY
        </cfquery>
    </cfif>   
	<cfinclude template="../service/query/get_com_method.cfm">		
	<cfif IsDefined("attributes.event") and attributes.event is 'add'>
		<cfif isdefined("attributes.subscrt_id")>
        <cfquery name="GET_SUBSCRIPT_CONRACT" datasource="#DSN3#">
            SELECT SUBSCRIPTION_ADD_OPTION_ID,PROJECT_ID,PRODUCT_ID,STOCK_ID,SUBSCRIPTION_HEAD,SALES_PARTNER_ID,SALES_COMPANY_ID,SALES_CONSUMER_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscrt_id#">
        </cfquery>
    </cfif>
		<cfquery name="GET_SERVICE_CODE" datasource="#DSN3#">
        SELECT 
            SERVICE_CODE_ID,
            SERVICE_CODE 
        FROM 
            SETUP_SERVICE_CODE
        ORDER BY
            SERVICE_CODE
    </cfquery>
    	<cfif isdefined("attributes.service_id") AND len(attributes.service_id)>
        <cfquery name="GET_SERVICE_DETAIL" datasource="#DSN3#">
            SELECT 
                SERVICE_COMPANY_ID, 
                SERVICE_PARTNER_ID, 
                SERVICECAT_ID, 
                SERVICE_DETAIL, 
                SERVICE_ADDRESS, 
                DOC_NO, 
                PROJECT_ID, 
                COMMETHOD_ID, 
                SERVICE_PRODUCT_ID, 
                PRODUCT_NAME,
                SERVICE_SUBSTATUS_ID,
                PRIORITY_ID,
                SALE_ADD_OPTION_ID,
                ACCESSORY,
                GUARANTY_INSIDE,
                GUARANTY_START_DATE,
                BRING_NAME,
                APPLICATOR_COMP_NAME,
                BRING_TEL_NO,
                BRING_EMAIL,
                SHIP_METHOD,
                STOCK_ID,
                ACCESSORY_DETAIL,
                INSIDE_DETAIL ,
                SERVICECAT_SUB_ID,
                SERVICECAT_SUB_STATUS_ID,
                WORKGROUP_ID,
                SERVICE_CONSUMER_ID,
                BRING_SHIP_METHOD_ID,
                SPEC_MAIN_ID
            FROM 
                SERVICE 
            WHERE 
                SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
        </cfquery>
        <cfif len(get_service_detail.service_company_id)>
            <cfset attributes.company_id = get_service_detail.service_company_id>
            <cfset attributes.member_id = get_service_detail.service_partner_id>
            <cfset attributes.member_type = 'partner'>
        <cfelseif len(get_service_detail.service_consumer_id)>
            <cfset attributes.member_id = get_service_detail.service_consumer_id>
            <cfset attributes.member_type = 'consumer'>
        </cfif>
        <cfset attributes.appcat_id = get_service_detail.servicecat_id>
        <cfset attributes.appcat_sub_id = get_service_detail.SERVICECAT_SUB_ID>
        <cfset attributes.appcat_sub_status_id = get_service_detail.SERVICECAT_SUB_STATUS_ID>
        <cfset attributes.service_head = ''>
        <cfset attributes.service_detail = get_service_detail.service_detail>
        <cfset attributes.service_address = get_service_detail.service_address>
        <cfset attributes.kabul_belge_no = get_service_detail.doc_no>
        <cfset attributes.project_id = get_service_detail.project_id>
        <cfset attributes.commethod_id = get_service_detail.commethod_id>
    <cfelseif isdefined('attributes.cus_help_id') and len(attributes.cus_help_id)>
        <cfquery name="GET_HELP_" datasource="#DSN#">
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
                CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#">
        </cfquery>
        <cfif len(get_help_.company_id)>
            <cfset attributes.company_id = get_help_.company_id>
            <cfset attributes.member_id = get_help_.partner_id>
            <cfset attributes.member_type = 'partner'>
        <cfelseif len(get_help_.consumer_id)>
            <cfset attributes.member_id = get_help_.consumer_id>
            <cfset attributes.member_type = 'consumer'>
        </cfif>
        <cfset attributes.subscription_id = get_help_.subscription_id>
        <cfset attributes.service_detail = get_help_.subject>
        <cfset attributes.commethod_id = get_help_.app_cat>
        <cfif len(get_help_.company_id)>
            <cfinclude template="../query/get_company_.cfm">
            <cfset attributes.service_city_id = get_company_.city>
            <cfset attributes.service_county_id = get_company_.county>
            <cfset attributes.bring_tel_no = get_company_.COMPANY_TELCODE&''&get_company_.COMPANY_TEL1>
            <cfset attributes.bring_mobile_no = get_company_.MOBIL_CODE&''&get_company_.MOBILTEL>
            <cfset attributes.service_address = get_company_.COMPANY_ADDRESS&' '&get_company_.COMPANY_POSTCODE&' '&get_company_.SEMT&' '&get_company.COUNTY_NAME&' '&get_company_.city_name&' '&get_company_.COUNTRY_NAME>
            <cfset attributes.bring_email = get_company_.COMPANY_PARTNER_EMAIL>
            <cfset attributes.applicator_comp_name = get_company_.FULLNAME>
        <cfelseif len(get_help_.consumer_id)>
            <cfinclude template="../query/get_consumer_.cfm">
            <cfset attributes.service_city_id = get_consumer_.WORK_CITY_ID>
            <cfset attributes.service_county_id = get_consumer_.WORK_COUNTY_ID>
            <cfset attributes.bring_tel_no = get_consumer_.CONSUMER_WORKTELCODE&''&get_consumer_.CONSUMER_WORKTEL>
            <cfset attributes.bring_mobile_no = get_consumer_.MOBIL_CODE&''&get_consumer_.MOBILTEL>
            <cfset attributes.service_address = get_consumer_.WORKADDRESS&' '&get_consumer_.WORKPOSTCODE&' '&get_consumer_.WORKSEMT&' '&get_consumer_.COUNTY_NAME&' '&get_consumer_.city_name&' '&get_consumer_.COUNTRY_NAME>
            <cfset attributes.bring_email = get_consumer_.CONSUMER_EMAIL>
            <cfset attributes.applicator_comp_name = get_consumer_.FULLNAME>
        </cfif>
        <cfif len(attributes.subscription_id)>
            <cfquery name="GET_SUB_NO" datasource="#dsn3#">
                SELECT SUBSCRIPTION_NO,PROJECT_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
            </cfquery>
            <cfset attributes.subscription_no = get_sub_no.subscription_no>
            <cfset attributes.project_id = get_sub_no.project_id>
        </cfif>
    <cfelseif isdefined("attributes.event_id") and len(attributes.event_id)>
        <cfquery name="GET_EVENT" datasource="#DSN#">
            SELECT
                PROJECT_ID,
                STARTDATE,
                EVENT_HEAD
            FROM
                EVENT
            WHERE
                EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
        </cfquery>
        <cfset attributes.service_head = get_event.event_head>
        <cfif len(get_event.project_id)>
            <cfset attributes.project_id = get_event.project_id>
            <cfquery name="GET_PROJECT_INFO" datasource="#DSN#">
                SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
            </cfquery>
            <cfif len(get_project_info.partner_id)>
                <cfset attributes.company_id = get_project_info.company_id>
                <cfset attributes.member_id = get_project_info.partner_id>
                <cfset attributes.member_type = 'partner'>
                <cfinclude template="../query/get_company_.cfm">
                <cfset attributes.service_city_id = get_company_.city>
                <cfset attributes.service_county_id = get_company_.county>
                <cfset attributes.bring_tel_no = get_company_.COMPANY_TELCODE&''&get_company_.COMPANY_TEL1>
                <cfset attributes.bring_mobile_no = get_company_.MOBIL_CODE&''&get_company_.MOBILTEL>
                <cfset attributes.service_address = get_company_.COMPANY_ADDRESS&' '&get_company_.COMPANY_POSTCODE&' '&get_company_.SEMT&' '&get_company_.COUNTY_NAME&' '&get_company_.city_name&' '&get_company_.COUNTRY_NAME>
                <cfset attributes.bring_email = get_company_.COMPANY_PARTNER_EMAIL>
                <cfset attributes.applicator_comp_name = get_company_.FULLNAME>
            <cfelseif len(get_project_info.consumer_id)>
                <cfset attributes.member_id = get_project_info.consumer_id>
                <cfset attributes.member_type = 'consumer'>
                <cfinclude template="../query/get_consumer_.cfm">
                <cfset attributes.service_city_id = get_consumer_.WORK_CITY_ID>
                <cfset attributes.service_county_id = get_consumer_.WORK_COUNTY_ID>
                <cfset attributes.bring_tel_no = get_consumer_.CONSUMER_WORKTELCODE&''&get_consumer_.CONSUMER_WORKTEL>
                <cfset attributes.bring_mobile_no = get_consumer_.MOBIL_CODE&''&get_consumer_.MOBILTEL>
                <cfset attributes.service_address = get_consumer_.WORKADDRESS&' '&get_consumer_.WORKPOSTCODE&' '&get_consumer_.WORKSEMT&' '&get_consumer_.COUNTY_NAME&' '&get_consumer_.city_name&' '&get_consumer_.COUNTRY_NAME>
                <cfset attributes.bring_email = get_consumer_.CONSUMER_EMAIL>
                <cfset attributes.applicator_comp_name = get_consumer_.FULLNAME>
            </cfif>
        </cfif>
    <cfelseif isdefined("attributes.call_service_id") and len(attributes.call_service_id)>
        <cfquery name="get_call_service" datasource="#dsn#">
            SELECT 
                ISNULL(ISNULL(E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME,C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME),CP.COMPANY_PARTNER_NAME+' '+CP.COMPANY_PARTNER_SURNAME) NAME,            
                G.SERVICE_COMPANY_ID,
                G.PROJECT_ID,
                G.SUBSCRIPTION_ID,
                CM.FULLNAME,
                G.COMMETHOD_ID,
                G.SERVICE_DETAIL,
                G.APPLY_DATE,
                G.SERVICE_CONSUMER_ID,
                G.SERVICE_PARTNER_ID,
                (SELECT SERVICE_SUB_STATUS FROM G_SERVICE_APPCAT_SUB_STATUS GSA WHERE GS.SERVICE_SUB_STATUS_ID=GSA.SERVICE_SUB_STATUS_ID) SERVICE_SUB_STATUS,
                CASE 
                    WHEN   G.SERVICE_PARTNER_ID IS NOT NULL THEN  CM.SALES_COUNTY 
                    WHEN  G.SERVICE_CONSUMER_ID IS NOT NULL THEN  CM.SALES_COUNTY
                END  SZ_ID
            FROM 
                G_SERVICE G
                LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID=G.SERVICE_EMPLOYEE_ID
                LEFT JOIN CONSUMER C ON C.CONSUMER_ID=G.SERVICE_CONSUMER_ID
                LEFT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID=G.SERVICE_PARTNER_ID
                LEFT JOIN COMPANY CM ON CM.COMPANY_ID=G.SERVICE_COMPANY_ID
                LEFT JOIN G_SERVICE_APP_ROWS GS ON GS.SERVICE_ID=G.SERVICE_ID
            WHERE 
                G.SERVICE_ID=#attributes.call_service_id#
         </cfquery>
         
        <cfif get_call_service.recordcount>
            <cfset attributes.company_id=get_call_service.service_company_id>
            <cfset attributes.company_name=get_call_service.fullname>
            <cfif len(get_call_service.service_consumer_id)>
                <cfset attributes.member_type='consumer'>
                <cfset attributes.member_id=get_call_service.service_consumer_id>
            <cfelseif len(get_call_service.service_partner_id)>
                <cfset attributes.member_type='partner'>
                <cfset attributes.member_id=get_call_service.service_partner_id>
            </cfif>
            <cfset attributes.service_detail=get_call_service.service_detail>
            <cfset attributes.commethod_id=get_call_service.commethod_id>
            <cfset attributes.service_head=get_call_service.service_sub_status>
            <cfset attributes.sales_zone_id=get_call_service.sz_id>
            <cfset attributes.project_id=get_call_service.PROJECT_ID>
            <cfset attributes.subscription_id=get_call_service.subscription_id>
            <cfset attributes.start_date1=now()>
         </cfif>
        <cfif len(get_call_service.subscription_id)>
            <cfset attributes.subscription_id = get_call_service.subscription_id>					 	
            <cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
                SELECT 
                    SUBSCRIPTION_ID,
                    SUBSCRIPTION_NO 
                FROM 
                    SUBSCRIPTION_CONTRACT 
                WHERE 
                    SUBSCRIPTION_ID IS NOT NULL 
                    AND SUBSCRIPTION_ID = #attributes.subscription_id#
            </cfquery>
            <cfset attributes.subscription_no = GET_SUBSCRIPTION.SUBSCRIPTION_NO>
            <cfquery name="GET_SUBSCRIPTION_ADDRES_INFO" datasource="#DSN3#">
                SELECT
                    INVOICE_ADDRESS,
                    INVOICE_COUNTY_ID,
                    INVOICE_CITY_ID
                FROM
                    SUBSCRIPTION_CONTRACT
                WHERE
                    SUBSCRIPTION_NO = '#GET_SUBSCRIPTION.SUBSCRIPTION_NO#'
            </cfquery>
            <cfset attributes.service_address = GET_SUBSCRIPTION_ADDRES_INFO.INVOICE_ADDRESS>
            <cfset attributes.service_city_id = GET_SUBSCRIPTION_ADDRES_INFO.INVOICE_CITY_ID>
            <cfset attributes.service_county_id = GET_SUBSCRIPTION_ADDRES_INFO.INVOICE_COUNTY_ID>
        </cfif>
    </cfif>
    	<cfif isdefined("get_service_detail.other_company_branch_id")>
		<cfif len(get_service_detail.other_company_branch_id) and get_service_detail.other_company_branch_id eq -1>
            <cfset other_company_branch_name_ = 'Merkez'>
        <cfelseif len(get_service_detail.other_company_branch_id)>
            <cfquery name="GET_B_NAME" datasource="#DSN#">
                SELECT COMPBRANCH__NAME FROM COMPANY_BRANCH WHERE COMPBRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.other_company_branch_id#">
            </cfquery>
            <cfset other_company_branch_name_ = '#get_b_name.compbranch__name#'>
        <cfelse>
            <cfset other_company_branch_name_ = ''>
        </cfif>
	</cfif>  
    	<cfif x_is_multiple_category_select eq 1>  
		<cfif isdefined("get_service_detail.servicecat_id") and len(get_service_detail.servicecat_id)>
            <cfquery name="get_service_sub_appcat" datasource="#dsn3#">
                 SELECT SERVICECAT_SUB_ID,SERVICECAT_SUB FROM SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = #get_service_detail.servicecat_id# ORDER BY SERVICECAT_SUB ASC
            </cfquery>
        </cfif> 
	</cfif>
    	<cfif session.ep.our_company_info.guaranty_followup eq 1>
		<cfif isdefined("get_service_detail.spec_main_id") and len(get_service_detail.spec_main_id)>
            <cfquery name="GET_SPEC_NAME" datasource="#DSN3#">
                SELECT SPECT_MAIN_ID, SPECT_MAIN_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.spec_main_id#">
            </cfquery>
            <cfset spec_name_ = get_spec_name.SPECT_MAIN_NAME>
        <cfelse>
            <cfset spec_name_ = "">
        </cfif> 
	</cfif>
    	<cfif x_activity_time eq 1>
		<!--- MT:aktivite tipi ve süre alanları eklenmiştir.Bu alanlarda dahil olmak üzere başvuru kaydedildiğinde zaman harcamasına kayıt atılıyor.--->
        <cfquery name="get_activity" datasource="#dsn#">
            SELECT ACTIVITY_ID,ACTIVITY_NAME FROM SETUP_ACTIVITY WHERE ACTIVITY_STATUS = 1 ORDER BY ACTIVITY_NAME
        </cfquery>
	</cfif>
    	<cfif (isdefined("get_service_detail.service_county_id") and len(get_service_detail.service_county_id)) or (isdefined("attributes.service_county_id") and len(attributes.service_county_id))>
		<cfif isdefined("get_service_detail.service_county_id") and len(get_service_detail.service_county_id)>
            <cfset county_id_ = get_service_detail.service_county_id>
        <cfelseif isdefined("attributes.service_county_id") and len(attributes.service_county_id)>
            <cfset county_id_ = attributes.service_county_id>
        </cfif>
        <cfquery name="GET_COUNTY" datasource="#DSN#">
            SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#county_id_#">
        </cfquery>
        <cfset county_ = get_county.county_name> 
	</cfif>
    <cfset action_date = now()>
    </cfif>
    <cfinclude template="../service/query/get_service_substatus.cfm">
	<cfif IsDefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'det')>
		<cfset attributes.id = attributes.service_id>
		<cfset url.id = attributes.service_id>
		<cfparam name="attributes.sales_add_option" default=""> 
        <cfif isdefined('attributes.id') and len(attributes.id)>
            <cfinclude template="../service/query/get_service_detail.cfm">
        <cfelse>
            <cfset get_service_detail.recordcount = 0>
		</cfif> 
        <cfif not isnumeric(attributes.id) or get_service_detail.recordcount eq 0>
			<cfset hata  = 10>
			<cfinclude template="../dsp_hata.cfm">
    	</cfif>
        <cfquery name="GET_SERVICE_USING_CODE" datasource="#DSN3#">
            SELECT
                SETUP_SERVICE_CODE.SERVICE_CODE_ID,
                SETUP_SERVICE_CODE.SERVICE_CODE
            FROM 
                SERVICE_CODE_ROWS,
                SETUP_SERVICE_CODE
            WHERE 
                SERVICE_CODE_ROWS.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#"> AND
                SERVICE_CODE_ROWS.SERVICE_CODE_ID = SETUP_SERVICE_CODE.SERVICE_CODE_ID
        </cfquery>
        <cfset our_get_service_using_code=valuelist(get_service_using_code.service_code_id)>
        <cfset service_id = get_service_detail.service_id>
        <cfscript>
            attributes.company_id=get_service_detail.service_company_id;
            attributes.partner_id=get_service_detail.service_partner_id;
            attributes.consumer_id=get_service_detail.service_consumer_id;
            attributes.employee_id = get_service_detail.service_employee_id;
        </cfscript>
        <cfscript>
            stock_id = get_service_detail.stock_id;
            pro_serial_no = get_service_detail.pro_serial_no;
            page_no = get_service_detail.guaranty_page_no;
        </cfscript>
        <cfif len(stock_id) and len(pro_serial_no)>
            <cfinclude template="../service/query/get_pro_guaranty.cfm">
        </cfif> 
		<cfif session.ep.our_company_info.sms eq 1>
            <cfif len(get_service_detail.service_partner_id)>
                <cfset member_type='partner'>
                <cfset member_id=get_service_detail.service_partner_id>
            <cfelseif len(get_service_detail.service_company_id)>
                <cfset member_type='company'>
                <cfset member_id=get_service_detail.service_company_id>
            <cfelseif len(get_service_detail.service_consumer_id)>
                <cfset member_type='consumer'>
                <cfset member_id=get_service_detail.service_consumer_id>
            <cfelseif len(get_service_detail.service_employee_id)>
                <cfset member_type='employee'>
                <cfset member_id=get_service_detail.service_employee_id>
            </cfif>
        </cfif> 
         <cfif len(get_service_detail.subscription_id)>
			<cfset attributes.subscription_id = get_service_detail.subscription_id>					 	
            <cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
                SELECT SUBSCRIPTION_ID,SUBSCRIPTION_NO,SUBSCRIPTION_HEAD FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID IS NOT NULL AND SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
            </cfquery>
        <cfelse>
        	<cfset attributes.subscription_id = ''>					 	
        </cfif>
        <cfset paper_num = get_service_detail.SERVICE_HEAD>
        <cfset action_date = get_service_detail.action_date>
			<cfif len(get_service_detail.service_partner_id)>
                <cfset member_id=get_service_detail.service_partner_id>
            <cfelseif len(get_service_detail.service_company_id)>
                <cfset member_id=get_service_detail.service_company_id>
            <cfelseif len(get_service_detail.service_consumer_id)>
                <cfset member_id=get_service_detail.service_consumer_id>
            <cfelseif len(get_service_detail.service_employee_id)>
                <cfset member_id=get_service_detail.service_employee_id>
            <cfelse>
                <cfset member_id="">                
            </cfif>
		<cfset adres_ = "#request.self#?fuseaction=objects.popup_add_pursuits_documents_plus&action_id=#attributes.id#&header=service.service_head&contact_person=#get_service_detail.applicator_name#">
        <cfif len(get_service_detail.service_consumer_id)>
            <cfset adres_ = adres_ & "&consumer_id=#get_service_detail.service_consumer_id#">
        <cfelseif len(get_service_detail.service_partner_id)>
            <cfset adres_ = adres_ & "&partner_id=#get_service_detail.service_partner_id#">
        </cfif>
        <cfquery name="GET_OUR_COMP_INFO" datasource="#DSN#">
            SELECT IS_GUARANTY_FOLLOWUP FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        </cfquery>
    </cfif>
</cfif>
<script type="text/javascript">
<cfif not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'list')>
	$( document ).ready(function() 
	{
    	document.getElementById('keyword').focus();
	});	
	function send_services_print()
	{
		<cfif not get_service.recordcount>
			alertObject({message: '<cf_get_lang no='46.Yazdırılacak Servis Bulunamadı! Toplu Print Yapamazsınız!'>'});
			return false;
		</cfif>
		<cfif get_service.recordcount eq 1>
			if(document.send_print.service_id_list.checked == false)
				{
				alertObject({message: '<cf_get_lang no='46.Yazdırılacak Servis Bulunamadı! Toplu Print Yapamazsınız!'>'});
				return false;
				}
			else
				{
				service_list_ = document.send_print.service_id_list.value;
				}
		</cfif>
		<cfif get_service.recordcount gt 1>
			service_list_ = "";
			for (i=0; i < document.send_print.service_id_list.length; i++)
			{
				if(document.send_print.service_id_list[i].checked == true)
					{
					service_list_ = service_list_ + document.send_print.service_id_list[i].value + ',';
					}	
			}
			if(service_list_.length == 0)
				{
				alertObject({message: '<cf_get_lang no='46.Yazdırılacak Servis Bulunamadı! Toplu Print Yapamazsınız!'>'});
				return false;
				}
		</cfif>
		
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_print_files&print_type=51&iid='+service_list_,'page');
	}
	function return_company()
	{
		var emp_id=document.getElementById('task_employee_id').value;
		var GET_COMPANY=wrk_safe_query('srv_get_cmpny','dsn',0,emp_id);
		document.getElementById('task_cmp_id').value=GET_COMPANY.COMP_ID;
	}
	function alan_kontrol()
	{
		document.service.partner_id_.value='';
		document.service.consumer_id_.value='';
	}
	function kontrol()
	{
		var formName = 'service',  
		form  = $('form[name="'+ formName +'"]');
		if (form.find('input#start_date').val() != '' && form.find('input#finish_date').val() != ''){ 
			if(datediff(form.find('input#finish_date').val(),form.find('input#start_date').val() ,0)<0){
					validateMessage('notValid',form.find('input#start_date')); 
					return false;
			}else    {
					  validateMessage('valid',form.find('input#start_date') ); 
					 } 
		}

	}
<cfelseif IsDefined("attributes.event") and ListFindNoCase('add,upd',attributes.event)>
	function fill_saleszone(member_id,type)
	{
		<cfif IsDefined("attributes.event") and attributes.event is 'add'>
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
		</cfif>	
				url_= '/V16/service/cfc/service.cfc?method=get_country_func';
					$.ajax({
						type: "get",
						url: url_,
						data: {member_id: member_id,type:type},
						cache: false,
						async: false,
						success: function(read_data){
							data_ = jQuery.parseJSON(read_data.replace('//',''));
							if(data_.DATA.length!='')
							{
								$.each(data_.DATA,function(i){
									document.getElementById('sales_zone_id').value=data_.DATA[i][0];
								});
							}
						}
					});	
	}	
	function showAltKategori()	
	{
		var appcat_id_ = document.getElementById('appcat_id').value;
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=service.get_app_sub_cat_ajax&appcat_id="+appcat_id_;
		AjaxPageLoad(send_address,'sub_cat_place',1,'İlişkili Kategoriler');
	}
	function showAltTreeKategori()	
	{
		var appcat_sub_id_ = document.getElementById('appcat_sub_id').value;
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=service.get_app_sub_cat_ajax&appcat_sub_id="+appcat_sub_id_;
		AjaxPageLoad(send_address,'sub_cat_tree_place',1,'İlişkili Kategoriler');
	}
	function serino_control()
	{	
		if(document.service.service_product_serial.value.length==0)
		{
			alertObject({message: '<cf_get_lang no ='233.Lütfen Seri No Giriniz'> !'});
		}
		<cfif IsDefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'det')>
			else
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.serial_no&event=det&company_send_form=service&product_serial_no='+service.service_product_serial.value,'list');
			}
		<cfelseif IsDefined("attributes.event") and attributes.event is 'add'>	
			else
				{serino_search();}
		</cfif>	
	}
	function main_serino_control()
	{	
		if(document.service.main_serial_no.value.length==0)
		{
			alertObject({message: '<cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang no="273.Ana Seri No"> !'});
		}
		<cfif IsDefined("attributes.event") and attributes.event is 'add'>
			else
			{main_serino_search();}
		<cfelseif IsDefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'det')>
			else
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.serial_no&event=det&company_send_form=service&product_serial_no='+service.service_product_serial.value,'list');
			}
		</cfif>	
	}
	function serino_search()
	{
		if(document.service.service_product_serial.value.length>0)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.serial_no&event=det&company_send_form=service&product_serial_no='+service.service_product_serial.value,'list');
		}
	}
	function main_serino_search()
	{
		if(document.service.main_serial_no.value.length>0)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.serial_no&event=det&product_serial_no='+service.main_serial_no.value,'list');
		}
	}
	function add_adress(type)
	{
		if(!(service.company_id.value=="") || !(service.member_id.value==""))
		{
			if(type == 1)
				{
				str_adrlink = '&field_long_adres=service.service_address';
				str_adrlink = str_adrlink+'&field_city=service.service_city_id';
				str_adrlink = str_adrlink+'&field_county=service.service_county_id';
				str_adrlink = str_adrlink+'&field_county_name=service.service_county_name';
				<cfif is_county_related_company>
					str_adrlink = str_adrlink+'&is_county_related_company=1';
					str_adrlink = str_adrlink+'&related_company_id=service.related_company_id';
					str_adrlink = str_adrlink+'&related_company=service.related_company';
				</cfif>
				}
			else
				str_adrlink = '&field_long_adres=service.bring_detail';
			
			if(service.company_id.value!="")
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(service.company_name.value)+''+ str_adrlink , 'list');
				return true;
			}
			else
			{
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(service.member_name.value)+''+ str_adrlink , 'list');
				return true;
			}
		}
		else
		{
			alertObject({message: '<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no ='45.Müşteri'> !'});
			return false;
		}
	}
	function add_adress_other()
	{
		if(!(service.other_company_id.value==""))
		{
			str_adrlink = '&field_id=service.other_company_branch_company_id';
			str_adrlink = str_adrlink + '&company_branch_id=service.other_company_branch_id';
			str_adrlink = str_adrlink + '&company_branch_name=service.other_company_branch_name';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(service.other_company_name.value)+''+ str_adrlink , 'list');
		}
		else
		{
			alertObject({message: '<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no ='5.İlgili Bayi'> !'});
			return false;
		}
	}
	function product_control()
	{/*Ürün seçmeden spec seçemesin.*/
		if(document.getElementById('stock_id').value=="" || document.getElementById('service_product').value == "" )
		{
			alertObject({message: '<cf_get_lang no='34.Spec Seçmek için öncelikle ürün seçmeniz gerekmektedir'> !'});
			return false;
		}
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=service.spec_main_id&field_name=service.spect_name&is_display=1&stock_id='+document.getElementById('stock_id').value,'list');
	}
	<cfif IsDefined("attributes.event") and attributes.event is 'add'>		
		function chk_form()
		{
			if(document.service.other_company_id.value!="" && document.service.other_company_name.value!="")
				{
				if(document.service.other_company_branch_company_id.value!="" && document.service.other_company_branch_id.value!="" && document.service.other_company_branch_name.value!="")
					{
					if(document.service.other_company_id.value != document.service.other_company_branch_company_id.value)
						{
						alertObject({message: '<cf_get_lang no='15.İlgili Bayi İle İlgili Bayi Şubesi Uyuşmuyor'>!'});
						return false;
						}
					}
				}
			//select_add('inside_detail_select');
			//select_add('accessory_detail_select');
			return process_cat_control();
		}
		function return_company()
		{
			
			 var emp_id=document.getElementById('task_emp_id').value;
			 if(emp_id!='')
			 {
				 var GET_COMPANY=wrk_safe_query('srv_get_cmpny','dsn',0,emp_id);
				 document.getElementById('task_company_id').value=GET_COMPANY.COMP_ID;
			 }
			else
			return false;
		}
		function select_all(selected_field)
		{
			var m = document.getElementById(selected_field).options.length;
			for(i=0;i<m;i++)
			{
				document.getElementById(selected_field)[i].selected=true
			}
		}	
		//$( document ).ready(function() {
//			<cfif session.ep.our_company_info.guaranty_followup eq 1><!--- silinmesin musterilerde hizli kayitta seri no alani focus isteniyor --->
//				document.getElementById('service_product_serial').focus();
//			</cfif>	
//		});
	</cfif>	
	<cfif IsDefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'det')>
		function chk_form()
		{
			<cfif session.ep.our_company_info.guaranty_followup eq 1>
			if ((document.service.service_product_id.value != "") && (document.service.is_check_product_serial_number.value == 1) && (document.service.service_product_serial.value == ""))
			{
				alertObject({message: '<cf_get_lang no ='232.Ürün İçin Seri No Takibi Yapılıyor'>!<cf_get_lang no ='233.Lütfen Seri No Giriniz'> !'});
				return false;
			}
			</cfif>
		
			if(document.service.other_company_id.value!="" && document.service.other_company_name.value!="")
				{
				if(document.service.other_company_branch_company_id.value!="" && document.service.other_company_branch_id.value!="" && document.service.other_company_branch_name.value!="")
					{
					if(document.service.other_company_id.value != document.service.other_company_branch_company_id.value)
						{
						alertObject({message: '<cf_get_lang no ='15.İlgili Bayi İle İlgili Bayi Şubesi Uyuşmuyor!'>!'});
						return false;
						}
					}
				}
			return process_cat_control();
		}
		function islem_geri()
		{
			document.service.appcat_id.value = document.service.old_appcat_id.value;
		}
		
		function islem_devam()
		{
			window.location.href='<cfoutput>#request.self#?fuseaction=service.add_service<cfif len(get_service_detail.service_company_id)>&company_id=#get_service_detail.service_company_id#</cfif><cfif len(get_service_detail.service_partner_id)>&partner_id=#get_service_detail.service_partner_id#</cfif>&basvuru_yapan=#get_service_detail.applicator_name#</cfoutput>&servicecat_id='+document.service.appcat_id.value;
		}
		
		function substatus()
		{
			document.service.service_substatus_id.value=document.service.service_status_id.value;
		}
		function opage(deger)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=service.pro_id' + deger + '&field_name=service.product' + deger,'list');
		}
		function get_service_defect(deger)
		{
			<cfif x_product_cat>
			if(document.getElementById('service_product_cat').value)
			{
				deger = document.getElementById('service_product_cat').value;
				result = wrk_safe_query('srv_get_service_code','dsn3',0,deger);
				mylist = result.SERVICE_CODE_ID;
				$("#failure_code").val(mylist);
				$("#failure_code").multiselect("refresh");
			}
			</cfif>
		}
	</cfif>
</cfif>	
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	WOStruct['#attributes.fuseaction#']['systemObject']['processStage'] = true;
	
	
	if(isdefined('attributes.event') and (attributes.event contains 'upd' or attributes.event contains 'det'))
		WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = get_service_detail.service_status_id;
	else
		WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = '';


	if(not isdefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['systemObject']['paperNumber'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['paperType'] = 'SERVICE_APP';
	WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn3; // Transaction icin yapildi.

	WOStruct['#attributes.fuseaction#']['systemObject']['paperDate'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['paperDateCallFunction'] = 'change_money_info';

	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SERVICE';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'SERVICE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-company_name','item-appcat_id','item-appcat_sub_id','item-sub_cat_tree_place','item-service_substatus_id']";
	
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'service.list_service';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'service/display/list_service.cfm';
	WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'service.list_service';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'service.add_service';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'service/form/add_service.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'service/query/add_service.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'service.list_service&event=det&service_id=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'service';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'chk_form() && validate().check()';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'service.upd_service';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'service/form/upd_service.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'service/query/upd_service.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'service.list_service&event=det&service_id=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'service_id=##attributes.service_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.service_id##';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_service_detail';
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'service';

	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_service_detail'; 
	WOStruct['#attributes.fuseaction#']['upd']['recordQueryRecordEmp'] = 'record_member'; 

	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'chk_form()';
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;

	
	WOStruct['#attributes.fuseaction#']['det']['pageParams'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['pageParams']['size'] = '9-3';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'service/form/upd_service.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'service.list_service&event=det&service_id=';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.service_id##';
	WOStruct['#attributes.fuseaction#']['det']['pageObjects'] = structNew();
	
	if(isdefined('attributes.event') and listfindNoCase('del,upd,det',attributes.event,','))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=service.emptypopup_del_service&service_id=#attributes.service_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'service/query/del_service.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'service/query/del_service.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'service.list_service';		
	}	
	
	
	if(not isdefined('attributes.formSubmittedController'))
	{
		// type'lar include,box,custom tag şekline dönüşecek.
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'service.list_service&event=det&service_id=';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'service/display/list_service.cfm';
		
		if(isdefined("attributes.event") and not (attributes.event is 'add' or attributes.event is 'list'))
		{
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['type'] = 0; // Include
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceController']  = 'serviceListService.cfm';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][0]['referenceEvent']  = 'upd';
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][1]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][1]['file'] = '#request.self#?fuseaction=service.list_service_operation&employee_id=#attributes.employee_id#&service_id=#service_id#&id=#id#&SUBSCRIPTION_ID=#attributes.SUBSCRIPTION_ID#&company_id=#attributes.company_id#&partner_id=#attributes.partner_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][1]['id'] = 'service_oper';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][1]['title'] = '#lang_array.item[28]#';

			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][2]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][2]['file'] = '#request.self#?fuseaction=service.list_service_operation_transact&employee_id=#attributes.employee_id#&service_id=#service_id#&id=#id#&SUBSCRIPTION_ID=#attributes.SUBSCRIPTION_ID #&company_id=#attributes.company_id#&member_id=#member_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][2]['id'] = 'service_trans';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][2]['title'] = '#lang_array.item[38]#';


			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][3]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][3]['file'] = '#request.self#?fuseaction=service.list_service_time_cost&employee_id=#attributes.employee_id#&service_id=#service_id#&id=#id#&SUBSCRIPTION_ID=#attributes.SUBSCRIPTION_ID#&company_id=#attributes.company_id#&partner_id=#attributes.partner_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][3]['id'] = 'service_time_cost';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][3]['title'] = '#lang_array.item[89]#';

			controlParam=4;
			if(session.ep.our_company_info.subscription_contract eq 1 and (isdefined("attributes.subscription_id") and len(attributes.subscription_id) or len(get_service_detail.SUBSCRIPTION_ID)))
			{
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][controlParam]['type'] = 2;
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][controlParam]['file'] = '#request.self#?fuseaction=service.list_subscription_products&SUBSCRIPTION_ID=#attributes.SUBSCRIPTION_ID#';
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][controlParam]['id'] = 'system_plan_';
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][controlParam]['title'] = '#lang_array.item[276]#';
				controlParam = controlParam + 1;
			}
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][controlParam]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][controlParam]['file'] = '#request.self#?fuseaction=service.dsp_service_plus&id=#id#&service_id=#service_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][controlParam]['addFile'] = '#adres_#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][controlParam]['id'] = 'plus_service';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][controlParam]['title'] = '#lang_array.item[94]#';
			controlParam = controlParam + 1;

			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][controlParam]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][controlParam]['file'] = '#request.self#?fuseaction=objects.emptypopup_ajax_project_works&service_id=#attributes.service_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][controlParam]['id'] = 'main_news_menu';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][0][controlParam]['title'] = '#lang_array_main.item[608]#';
			controlParam = controlParam + 1;

			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['file'] = '#request.self#?fuseaction=objects.emptypopup_ajax_list_extra_pages&type=1&company_id=#attributes.company_id#&consumer_id=#attributes.consumer_id#&employee_id=#attributes.employee_id#&service_id=#attributes.service_id#&partner_id=#attributes.partner_id#&service_id=#attributes.service_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['id'] = 'contract_';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][0]['title'] = '#lang_array_main.item[163]#';	
			controlParam = 1;
			if (len(get_service_detail.stock_id) and len(get_service_detail.pro_serial_no) )// and get_pro_guaranty.recordcount
			{
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['type'] = 2;
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '#request.self#?fuseaction=objects.emptypopup_ajax_list_extra_pages&type=4&service_id=#attributes.service_id#&stock_id=#get_service_detail.stock_id#&pro_serial_no=#get_service_detail.pro_serial_no#';
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['id'] = 'get_guaranty_info';
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['title'] = '#lang_array.item[18]#';
				controlParam = controlParam + 1;
		    }

			if (session.ep.our_company_info.guaranty_followup eq 1)
			{
				if(len(get_service_detail.stock_id))
				{
					WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['type'] = 2;
					WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '#request.self#?fuseaction=service.popup_add_service_test&service_id=#attributes.service_id#';
					WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['id'] = 'guaranty_control';
					WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['title'] = '#lang_array.item[73]#';
				}
				else
				{
					WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['type'] = 2;
					WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '#request.self#?fuseaction=service.list_service_tests&service_id=#attributes.service_id#&type=3';
					WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['id'] = 'guaranty_control';
					WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['title'] = '#lang_array.item[73]#';
				}
				controlParam = controlParam + 1;
				
			}
			
			if(not listfindnocase(denied_pages,'service.popup_add_sms_reply') and (session.ep.our_company_info.sms eq 1))
			{
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['type'] = 2;
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '#request.self#?fuseaction=service.popup_add_reply&service_id=#service_id#';
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['id'] = 'reply_';
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['title'] = '#lang_array.item[60]#';	
				controlParam = controlParam + 1;
			}
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['type'] = 2;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '#request.self#?fuseaction=service.list_internaldemands&service_id=#service_id#';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['id'] = 'inter_';
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['title'] = '#lang_array.item[341]#';	
			controlParam = controlParam + 1;
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['type'] = 1;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-5" module_id="14" action_section="SERVICE_ID" action_id="##attributes.service_id##">';
			controlParam = controlParam + 1;

			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['type'] = 1;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '<cf_get_workcube_note company_id="#session.ep.company_id#" module_id="14" action_section="SERVICE_ID" action_id="##attributes.service_id##">';
			controlParam = controlParam + 1;
			
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['type'] = 1;
			WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '<cf_get_related_events action_section="SERVICE_ID" action_id="#attributes.service_id#" member_id="#member_id#" member_type="#member_type#">';
			controlParam = controlParam + 1;
			
			if(len(get_service_Detail.workgroup_id))
			{
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['type'] = 2;
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['file'] = '#request.self#?fuseaction=service.popup_add_workgroup_employees&service_id=#service_id#';
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['id'] = 'wrk_group';
				WOStruct['#attributes.fuseaction#']['det']['pageObjects'][1][controlParam]['title'] = '#lang_array_main.item[2639]#';	
				controlParam = controlParam + 1;
			}

		}
	}	
	
	// Upd //	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
	// Tab Menus //
		tabMenuStruct = StructNew();
		tabMenuStruct['#attributes.fuseaction#'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['onclick'] = "windowopen('#request.self#?fuseaction=service.popup_service_page_warnings&action=service.service&action_name=service_id&action_id=#attributes.service_id#','list')";
		i = 1 ;
		str_link = "&form_submitted=1&made_application=#get_service_detail.applicator_name#";
		if (len(get_service_detail.service_company_id) and len(get_service_detail.service_partner_id))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['der']['menus'][i]['text'] = '#lang_array.item[280]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=myhome.mytime_management&event=add&service_id=#attributes.service_id#&comp_id=#get_service_detail.SERVICE_COMPANY_ID#&partner_id=#get_service_detail.service_partner_id#&is_service=1','page_horizantal')";
			i = i+1;
		}
		else if (len(get_service_detail.service_consumer_id))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array.item[280]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=service.popup_add_timecost&service_id=#url.id#&cons_id=#get_service_detail.SERVICE_CONSUMER_ID#&is_service=1','medium')";
			i = i+1;	
		}
		
		
		if (len(attributes.employee_id) and (attributes.employee_id neq 0))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array.item[243]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=service.list_service&employee_id=#attributes.employee_id##str_link#";
			i = i+1;
		}
		else if (len(attributes.partner_id) and (attributes.partner_id neq 0))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array.item[243]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "";
			i = i+1;	
		}
		else if (len(attributes.partner_id) and (attributes.partner_id neq 0))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array.item[243]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=service.list_service&partner_id=#attributes.partner_id##str_link#";	
			i = i+1;
		}
        else if (len(attributes.consumer_id) and (attributes.consumer_id neq 0))
        {
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array_main.item[243]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=service.list_service&consumer_id=#attributes.consumer_id##str_link#";	  
			i = i+1;  
		}
		if(session.ep.our_company_info.sms eq 1)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array_main.item[1178]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=#member_type#&member_id=#member_id#&paper_id=#attributes.service_id#&paper_type=7&sms_action=#fuseaction#','small')";	 
			i = i+1;   	
		}
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array_main.item[61]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=service.popup_service_history&service_id=#attributes.service_id#','wide')";
		i = i+1;
		consumer = '';
		partner = '';
		if(len(get_service_detail.service_consumer_id))
		{
			consumer = get_service_detail.service_consumer_id;
		}
		else if(len(get_service_detail.service_partner_id))
		{	
			partner = get_service_detail.service_partner_id;	
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_add_pursuits_documents_plus&action_id=#attributes.service_id#&header=service.service_head&contact_person=#get_service_detail.applicator_name#&consumer_id=#consumer#&partner_id=#partner#&pursuit_type=is_service_application','list')";
		i = i+1;
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array.item[279]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=service.popup_check_service_ships&service_id=#attributes.service_id#','wide')";
		i = i+1;
		if(len(get_service_detail.service_consumer_id))
			consumer = get_service_detail.service_consumer_id;
		else if(len(get_service_detail.service_company_id))
			partner = get_service_detail.service_company_id;
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array.item[278]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=stock.list_serial_operations&service_id=#attributes.service_id#&consumer_id=#consumer#&company_id=#partner#&is_filtre=1";
		i = i+1;
		if(session.ep.our_company_info.workcube_sector is 'it' and get_ship.recordcount)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array.item[277]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_cargo_information&cargo_type=2&service_no=#get_service_detail.service_no#','horizantal','popup_cargo_information')";
			i = i+1;
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#lang_array.item[56]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=service.popup_list_similar_services&keyword=#URLEncodedFormat(get_service_detail.service_head)#&id=#attributes.service_id#&service_product_id=#get_service_detail.service_product_id#','medium');";
		i = i+1;
			
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=service.list_service&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['search']['text'] = '#lang_array_main.item[153]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['search']['onclick'] = "openSearchForm('basvuru_no','#lang_array.item[84]#','service.emptypopup_git_basvuru')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['href'] = "#request.self#?fuseaction=service.add_service&service_id=#attributes.service_id#";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['target'] = "_blank";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.service_id#&print_type=51','page')";


		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>