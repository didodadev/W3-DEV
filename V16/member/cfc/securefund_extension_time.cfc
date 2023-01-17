<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2= "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cfset dsn3_alias = "#dsn3#">
    <cfset dsn2_alias = "#dsn2#">

    <cffunction name="ADD_SECUREFUND_EXTENSION_TIME" access="remote" returnFormat="json" returntype="any">       
        <cfargument name="securefund_id" default="">
        <cfargument name="process_cat" default="">
        <cfargument name="detail" default="">
        <cfargument name="rd_money" default="">
        <cfargument name="expense_total" default="">
        <cfargument name="money_cat_expense" default="">
        <cfargument name="commission_rate" default="">
        <cfargument name="extension_time_finish_date" default="">
        <cfquery datasource="#dsn#" result="MAX_ID">       
            INSERT INTO SECUREFUND_EXTENSION_TIME
            (   SECUREFUND_ID
                ,ACTION_CAT_ID
                ,DETAIL
                ,MONEY_CAT
                ,EXPENSE_TOTAL
                ,MONEY_CAT_EXPENSE
                ,COMMISSION_RATE
                ,EXTENSION_TIME_FINISH_DATE
                ,RECORD_DATE
                ,RECORD_EMP
                ,RECORD_IP
            )
            VALUES
            (
                <cfif isdefined("arguments.securefund_id") and len(arguments.securefund_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.securefund_id#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.process_cat") and len(arguments.process_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#"><cfelse>NULL</cfif>,  
                <cfif isdefined("arguments.detail") and len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>,  
                <cfif isdefined("arguments.rd_money") and len(arguments.rd_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rd_money#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.expense_total") and len(arguments.expense_total)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.expense_total#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.money_cat_expense") and len(arguments.money_cat_expense)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.money_cat_expense#"><cfelse>NULL</cfif>,
                <cfif isdefined("arguments.commission_rate") and len(arguments.commission_rate)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.commission_rate#"><cfelse>NULL</cfif>,  
                <cfif isdefined("arguments.extension_time_finish_date") and len(arguments.extension_time_finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.extension_time_finish_date#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateTimeFormat(now())#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            )           
        </cfquery>
        <cfreturn Replace( serializeJSON(MAX_ID.IDENTITYCOL), "//", "" ) />
    </cffunction>
    <cffunction name="UPD_SECUREFUND" access="remote" returnFormat="json" returntype="any">       
        <cfargument name="securefund_id" default="">
        <cfargument name="extension_time_finish_date" default="">
        <cfquery name="UPD_SECUREFUND" datasource="#dsn#" result="MAX_ID">       
            UPDATE COMPANY_SECUREFUND SET EXTENSION_TIME_FINISH_DATE = <cfif isdefined("arguments.extension_time_finish_date") and len(arguments.extension_time_finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.extension_time_finish_date#"><cfelse>NULL</cfif>
            WHERE 
            SECUREFUND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.securefund_id#">     
        </cfquery>
    </cffunction>
    <cffunction name="UPD_SECUREFUND_EXTENSION_TIME" access="remote" returntype="any">       
        <cfargument name="extension_securefund_time_id" default="">
        <cfargument name="process_cat" default="">
        <cfargument name="detail" default="">
        <cfargument name="rd_money" default="">
        <cfargument name="expense_total" default="">
        <cfargument name="money_cat_expense" default="">
        <cfargument name="commission_rate" default="">
        <cfargument name="extension_time_finish_date" default="">
        <cfquery datasource="#dsn#" name="upd_securefund_extension_time">       
            UPDATE SECUREFUND_EXTENSION_TIME
            SET ACTION_CAT_ID = <cfif isdefined("arguments.process_cat") and len(arguments.process_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#"><cfelse>NULL</cfif>,
                DETAIL = <cfif isdefined("arguments.detail") and len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#"><cfelse>NULL</cfif>,  
                MONEY_CAT = <cfif isdefined("arguments.rd_money") and len(arguments.rd_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rd_money#"><cfelse>NULL</cfif>,
                EXPENSE_TOTAL = <cfif isdefined("arguments.expense_total") and len(arguments.expense_total)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.expense_total#"><cfelse>NULL</cfif>,
                MONEY_CAT_EXPENSE = <cfif isdefined("arguments.money_cat_expense") and len(arguments.money_cat_expense)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.money_cat_expense#"><cfelse>NULL</cfif>,
                COMMISSION_RATE = <cfif isdefined("arguments.commission_rate") and len(arguments.commission_rate)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.commission_rate#"><cfelse>NULL</cfif>,  
                EXTENSION_TIME_FINISH_DATE = <cfif isdefined("arguments.extension_time_finish_date") and len(arguments.extension_time_finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.extension_time_finish_date#"><cfelse>NULL</cfif>,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateTimeFormat(now())#">,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            WHERE SECUREFUND_EXTENSION_TIME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.extension_securefund_time_id#">               
        </cfquery>
    </cffunction>
    <cffunction name="get_securefund_extension" access="remote">
        <cfargument name="extension_securefund_id" default="">
        <cfquery name="get_securefund_extension" datasource="#dsn#">
            SELECT * FROM SECUREFUND_EXTENSION_TIME WHERE SECUREFUND_EXTENSION_TIME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.extension_securefund_id#"> 
        </cfquery>
        <cfreturn get_securefund_extension>
    </cffunction>
    <cffunction name="get_securefund_extension_time" access="remote">
        <cfargument name="securefund_id" default="">
        <cfquery name="get_securefund_extension_time" datasource="#dsn#">
            SELECT * FROM SECUREFUND_EXTENSION_TIME WHERE SECUREFUND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.securefund_id#"> 
        </cfquery>
        <cfreturn get_securefund_extension_time>
    </cffunction>
    <cffunction name="DEL_SECUREFUND_EXTENSION" access="remote">
        <cfargument name="extension_securefund_id" default="">
        <cfquery name="DEL_SECUREFUND_EXTENSION" datasource="#dsn#">
            DELETE FROM SECUREFUND_EXTENSION_TIME WHERE SECUREFUND_EXTENSION_TIME_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.extension_securefund_id#"> 
        </cfquery>
        <script>
            location.href=document.referrer;
        </script>
    </cffunction>
    <cffunction name="get_process_type" access="remote">
        <cfargument name="process_cat" default="">
        <cfquery name="get_process_type" datasource="#dsn#">
            SELECT 
                PROCESS_TYPE,
                IS_ACCOUNT,
                IS_CARI,
                IS_ACCOUNT_GROUP,
                ACTION_FILE_NAME,
                ACTION_FILE_FROM_TEMPLATE
             FROM 
                 #dsn3_alias#.SETUP_PROCESS_CAT 
            WHERE 
                PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#"> 
        </cfquery>
        <cfreturn get_process_type>
    </cffunction>
    <cffunction name="get_process_cat" access="remote">
        <cfargument name="action_cat_id" default="">
        <cfquery name="get_process_cat" datasource="#dsn3#">
            SELECT PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #arguments.action_cat_id#
        </cfquery>
        <cfreturn get_process_cat>
    </cffunction>
    <cffunction name="GET_COMPANY_SECUREFUND" access="remote">
        <cfargument name="securefund_id" default="">
        <cfquery name="GET_COMPANY_SECUREFUND" datasource="#DSN#">
            SELECT * FROM COMPANY_SECUREFUND WHERE SECUREFUND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SECUREFUND_ID#">
        </cfquery>
        <cfreturn GET_COMPANY_SECUREFUND>
    </cffunction>
    <cffunction name="GET_MONEY" access="remote">
        <cfquery name="GET_MONEY" datasource="#dsn2#">
            SELECT * FROM SETUP_MONEY WHERE MONEY_STATUS = 1 ORDER BY MONEY
        </cfquery>
        <cfreturn GET_MONEY>
    </cffunction>
</cfcomponent>