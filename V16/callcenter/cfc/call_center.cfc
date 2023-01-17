<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>

    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
        <cfset our_company_id = session.pp.our_company_id>
        <cfset company_id = session.pp.company_id>
        <cfset period_year = session.pp.period_year>
        <cfset language = session.pp.language>
        <cfset user_id = session.pp.userid>
        <cfset company_mail = session.pp.our_company_email>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
        <cfset our_company_id = session.ep.our_company_id>
        <cfset company_id = session.ep.company_id>
        <cfset period_year = session.ep.period_year>
        <cfset language = session.ep.language>
        <cfset user_id = session.ep.userid>
        <cfset company_mail = session.ep.company_email>
    <cfelseif isdefined("session.cp")>
        <cfset session_base = evaluate('session.cp')>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
        <cfset our_company_id = session.ww.our_company_id>
        <cfset company_id = session.ww.company_id>
        <cfset period_year = session.ww.period_year>
        <cfset language = session.ww.language>
        <cfset company_mail = session.ww.company_email>
    </cfif>
    <cfset dsn3 = '#dsn#_#our_company_id#'> 

    <cfset result = StructNew()>
    <cffunction name="GET_COMPANY_SECTOR" returntype="query" access="public">
        <cfquery name="get_company_sector" datasource="#DSN#">
            SELECT 
                SECTOR_CAT_ID,
                SECTOR_CAT 
            FROM 
                SETUP_SECTOR_CATS
            WHERE
                IS_INTERNET = 1
            ORDER BY 
                SECTOR_CAT ASC
        </cfquery>
        <cfreturn get_company_sector>
    </cffunction>
    <cffunction name="GET_CUSTOMER_VALUE" returntype="query" access="public">
        <cfquery name="get_customer_value" datasource="#DSN#">
            SELECT
                CUSTOMER_VALUE_ID,
                CUSTOMER_VALUE 
            FROM
                SETUP_CUSTOMER_VALUE
            ORDER BY
                CUSTOMER_VALUE
        </cfquery>
        <cfreturn get_customer_value>
    </cffunction>
    <cffunction name="GET_PARTNER_DETAIL" returntype="query" access="public">
        <cfargument name="partner_id_list" type="any" default="">
        <cfquery name="get_partner_detail" datasource="#DSN#">
            SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME,PARTNER_ID FROM COMPANY_PARTNER WHERE PARTNER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#arguments.partner_id_list#">) ORDER BY PARTNER_ID
        </cfquery>
        <cfreturn get_partner_detail>
    </cffunction>
    <cffunction name="GET_RECORD_EMP" returntype="query" access="public">
        <cfargument name="employee_list" type="any" default="">
        <cfquery name="get_record_emp" datasource="#DSN#">
            SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#arguments.employee_list#">) ORDER BY EMPLOYEE_ID
        </cfquery>
        <cfreturn get_record_emp>
    </cffunction>
    <cffunction name="GET_CONSUMER_DETAIL" returntype="query" access="public">
        <cfargument name="consumer_id_list" type="any" default="">
        <cfquery name="get_consumer_detail" datasource="#DSN#">
            SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID,SALES_COUNTY FROM CONSUMER WHERE CONSUMER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#arguments.consumer_id_list#">) ORDER BY CONSUMER_ID
        </cfquery>
        <cfreturn get_consumer_detail>
    </cffunction>
    <cffunction name="GET_COMPANY_DETAIL" returntype="query" access="public">
        <cfargument name="company_id_list" type="any" default="">
        <cfquery name="get_company_detail" datasource="#DSN#">
            SELECT FULLNAME,COMPANY_ID,SALES_COUNTY,NICKNAME FROM COMPANY WHERE COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#arguments.company_id_list#">) ORDER BY COMPANY_ID
        </cfquery>
        <cfreturn get_company_detail>
    </cffunction>
    <cffunction name="GET_SERVICE_APPCAT" returntype="query" access="public">
        <cfquery name="get_service_appcat" datasource="#DSN#">
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
                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#language#">
            WHERE
                IS_STATUS = 1 AND
                (
                    OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#our_company_id#"> OR
                    OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#our_company_id#"> OR
                    OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#our_company_id#,%"> OR
                    OUR_COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#our_company_id#,%">
                )
            ORDER BY 
                SERVICECAT
        </cfquery>
        <cfreturn get_service_appcat>
    </cffunction>
    <cffunction name="GET_PROCESS_TYPES" returntype="query" access="public">
        <cfargument name="x_show_authorized_stage" type="any" default="">
        <cfargument name="process_rowid_list" type="any" default="">
        <cfargument name="faction" type="any" default="">
        <cfquery name="get_process_types" datasource="#DSN#">
            SELECT
                 CASE
                    WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                    ELSE STAGE
                END AS STAGE,
                PTR.PROCESS_ROW_ID 
            FROM
                PROCESS_TYPE_ROWS PTR
                LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = ptr.PROCESS_ROW_ID
                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="STAGE">
                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PROCESS_TYPE_ROWS">
                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#language#">
                ,
                PROCESS_TYPE_OUR_COMPANY PTO,
                PROCESS_TYPE PT
            WHERE
                PT.IS_ACTIVE = 1 AND
                PTR.PROCESS_ID = PT.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#our_company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.faction#,%">
                <cfif isDefined('arguments.x_show_authorized_stage') and arguments.x_show_authorized_stage eq 1 and isDefined("arguments.process_rowid_list") and ListLen(arguments.process_rowid_list)>
                    AND PTR.PROCESS_ROW_ID IN (#arguments.process_rowid_list#)
                </cfif>
                <cfif isdefined("session.pp")>
                    AND PTR.IS_PARTNER = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                <cfelseif isdefined("session.ep")>
                    AND PTR.IS_EMPLOYEE = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
                <cfelseif isdefined("session.cp")>
                    AND PTR.IS_CONSUMER = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
                </cfif>
        </cfquery>
        <cfreturn get_process_types>
    </cffunction>
    <cffunction name="GET_PRIORITY" returntype="query" access="public">
        <cfquery name="get_priority" datasource="#DSN#">
            SELECT 
                PRIORITY_ID, 
                   CASE
                    WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                    ELSE PRIORITY
                END AS PRIORITY
            FROM 
                SETUP_PRIORITY 
                 LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_PRIORITY.PRIORITY_ID
                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRIORITY">
                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_PRIORITY">
                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#language#">
            ORDER BY PRIORITY_ID
        </cfquery>
        <cfreturn get_priority>
    </cffunction>
    <cffunction name="GET_SERVICE" returntype="query" access="public">
        
        <cfargument name="city" type="any" default="">
        <cfargument name="city_id" type="any" default="">
        <cfargument name="county" type="any" default="">
        <cfargument name="county_id" type="any" default="">
        <cfargument name="vergi_no" type="any" default="">
        <cfargument name="branch_id_list" type="any" default="">
        <cfargument name="xml_is_our_company" type="any" default="">
        <cfargument name="commethod_id" type="any" default="">
        <cfargument name="service_product_id" type="any" default="">
        <cfargument name="project_head" type="any" default="">
        <cfargument name="project_id" type="any" default="">
        <cfargument name="category" type="any" default="">
        <cfargument name="priority_cat" type="any" default="">
        <cfargument name="start_date" type="any" default="">
        <cfargument name="fin_date" type="any" default="">
        <cfargument name="s_date_1" type="any" default="">
        <cfargument name="f_date_1" type="any" default="">
        <cfargument name="service_code" type="any" default="">
        <cfargument name="keyword_detail" type="any" default="">
        <cfargument name="keyword_subject" type="any" default="">
        <cfargument name="keyword" type="any" default="">
        <cfargument name="product" type="any" default="">
        <cfargument name="service_branch_id" type="any" default="">
        <cfargument name="made_application" type="any" default="">
        <cfargument name="partner_id_" type="any" default="">
        <cfargument name="consumer_id_" type="any" default="">
        <cfargument name="notify_app_name" type="any" default="">
        <cfargument name="notify_emp_id" type="any" default="">
        <cfargument name="notify_par_id" type="any" default="">
        <cfargument name="notify_con_id" type="any" default="">
        <cfargument name="task_person_name" type="any" default="">
        <cfargument name="task_emp_id" type="any" default="">
        <cfargument name="task_par_id" type="any" default="">
        <cfargument name="service_status" type="any" default="">
        <cfargument name="process_stage" type="any" default="">
        <cfargument name="consumer_id" type="any" default="">
        <cfargument name="company_id" type="any" default="">
        <cfargument name="ismyhome" type="any" default="">
        <cfargument name="other_service_app" type="any" default="">
        <cfargument name="employee_id" type="any" default="">
        <cfargument name="partner_id" type="any" default="">
        <cfargument name="service_cat" type="any" default="">
        <cfargument name="service_cat_id" type="any" default="">
        <cfargument name="service_sub_cat_id" type="any" default="">
        <cfargument name="service_sub_status_id" type="any" default="">
        <cfargument name="appcat_id" type="any" default="">
        <cfargument name="resp_emp_id" type="any" default="">
        <cfargument name="resp_emp_name" type="any" default="">
        <cfargument name="recorder_name" type="any" default="">
        <cfargument name="record_par_id" type="any" default="">
        <cfargument name="record_emp_id" type="any" default="">
        <cfargument name="record_cons_id" type="any" default="">
        <cfargument name="subscription_id" type="any" default="">
        <cfargument name="subscription_no" type="any" default="">
        <cfargument name="sales_zones" type="any" default="">
        <cfargument name="startrow" type="any" default="1">
        <cfargument name="maxrows" type="any" default="20">
        <cfargument name="process_row_id_list" type="any" default="">


        <cfquery name="get_service" datasource="#dsn#">
            SELECT
                SERVICE.SERVICE_ID,
                SERVICE.ISREAD,
                SERVICE.SERVICE_COMPANY_ID,
                SERVICE.APPLICATOR_NAME,
                SERVICE.SERVICE_PARTNER_ID,
                SERVICE.SERVICE_CONSUMER_ID,
                SERVICE.SERVICE_EMPLOYEE_ID,
                SERVICE.SERVICE_STATUS_ID,
                SERVICE.SERVICE_NO,
                SERVICE.APPLY_DATE,
                SERVICE.RESP_EMP_ID,
                SERVICE.RESP_PAR_ID,
                SERVICE.RESP_CONS_ID,
                SERVICE.SERVICE_HEAD,
                SERVICE.SERVICE_DETAIL,
                SERVICE.RECORD_MEMBER,
                SERVICE.RECORD_PAR,
                SERVICE.RECORD_CONS,
                SERVICE.SERVICE_BRANCH_ID,
                SERVICE.COMMETHOD_ID,
                SERVICE_APPCAT.SERVICECAT,
                SERVICE.SUBSCRIPTION_ID,
                SERVICE.RECORD_DATE,
                SERVICE.SERVICECAT_ID,
                ISNULL(ISNULL(E.DIRECT_TELCODE+' '+E.DIRECT_TEL,CP.COMPANY_PARTNER_TELCODE+' '+CP.COMPANY_PARTNER_TEL),C.CONSUMER_HOMETELCODE+' '+C.CONSUMER_HOMETEL) TELNO,
                ISNULL(ISNULL(E.MOBILCODE+' '+E.MOBILTEL, CP.MOBIL_CODE+' '+CP.MOBILTEL),C.MOBIL_CODE+' '+C.MOBILTEL) MOBIL_TEL,
                PP.PROJECT_HEAD,
                PROCESS_TYPE_ROWS.LINE_NUMBER,
                PROCESS_TYPE_ROWS.STAGE
            FROM
                <cfif (isdefined("arguments.city") and len(arguments.city) and isdefined("arguments.city_id") and len(arguments.city_id)) or (isdefined("arguments.county") and isdefined("arguments.county_id") and len(arguments.county_id))>
                    SETUP_CITY SETUP_CITY,
                </cfif>
                <cfif (isdefined("arguments.county") and len(arguments.county) and isdefined("arguments.county_id") AND len(arguments.county_id))>
                    SETUP_COUNTY SETUP_COUNTY,
                </cfif>
                <cfif (isdefined("arguments.city") and len(arguments.city) and isdefined("arguments.city_id") and len(arguments.city_id)) or (isdefined("arguments.county") and len(arguments.county) and isdefined("arguments.county_id") AND len(arguments.county_id)) or (isdefined("arguments.vergi_no") and len(arguments.vergi_no))>
                    COMPANY COMPANY,
                </cfif>	
                G_SERVICE SERVICE WITH (NOLOCK)
                LEFT JOIN EMPLOYEES E ON SERVICE.SERVICE_EMPLOYEE_ID=E.EMPLOYEE_ID
                LEFT JOIN CONSUMER C ON SERVICE.SERVICE_CONSUMER_ID=C.CONSUMER_ID
                LEFT JOIN COMPANY_PARTNER CP ON SERVICE.SERVICE_PARTNER_ID=CP.PARTNER_ID
                LEFT JOIN PRO_PROJECTS PP  ON PP.PROJECT_ID=SERVICE.PROJECT_ID
                LEFT JOIN #dsn3#.SUBSCRIPTION_CONTRACT SUB ON SERVICE.SUBSCRIPTION_ID = SUB.SUBSCRIPTION_ID,
                G_SERVICE_APPCAT SERVICE_APPCAT,
                PROCESS_TYPE_ROWS PROCESS_TYPE_ROWS
            WHERE
                1=1 AND 
                <cfif isDefined('session.pp.userid')>
                    SERVICE.SERVICE_COMPANY_ID = #session.pp.company_id#  AND
                </cfif>
                (
                    SERVICE_BRANCH_ID IS NULL
                    <cfif listlen(arguments.branch_id_list)>
                        OR SERVICE_BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id_list#" list="yes">)
                    </cfif>
                ) AND
                <cfif isdefined("arguments.commethod_id") and len(arguments.commethod_id)>
                    SERVICE.COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.commethod_id#"> AND
                </cfif>
                <cfif isdefined("arguments.service_product_id") and len(arguments.service_product_id) and isdefined("arguments.service_product") and len(arguments.service_product)>
                    SERVICE.SERVICE_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_product_id#"> AND
                </cfif>
                <cfif len(arguments.project_id) and len(arguments.project_head)>
                    SERVICE.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"> AND
                </cfif>
                <cfif isDefined("arguments.category") and len(arguments.category)>
                    SERVICE.SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.category#"> AND
                </cfif>
                <cfif isDefined("arguments.priority_cat") and len(arguments.priority_cat)>
                    SERVICE.PRIORITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.priority_cat#"> AND
                </cfif>
                <cfif isdefined("arguments.start_date") and len(arguments.start_date)>
                    SERVICE.APPLY_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
                </cfif>
                <cfif isdefined("arguments.fin_date") and len(arguments.fin_date)>
                    SERVICE.APPLY_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.fin_date#"> AND
                </cfif>
                <cfif isdefined("arguments.s_date_1") and len(arguments.s_date_1)>
                    SERVICE.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.s_date_1#"> AND
                </cfif>
                <cfif isdefined("arguments.f_date_1") and len(arguments.f_date_1)>
                    SERVICE.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.f_date_1#"> AND
                </cfif>               
                <cfif isdefined("arguments.service_code") and len(arguments.service_code)>
                    SERVICE.SERVICE_DEFECT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.service_code#"> AND
                </cfif>
                
                <cfif len(arguments.keyword_detail) >
                     SERVICE.SERVICE_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword_detail#%"> AND
                </cfif>
                <cfif len(arguments.keyword_subject)>
                        SERVICE.SERVICE_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword_subject#%"> AND
                </cfif>
                <cfif len(arguments.keyword)>
                    (
                        SERVICE.SERVICE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
                        SERVICE.SERVICE_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                    ) AND
                </cfif>
                
                <cfif isdefined("arguments.product") and len(arguments.product) and len(arguments.product_id)>
                    SERVICE.SERVICE_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"> AND
                </cfif>
                <cfif isdefined("arguments.service_branch_id") and len(arguments.service_branch_id)>
                    SERVICE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_branch_id#"> AND
                </cfif>
                <cfif isdefined("arguments.made_application") and len(arguments.made_application)>
                    (
                        APPLICATOR_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.made_application#%">
                        <cfif isdefined("arguments.partner_id_") and len(arguments.partner_id_)>
                            OR SERVICE.SERVICE_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id_#">
                        </cfif>
                        <cfif isdefined("arguments.consumer_id_") and len(arguments.consumer_id_)>
                            OR SERVICE.SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id_#">
                        </cfif>
                    ) AND
                </cfif>
                <cfif isdefined("arguments.notify_app_name") and len(arguments.notify_app_name)>
                    <cfif isdefined("arguments.notify_emp_id") and len(arguments.notify_emp_id)>
                        SERVICE.NOTIFY_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.notify_emp_id#"> AND
                    <cfelseif isdefined("arguments.notify_par_id") and len(arguments.notify_par_id)>
                        SERVICE.NOTIFY_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.notify_par_id#"> AND
                    <cfelseif isdefined("arguments.notify_con_id") and len(arguments.notify_con_id)>
                        SERVICE.NOTIFY_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.notify_con_id#"> AND
                    </cfif>
                </cfif>
                <cfif isdefined("arguments.task_person_name") and len(arguments.task_person_name)>
                    <cfif len(arguments.task_emp_id)>
                        SERVICE.SERVICE_ID IN (SELECT G_SERVICE_ID FROM PRO_WORKS WHERE PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.task_emp_id#"> AND G_SERVICE_ID = SERVICE.SERVICE_ID) AND
                    <cfelseif len(arguments.task_par_id)>
                        SERVICE.SERVICE_ID IN (SELECT G_SERVICE_ID FROM PRO_WORKS WHERE OUTSRC_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.task_par_id#"> AND G_SERVICE_ID = SERVICE.SERVICE_ID) AND
                    </cfif>
                </cfif>
                <cfif isdefined("arguments.service_status") and len(arguments.service_status)>
                    SERVICE.SERVICE_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.service_status#"> AND
                </cfif>
                <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)>
                    SERVICE.SERVICE_STATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"> AND
                </cfif>
                <!--- BU BÖLÜM MYHOME DAN VE ÜYEDEN DİREK ULAŞIM İÇİN KONULMUŞTUR --->
                <cfif isDefined("arguments.ismyhome") and isdefined("arguments.company_id") and len(arguments.company_id)>
                    SERVICE_PARTNER_ID IN (SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">)  AND
                </cfif>
                <cfif isDefined("arguments.ismyhome") and isdefined("arguments.consumer_id") and len(arguments.consumer_id)>
                    SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"> AND
                </cfif>
                <!--- //BU BÖLÜM MYHOME DAN VE ÜYEDEN DİREK ULAŞIM İÇİN KONULMUŞTUR --->		
                
                <!--- Bu bölüm service update sayfasından başvuru yapanın diğer servis başvurularına direk erişim için konulmuştur--->
                <cfif isdefined('other_service_app') and isdefined("arguments.service_id") and len(arguments.service_id)>
                    SERVICE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#"> AND
                    <cfif isdefined('arguments.partner_id') and len(arguments.partner_id)>
                        SERVICE_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#"> AND
                    <cfelseif isdefined('arguments.employee_id') and len(arguments.employee_id)>
                        SERVICE_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> AND
                    <cfelseif isdefined('arguments.consumer_id') and len(arguments.consumer_id)>
                        SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"> AND
                    </cfif>
                </cfif>
                <cfif isdefined('arguments.employee_id') and len(arguments.employee_id)>
                     SERVICE_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> AND
                </cfif>
                <cfif isdefined("arguments.service_id") and len(arguments.service_id)>
                    SERVICE_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#" list="yes">) AND
                </cfif>
                <!--- Kategori tanımlysa o kategorideki service_id leri buluyor ona göre filtreliyor --->
                <cfif isdefined("arguments.service_cat") and len(arguments.service_cat) and (len(arguments.service_cat_id) or len(arguments.service_sub_cat_id) or len(arguments.service_sub_status_id))>
                    SERVICE.SERVICE_ID IN (SELECT 
                                                SERVICE_ID 
                                            FROM 
                                                G_SERVICE_APP_ROWS 
                                            WHERE 
                                                SERVICE_ID IS NOT NULL 
                                                <cfif isdefined("arguments.service_cat_id") and len(arguments.service_cat_id)>
                                                    AND SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_cat_id#">
                                                </cfif>
                                                <cfif isdefined("arguments.service_sub_cat_id") and len(arguments.service_sub_cat_id)>
                                                    AND SERVICE_SUB_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_sub_cat_id#">
                                                </cfif>
                                                <cfif isdefined("arguments.service_sub_status_id") and len(arguments.service_sub_status_id)>
                                                    AND SERVICE_SUB_STATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_sub_status_id#">
                                                </cfif>
                                            ) AND
                </cfif>
                <!--- Başvurunun kategorisine göre filtreliyor --->
                <cfif isdefined("arguments.appcat_id") and len(arguments.appcat_id)>
                    SERVICE.SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.appcat_id#"> AND			
                </cfif>
                <cfif (isdefined("arguments.city") and len(arguments.city) and isdefined("arguments.city_id") and len(arguments.city_id)) or (isdefined("arguments.county") and len(arguments.county) and isdefined("arguments.county_id") and len(arguments.county_id))>
                    COMPANY.COMPANY_ID = SERVICE.SERVICE_COMPANY_ID AND 
                    <cfif isdefined("arguments.city") and len(arguments.city) and isdefined("arguments.city_id") and len(arguments.city_id)>
                        SETUP_CITY.CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city_id#"> AND
                        SETUP_CITY.CITY_ID = COMPANY.CITY AND
                    </cfif>
                    <cfif isdefined("arguments.county") and len(arguments.county) and isdefined("arguments.county_id") and len(arguments.county_id)>
                        SETUP_COUNTY.COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.county_id#"> AND
                        SETUP_COUNTY.COUNTY_ID = COMPANY.COUNTY AND
                    </cfif>
                </cfif>
                <cfif isdefined("arguments.vergi_no") and len(arguments.vergi_no)>
                    COMPANY.COMPANY_ID = SERVICE.SERVICE_COMPANY_ID AND
                    COMPANY.TAXNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.vergi_no#"> AND
                </cfif>
                SERVICE.SERVICECAT_ID = SERVICE_APPCAT.SERVICECAT_ID AND
                SERVICE.SERVICE_STATUS_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
                <cfif isDefined('arguments.process_row_id_list') and len(arguments.process_row_id_list)>
                    AND PROCESS_TYPE_ROWS.PROCESS_ROW_ID IN (#ValueList(arguments.process_row_id_list)#)
                <cfelseif isDefined('x_show_authorized_stage') and x_show_authorized_stage eq 1>
                    AND 1 = 0
                </cfif>
                <cfif isdefined("arguments.company_id") and len(arguments.company_id) and isdefined("arguments.company") and len(arguments.company)> 
                    AND SERVICE.SERVICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                </cfif>
                <cfif isdefined("arguments.resp_id") and len(arguments.resp_id) and listLast(arguments.resp_id,'_') eq 2>
                    AND SERVICE.RESP_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(arguments.resp_id,'_')#">
                </cfif>
                <cfif isdefined("arguments.resp_id") and len(arguments.resp_id) and listLast(arguments.resp_id,'_') eq 1>
                    AND SERVICE.RESP_PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(arguments.resp_id,'_')#">
                </cfif>
                <cfif isdefined("arguments.resp_cons_id") and len(arguments.resp_cons_id) and isdefined("arguments.resp_emp_name") and len(arguments.resp_emp_name)> 
                    AND SERVICE.RESP_CONS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.resp_cons_id#">
                </cfif>
                <cfif isDefined('arguments.recorder_name') and len(arguments.recorder_name) and isdefined("arguments.record_emp_id") and len(arguments.record_emp_id)>
                    AND SERVICE.RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_emp_id#">
                <cfelseif isDefined('arguments.recorder_name') and len(arguments.recorder_name) and isdefined("arguments.record_par_id") and len(arguments.record_par_id)>
                    AND SERVICE.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_par_id#">
                <cfelseif isDefined('arguments.recorder_name') and len(arguments.recorder_name) and isdefined("arguments.record_cons_id") and len(arguments.record_cons_id)>
                    AND SERVICE.RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_cons_id#">
                </cfif>
                <cfif len(arguments.subscription_no)>
                    AND SERVICE.OUR_COMPANY_ID = #our_company_id#
                    AND SUB.SUBSCRIPTION_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.subscription_no#">
                </cfif>
                <cfif len(arguments.subscription_id)>
                    AND SUB.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#">
                </cfif>
                <cfif isdefined("arguments.sales_zones") and len(arguments.sales_zones)>
                    AND (
                         SERVICE.SERVICE_COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY WHERE SALES_COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sales_zones#">)
                           OR 
                         SERVICE.SERVICE_CONSUMER_ID IN (SELECT CONSUMER_ID FROM CONSUMER WHERE SALES_COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sales_zones#">)
                         )
                </cfif>
               
                <cfif isdefined("session.ep.our_company_info.sales_zone_followup") and session.ep.our_company_info.sales_zone_followup eq 1 and isDefined('session.ep.userid')>
                    <!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
                    AND
                    ((	
                        SERVICE_COMPANY_ID IS NULL OR
                        (
                            SERVICE_COMPANY_ID IS NOT NULL AND
                            SERVICE_COMPANY_ID IN
                            (
                                SELECT 
                                    C.COMPANY_ID
                                FROM
                                    COMPANY C
                                WHERE
                                    C.IMS_CODE_ID IN 
                                    (
                                    SELECT
                                        IMS_ID
                                    FROM
                                        SALES_ZONES_ALL_2
                                    WHERE
                                        POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                                    )
                                    <!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
                                    <cfif get_hierarchies.recordcount>
                                    OR C.IMS_CODE_ID IN 
                                    (
                                        SELECT
                                            IMS_ID
                                        FROM
                                            SALES_ZONES_ALL_1
                                        WHERE											
                                        <cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
                                            <cfset start_row=(page_stock*row_block)+1>	
                                            <cfset end_row=start_row+(row_block-1)>
                                            <cfif (end_row) gte get_hierarchies.recordcount>
                                                <cfset end_row=get_hierarchies.recordcount>
                                            </cfif>
                                                (
                                                <cfloop index="add_stock" from="#start_row#" to="#end_row#">
                                                    <cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_hierarchies.sz_hierarchy[add_stock]#%">
                                                </cfloop>
                                                
                                                )<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
                                        </cfloop>											
                                        )
                                    </cfif>						
                            )
                        )
                    )
                    AND
                    (	
                        SERVICE_CONSUMER_ID IS NULL OR
                        (
                            SERVICE_CONSUMER_ID IS NOT NULL AND
                            SERVICE_CONSUMER_ID IN
                            (
                                SELECT 
                                    C.CONSUMER_ID
                                FROM
                                    CONSUMER C
                                WHERE
                                    C.IMS_CODE_ID IN (
                                                        SELECT
                                                            IMS_ID
                                                        FROM
                                                            SALES_ZONES_ALL_2
                                                        WHERE
                                                            POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                                                        )
                                    <!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
                                    <cfif get_hierarchies.recordcount>
                                        OR C.IMS_CODE_ID IN 
                                            (
                                            SELECT
                                                IMS_ID
                                            FROM
                                                SALES_ZONES_ALL_1
                                            WHERE											
                                                <cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
                                                    <cfset start_row=(page_stock*row_block)+1>	
                                                    <cfset end_row=start_row+(row_block-1)>
                                                    <cfif (end_row) gte get_hierarchies.recordcount>
                                                        <cfset end_row=get_hierarchies.recordcount>
                                                    </cfif>
                                                        (
                                                        <cfloop index="add_stock" from="#start_row#" to="#end_row#">
                                                            <cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_hierarchies.sz_hierarchy[add_stock]#%">
                                                        </cfloop>
                                                        
                                                        )<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
                                                </cfloop>											
                                            )
                                  </cfif>						
                            )
                        )
                    ))
                </cfif>
                
                ORDER BY SERVICE.SERVICE_ID DESC
        </cfquery>
        <cfreturn get_service>
    </cffunction>
    <cffunction name="GET_SERVICE_DETAIL" access="public" returntype="query">
        <cfargument name="service_id" type="any" default="">
        <cfquery name="get_service_detail" datasource="#DSN#">
            SELECT 
                SERVICE_COMPANY_ID,
                SERVICE_PARTNER_ID,
                SERVICE_CONSUMER_ID,
                SERVICE_EMPLOYEE_ID,
                SERVICE_BRANCH_ID,
                SERVICE_NO,
                RESP_EMP_ID,
                RESP_PAR_ID,
                RESP_COMP_ID,
                RESP_CONS_ID,
                SERVICE_HEAD,
                SERVICE_ACTIVE,
                SEND_MAIL,
                SEND_SMS,
                APPLICATOR_NAME,
                APPLICATOR_EMAIL,
                PRIORITY_ID,
                APPLY_DATE,
                START_DATE,
                FINISH_DATE,
                REF_NO,
                PROJECT_ID,
                SUBSCRIPTION_ID,
                SERVICE_STATUS_ID,
                SERVICECAT_ID,
                COMMETHOD_ID,
                SERVICE_DETAIL,
                RECORD_MEMBER,
                RECORD_PAR,
                RECORD_CONS,
                RECORD_DATE,
                UPDATE_MEMBER,
                UPDATE_PAR,
                UPDATE_DATE,
                NOTIFY_EMPLOYEE_ID,
                NOTIFY_PARTNER_ID,
                NOTIFY_CONSUMER_ID,
                CAMPAIGN_ID,
                SERVICE_ID,
                FUSEACTION,
                FULL_URL
            FROM 
                G_SERVICE 
            WHERE 
                SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
        </cfquery>
        <cfreturn get_service_detail>
    </cffunction>
    <cffunction name="GET_SUBSCRIPTION" access="public" returntype="query">
        <cfargument name="service_id" type="any" default="">
        <cfargument name="s_status" type="any" default="">
        <cfargument name="keyword" type="any" default="">
        <cfargument name="subscription_type" type="any" default="">
        <cfargument name="process_stage_type" type="any" default="">
        <cfquery name="get_subscription" datasource="#DSN3#">
            SELECT
                SC.SUBSCRIPTION_ID,
                SC.SUBSCRIPTION_NO,
                SC.SUBSCRIPTION_HEAD,
                SC.PARTNER_ID,
                SC.COMPANY_ID,
                SC.CONSUMER_ID,
                SC.SALES_EMP_ID,
                SC.SUBSCRIPTION_STAGE,
                SC.MONTAGE_DATE,
                SC.START_DATE,
                SC.FINISH_DATE,
                SC.RECORD_EMP,
                SC.SUBSCRIPTION_ADD_OPTION_ID,
                SC.SALES_ADD_OPTION_ID,
                SST.SUBSCRIPTION_TYPE
            FROM
                SUBSCRIPTION_CONTRACT SC,
                SETUP_SUBSCRIPTION_TYPE AS SST
            WHERE
                (
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#"> OR
                    INVOICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#">
                ) AND
                <cfif len(arguments.s_status) and arguments.s_status eq 1>
                    SC.IS_ACTIVE = 1 AND
                <cfelseif len(arguments.s_status) and arguments.s_status eq 0>
                    SC.IS_ACTIVE = 0 AND
                </cfif>
                SUBSCRIPTION_ID IS NOT NULL AND 
                SST.SUBSCRIPTION_TYPE_ID = SC.SUBSCRIPTION_TYPE_ID
                <cfif len(arguments.process_stage_type)> 
                    AND SC.SUBSCRIPTION_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage_type#">
                </cfif>
                <cfif len(arguments.subscription_type)> 
                    AND SC.SUBSCRIPTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_type#">
                </cfif>
                <cfif len(arguments.keyword)>
                    AND (
                            SC.SUBSCRIPTION_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
                            SC.SUBSCRIPTION_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                        )
                </cfif>
        </cfquery>
        <cfreturn get_subscription>
    </cffunction>
    <cffunction name="GET_RELATED_SUBSCRIPTION" access="public" returntype="query">
        <cfargument name="subscription_id" type="any" default="">
        <cfquery name="get_related_subscription" datasource="#DSN3#">
            SELECT SUBSCRIPTION_NO,SUBSCRIPTION_HEAD FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID IS NOT NULL AND SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#">
        </cfquery>
        <cfreturn get_related_subscription>
    </cffunction>
    <cffunction name="GET_SERVICE_PLUS" access="public" returntype="query">
        <cfargument name="service_id" type="numeric" default="">
        <cfargument name="service_plus_id" type="any" default="">
        <cfquery name="get_service_plus" datasource="#DSN#">
            SELECT 
                *
            FROM 
                G_SERVICE_PLUS
            WHERE   
                SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
            <cfif isDefined("arguments.service_plus_id") and len(arguments.service_plus_id)>
                AND SERVICE_PLUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_plus_id#">
            </cfif>	
            ORDER BY 
                SERVICE_PLUS_ID DESC
        </cfquery>
        <cfreturn get_service_plus>
    </cffunction>
    <cffunction name="GET_MODULE_TEMP" access="public" returntype="query">
        <cfquery name="get_module_temp" datasource="#DSN#">
            SELECT
                TEMPLATE_ID,
                TEMPLATE_HEAD,
                TEMPLATE_CONTENT
            FROM
                TEMPLATE_FORMS
            WHERE
                TEMPLATE_MODULE = <cfqueryparam cfsqltype="cf_sql_integer" value="#27#">
        </cfquery>
        <cfreturn get_module_temp>
    </cffunction>
    <cffunction name="GET_TEMPLATE_SELECTED" access="public" returntype="query">
        <cfquery name="get_template_selected" datasource="#DSN#">
            SELECT
                TEMPLATE_CONTENT
            FROM
                TEMPLATE_FORMS
            WHERE
                TEMPLATE_MODULE = <cfqueryparam cfsqltype="cf_sql_integer" value="#27#">
                <cfif isDefined("arguments.template_id") and len(arguments.template_id)>		
                    AND TEMPLATE_ID = #arguments.template_id#
                </cfif>	
        </cfquery>
        <cfreturn get_template_selected>
    </cffunction>
    <cffunction name="add_service" access="remote" returntype="string" returnargumentsat="json">
        <cfset result = StructNew()>
        <cfscript>
            if(isdefined("arguments.apply_date") and len(arguments.apply_date) and isdefined("arguments.apply_hour") and len(arguments.apply_hour)){
                arguments.apply_date = DateAdd('h',ListFirst(arguments.apply_hour,':')-session_base.time_zone, arguments.apply_date);
                arguments.apply_date = DateAdd('N',ListLast(arguments.apply_hour,':'), arguments.apply_date);
            } 
            if(isdefined("arguments.start_date1") and len(arguments.start_date1) and isdefined("arguments.start_hour") and len(arguments.start_hour)){
                arguments.start_date1 = DateAdd('h',ListFirst(arguments.start_hour,':')-session_base.time_zone, arguments.start_date1);
                arguments.start_date1 = DateAdd('N',ListLast(arguments.start_hour,':'), arguments.start_date1);
            } 
            if(isdefined("arguments.finish_date") and len(arguments.finish_date) and isdefined("arguments.finish_hour") and len(arguments.finish_hour))
            {
                arguments.finish_date = DateAdd('h',ListFirst(arguments.finish_hour,':')-session_base.time_zone, arguments.finish_date);
                arguments.finish_date = DateAdd('N',ListLast(arguments.finish_hour,':'), arguments.finish_date);
            } 
        </cfscript>
        <cf_papers paper_type="g_service_app">
		<cfset system_paper_no=paper_code & '-' & paper_number>
		<cfset system_paper_no_add=paper_number>
		<cfif len(system_paper_no_add)>
			<cfquery name="UPD_GEN_PAP" datasource="#DSN#">
				UPDATE
					GENERAL_PAPERS_MAIN
				SET
					G_SERVICE_APP_NUMBER = #system_paper_no_add#
				WHERE
					G_SERVICE_APP_NUMBER IS NOT NULL
			</cfquery>
		</cfif>
        <cftry>       
            <cfquery name="add_service" datasource="#DSN#" result="MAX_ID">
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
                    FINISH_DATE,
                    SERVICE_EMPLOYEE_ID,
                    SERVICE_CONSUMER_ID,
                    SERVICE_COMPANY_ID,
                    SERVICE_PARTNER_ID,
                    NOTIFY_PARTNER_ID,
                    NOTIFY_CONSUMER_ID,
                    NOTIFY_EMPLOYEE_ID,
                    SERVICE_BRANCH_ID,
                    APPLICATOR_NAME,
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
                    CAMPAIGN_ID,
                    OUR_COMPANY_ID	
                )
                VALUES
                (
                    <cfif isdefined('arguments.is_status') and arguments.is_status eq 1><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
                    0,
                    <cfif len(arguments.appcat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.appcat_id#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                    <cfif len(arguments.priority_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.priority_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.commethod_id") and len(arguments.commethod_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.commethod_id#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.service_head#">,
                    <cfif isdefined("arguments.service_detail") and len(arguments.service_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.service_detail#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.apply_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.apply_date#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.start_date1") and len(arguments.start_date1)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date1#"><cfelseif len(arguments.apply_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.apply_date#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#"><cfelse>NULL</cfif>,
                    <cfif isDefined("arguments.employee_id") and len(arguments.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#"><cfelse>NULL</cfif>,
                    <cfif isDefined("arguments.consumer_id") and len(arguments.consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#consumer_id#"><cfelse>NULL</cfif>,
                    <cfif isDefined("arguments.company_id_") and len(arguments.company_id_)><cfqueryparam cfsqltype="cf_sql_integer" value="#company_id_#">
                    <cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                    <cfelse>NULL</cfif>,
                    <cfif isDefined("arguments.partner_id") and len(arguments.partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#partner_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.notify_app_type") and len(arguments.notify_app_type) and isdefined("arguments.notify_app_name") and len(arguments.notify_app_name)>
                        <cfif arguments.notify_app_type is 'partner'>
                            <cfif len(arguments.notify_app_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.notify_app_id#"><cfelse>NULL</cfif>,
                            NULL,
                            NULL,
                        <cfelseif arguments.notify_app_type is 'consumer'>
                            NULL,
                            <cfif len(arguments.notify_app_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.notify_app_id#"><cfelse>NULL</cfif>,
                            NULL,
                        <cfelseif arguments.notify_app_type is 'employee'>
                            NULL,
                            NULL,
                            <cfif len(arguments.notify_app_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.notify_app_id#"><cfelse>NULL</cfif>,
                        </cfif>
                    <cfelse>
                        NULL,
                        NULL,
                        NULL,
                    </cfif>
                    
                    <cfif isDefined("arguments.service_branch_id") and len(arguments.service_branch_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_branch_id#"><cfelse>NULL</cfif>,
                    <cfif isDefined("arguments.member_name") and len(arguments.member_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#"><cfelseif isdefined("session_base.name") and isDefined("session_base.surname")><cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.name# #session_base.surname#"><cfelse>NULL</cfif>,
                    <cfif isdefined("system_paper_no") and len(system_paper_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#system_paper_no#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.subscription_id") and len(arguments.subscription_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.project_id") and len(arguments.project_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.ref_no") and len(arguments.ref_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ref_no#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.cus_help_id") and len(arguments.cus_help_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cus_help_id#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfif isdefined("user_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#user_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.resp_id") and len(arguments.resp_id) and listLast(arguments.resp_id,'_') eq 2><cfqueryparam cfsqltype="cf_sql_integer" value="#listFirst(arguments.resp_id,'_')#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.resp_id") and len(arguments.resp_id) and listLast(arguments.resp_id,'_') eq 1><cfqueryparam cfsqltype="cf_sql_integer" value="#listFirst(arguments.resp_id,'_')#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.resp_id") and len(arguments.resp_id) and listLast(arguments.resp_id,'_') eq 2><cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.camp_name') and len(arguments.camp_name) and isdefined('arguments.camp_id') and Len(arguments.camp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.camp_id#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#"> 
                )
                SELECT SCOPE_IDENTITY() AS MAX_SERVICE_ID
                
            </cfquery>            
            <cfset result.status = true>
            <cfset result.success_message = "Kaydi Yapildi, Yonlendiriliyor">
            <cfset result.identity = CreateObject("component", "WMO.functions").contentEncryptingandDecodingAES(isEncode:1,content:ADD_SERVICE.MAX_SERVICE_ID,accountKey:"wrk")>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Suanda islem yapilamiyor.">
                <cfset result.error = cfcatch >
                <cfdump var ="#result.error#">
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>
    <cffunction name="UPD_SERVICE" access="remote" returntype="string" returnargumentsat="json">
        <cfset result = StructNew()>
         <cfscript>
            if(isdefined("arguments.apply_date") and len(arguments.apply_date) and isdefined("arguments.apply_hour") and len(arguments.apply_hour)){
                arguments.apply_date = DateAdd('h',ListFirst(arguments.apply_hour,':')-session_base.time_zone, arguments.apply_date);
                arguments.apply_date = DateAdd('N',ListLast(arguments.apply_hour,':'), arguments.apply_date);
            } 
            if(isdefined("arguments.start_date1") and len(arguments.start_date1) and isdefined("arguments.start_hour") and len(arguments.start_hour)){
                arguments.start_date1 = DateAdd('h',ListFirst(arguments.start_hour,':')-session_base.time_zone, arguments.start_date1);
                arguments.start_date1 = DateAdd('N',ListLast(arguments.start_hour,':'), arguments.start_date1);
            } 
            if(isdefined("arguments.finish_date1") and len(arguments.finish_date1) and isdefined("arguments.finish_hour") and len(arguments.finish_hour))
            {
                arguments.finish_date1 = DateAdd('h',ListFirst(arguments.finish_hour,':')-session_base.time_zone, arguments.finish_date1);
                arguments.finish_date1 = DateAdd('N',ListLast(arguments.finish_hour,':'), arguments.finish_date1);
            } 
        </cfscript>
        <cftry>   
            <cfquery name="upd_service" datasource="#DSN#">
                UPDATE
                    G_SERVICE
                SET
                    SERVICE_ACTIVE = <cfif isDefined("arguments.status") and arguments.status><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
                    SERVICECAT_ID = <cfif isdefined("arguments.appcat_id") and len(arguments.appcat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.appcat_id#"><cfelse>NULL</cfif>,
                    SERVICE_STATUS_ID = <cfif isdefined("arguments.process_stage") and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>,
                    PRIORITY_ID = <cfif isdefined("arguments.priority_id") and len(arguments.priority_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.priority_id#"><cfelse>NULL</cfif>,
                    COMMETHOD_ID = <cfif isdefined("arguments.commethod_id") and len(arguments.commethod_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.commethod_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.service_head") and len(arguments.service_head)> SERVICE_HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.service_head#">,</cfif> 
                    <cfif isdefined("arguments.service_detail") and len(arguments.service_detail)> SERVICE_HEAD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.service_detail#">,</cfif>
                    <cfif isdefined("arguments.company_id") and len(arguments.company_id)>
                        SERVICE_COMPANY_ID = #session.pp.company_id#,
                        SERVICE_PARTNER_ID = <cfif len(arguments.partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#"><cfelse>NULL</cfif>,
                        SERVICE_EMPLOYEE_ID = NULL,
                        SERVICE_CONSUMER_ID = NULL,
                    <cfelseif isdefined("arguments.employee_id") and len(arguments.employee_id)>
                        SERVICE_COMPANY_ID = NULL,
                        SERVICE_PARTNER_ID = NULL,
                        SERVICE_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                        SERVICE_CONSUMER_ID = NULL,
                    <cfelseif isdefined("arguments.consumer_id") and len(arguments.consumer_id)>
                        SERVICE_COMPANY_ID = NULL,
                        SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">,
                        SERVICE_EMPLOYEE_ID = NULL,
                        SERVICE_PARTNER_ID = NULL,
                    </cfif>
                    <cfif isdefined("arguments.notify_app_type") and len(arguments.notify_app_type) and isdefined("arguments.notify_app_name") and len(arguments.notify_app_name)>
                        <cfif arguments.notify_app_type is 'partner'>
                            NOTIFY_PARTNER_ID = <cfif len(arguments.notify_app_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.notify_app_id#"><cfelse>NULL</cfif>,
                            NOTIFY_CONSUMER_ID = NULL,
                            NOTIFY_EMPLOYEE_ID = NULL,
                        <cfelseif arguments.notify_app_type is 'consumer'>
                            NOTIFY_PARTNER_ID = NULL,
                            NOTIFY_CONSUMER_ID = <cfif len(arguments.notify_app_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.notify_app_id#"><cfelse>NULL</cfif>,
                            NOTIFY_EMPLOYEE_ID = NULL,
                        <cfelseif arguments.notify_app_type is 'employee'>
                            NOTIFY_PARTNER_ID = NULL,
                            NOTIFY_CONSUMER_ID = NULL,
                            NOTIFY_EMPLOYEE_ID = <cfif len(arguments.notify_app_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.notify_app_id#"><cfelse>NULL</cfif>,
                        </cfif>
                    <cfelse>
                        NOTIFY_PARTNER_ID = NULL,
                        NOTIFY_CONSUMER_ID = NULL,
                        NOTIFY_EMPLOYEE_ID = NULL,
                    </cfif>
                    UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                    UPDATE_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#user_id#"> ,
                    APPLY_DATE = <cfif isdefined("arguments.apply_date") and len(arguments.apply_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.apply_date#"><cfelse>NULL</cfif>,
                    START_DATE = <cfif isdefined("arguments.start_date1") and len(arguments.start_date1)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date1#"><cfelse><cfqueryparam cfsqltype="cf_sql_date" value="#now()#"></cfif>,
                    FINISH_DATE = <cfif isdefined("arguments.finish_date1") and  len(arguments.finish_date1)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date1#"><cfelse>NULL</cfif>,
                    SERVICE_BRANCH_ID = <cfif isDefined("arguments.service_branch_id") AND len(arguments.service_branch_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_branch_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.subscription_id") and len(arguments.subscription_id) and len(arguments.subscription_head)>SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#">,</cfif>
                    <cfif isdefined("arguments.project_id") and len(arguments.project_id) and len(arguments.project_head)>PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">,</cfif>
                    <cfif isdefined("arguments.member_name") and len(arguments.member_name)>APPLICATOR_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_name#">,</cfif>
                    SEND_MAIL = <cfif isDefined("arguments.send_mail")><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
                    SEND_SMS = <cfif isDefined("arguments.send_sms")><cfqueryparam cfsqltype="cf_sql_integer" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
                    REF_NO = <cfif isdefined("arguments.ref_no") and len(arguments.ref_no)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ref_no#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.resp_id") and len(arguments.resp_id) and  listLast(arguments.resp_id,'_') eq 2>
                        RESP_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listFirst(arguments.resp_id,'_')#">,
                        RESP_PAR_ID = NULL,
                        RESP_COMP_ID = NULL,
                        RESP_CONS_ID = NULL,
                    <cfelseif isdefined("arguments.resp_id") and len(arguments.resp_id) and listLast(arguments.resp_id,'_') eq 1>
                        RESP_EMP_ID = NULL,
                        RESP_PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listFirst(arguments.resp_id,'_')#">,
                        RESP_COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#">,
                        RESP_CONS_ID = NULL,
                    </cfif>
                    CAMPAIGN_ID = <cfif isdefined('arguments.camp_name') and len(arguments.camp_name) and isdefined('arguments.camp_id') and Len(arguments.camp_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.camp_id#"><cfelse>NULL</cfif>,
                    OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#"> ,
                    FUSEACTION=<cfif isdefined('arguments.url') and len(arguments.url)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.url#"><cfelse>NULL</cfif>
                WHERE
                    SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
            </cfquery>
            <cfset result.status = true>
            <cfset result.success_message = "Guncelleme islemi yapildi, Yonlendiriliyor">
            <cfset result.identity = CreateObject("component", "WMO.functions").contentEncryptingandDecodingAES(isEncode:1,content:arguments.id,accountKey:"wrk")>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Suanda islem yapilamiyor.">
                <cfset result.error = cfcatch >
                <cfdump var ="#result.error#">
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>
    <cffunction name="add_service_plus" access="remote" returntype="string" returnargumentsat="json">
        <cfset result = StructNew()>
        <cftry>       
            <cfquery name="add_service_plus" datasource="#DSN#">
                INSERT INTO 
                    G_SERVICE_PLUS 
                (
                    SUBJECT,
                    SERVICE_ID,
                    PLUS_DATE,
                    COMMETHOD_ID,
                    PLUS_CONTENT,
                    SERVICE_ZONE,
                    PARTNER_ID,
                    CONSUMER_ID,
                    EMPLOYEE_ID,
                    MAIL_SENDER,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_PAR,
                    RECORD_IP,
                    IS_MAIL
                )
                VALUES 
                (
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.header#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                    <cfif arguments.commethod_id is "0"><cfqueryparam cfsqltype="cf_sql_integer" value="17"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.commethod_id#"></cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.plus_content#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
                    <cfif isdefined('arguments.partner_id') and len(arguments.partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#ListFirst(arguments.partner_id)#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.consumer_id') and len(arguments.consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#ListFirst(arguments.consumer_id)#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.employee_id') and len(arguments.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#ListFirst(arguments.employee_id)#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.partner_names") and len(arguments.partner_names)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.partner_names#"><cfelse>NULL</cfif>,
                    #now()#,
                    <cfif isdefined("session.ep")><cfqueryparam cfsqltype="cf_sql_integer" value="#user_id#"><cfelse>NULL</cfif>,
                    <cfif isdefined("session.pp")><cfqueryparam cfsqltype="cf_sql_integer" value="#user_id#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_add#">,
                    <cfif isDefined('arguments.email') and arguments.email eq 'true'><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>	
                )
            </cfquery>
            <cfif isDefined('arguments.email') and arguments.email eq 'true'>
                <cfset sender='#company_id#<#company_mail#>'>
                <cfquery name="GET_SERVICE" datasource="#DSN#">
                    SELECT SERVICE_NO, SERVICE_HEAD, SERVICE_DETAIL FROM G_SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
                </cfquery>
                <cfif isdefined("get_service.service_detail") and len(get_service.service_detail)>
                    <cfset service_detail_ = replace(get_service.service_detail,'<p>','','all')>
                    <cfset service_detail_ = replace(service_detail_,'</p>','','all')>
                <cfelse>
                    <cfset service_detail_ = "">
                </cfif>
                <cfset domain_control = 0>
                <cfmail from="#sender#" to="#arguments.partner_names#" subject="#arguments.header#" type="html" cc="#arguments.partner_names_cc#">
                    <style type="text/css">
                        .color-header{background-color: ##a7caed; color:##FFFFFF;}
                        .color-border	{background-color:##6699cc;}
                        .color-row{font-weight:bold;}
                        .label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
                    </style>
                    <table width="50%" border="0">
                        <tr class="color-header">
                            <td colspan="2"><cf_get_lang dictionary_id='49287.Başvuru No'> : <cfoutput>#get_service.service_no#</cfoutput></td>
                        </tr>
                        <tr>
                            <td class="color-row" colspan="2"><b><cf_get_lang dictionary_id='49315.Başvuru Bilgileri'></b></td>
                        </tr>
                        <tr>
                            <td><b><cf_get_lang dictionary_id='57480.Konu'> :</b></td>
                            <td><cfoutput>#get_service.service_head#</cfoutput></td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap" valign="top"><b><cf_get_lang dictionary_id='57629.Explanation'> :</b></td>
                            <td><cfoutput>#service_detail_#</cfoutput></td>
                        </tr>
                        <tr height="20">
                            <td></td>
                        </tr>
                        <tr>
                            <td class="headbold" colspan="2"><b><cf_get_lang dictionary_id='49316.Follow-up Details'></b></td>
                        </tr>
                        <tr>
                            <td><b><cf_get_lang dictionary_id='57480.Konu'> :</b></td>
                            <td><cfoutput>#arguments.header#</cfoutput></td>
                        </tr>
                        <tr>
                            <td nowrap="nowrap" valign="top"><b><cf_get_lang dictionary_id='57629.Explanation'> :</b></td>
                            <td><cfoutput>#arguments.plus_content#</cfoutput></td>
                        </tr>
                        <cfif domain_control neq 1>
                            <tr>
                                <td colspan="2"><a href="<cfoutput>https://#CGI.SERVER_NAME#/#arguments.site_language_path#/callDet?id=#arguments.service_id#</cfoutput>"><cf_get_lang dictionary_id='49220.Detaylı Bilgi İçin Tıklayınız'></a></td>
                            </tr>
                        </cfif>
                    </table>			
                    <br/><br/>
                </cfmail>
            </cfif>           
            <cfset result.status = true>
            <cfset result.success_message = "Kaydi Yapildi, Yonlendiriliyor">
            <cfset result.identity = CreateObject("component", "WMO.functions").contentEncryptingandDecodingAES(isEncode:1,content:arguments.service_id,accountKey:"wrk")>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Suanda islem yapilamiyor...">
                <cfset result.error = cfcatch >
                <cfdump var ="#result.error#">
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>
</cfcomponent>
