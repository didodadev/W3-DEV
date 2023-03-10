<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = application.systemParam.systemParam().dsn & '_5'>
    <cfif http.referer contains 'wiki.workcube.com'>
    <cfset uploadFolder = application.systemParam.systemParam().upload_folder>
    
    <cffunction name="GET_SERVICE_APPCAT" access="remote" returntype="query">
        <cfquery name="GET_SERVICE_APPCAT" datasource="#dsn#">
            SELECT
                SERVICECAT,
                SERVICECAT_ID
            FROM
                G_SERVICE_APPCAT
            WHERE
                IS_STATUS = 1
            ORDER BY SERVICECAT
        </cfquery>
       <cfreturn GET_SERVICE_APPCAT>
    </cffunction>

	<cffunction name="SAVEHELPDESK" returntype="any" returnformat="json" access="remote">
        <cfargument name="action_id" default="1">
        <cfif isdefined("session.ww.userid")>
                <cfset member_id = session.ww.userid>
            <cfelseif isdefined("session.pp.userid")>
                <cfset member_id = session.pp.userid>
        <cfelseif isdefined("session.ep.userid")>
            <cfset member_id = session.ep.userid>
        <cfelse>
            <cfset member_id = 0>
        </cfif>
        <cf_papers paper_type="ASSET">
        <cfquery name="GET_MAIN_PAPER" datasource="#DSN#">
            SELECT * FROM GENERAL_PAPERS_MAIN WHERE EMPLOYEE_NUMBER IS NOT NULL
        </cfquery>
        <cfset paper_code = evaluate('get_main_paper.g_service_app_no')>
        <cfset paper_number = evaluate('get_main_paper.g_service_app_number') +1>

        <cfset system_paper_no_add = paper_number>
        <cfquery name="UPD_GEN_PAP" datasource="#DSN#">
            UPDATE
                GENERAL_PAPERS_MAIN
            SET
                G_SERVICE_APP_NUMBER = #system_paper_no_add#
            WHERE
                G_SERVICE_APP_NUMBER IS NOT NULL
        </cfquery>

        <cfset system_paper_no=paper_code & '-' & paper_number>
        <cfset x_is_sub_tree_single_select = 0> 
        <cfset system_paper_no2=paper_code & '-' & paper_number>
        <!--- <cfset formElements = URLDecode(arguments.dataForm)> --->
        <!--- <cfset attributes.process_stage = GET_PROCESS.PROCESS_ROW_ID> --->
        <!--- <cfset asset_file_real_name = file.serverfile> --->
        <cfset moduleName="call">
        <cfset moduleId=27>
        <cfset actionSection="G_SERVICE_ID">
         <!---
        <cfloop from="1" to="#listlen(formElements,'&')#" index="elem">
            <cfset arguments[listFirst(listGetAt(formElements,elem,'&'),'=')] = listLast(listGetAt(formElements,elem,'&'),'=')>
        </cfloop> --->
        <cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
            SELECT
                SUBSCRIPTION_ID,			
                SUBSCRIPTION_NO,
                COMPANY_ID,
                PARTNER_ID,
                CONSUMER_ID,
                PROJECT_ID
            FROM
                SUBSCRIPTION_CONTRACT			
            WHERE
                SUBSCRIPTION_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workcube_id#">
        </cfquery>
        <cfsavecontent variable="arguments.subject">
            <cfoutput>	
                <p>#arguments.service_head#</p>
            </cfoutput>
        </cfsavecontent>
        
        <cfset priority_id = 1><!--- ??ncelik 1-Normal --->
        <cfset commethod_id = 11><!--- ??leti??im 11-Workcube --->
        <cfset attributes.apply_date = now()><!--- Ba??vuru Tarihi --->
        <cfset arguments.apply_hour = datepart('h',now())>
        <cfset arguments.apply_minute = datepart('n',now())>
        <cfset start_date1 = DateAdd('h', 4, now())>
        <cfset service_head = arguments.service_head>
        <cfset service_detail = arguments.service_detail>
        <cfset member_name = arguments.member_name>
        <cfset applicant_mail = arguments.applicant_mail>
	    <cfset service_url = arguments.service_url>
        <cfset arguments.subscription_id = GET_SUBSCRIPTION.SUBSCRIPTION_ID>
		<cfif GET_SUBSCRIPTION.recordcount>
            <cfif LEN(GET_SUBSCRIPTION.COMPANY_ID)>
                <cfset arguments.company_id =GET_SUBSCRIPTION.COMPANY_ID>
                <cfquery name="GET_PART_EMAIL" datasource="#DSN#">
                    SELECT 
                        PARTNER_ID 
                    FROM 
                        COMPANY_PARTNER 
                    WHERE
                        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND 
                        (
                            COMPANY_PARTNER_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#applicant_mail#"> OR
                            COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#member_name#%">
                        )
                </cfquery>
                <cfif get_part_email.recordcount>
                    <cfset arguments.partner_id = get_part_email.partner_id>
                </cfif>
            <cfelseif len(GET_SUBSCRIPTION.CONSUMER_ID)>
                <cfset arguments.consumer_id =GET_SUBSCRIPTION.CONSUMER_ID>
            <cfelseif len(GET_SUBSCRIPTION.PARTNER_ID)>
                <cfset arguments.partner_id =GET_SUBSCRIPTION.PARTNER_ID>
            </cfif>
		<cfif len(GET_SUBSCRIPTION.project_id)>
		    <cfset attributes.project_id = GET_SUBSCRIPTION.project_id>
		</cfif>
        </cfif>
        <cfquery name="GET_MAIN_PAPER" datasource="#DSN#">
            SELECT * FROM GENERAL_PAPERS_MAIN WHERE EMPLOYEE_NUMBER IS NOT NULL
        </cfquery>
        <cfset paper_code = evaluate('get_main_paper.g_service_app_no')>
        <cfset paper_number = evaluate('get_main_paper.g_service_app_number') +1>
        <cfset system_paper_no_add = paper_number>
        <cfquery name="UPD_GEN_PAP" datasource="#DSN#">
            UPDATE
                GENERAL_PAPERS_MAIN
            SET
                G_SERVICE_APP_NUMBER = #system_paper_no_add#
            WHERE
                G_SERVICE_APP_NUMBER IS NOT NULL
        </cfquery>
        <cfset system_paper_no=paper_code & '-' & paper_number>
        <cfset x_is_sub_tree_single_select = 0> 
        <cfquery name="ADD_SERVICE" datasource="#DSN#" result="xxx">
            INSERT INTO
            G_SERVICE
            (
                SERVICE_ACTIVE,
                ISREAD,
                SERVICECAT_ID,
                SERVICE_STATUS_ID,
                PRIORITY_ID,
                COMMETHOD_ID,
                SERVICE_HEAD,
                SERVICE_DETAIL,
                APPLY_DATE,
                START_DATE,
                SERVICE_EMPLOYEE_ID,
                SERVICE_CONSUMER_ID,
                SERVICE_COMPANY_ID,
                SERVICE_PARTNER_ID,
                NOTIFY_PARTNER_ID,
                NOTIFY_CONSUMER_ID,
                NOTIFY_EMPLOYEE_ID,
                SERVICE_BRANCH_ID,
                APPLICATOR_NAME,
                APPLICATOR_EMAIL,
                SERVICE_NO,
                SUBSCRIPTION_ID,
                PROJECT_ID,
                REF_NO,
                CUS_HELP_ID,
                RECORD_DATE,
                RECORD_MEMBER,
                RESP_EMP_ID,
                RESP_PAR_ID,
                RESP_COMP_ID,
                RESP_CONS_ID,
                CAMPAIGN_ID,
                OUR_COMPANY_ID,
                FUSEACTION,
                FULL_URL,
                RELEASE_NO,
                PATCH_NO,
                EXTRA_INFO
                <cfif isdefined("attributes.tmarket_id")>
                    ,TMARKET_ID
                    ,TARGET_RECORD_ID
                </cfif>
                <cfif isdefined('session.pp.userid')>
                    ,RECORD_PAR
                <cfelseif isdefined('session.ww.userid')>
                    ,RECORD_CONS
                </cfif>
            )
            VALUES
            (
                1,
                0,
                <cfif len(appcat_id)>#appcat_id#<cfelse>NULL</cfif>,
                813,
                <cfif len(priority_id)>#priority_id#<cfelse>NULL</cfif>,
                <cfif len(commethod_id)>#commethod_id#<cfelse>NULL</cfif>,
                <cfif len(service_head)>'#service_head#'<cfelse>'#system_paper_no#'</cfif>,
                <cfif len(service_detail)>'#service_detail#'<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.apply_date") and len(attributes.apply_date)>#attributes.apply_date#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.start_date1") and len(attributes.start_date1)>#attributes.start_date1#<cfelseif len(attributes.apply_date)>#DateAdd('h', 4, attributes.apply_date)#<cfelse>NULL</cfif>,
                <cfif isDefined("arguments.employee_id") and len(arguments.employee_id)>#arguments.employee_id#<cfelse>NULL</cfif>,
                <cfif isDefined("arguments.consumer_id") and len(arguments.consumer_id)>#arguments.consumer_id#<cfelse>NULL</cfif>,
                <cfif isDefined("arguments.company_id") and len(arguments.company_id)>#arguments.company_id#<cfelse>NULL</cfif>,
                <cfif isDefined("arguments.partner_id") and len(arguments.partner_id)>#arguments.partner_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.notify_app_type") and len(attributes.notify_app_type) and isdefined("attributes.notify_app_name") and len(attributes.notify_app_name)>
                    <cfif attributes.notify_app_type is 'partner'>
                        <cfif len(attributes.notify_app_id)>#attributes.notify_app_id#<cfelse>NULL</cfif>,
                        NULL,
                        NULL,
                    <cfelseif attributes.notify_app_type is 'consumer'>
                        NULL,
                        <cfif len(attributes.notify_app_id)>#attributes.notify_app_id#<cfelse>NULL</cfif>,
                        NULL,
                    <cfelseif attributes.notify_app_type is 'employee'>
                        NULL,
                        NULL,
                        <cfif len(attributes.notify_app_id)>#attributes.notify_app_id#<cfelse>NULL</cfif>,
                    </cfif>
                <cfelse>
                    NULL,
                    NULL,
                    NULL,
                </cfif>
                <cfif isDefined("service_branch_id") and len(service_branch_id)>#service_branch_id#<cfelse>NULL</cfif>,
                '#member_name#',
                '#applicant_mail#',
                '#system_paper_no#',
                <cfif isdefined("arguments.subscription_id") and len(arguments.subscription_id)>#arguments.subscription_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.ref_no") and len

