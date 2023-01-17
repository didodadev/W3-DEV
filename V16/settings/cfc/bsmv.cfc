<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cffunction name="Select" access="public">
        <cfquery name="GET_BSMV" datasource="#dsn3#">
            SELECT 
                BSMV.BSMV_ID,
                BSMV.TAX,
                BSMV.DETAIL,
                BSMV.ACCOUNT_CODE,
                BSMV.PURCHASE_CODE,
                BSMV.ACCOUNT_CODE_IADE,
                BSMV.PURCHASE_CODE_IADE,
                BSMV.DIRECT_EXPENSE_CODE,
                BSMV.PERIOD_ID,
                BSMV.TAX_CODE,
                EXP_ITEM.EXPENSE_ITEM_ID,
                EXP_ITEM.EXPENSE_ITEM_NAME
            FROM
                SETUP_BSMV AS BSMV
                LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXP_ITEM ON BSMV.EXPENSE_ITEM_ID = EXP_ITEM.EXPENSE_ITEM_ID
            WHERE
                BSMV.PERIOD_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#">
        </cfquery>
        <cfreturn GET_BSMV>
    </cffunction>
    <cffunction name="SelectID" access="public">
        <cfargument name="BSMV_ID" type="numeric" default="">
        <cfquery name="CATEGORY" datasource="#dsn3#">
            SELECT 
                BSMV.*,
                EXP_ITEM.EXPENSE_ITEM_ID,
                EXP_ITEM.EXPENSE_ITEM_NAME
            FROM 
                SETUP_BSMV AS BSMV
                LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXP_ITEM ON BSMV.EXPENSE_ITEM_ID = EXP_ITEM.EXPENSE_ITEM_ID
            WHERE 
                1=1
                <cfif isDefined('arguments.BSMV_ID') and len(arguments.BSMV_ID)>
                    AND BSMV.BSMV_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.BSMV_ID#">
                </cfif>
        </cfquery>
        <cfreturn CATEGORY>
    </cffunction> 
    <cffunction name="INSERT" access="public" returnType="any">
        <cfargument name="ACCOUNT_CODE" type="string" default="">
        <cfargument name="ACCOUNT_CODE_P" type="string" default="">
        <cfargument name="ACCOUNT_CODE_IADE" type="string" default="">
        <cfargument name="ACCOUNT_CODE_P_IADE" type="string" default="">
        <cfargument name="EXPENSE_ITEM_ID" type="string" default="">
        <cfargument name="tax" type="numeric" default="">
        <cfargument name="tax_code" type="string" default="">
        <cfargument name="tax_code_name" type="string" required="true" default="" />
        <cfargument name="DETAIL" type="string" default="">
        <cfquery name="ADD_BSMV" datasource="#DSN3#" result="result">
            INSERT INTO 
                SETUP_BSMV 
            (
                ACCOUNT_CODE,
                PURCHASE_CODE,
                ACCOUNT_CODE_IADE,
                PURCHASE_CODE_IADE,
                DIRECT_EXPENSE_CODE,
                EXPENSE_ITEM_ID,
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
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_DIRECT_EXPENSE#">,
                <cfif len( arguments.EXPENSE_ITEM_ID )><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EXPENSE_ITEM_ID#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.tax#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tax_code#">,
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
    <cffunction name="Update" access="public">
        <cfargument name="BSMV_ID" type="numeric" default="">
        <cfargument name="ACCOUNT_CODE" type="string" default="">
        <cfargument name="ACCOUNT_CODE_P" type="string" default="">
        <cfargument name="ACCOUNT_CODE_IADE" type="string" default="">
        <cfargument name="ACCOUNT_CODE_P_IADE" type="string" default="">
        <cfargument name="ACCOUNT_CODE_DIRECT_EXPENSE" type="string" default="">
        <cfargument name="EXPENSE_ITEM_ID" type="string" default="">
        <cfargument name="tax" default="">
        <cfargument name="tax_code" type="string" default="">
        <cfargument name="tax_code_name" type="string" default="">
        <cfargument name="DETAIL" type="string" default="">
        <cfquery name="UPD_BSMV" datasource="#DSN3#">
            UPDATE 
                SETUP_BSMV
            SET 
                ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE#">,
                PURCHASE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_P#">,
                ACCOUNT_CODE_IADE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_IADE#">,
                PURCHASE_CODE_IADE  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_P_IADE#">,
                DIRECT_EXPENSE_CODE  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ACCOUNT_CODE_DIRECT_EXPENSE#">,
                EXPENSE_ITEM_ID = <cfif len( arguments.EXPENSE_ITEM_ID )><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EXPENSE_ITEM_ID#"><cfelse>NULL</cfif>,
                TAX = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.tax#">,
                TAX_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tax_code#">,
                TAX_CODE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tax_code_name#">,
                DETAIL = <cfif len(arguments.DETAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.DETAIL#">,<cfelse>NULL,</cfif>
                PERIOD_ID = #SESSION.EP.PERIOD_ID#,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                UPDATE_DATE = #now()#,
                UPDATE_EMP = #session.ep.userid#
            WHERE
                BSMV_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.BSMV_ID#">
        </cfquery>
    </cffunction>
</cfcomponent>