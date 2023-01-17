<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>

	<cffunction name="getBankInfo" access="remote" returntype="any" returnformat="plain">
        <cfargument name="acc_info" type="numeric" required="yes">
        <cfif isdefined("session.ep")>
            <cfquery name="get_acc" datasource="#dsn3#">
                SELECT 
                    ACCOUNT_CURRENCY_ID,
                    ACCOUNT_ACC_CODE,
                    BANK_NAME,
                    BANK_BRANCH_NAME,
                    BANK_CODE
                FROM 
                    ACCOUNTS,
                    BANK_BRANCH 
                WHERE 
                    ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID AND 
                    ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#acc_info#">
            </cfquery>
            <cfset return_val =  SerializeJSON(get_acc)>
        <cfelse>
        	<cfset return_val =  ''>
        </cfif>
        <cfreturn return_val>
    </cffunction>
    
    <cffunction name="getCreditBankInfo" access="remote" returntype="any" returnformat="plain">
        <cfargument name="paymentType" type="numeric" required="yes">
        <cfif isdefined("session.ep")>
            <cfquery name="get_acc" datasource="#dsn3#">
                SELECT 
                	ACCOUNTS.ACCOUNT_CURRENCY_ID,
                    ACCOUNTS.ACCOUNT_ACC_CODE,
                    ACCOUNTS.ACCOUNT_ID,
                    CPT.PAYMENT_RATE,
                    CPT.PAYMENT_RATE_ACC
                FROM 
                	ACCOUNTS,
                    CREDITCARD_PAYMENT_TYPE CPT 
                 WHERE 
                 	ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND 
                    PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#paymentType#">
            </cfquery>
            <cfset return_val =  SerializeJSON(get_acc)>
        <cfelse>
        	<cfset return_val =  ''>
        </cfif>
        <cfreturn return_val>
    </cffunction>
    
</cfcomponent>