(attributes.ref_no)>'#attributes.ref_no#'<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.cus_help_id") and len

(attributes.cus_help_id)>#attributes.cus_help_id#<cfelse>NULL</cfif>,
                #now()#,
                <cfif isdefined("session.ep.userid")>#session.ep.userid#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.resp_emp_id") and len(attributes.resp_emp_id) and 

isdefined("attributes.responsible_person") and len

(attributes.responsible_person)>#attributes.resp_emp_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.resp_par_id") and len(attributes.resp_par_id) and 

isdefined("attributes.responsible_person") and len

(attributes.responsible_person)>#attributes.resp_par_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.resp_comp_id") and len(attributes.resp_comp_id) and 

isdefined("attributes.responsible_person") and len

(attributes.responsible_person)>#attributes.resp_comp_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.resp_cons_id") and len(attributes.resp_cons_id) and 

isdefined("attributes.responsible_person") and len

(attributes.responsible_person)>#attributes.resp_cons_id#<cfelse>NULL</cfif>,
                <cfif isdefined('attributes.camp_name') and len(attributes.camp_name) and 

isdefined('attributes.camp_id') and Len

(attributes.camp_id)>#attributes.camp_id#<cfelse>NULL</cfif>,
                <!--- <cfif isdefined

("session.ep.company_id")>#session.ep.company_id#<cfelse>NULL</cfif> --->
                5,
                <cfif len(service_url)>'#service_url#'<cfelse>NULL</cfif>,
                <cfif len(full_url)>'#full_url#'<cfelse>NULL</cfif>,
                <cfif len(release_no)>'#release_no#'<cfelse>NULL</cfif>,
                <cfif len(patch_no)>'#patch_no#'<cfelse>NULL</cfif>,
                <cfif len(extra_info)>'#extra_info#'<cfelse>NULL</cfif>
                <cfif isdefined("attributes.tmarket_id")>
                ,#attributes.tmarket_id#
                ,#attributes.target_record_id#
                </cfif>
                <cfif isdefined('session.pp.userid')>
                    ,#session.pp.userid#
                <cfelseif isdefined('session.ww.userid')>
                    ,#session.ww.userid#
                </cfif>
            )
            SELECT @@IDENTITY AS MAX_SERVICE_ID
        </cfquery>
		<cfset GET_SERVICE1.SERVICE_ID = ADD_SERVICE.MAX_SERVICE_ID>
        <cfquery name="ADD_HISTORY" datasource="#DSN#">
            INSERT INTO
                G_SERVICE_HISTORY
                (
                    SERVICE_ACTIVE,
                    SERVICE_HEAD,
                    SERVICE_DETAIL,
                    START_DATE,
                    APPLICATOR_NAME,
                    RECORD_DATE,
                    RECORD_MEMBER
                )
                SELECT
                    SERVICE_ACTIVE,
                    SERVICE_HEAD,
                    SERVICE_DETAIL,
                    START_DATE,
                    APPLICATOR_NAME,
                    RECORD_DATE,
                    RECORD_MEMBER
                FROM
                    G_SERVICE
                WHERE
                    SERVICE_ID =#get_service1.service_id#
        </cfquery>
        <cfif listlen(arguments.fileSystemNameList)>
        	<cfloop from="1" to="#listlen(arguments.fileSystemNameList)#" index="ind">
            	<cfquery name="INSERT_ASSET" datasource="#DSN#">
                	INSERT INTO ASSET
                    	(
                            IS_ACTIVE,	
                            IS_SPECIAL,
                            IS_INTERNET,
                            ASSET_NO,
                            MODULE_NAME,
                            MODULE_ID,
                            ACTION_SECTION,
                            ACTION_ID,
                            ASSETCAT_ID,
                            PROPERTY_ID,
                            COMPANY_ID,
                            ASSET_NAME,
                            ASSET_STAGE,
                            ASSET_FILE_NAME,
                            ASSET_FILE_REAL_NAME,
                            SERVER_NAME,
                            ASSET_FILE_SIZE,
                            ASSET_FILE_SERVER_ID,
                            RECORD_EMP,
                            RECORD_DATE,
                            RECORD_IP
  
                        )
                    VALUES
                    	(
                            1,	
                            0,
                            1,
                            '#system_paper_no2#',
                            '#moduleName#',
                            #moduleId#,
                            '#actionSection#',
                            #GET_SERVICE1.SERVICE_ID#,
                            30,
                            31,
                            5, <!--- company_id --->
                            'Ba??vuru: #system_paper_no#',
                            813, <!--- process_stage --->
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(arguments.fileSystemNameList,ind,',')#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(arguments.fileRealNameList,ind,',')#">,
                            '#cgi.http_host#',
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#listGetAt(arguments.fileSize,ind,',')#">, <!--- asset file size --->
                            NULL, <!--- asset file server id --->
                            #member_id#,
                            #now()#,
                            '#cgi.remote_addr#'
                        )
                </cfquery>
            </cfloop>
        </cfif>
        <cfreturn GET_SERVICE1.SERVICE_ID>
    </cffunction>

    <cffunction name="SAVEHELPDESKFORM" returntype="any" returnformat="json" access="remote"> 
        <cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
            SELECT
                SUBSCRIPTION_ID,			
                SUBSCRIPTION_NO,
                COMPANY_ID,
                PARTNER_ID,
                CONSUMER_ID,
				PROJECT_ID
            FROM
                SUBSCRIPTION_CONTRACT			
            WHERE
                SUBSCRIPTION_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workcube_id#">
        </cfquery>
        <cfsavecontent variable="arguments.subject">
            <cfoutput>	
                <p>#arguments.service_head#</p>
            </cfoutput>
        </cfsavecontent>
        
        <cfset priority_id = 1><!--- ??ncelik 1-Normal --->
        <cfset commethod_id = 11><!--- ??leti??im 11-Workcube --->
        <cfset attributes.apply_date = now()><!--- Ba??vuru Tarihi --->
        <cfset arguments.apply_hour = datepart('h',now())>
        <cfset arguments.apply_minute = datepart('n',now())>
        <cfset start_date1 = DateAdd('h', 4, now())>
        <cfset service_head = arguments.service_head>
        <cfset service_detail = arguments.service_detail>
        <cfset member_name = arguments.member_name>
        <cfset applicant_mail = arguments.applicant_mail>
        <cfif isdefined("arguments.company_id") and len(arguments.company_id) and isNumeric(arguments.company_id)>
		    <cfset company_id = arguments.company_id>
        <cfelse>
		    <cfset company_id = 1859>
        </cfif>
	    <cfset service_url = arguments.service_url>
        <cfset arguments.subscription_id = GET_SUBSCRIPTION.SUBSCRIPTION_ID>
        
        
		<cfif GET_SUBSCRIPTION.recordcount>
            <cfif LEN(GET_SUBSCRIPTION.COMPANY_ID)>
                <cfset arguments.company_id =GET_SUBSCRIPTION.COMPANY_ID>
                <cfquery name="GET_PART_EMAIL" datasource="#DSN#">
                    SELECT 
                        PARTNER_ID 
                    FROM 
                        COMPANY_PARTNER 
                    WHERE
                        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND 
                        (
                            COMPANY_PARTNER_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#applicant_mail#"> OR
                            COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#member_name#%">
                        )
                </cfquery>
                <cfif get_part_email.recordcount>
                    <cfset arguments.partner_id = get_part_email.partner_id>
                </cfif>
            <cfelseif len(GET_SUBSCRIPTION.CONSUMER_ID)>
                <cfset arguments.consumer_id =GET_SUBSCRIPTION.CONSUMER_ID>
            <cfelseif len(GET_SUBSCRIPTION.PARTNER_ID)>
                <cfset arguments.partner_id =GET_SUBSCRIPTION.PARTNER_ID>
            </cfif>
		<cfif len(GET_SUBSCRIPTION.project_id)>
		<cfset attributes.project_id = GET_SUBSCRIPTION.project_id>
		</cfif>
        </cfif>
        
        <cfquery name="GET_MAIN_PAPER" datasource="#DSN#">
            SELECT * FROM GENERAL_PAPERS_MAIN WHERE EMPLOYEE_NUMBER IS NOT NULL
        </cfquery>
        <cfset paper_code = evaluate('get_main_paper.g_service_app_no')>
        <cfset paper_number = evaluate('get_main_paper.g_service_app_number') +1>

        <cfset system_paper_no_add = paper_number>
        <cfquery name="UPD_GEN_PAP" datasource="#DSN#">
            UPDATE
                GENERAL_PAPERS_MAIN
            SET
                G_SERVICE_APP_NUMBER = #system_paper_no_add#
            WHERE
                G_SERVICE_APP_NUMBER IS NOT NULL
        </cfquery>

        <cfset system_paper_no=paper_code & '-' & paper_number>
        <cfset x_is_sub_tree_single_select = 0> 
        
        <cfquery name="ADD_SERVICE" datasource="#DSN#" result="xxx">
            INSERT INTO
            G_SERVICE
            (
                SERVICE_ACTIVE,
                ISREAD,
                SERVICECAT_ID,
                SERVICE_STATUS_ID,
                PRIORITY_ID,
                COMMETHOD_ID,
                SERVICE_HEAD,
                SERVICE_DETAIL,
                APPLY_DATE,
                START_DATE,
                SERVICE_EMPLOYEE_ID,
                SERVICE_CONSUMER_ID,
                SERVICE_COMPANY_ID,
                SERVICE_PARTNER_ID,
                NOTIFY_PARTNER_ID,
                NOTIFY_CONSUMER_ID,
                NOTIFY_EMPLOYEE_ID,
                SERVICE_BRANCH_ID,
                APPLICATOR_NAME,
                APPLICATOR_EMAIL,
                SERVICE_NO,
                SUBSCRIPTION_ID,
                PROJECT_ID,
                REF_NO,
                CUS_HELP_ID,
                RECORD_DATE,
                RECORD_MEMBER,
                RESP_EMP_ID,
                RESP_PAR_ID,
                RESP_COMP_ID,
                RESP_CONS_ID,
                CAMPAIGN_ID,
                OUR_COMPANY_ID,
                FUSEACTION,
                FULL_URL,
                RELEASE_NO,
                PATCH_NO,
                EXTRA_INFO
                <cfif isdefined("attributes.tmarket_id")>
                    ,TMARKET_ID
                    ,TARGET_RECORD_ID
                </cfif>
                <cfif isdefined('session.pp.userid')>
                    ,RECORD_PAR
                <cfelseif isdefined('session.ww.userid')>
                    ,RECORD_CONS
                </cfif>

            )
            VALUES
            (
                1,
                0,
                <cfif len(appcat_id)>#appcat_id#<cfelse>NULL</cfif>,
                813,
                <cfif len(priority_id)>#priority_id#<cfelse>NULL</cfif>,
                <cfif len(commethod_id)>#commethod_id#<cfelse>NULL</cfif>,
                <cfif len(service_head)>'#service_head#'<cfelse>'#system_paper_no#'</cfif>,
                <cfif len(service_detail)>'#service_detail#'<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.apply_date") and len(attributes.apply_date)>#attributes.apply_date#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.start_date1") and len(attributes.start_date1)>#attributes.start_date1#<cfelseif len(attributes.apply_date)>#DateAdd('h', 4, attributes.apply_date)#<cfelse>NULL</cfif>,
                <cfif isDefined("arguments.employee_id") and len(arguments.employee_id)>#arguments.employee_id#<cfelse>NULL</cfif>,
                <cfif isDefined("arguments.consumer_id") and len(arguments.consumer_id)>#arguments.consumer_id#<cfelse>NULL</cfif>,
                <cfif isDefined("arguments.company_id") and len(arguments.company_id)>#arguments.company_id#<cfelse>NULL</cfif>,
                <cfif isDefined("arguments.partner_id") and len(arguments.partner_id)>#arguments.partner_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.notify_app_type") and len(attributes.notify_app_type) and isdefined("attributes.notify_app_name") and len(attributes.notify_app_name)>
                <cfif attributes.notify_app_type is 'partner'>
                    <cfif len(attributes.notify_app_id)>#attributes.notify_app_id#<cfelse>NULL</cfif>,
                        NULL,
                        NULL,
                    <cfelseif attributes.notify_app_type is 'consumer'>
                        NULL,
                        <cfif len(attributes.notify_app_id)>#attributes.notify_app_id#<cfelse>NULL</cfif>,
                        NULL,
                    <cfelseif attributes.notify_app_type is 'employee'>
                        NULL,
                        NULL,
                        <cfif len(attributes.notify_app_id)>#attributes.notify_app_id#<cfelse>NULL</cfif>,
                    </cfif>
                <cfelse>
                    NULL,
                    NULL,
                    NULL,
                </cfif>
                <cfif isDefined("service_branch_id") and len(service_branch_id)>#service_branch_id#<cfelse>NULL</cfif>,
                '#member_name#',
                '#applicant_mail#',
                '#system_paper_no#',
                <cfif isdefined("arguments.subscription_id") and len(arguments.subscription_id)>#arguments.subscription_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.ref_no") and len(attributes.ref_no)>'#attributes.ref_no#'<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.cus_help_id") and len(attributes.cus_help_id)>#attributes.cus_help_id#<cfelse>NULL</cfif>,
                #now()#,
                <cfif isdefined("session.ep.userid")>#session.ep.userid#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.resp_emp_id") and len(attributes.resp_emp_id) and isdefined("attributes.responsible_person") and len(attributes.responsible_person)>#attributes.resp_emp_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.resp_par_id") and len(attributes.resp_par_id) and isdefined("attributes.responsible_person") and len(attributes.responsible_person)>#attributes.resp_par_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.resp_comp_id") and len(attributes.resp_comp_id) and isdefined("attributes.responsible_person") and len(attributes.responsible_person)>#attributes.resp_comp_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.resp_cons_id") and len(attributes.resp_cons_id) and isdefined("attributes.responsible_person") and len(attributes.responsible_person)>#attributes.resp_cons_id#<cfelse>NULL</cfif>,
                <cfif isdefined('attributes.camp_name') and len(attributes.camp_name) and isdefined('attributes.camp_id') and Len(attributes.camp_id)>#attributes.camp_id#<cfelse>NULL</cfif>,
                <!--- <cfif isdefined("session.ep.company_id")>#session.ep.company_id#<cfelse>NULL</cfif> --->
                5,
                <cfif len(service_url)>'#service_url#'<cfelse>NULL</cfif>,
                <cfif len(full_url)>'#full_url#'<cfelse>NULL</cfif>,
                <cfif len(release_no)>'#release_no#'<cfelse>NULL</cfif>,
                <cfif len(patch_no)>'#patch_no#'<cfelse>NULL</cfif>,
                <cfif len(extra_info)>'#extra_info#'<cfelse>NULL</cfif>
                <cfif isdefined("attributes.tmarket_id")>
                ,#attributes.tmarket_id#
                ,#attributes.target_record_id#
                </cfif>
                <cfif isdefined('session.pp.userid')>
                    ,#session.pp.userid#
                <cfelseif isdefined('session.ww.userid')>
                    ,#session.ww.userid#
                </cfif>
            )
            SELECT @@IDENTITY AS MAX_SERVICE_ID
        </cfquery>
		<cfset GET_SERVICE1.SERVICE_ID = ADD_SERVICE.MAX_SERVICE_ID>
        <cfquery name="ADD_HISTORY" datasource="#DSN#">
            INSERT INTO
                G_SERVICE_HISTORY
                (
                    SERVICE_ACTIVE,
                    SERVICE_HEAD,
                    SERVICE_DETAIL,
                    START_DATE,
                    APPLICATOR_NAME,
                    RECORD_DATE,
                    RECORD_MEMBER
                )
                SELECT
                    SERVICE_ACTIVE,
                    SERVICE_HEAD,
                    SERVICE_DETAIL,
                    START_DATE,
                    APPLICATOR_NAME,
                    RECORD_DATE,
                    RECORD_MEMBER
                FROM
                    G_SERVICE
                WHERE
                    SERVICE_ID =#get_service1.service_id#
        </cfquery>
        <cfreturn GET_SERVICE1.SERVICE_ID>
    </cffunction>
   <cffunction name="GET_FILE_UPLOAD" access="remote" returntype="any" returnFormat="json">
        <cfset arguments.files = []>
        
        <cffile action="uploadAll" source="#arguments[1]#" destination="#uploadFolder#/asset/helpdesk" result="UPLOADALL_RESULTS" NAMECONFLICT="Overwrite">
        <cfloop from="1" to="#arrayLen(UPLOADALL_RESULTS)#" index="i">  
              <cfset file = UPLOADALL_RESULTS[i]>  
              <cfset arguments.files[i]['fileName'] = file.SERVERFILENAME>
              <cfset arguments.files[i]['ext'] = file.SERVERFILEEXT>
              <cfset arguments.files[i]['fileSize'] = file.FILESIZE>
              <cfset arguments.files[i]['systemName'] = createUUID()&'.'&arguments.files[i]['ext']>
              <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
              <cfset assetTypeName = listlast(file.SERVERFILEEXT)>

                <cfif listfind(blackList,assetTypeName,',')>
                    <cfset banname = 0 >
                    <cffile action="delete" file="#file.SERVERDIRECTORY#/#file.SERVERFILE#" destination="#file.SERVERDIRECTORY#/#arguments.files[i]['systemName']#">
                <cfelse>
                    <cffile action="rename" source="#file.SERVERDIRECTORY#/#file.SERVERFILE#" destination="#file.SERVERDIRECTORY#/#arguments.files[i]['systemName']#">
                </cfif>
        </cfloop>

        <cfif isdefined("banname")>
            <cfreturn 0>
         <cfelse> 
            <cfreturn Replace(SerializeJSON(arguments.files),'//','')>
         </cfif>
    </cffunction>
    <cffunction name="GET_WORKCUBE_ID" returntype="any" access="remote">
	    <cfargument name="workcube_id"> 
	    <cfargument name="company_id" default="1859"> 
            <cfquery name="GET_WORKCUBE_ID" datasource="#DSN3#">
                SELECT 
                    SUBSCRIPTION_NO, SUBSCRIPTION_STAGE, COMPANY_ID ,PARTNER_ID
                FROM 
                    SUBSCRIPTION_CONTRACT 
                WHERE 
			        SUBSCRIPTION_NO = '#arguments.workcube_id#'
            </cfquery>
            <cfset attributes.workcube_id = get_workcube_id.subscription_no>
            <cfset attributes.workcube_stage = get_workcube_id.subscription_stage>
            <cfif (('attributes.workcube_stage') eq '664') or (('attributes.workcube_stage') eq '118') or (('attributes.workcube_stage') eq '719')>
                <div id="myModals" class="modals">
                    <!-- Modal content -->
                    <div class="modals-content">
                      <span class="close">&times;</span>
                    <cfif ("#session.ep.language#") eq "tr">
                        <p>DE??ERL?? KULLANICIMIZ MERHABA;</p>
                        <h3>
                            Sistemimizi denetledi??imizde Workcube uygulaman??z i??in y??ll??k LYKP ??? 
                            Lisans Yenileme ve Koruma Paketi'ne sahip olmad??????n??z?? g??rmekteyiz. Ayr??ca kay??tlar??m??zda 
                            anla??mal?? oldu??unuz herhangi bir yetkili Workcube i?? orta???? da g??r??nmemektedir. Bu sebeple 
                            maalesef ba??vurunuza cevap veremiyoruz. 
                        </h3>
                        <h3>
                            Hata giderme garantinizi s??rd??rmek ve t??m yeni Workcube versiyon ve 
                            g??ncelleme lisanslar??na ??cretsiz sahip olmak i??in LYKP alman??z gerekmektedir. Ayr??ca kullan??m 
                            yard??m??n??n da i??inde yer ald?????? destek hizmetlerini bir i?? orta????m??zdan d??zenli olarak sat??n 
                            alman??z?? ??nermekteyiz. Bu konuda bilgi ve teklif almak i??in a??a????daki linklerden 
                            faydalanabilirsiniz. 
                        </h3>
                        <div class="col col-12 col-xs-12" style="margin-top:4%;">
                            <div class="col col-4 col-xs-12"><span class="content-span">> Yetkili ???? Ortaklar??</span></div>
                            <div class="col col-4 col-xs-12"><span class="content-span">> Destek Hizmetleri Hakk??nda Bilgi</span></div>
                            <div class="col col-4 col-xs-12"><span class="content-span">> LYKP Almak ????in Ba??vur</span></div>
                        </div>
                    <cfelse>
                        <p>DEAR WORKCUBE USER</p>
                        <h3>
                            We have checked our system and see that you do not have Workcube 
                            License Renewal and Warranty Package for your Workcube application. We also see that you have not 
                            received any support services from any Workcube business partner. Unfortunately, we cannot 
                            respond to your application for this reason.
                        </h3>
                        <h3>
                            You need to purchase a Renewal and Warranty Package to maintain your 
                            maintenance warranty and to have all new Workcube versions and update licenses for free. We also 
                            recommend that you regularly purchase support services from a Workcube Channel Partner. You can 
                            use the following links to get information and to request offer.
                        </h3>
                        <div class="col col-12 col-xs-12" style="margin-top:4%;">
                            <div class="col col-4 col-xs-12"><span class="content-span">> Authorized Channel Partners</span></div>
                            <div class="col col-4 col-xs-12"><span class="content-span">> Support Services</span></div>
                            <div class="col col-4 col-xs-12"><span class="content-span">> Apply to buy a Renewal and Warranty Package</span></div>
                        </div> 
                    </cfif>
                    </div>
                </div> 
            </cfif>
        <cfreturn GET_WORKCUBE_ID>
    </cffunction>
    <cffunction name="GET_HELP" returntype="query" access="remote">
        <cfif isDefined("attributes.help_id")>
            <cfquery name="GET_HELP" datasource="#DSN#">
                SELECT
                    HELP_CIRCUIT,
                    HELP_FUSEACTION,
                    HELP_ID,
                    HELP_HEAD,
                    HELP_LANGUAGE,
                    HELP_TOPIC,
                    RECORD_DATE,
                    UPDATE_DATE,
                    RECORD_MEMBER,
                    UPDATE_MEMBER,
                    RECORD_ID,
                    UPDATE_ID,
                    RELATION_HELP_ID,
                    IS_STANDARD,
                       IS_FAQ,
                    IS_INTERNET
                FROM
                    HELP_DESK
                WHERE
                    HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.help_id#">
                    <cfif isDefined("attributes.relation_help_id") and Len(attributes.relation_help_id)>
                        OR RELATION_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.help_id#">
                        OR RELATION_HELP_ID 
                            IN 
                                (SELECT RELATION_HELP_ID FROM HELP_DESK 
                            WHERE HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.relation_help_id#">)
                        OR HELP_ID 
                            IN 
                                (SELECT RELATION_HELP_ID FROM HELP_DESK WHERE HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.relation_help_id#">)
                    </cfif>
            </cfquery>
        <cfelseif isDefined("attributes.help") and (listlen(attributes.help,'.') eq 2)>
            <cfquery name="GET_HELP" datasource="#DSN#">
                SELECT 
                    HELP_CIRCUIT,
                    HELP_FUSEACTION,
                    HELP_ID,
                    HELP_HEAD,
                    HELP_LANGUAGE,
                    HELP_TOPIC,
                    RECORD_DATE,
                    UPDATE_DATE,
                    RECORD_MEMBER,
                    UPDATE_MEMBER,
                    RECORD_ID,
                    UPDATE_ID,
                    RELATION_HELP_ID,
                    IS_STANDARD,
                       IS_FAQ,
                    IS_INTERNET
                FROM 
                    HELP_DESK
                WHERE
                    HELP_CIRCUIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(attributes.help,1,'.')#">
                    <cfif  isdefined('attributes.c_module_id') and len(attributes.c_module_id)>
                        AND	HELP_CIRCUIT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(modul_list,listfind(modul_id_list,attributes.c_module_id,','),',')#%">
                    </cfif>
                    <cfif isdefined('attributes.is_internet') and len(attributes.is_internet)>
                        AND IS_INTERNET = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_internet#">
                    </cfif>
                    <cfif isDefined("attributes.help_language") and Len(attributes.help_language)>
                        AND HELP_LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.help_language#">
                    </cfif>
                ORDER BY
                    <cfif isdefined("attributes.is_order_by") and attributes.is_order_by eq 0>
                        HELP_HEAD
                    <cfelse>
                        ISNULL(UPDATE_DATE,RECORD_DATE) DESC
                    </cfif>
            </cfquery>
        <cfelse>
            <cfquery name="GET_HELP" datasource="#DSN#">
                SELECT
                    HELP_ID,
                    HELP_HEAD,
                    HELP_LANGUAGE,
                    HELP_TOPIC,
                    RECORD_DATE,
                    UPDATE_DATE,
                    RECORD_MEMBER,
                    UPDATE_MEMBER,
                    RECORD_ID,
                    UPDATE_ID,
                    RELATION_HELP_ID,
                    HELP_FUSEACTION,
                    HELP_CIRCUIT,
                    IS_STANDARD,
                    IS_FAQ,
                    IS_INTERNET
                FROM 
                    HELP_DESK
                 WHERE 
                     HELP_HEAD <> ''
                    <cfif isDefined("attributes.keyword") and (len(attributes.keyword) eq 1)>
                        AND HELP_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
                    <cfelseif isDefined("attributes.keyword") and (len(attributes.keyword) gt 1)>
                        AND
                        (
                            HELP_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 				
                            HELP_TOPIC LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 				
                            HELP_CIRCUIT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> 
                        )
                    </cfif>
                    <cfif isdefined('attributes.c_module_id') and len(attributes.c_module_id)>
                        AND HELP_CIRCUIT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(modul_list,listfind(modul_id_list,attributes.c_module_id,','),',')#%">
                    </cfif>
                    <cfif isdefined('attributes.is_faq') and len(attributes.is_faq)>
                        AND	IS_FAQ = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_faq#">
                    </cfif>
                    <cfif isdefined('attributes.is_internet') and len(attributes.is_internet)>
                        AND IS_INTERNET = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_internet#">
                    </cfif> 
                    <cfif isDefined("attributes.help_language") and Len(attributes.help_language)>
                        AND HELP_LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.help_language#">
                    </cfif> 
                ORDER BY
                    <cfif isdefined("attributes.is_order_by") and attributes.is_order_by eq 0>
                        HELP_HEAD
                    <cfelse>
                        ISNULL(UPDATE_DATE,RECORD_DATE) DESC
                    </cfif>
            </cfquery>
        </cfif>
        <cfreturn GET_HELP>        
    </cffunction>
    <cffunction name="GET_MODULES" returntype="query" access="remote">
        <cfquery name="GET_MODULES" datasource="#DSN#">
            SELECT MODULE_ID, MODULE_NAME_TR, MODULE_SHORT_NAME FROM MODULES WHERE MODULE_SHORT_NAME IS NOT NULL ORDER BY MODULE_ID ASC
        </cfquery>
        <cfreturn GET_MODULES>
    </cffunction>
    <cffunction name="GET_HELP_LANGUAGE" returntype="query" access="remote">
        <cfquery name="GET_HELP_LANGUAGE" datasource="#DSN#">
            SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE ORDER BY LANGUAGE_SET
        </cfquery>
        <cfreturn GET_HELP_LANGUAGE>
    </cffunction>
    <cffunction name="GET_CONSUMER" returntype="any" access="remote">
    <cfif isdefined("session.ww.userid") and len(session.ww.userid)>
        <cfquery name="GET_CONSUMER" datasource="#DSN#">
            SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_EMAIL FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
        </cfquery>
    </cfif>
    <cfreturn GET_CONSUMER>
    </cffunction>
    <cffunction name="GET_PARTNER" returntype="any" access="remote">
    <cfif isdefined("session.pp.userid")>
        <cfquery name="GET_PARTNER" datasource="#DSN#">
            SELECT COMPANY_PARTNER_EMAIL FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
        </cfquery>
    </cfif>
    <cfreturn GET_PARTNER>
    </cffunction> 
    <cffunction name="CAREER_REQUEST" access="remote" returntype="any" returnFormat="json">
        <cftry>
            <cfif len(arguments.careerName) and len(arguments.careerSurname) and len(arguments.careerMail) and len(arguments.careerPhone)>
                <cfset filePath = "#uploadFolder#hr/" />
                <cfset createId = createUUID()/>
                
                <cffile action="upload" destination="#filePath#"  result="careerFile" NAMECONFLICT="Overwrite">
                <cfset fileExtension = ucase(careerFile.CLIENTFILEEXT) />
                <cfset fileName = createId & "." & fileExtension />
                <cfset filefullPath = "#uploadFolder#hr/#fileName#" />
                <cffile action="rename" source="#careerFile.SERVERDIRECTORY#/#careerFile.SERVERFILE#" destination="#careerFile.SERVERDIRECTORY#/#fileName#" attributes="normal">	

                <cfset whiteList = 'pdf'>
                <cfif listfind(whiteList,careerFile.CLIENTFILEEXT,',')>
                    <cfset newFileName = "#createId#.#careerFile.CLIENTFILEEXT#" /> 
                    <cfquery name="get_empapp_mail" datasource="#dsn#">
                        SELECT EMAIL FROM EMPLOYEES_APP WHERE EMAIL='#arguments.careerMail#'
                    </cfquery>
                    <cfif get_empapp_mail.recordcount>
                        <cfset result.status = false>
                        <cfsavecontent variable="d_message"><cf_get_lang dictionary_id='44544.Bu e-mail adresine ait Cv Kayd?? bulunuyor tekrar Kay??t Edemezsiniz'>!</cfsavecontent>
                        <cfset result.danger_message =  "#d_message#">     
                    <cfelse>
                        <cftransaction>
                            <cfquery name="ADD_EMP_APP" datasource="#dsn#" result="career_result">
                                INSERT INTO 
                                    EMPLOYEES_APP
                                    (
                                        CV_STAGE,
                                        STEP_NO,
                                        APP_STATUS,
                                        NAME,
                                        SURNAME,
                                        HOMECOUNTRY,
                                        HOMECITY,
                                        MOBILCODE,
                                        MOBIL,
                                        EMAIL,
                                        RECORD_DATE,
                                        RECORD_IP,
                                        HOMECOUNTY
                                    )
                                    VALUES(
                                        568,
                                        -1,
                                        1,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.careerName#">,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.careerSurname#">,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.country_id#">,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city_id#">,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.careerPhoneCode#">,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.careerPhone#">,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.careerMail#">,
                                        #NOW()#,
                                        '#CGI.REMOTE_ADDR#',
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.county_id#">
                                    )
                            </cfquery>
                            <cfquery name="GET_MAIN_PAPER" datasource="#dsn#">
                                SELECT * FROM GENERAL_PAPERS_MAIN WHERE EMPLOYEE_NUMBER IS NOT NULL
                            </cfquery>
                            <cfset paper_code = evaluate('get_main_paper.ASSET_no')>
                            <cfset paper_number = evaluate('get_main_paper.ASSET_number') +1>
                            <cfset system_paper_no2=paper_code & '-' & paper_number>
                            <cfset moduleName="hr">
                            <cfset moduleId=3>
                            <cfset actionSection="EMPLOYEES_APP_ID">
                            <cfset assetName = "CV-#arguments.careerName##arguments.careerSurname#">
                            <cfquery name="ADD_ASSET" datasource="#dsn#" result="GET_MAX_ASSET">
                                INSERT INTO 
                                    ASSET
                                (
                                    ASSETCAT_ID,
                                    IS_ACTIVE,	
                                    IS_SPECIAL,
                                    IS_INTERNET,
                                    ASSET_NO,
                                    MODULE_NAME,
                                    MODULE_ID,
                                    ACTION_SECTION,
                                    ACTION_ID,
                                    COMPANY_ID,
                                    ASSET_NAME,
                                    ASSET_FILE_NAME,
                                    ASSET_FILE_REAL_NAME,
                                    SERVER_NAME,
                                    ASSET_FILE_SIZE,
                                    ASSET_FILE_SERVER_ID,
                                    RECORD_EMP,
                                    RECORD_DATE,
                                    RECORD_IP,
                                    PROPERTY_ID
                                )
                                VALUES
                                (
                                    -8,
                                    1,	
                                    0,
                                    1,
                                    '#system_paper_no2#',
                                    '#moduleName#',
                                    #moduleId#,
                                    '#actionSection#',
                                    #career_result.IDENTITYCOL#,
                                    5,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#assetName#">,
                                    '#newFileName#',
                                    '#careerFile.CLIENTFILENAME#',
                                    '#cgi.http_host#',
                                    10,
                                    1,
                                    0,
                                    #now()#,
                                    '#cgi.remote_addr#',
                                    1
                                )
                            </cfquery>
                        </cftransaction>   
                    </cfif>
                </cfif>
            </cfif>
            <cfset result.status = true>
            <cfsavecontent variable="s_message"><cf_get_lang dictionary_id='61210.????lem Ba??ar??l??'></cfsavecontent>
            <cfset result.success_message = "#s_message#">
            <cfset result.identity = "">
        <cfcatch type="any">
            <cfset result.status = false>
            <cfsavecontent variable="d_message"><cf_get_lang dictionary_id='65298.??uanda i??lem yap??lam??yor'>...</cfsavecontent>
            <cfset result.danger_message = "#d_message#">
            <cfset result.error = cfcatch >
            <cfdump var="#cfcatch#">
        </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>
</cfif>  
</cfcomponent>