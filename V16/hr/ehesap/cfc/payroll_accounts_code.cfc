<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="GET_CODE_CAT" access="remote" returntype="any">
        <cfargument name="payroll_id" default="">
        <cfquery name="get_code_cat" datasource="#dsn#">
            SELECT
                PAYROLL_ID,
                DEFINITION
            FROM	
            SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF
            WHERE
                PAYROLL_STATUS = 1 
                <cfif isdefined("arguments.payroll_id") and len(arguments.payroll_id)>
                  OR PAYROLL_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.payroll_id#">
                </cfif>
        </cfquery>
        <cfreturn get_code_cat>
    </cffunction>
    <cffunction name="GET_ACCOUNTS" access="remote" returntype="any">
        <cfargument name="keyword" default="">
        <cfargument name="account_type_status" default="">
        <cfquery name="get_accounts" datasource="#dsn#">
            SELECT 
                *
            FROM 
                SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF
                WHERE
                1=1 
                <!---OUR_COMPANY_ID = #session.ep.company_id#--->
                <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                    AND DEFINITION LIKE '%#arguments.keyword#%'
                </cfif> 
                <cfif isDefined("arguments.account_type_status") and len(arguments.account_type_status)>  
                    <cfif arguments.account_type_status eq 1>
                        AND  PAYROLL_STATUS = 1 
                    <cfelseif arguments.account_type_status eq 0>
                        AND  PAYROLL_STATUS = 0               
                    </cfif>	
                </cfif>
            </cfquery>
            <cfreturn get_accounts>
    </cffunction>
</cfcomponent>
