<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cffunction name="Select" access="public">
        <cfquery name="GET_OIV" datasource="#dsn3#">
            SELECT 
                OIV_ID,
                TAX,
                DETAIL,
                ACCOUNT_CODE,
                PURCHASE_CODE,
                ACCOUNT_CODE_IADE,
                PURCHASE_CODE_IADE,
                PERIOD_ID,
                TAX_CODE
            FROM
                SETUP_OIV
            WHERE
                PERIOD_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#">
        </cfquery>
        <cfreturn GET_OIV>
    </cffunction>

    <cffunction name="SelectID" access="public">
        <cfargument name="OIV_ID" type="numeric" default="">
        <cfquery name="CATEGORY" datasource="#dsn3#">
                SELECT
                    *
                FROM
                    SETUP_OIV
                WHERE
                    1=1
                    <cfif isDefined('arguments.OIV_ID') and len(arguments.OIV_ID)>
                        AND OIV_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.OIV_ID#">
                    </cfif>
        </cfquery>
        <cfreturn CATEGORY>
    </cffunction> 

    <cffunction name="INSERT" access="public" returnType="any">
        <cfargument name="ACCOUNT_CODE" type="string" default="">
        <cfargument name="ACCOUNT_CODE_P" type="string" default="">
        <cfargument name="ACCOUNT_CODE_IADE" type="string" default="">
        <cfargument name="ACCOUNT_CODE_P_IADE" type="string" default="">
        <cfargument name="tax" type="numeric" default="">
        <cfargument name="tax_code" type="string" default="">
        <cfargument name="DETAIL" type="string" default="">
        <cfargument name="tax_code_name" type="string" default="">
        <cfquery name="ADD_OIV" datasource="#DSN3#" result="result">
            INSERT INTO
                SETUP_OIV
            (
                ACCOUNT_CODE,
                PURCHASE_CODE,
                ACCOUNT_CODE_IADE,
                PURCHASE_CODE_IADE,
                TAX,
                TAX_CODE,
                DETAIL,
                PERIOD_ID,
                RECORD_IP,
                RECORD_DATE,
                RECORD_EMP,
                TAX_CODE_NAME
            ) 
            VALUES 
            (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_P#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_IADE#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_P_IADE#">,
                <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.tax#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(arguments.tax_code)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DETAIL#">,
                #SESSION.EP.PERIOD_ID#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                #now()#,
                #session.ep.userid#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tax_code_name#">
            )
        </cfquery>
        <cfset response = result>
		<cfreturn response>
    </cffunction>
    <cffunction  name="Update" access="public">
        <cfargument name="OIV_ID" type="numeric" default="">
        <cfargument name="ACCOUNT_CODE" type="string" default="">
        <cfargument name="ACCOUNT_CODE_P" type="string" default="">
        <cfargument name="ACCOUNT_CODE_IADE" type="string" default="">
        <cfargument name="ACCOUNT_CODE_P_IADE" type="string" default="">
        <cfargument name="tax" default="">
        <cfargument name="tax_code" type="string" default="">
        <cfargument name="tax_code_name" type="string" default="">
        <cfargument name="DETAIL" type="string" default="">
        <cfquery name="UPD_OIV" datasource="#DSN3#">
            UPDATE
                SETUP_OIV
            SET
                ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE#">,
                PURCHASE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_P#">,
                ACCOUNT_CODE_IADE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_IADE#">,
                PURCHASE_CODE_IADE  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_P_IADE#">,
                TAX = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.tax#">,
                TAX_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tax_code#">,
                TAX_CODE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tax_code_name#">,
                DETAIL = <cfif len(arguments.DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DETAIL#">,<cfelse>NULL,</cfif>
                PERIOD_ID = #SESSION.EP.PERIOD_ID#,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_DATE = #now()#,
                UPDATE_EMP = #session.ep.userid#
            WHERE
                OIV_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.OIV_ID#">
        </cfquery>
    </cffunction>
</cfcomponent>