-<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = '#dsn#_product'>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>

    <cffunction name="GetEArchiveIntegrationInfo" access="public" hint="E-arsiv entegrasyon bilgileri">
        <cfquery name="query_integrationinfo" datasource="#dsn2#">
            SELECT
                EARCHIVE_TEST_SYSTEM AS EARSIV_TEST_SYSTEM,
                'https://efaturatest.doganedonusum.com/' AS EARSIV_TEST_URL,
                'https://connector.doganedonusum.com/' AS EARSIV_LIVE_URL
            FROM
                #dsn#.EARCHIVE_INTEGRATION_INFO
            WHERE
                COMP_ID = #session.ep.company_id#
        </cfquery>
        
        <cfreturn query_integrationinfo>
    </cffunction>

    <cffunction name="GetAuthorizationVars" access="public">
        <cfquery name="get_authorizaton" datasource="#dsn2#">
            SELECT
                EARCHIVE_COMPANY_CODE AS EARSIV_COMPANY_CODE,
                EARCHIVE_USERNAME AS EARSIV_USER_NAME,
                EARCHIVE_PASSWORD AS EARSIV_PASSWORD
            FROM
                #dsn#.EARCHIVE_INTEGRATION_INFO
            WHERE
                COMP_ID = #session.ep.company_id#
        </cfquery>
        <cfset authvars = structNew()>
        <cfset authvars.corporateCode = "#get_authorizaton.EARSIV_COMPANY_CODE#">
        <cfset authvars.loginName = "#get_authorizaton.EARSIV_USER_NAME#">
        <cfset authvars.password = "#get_authorizaton.EARSIV_PASSWORD#">

        <cfreturn authvars>
    </cffunction>

    <cffunction name="addEarchiveSendingDetail" access="public" returntype="any">
    	<cfargument name="zip_file_name" type="string" required="no">
        <cfargument name="service_result" type="string" required="no">
        <cfargument name="uuid" type="string" required="no">
        <cfargument name="earchive_id" type="string" required="no">
        <cfargument name="status_description" type="string" required="no">
        <cfargument name="service_result_description" type="string" required="no">
        <cfargument name="status_code" type="string" required="no">
        <cfargument name="error_code" type="string" required="no">
        <cfargument name="output_type" type="string" required="no">
        <cfargument name="action_id" type="numeric" required="no">
        <cfargument name="action_type" type="string" required="no">
        <cfargument name="earchive_sending_type" type="string" required="no">
        <cfargument name="invoice_type_code" type="string" required="no">
        
    	<cfquery name="INS_EARCHIVE" datasource="#dsn2#">
                INSERT INTO
                    EARCHIVE_SENDING_DETAIL
                (
                    <cfif isdefined("arguments.zip_file_name")>ZIP_FILE_NAME,</cfif>
                    SERVICE_RESULT,
                    <cfif isdefined("arguments.uuid")>UUID,</cfif>
                    EARCHIVE_ID,
                    STATUS_DESCRIPTION,
                    SERVICE_RESULT_DESCRIPTION,
                    <cfif isdefined("arguments.status_code")>STATUS_CODE,</cfif>
                    ERROR_CODE,
                    ACTION_ID,
                    ACTION_TYPE,
                    <cfif isDefined("arguments.output_type")>OUTPUT_TYPE,</cfif>
                    EARCHIVE_SENDING_TYPE,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP,
                    INVOICE_TYPE_CODE
                )
                VALUES
                (
                    <cfif isdefined("arguments.zip_file_name")><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.zip_file_name#">,</cfif>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.service_result#">,
                    <cfif isdefined("arguments.uuid")><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.uuid#">,</cfif>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.earchive_id#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status_description#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(arguments.service_result_description,1000)#">,
                    <cfif isdefined("arguments.status_code")><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status_code#">,</cfif>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.error_code#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#">,
                    <cfif isdefined("arguments.output_type")><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.output_type#">,</cfif>
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.earchive_sending_type#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.invoice_type_code#">
                )
           </cfquery> 
    </cffunction>
    
    <cffunction name="addEarchiveRelation" access="public" returntype="any">
    	<cfargument name="status_description" type="string" required="no">
        <cfargument name="uuid" type="string" required="no">
        <cfargument name="integration_id" type="string" required="no">
        <cfargument name="earchive_id" type="string" required="no">
        <cfargument name="action_id" type="numeric" required="no">
        <cfargument name="action_type" type="string" required="no">
    	<cfargument name="path" type="string" required="no">
        <cfargument name="sender_type" type="string" required="no">
        <cfargument name="earchive_sending_type" type="numeric" required="no">
        <cfargument name="is_internet" type="numeric" required="no">
        
        <cfquery name="INS_EARCHIVE" datasource="#dsn2#">
            INSERT INTO
                EARCHIVE_RELATION
            (
                STATUS_DESCRIPTION,
                UUID,
                INTEGRATION_ID,
                EARCHIVE_ID,
                ACTION_ID,
                ACTION_TYPE,
                PATH,
                SENDER_TYPE,
                EARCHIVE_SENDING_TYPE,
                IS_INTERNET,
                STATUS,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status_description#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.uuid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.integration_id#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.earchive_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sender_type#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.earchive_sending_type#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_internet#">,
                <cfif arguments.sender_type eq 3>NULL,<cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="1">,</cfif>
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            )
        </cfquery>
    </cffunction>

    <cffunction name="getEarchiveSendingType" access="public" returntype="any">
    	<cfargument name="action_id" type="numeric" required="yes">
        <cfargument name="action_type" type="string" required="yes">

        <cfquery name = "get_invoice" datasource="#dsn2#">
            SELECT
                ISNULL(COM.EARCHIVE_SENDING_TYPE,CON.EARCHIVE_SENDING_TYPE) AS EARCHIVE_SENDING_TYPE,
                CASE WHEN SPC.IS_PARTNER = 1 OR SPC.IS_PUBLIC = 1 THEN 1 ELSE 0 END IS_INTERNET
            FROM
                #dsn2#.INVOICE I
                    LEFT JOIN #dsn#.COMPANY COM ON COM.COMPANY_ID = I.COMPANY_ID
                    LEFT JOIN #dsn#.CONSUMER CON ON CON.CONSUMER_ID = I.CONSUMER_ID
                    LEFT JOIN #dsn3#.SETUP_PROCESS_CAT SPC ON SPC.PROCESS_CAT_ID = I.PROCESS_CAT
            WHERE
                I.INVOICE_ID = #arguments.action_id#
                AND '#arguments.action_type#' = 'INVOICE'

            UNION ALL

            SELECT
                ISNULL(COM.EARCHIVE_SENDING_TYPE,CON.EARCHIVE_SENDING_TYPE) AS EARCHIVE_SENDING_TYPE,
                CASE WHEN SPC.IS_PARTNER = 1 OR SPC.IS_PUBLIC = 1 THEN 1 ELSE 0 END IS_INTERNET
            FROM
                #dsn2#.EXPENSE_ITEM_PLANS I
                    LEFT JOIN #dsn#.COMPANY COM ON COM.COMPANY_ID = I.CH_COMPANY_ID
                    LEFT JOIN #dsn#.CONSUMER CON ON CON.CONSUMER_ID = I.CH_CONSUMER_ID
                    LEFT JOIN #dsn3#.SETUP_PROCESS_CAT SPC ON SPC.PROCESS_CAT_ID = I.PROCESS_CAT
            WHERE
                I.EXPENSE_ID = #arguments.action_id#
                AND '#arguments.action_type#' = 'EXPENSE_ITEM_PLANS'
        </cfquery>

        <cfreturn get_invoice>
    </cffunction>
</cfcomponent>