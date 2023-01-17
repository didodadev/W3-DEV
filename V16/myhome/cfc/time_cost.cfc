<!---
File: time_cost.cfc
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Controller: -
Description: Time Cost Functions
Date: 14/11/2019
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2_alias = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3_alias = '#dsn#_#session.ep.company_id#'>
    <!--- Aktiviteler --->
	<cffunction name="GET_ACTIVITY" access="public" returntype="query">
        <cfquery name="GET_ACTIVITY" datasource="#dsn#">
            SELECT ACTIVITY_ID,ACTIVITY_NAME FROM SETUP_ACTIVITY WHERE ACTIVITY_STATUS = 1 ORDER BY ACTIVITY_NAME
        </cfquery>
        <cfreturn GET_ACTIVITY>
    </cffunction>
    <!--- Kategoriler ---->
    <cffunction name="GET_TIME_COST_CATS" access="public" returntype="query">
        <cfquery name="GET_TIME_COST_CATS" datasource="#dsn#">
            SELECT TIME_COST_CAT,TIME_COST_CAT_ID FROM TIME_COST_CAT ORDER BY TIME_COST_CAT
        </cfquery>
        <cfreturn GET_TIME_COST_CATS>
    </cffunction>
    <!--- Süreç --->
    <cffunction name="GET_PROCESS_STAGE" access="public" returntype="query">
        <cfargument name="upd_myweek">
        <cfquery name="GET_PROCESS_STAGE" datasource="#dsn#">
            SELECT
                PTR.STAGE,
                PTR.PROCESS_ROW_ID,
                PT.IS_STAGE_BACK,
                PTR.LINE_NUMBER
            FROM
                PROCESS_TYPE_ROWS PTR,
                PROCESS_TYPE_OUR_COMPANY PTO,
                PROCESS_TYPE PT
            WHERE
                PT.IS_ACTIVE = 1 AND
                PT.PROCESS_ID = PTR.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.upd_myweek#%">
                <cfif isDefined("arguments.process_stage") and len(arguments.process_stage)>
                    AND PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
                </cfif>
            ORDER BY
                PTR.LINE_NUMBER
        </cfquery>
        <cfreturn GET_PROCESS_STAGE>
    </cffunction>
    <!--- Zaman Harcaması --->
    <cffunction name="GET_TIME_COST" access="public" returntype="query">
        <cfargument name="next_week">
        <cfargument name="to_day">
        <cfquery name="GET_TIME_COST" datasource="#DSN#">
            SELECT 
                TCO.*,
                PTR.LINE_NUMBER,
                (SELECT PP.PROJECT_HEAD FROM PRO_PROJECTS PP WHERE PP.PROJECT_ID = TCO.PROJECT_ID) PROJECT_HEAD,
                (SELECT PW.WORK_HEAD FROM PRO_WORKS PW WHERE PW.WORK_ID = TCO.WORK_ID) WORK_HEAD,
                (SELECT EC.EXPENSE FROM #dsn2_alias#.EXPENSE_CENTER EC WHERE EC.EXPENSE_ID = TCO.EXPENSE_ID) EXPENSE,
                (SELECT SERVICE.SERVICE_NO FROM #dsn3_alias#.SERVICE WHERE SERVICE.SERVICE_ID = TCO.SERVICE_ID) SERVICE_HEAD,
                (SELECT EVENT.EVENT_HEAD FROM EVENT WHERE EVENT.EVENT_ID = TCO.EVENT_ID) EVENT_HEAD,
                (SELECT SC.SUBSCRIPTION_NO FROM #dsn3_alias#.SUBSCRIPTION_CONTRACT SC WHERE SC.SUBSCRIPTION_ID = TCO.SUBSCRIPTION_ID) SUBSCRIPTION_NO,
                (SELECT TC.CLASS_NAME FROM TRAINING_CLASS TC WHERE TC.CLASS_ID = TCO.CLASS_ID) CLASS_NAME
            FROM 
                TIME_COST TCO
                LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = TCO.TIME_COST_STAGE
            WHERE 
                TCO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
                TCO.EVENT_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('h',-session.ep.time_zone,arguments.next_week)#"> AND
                TCO.EVENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.to_day#">
            ORDER BY
                TCO.EVENT_DATE
        </cfquery>
        <cfreturn GET_TIME_COST>
    </cffunction>
    <!--- Çalışan Maliyeti Hesaplaması için --->
    <cffunction name="GET_HOURLY_SALARY" access="public" returntype="query">
        <cfquery name="GET_HOURLY_SALARY" datasource="#dsn#">
            SELECT 
                ISNULL(ON_MALIYET,0) ON_MALIYET,
                ISNULL(ON_HOUR,0) ON_HOUR 
            FROM 
                EMPLOYEE_POSITIONS 
            WHERE 
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> 
                AND IS_MASTER = 1
        </cfquery>
        <cfreturn GET_HOURLY_SALARY>
    </cffunction>
    <cffunction name="GET_IN_OUT_ID" access="public" returntype="query">
        <cfquery name="GET_IN_OUT_ID" datasource="#dsn#">
            SELECT 
                EIO.IN_OUT_ID,
                PUANTAJ_GROUP_IDS,
                BRANCH_ID
            FROM
                EMPLOYEES_IN_OUT EIO
            WHERE
                EIO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND 
                (
                    (EIO.FINISH_DATE IS NULL AND EIO.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
                    OR
                    (
                    EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    )
                )
        </cfquery>
        <cfreturn GET_IN_OUT_ID>
    </cffunction>
    <cffunction name="UPD_TIME_COST" access="public" returntype="any">
        <cfargument name="topson">
        <cfargument name="para"> 
        <cfargument name="total_min">
        <cfargument name="form_work_id"> 
        <cfargument name="form_cus_help_id">
        <cfargument name="form_service_id"> 
        <cfargument name="form_event_id">
        <cfargument name="form_partner_id"> 
        <cfargument name="form_company_id">
        <cfargument name="form_consumer_id"> 
        <cfargument name="form_expense_id">
        <cfargument name="form_project_id"> 
        <cfargument name="form_project"> 
        <cfargument name="form_subscription_id">
        <cfargument name="form_class_id">
        <cfargument name="form_comment">
        <cfargument name="form_is_rd_ssk">
        <cfargument name="today">
        <cfargument name="form_overtime_type"> 
        <cfargument name="form_time_cost_stage">
        <cfargument name="form_time_cost_cat"> 
        <cfargument name="form_activity_id">
        <cfargument name="form_time_cost_id">
        <cfargument name="form_member_name">
        <cfargument name="form_expense">
        <cfargument name="form_work_head">  
        <cfargument name="form_service_head">
        <cfargument name="form_event_head">
        <cfargument name="form_subscription_no">
        <cfargument name="form_class_name">
        <cfquery name="UPD_TIME_COST" datasource="#dsn#">
            UPDATE 
                TIME_COST
            SET
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
                TOTAL_TIME = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.topson#">,
                EXPENSED_MONEY = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.para#">,
                EXPENSED_MINUTE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.total_min#">,
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                WORK_ID = <cfif len(arguments.form_work_id) and len(arguments.form_work_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_work_id#"><cfelse>NULL</cfif>,
                CUS_HELP_ID = <cfif Len(arguments.form_cus_help_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_cus_help_id#"><cfelse>NULL</cfif>,
                SERVICE_ID = <cfif len(arguments.form_service_id) and len(arguments.form_service_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_service_id#"><cfelse>NULL</cfif>,
                EVENT_ID = <cfif len(arguments.form_event_id) and len(arguments.form_event_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_event_id#"><cfelse>NULL</cfif>,
                PARTNER_ID = <cfif len(arguments.form_partner_id) and len(arguments.form_member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_partner_id#"><cfelse>NULL</cfif>,
                COMPANY_ID = <cfif len(arguments.form_company_id) and len(arguments.form_member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_company_id#"><cfelse>NULL</cfif>,
                CONSUMER_ID = <cfif len(arguments.form_consumer_id) and len(arguments.form_member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_consumer_id#"><cfelse>NULL</cfif>,
                EXPENSE_ID = <cfif len(arguments.form_expense_id) and len(arguments.form_expense)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_expense_id#"><cfelse>NULL</cfif>,
                PROJECT_ID = <cfif isdefined("arguments.form_project_id") and len(arguments.form_project_id) and isdefined("arguments.form_project") and len(arguments.form_project)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_project_id#"><cfelse>NULL</cfif>,
                SUBSCRIPTION_ID = <cfif len(arguments.form_subscription_id) and len(arguments.form_subscription_no)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_subscription_id#"><cfelse>NULL</cfif>,
                CLASS_ID = <cfif len(arguments.form_class_id) and len(arguments.form_class_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_class_id#"><cfelse>NULL</cfif>,
                COMMENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.form_comment#">,
                IS_RD_SSK = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_is_rd_ssk#">,
                EVENT_DATE =  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.today#">,
                OVERTIME_TYPE = <cfif len(arguments.form_overtime_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_overtime_type#"><cfelse>NULL</cfif>,
                TIME_COST_STAGE = <cfif len(arguments.form_time_cost_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_time_cost_stage#"><cfelse>NULL</cfif>,
                TIME_COST_CAT_ID = <cfif len(arguments.form_time_cost_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_time_cost_cat#"><cfelse>NULL</cfif>,
                ACTIVITY_ID = <cfif len(arguments.form_activity_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_activity_id#"><cfelse>NULL</cfif>,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            WHERE 
                TIME_COST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_time_cost_id#">
        </cfquery>
    </cffunction>
    <cffunction name="ADD_TIME_COST" access="public" returntype="any">
        <cfargument name="topson">
        <cfargument name="para"> 
        <cfargument name="total_min">
        <cfargument name="form_work_id"> 
        <cfargument name="form_cus_help_id">
        <cfargument name="form_service_id"> 
        <cfargument name="form_event_id">
        <cfargument name="form_partner_id"> 
        <cfargument name="form_company_id">
        <cfargument name="form_consumer_id"> 
        <cfargument name="form_expense_id">
        <cfargument name="form_project_id"> 
        <cfargument name="form_subscription_id">
        <cfargument name="form_class_id">
        <cfargument name="form_comment">
        <cfargument name="form_is_rd_ssk">
        <cfargument name="today">
        <cfargument name="form_overtime_type"> 
        <cfargument name="form_time_cost_stage">
        <cfargument name="form_time_cost_cat"> 
        <cfargument name="form_activity_id">
        <cfargument name="form_time_cost_id">
        <cfargument name="form_member_name">
        <cfargument name="form_expense">
        <cfargument name="form_work_head">  
        <cfargument name="form_service_head">
        <cfargument name="form_event_head">
        <cfargument name="form_subscription_no">
        <cfargument name="form_class_name">
        <cfargument name="form_project">
        <cfquery name="ADD_TIME_COST" datasource="#dsn#">
            INSERT INTO
                TIME_COST
            (
                OUR_COMPANY_ID,
                TOTAL_TIME,
                EXPENSED_MONEY,
                EXPENSED_MINUTE,
                EMPLOYEE_ID,
                WORK_ID,
                CUS_HELP_ID,
                SERVICE_ID,
                EVENT_ID,
                PROJECT_ID,
                SUBSCRIPTION_ID,
                CLASS_ID,
                PARTNER_ID,
                COMPANY_ID,
                CONSUMER_ID,
                EXPENSE_ID,
                COMMENT,
                IS_RD_SSK,
                EVENT_DATE,
                OVERTIME_TYPE,
                TIME_COST_STAGE,
                TIME_COST_CAT_ID,
                ACTIVITY_ID,
                STATE,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
                <cfqueryparam cfsqltype="cf_sql_float" value="#topson#">,
                <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.para#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.total_min#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfif len(arguments.form_work_id) and len(form_work_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_work_id#"><cfelse>NULL</cfif>,
                <cfif Len(arguments.form_cus_help_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_cus_help_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.form_service_id) and len(form_service_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_service_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.form_event_id) and len(form_event_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_event_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.form_project_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_project_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.form_subscription_id) and len(form_subscription_no)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_subscription_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.form_class_id) and len(form_class_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_class_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.form_partner_id) and len(form_member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_partner_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.form_company_id) and len(form_member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_company_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.form_consumer_id) and len(form_member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_consumer_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.form_expense_id) and len(form_expense)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_expense_id#"><cfelse>NULL</cfif>,
                <cfif len(arguments.form_comment)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.form_comment#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_is_rd_ssk#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.today#">,
                <cfif len(arguments.form_overtime_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_overtime_type#"><cfelse>NULL</cfif>,
                <cfif len(arguments.form_time_cost_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_time_cost_stage#"><cfelse>NULL</cfif>,
                <cfif len(arguments.form_time_cost_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_time_cost_cat#"><cfelse>NULL</cfif>,
                <cfif len(arguments.form_activity_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.form_activity_id#"><cfelse>NULL</cfif>,
                1,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            )
        </cfquery>
    </cffunction>
</cfcomponent>