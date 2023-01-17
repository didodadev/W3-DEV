<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getAccountType" access="public" returntype="query">
        <cfargument name="account_type" default="">
        <cfquery name="getAccount" datasource="#dsn#">
            SELECT
                ACCOUNT_TYPE_ID,
                ACCOUNT_TYPE
            FROM
                ACCOUNT_TYPES
            ORDER BY
                ACCOUNT_TYPE_ID
            desc
        </cfquery>
        <cfreturn getAccount>
    </cffunction>
    
</cfcomponent>
