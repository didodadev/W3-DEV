<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cffunction name="Select" access="public">
        <cfquery name="GET_otv" datasource="#dsn3#">
            SELECT 
                otv_ID,
                TAX,
                DETAIL,
                ACCOUNT_CODE,
                PURCHASE_CODE,
                ACCOUNT_CODE_IADE,
                PURCHASE_CODE_IADE,
                PERIOD_ID,
                TAX_CODE,
                TAX_TYPE
            FROM
                SETUP_otv
            WHERE
                PERIOD_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#">
        </cfquery>
        <cfreturn GET_otv>
    </cffunction>

    <cffunction name="SelectID" access="public">
        <cfargument name="otv_ID" type="numeric" default="">
        <cfquery name="CATEGORY" datasource="#dsn3#">
            SELECT 
                * 
            FROM 
                SETUP_otv 
            WHERE 
                1=1
                <cfif isDefined('arguments.otv_ID') and len(arguments.otv_ID)>
                    AND otv_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.otv_ID#">
                </cfif>
        </cfquery>
        <cfreturn CATEGORY>
    </cffunction> 

    <cffunction name="INSERT" access="public" returnType="any">
        <cfargument name="ACCOUNT_CODE" type="string" default="">
        <cfargument name="ACCOUNT_CODE_P" type="string" default="">
        <cfargument name="ACCOUNT_CODE_IADE" type="string" default="">
        <cfargument name="ACCOUNT_CODE_P_IADE" type="string" default="">
        <cfargument name="ACCOUNT_CODE_DISCOUNT" type="string" default="">
        <cfargument name="ACCOUNT_CODE_P_DISCOUNT" type="string" default="">
        <cfargument name="tax" type="numeric" default="">
        <cfargument name="tax_code" type="string" default="">
        <cfargument name="tax_code_name" type="string" default="">
        <cfargument name="DETAIL" type="string" default="">
        <cfargument name="tax_type" type="numeric" default="">

        <cfquery name="ADD_otv" datasource="#DSN3#" result="result">
            INSERT INTO 
                SETUP_otv 
            (
                ACCOUNT_CODE,
                PURCHASE_CODE,
                ACCOUNT_CODE_IADE,
                PURCHASE_CODE_IADE,
                ACCOUNT_CODE_DISCOUNT,
                ACCOUNT_CODE_P_DISCOUNT,
                TAX,
                TAX_CODE,
                TAX_CODE_NAME,
                DETAIL,
                PERIOD_ID,
                RECORD_IP,
                RECORD_DATE,
                RECORD_EMP,
                TAX_TYPE
            ) 
            VALUES 
            (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_P#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_IADE#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_P_IADE#">,
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.ACCOUNT_CODE_DISCOUNT#">,
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.ACCOUNT_CODE_P_DISCOUNT#">,
                <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.tax#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(arguments.tax_code)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tax_code_name#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DETAIL#">,
                #SESSION.EP.PERIOD_ID#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                #now()#,
                #session.ep.userid#,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tax_type#">

            )
        </cfquery>
        <cfset response = result>
		<cfreturn response>
    </cffunction>

    <cffunction name="Update" access="public">
        <cfargument name="OTV_ID" type="numeric" default="">
        <cfargument name="ACCOUNT_CODE" type="string" default="">
        <cfargument name="ACCOUNT_CODE_P" type="string" default="">
        <cfargument name="ACCOUNT_CODE_IADE" type="string" default="">
        <cfargument name="ACCOUNT_CODE_P_IADE" type="string" default="">
        <cfargument name="tax" default="">
        <cfargument name="tax_code" type="string" default="">
        <cfargument name="tax_code_name" type="string" default="">
        <cfargument name="DETAIL" type="string" default="">
        <cfargument name="tax_type" type="numeric" default="">
        <cfquery name="UPD_otv" datasource="#DSN3#">
            UPDATE 
                SETUP_otv
            SET 
                ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE#">,
                PURCHASE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_P#">,
                ACCOUNT_CODE_IADE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_IADE#">,
                PURCHASE_CODE_IADE  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_P_IADE#">,
                ACCOUNT_CODE_DISCOUNT = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.ACCOUNT_CODE_DISCOUNT#">,
                ACCOUNT_CODE_P_DISCOUNT = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.ACCOUNT_CODE_P_DISCOUNT#">,
                TAX = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.tax#">,
                TAX_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tax_code#">,
                TAX_CODE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tax_code_name#">,
                DETAIL = <cfif len(arguments.DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DETAIL#">,<cfelse>NULL,</cfif>
                PERIOD_ID = #SESSION.EP.PERIOD_ID#,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_DATE = #now()#,
                UPDATE_EMP = #session.ep.userid#,
                TAX_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tax_type#">

            WHERE
                otv_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.otv_ID#">
        </cfquery>
    </cffunction>

    <cffunction name="Delete" access="public">
        <cfargument name="otv_ID" type="numeric" default="">
        <cfquery name="DEL_otv" datasource="#DSN3#">
            DELETE
            FROM
                SETUP_otv
            WHERE
                otv_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.otv_ID#">
        </cfquery>
    </cffunction>
</cfcomponent>