<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getComponentFunction">
        <cfquery name="GET_OPP_CURRENCY" datasource="#DSN#_#session.ep.company_id#">
            SELECT * FROM OPPORTUNITY_CURRENCY
        </cfquery>
        <cfreturn GET_OPP_CURRENCY>        
    </cffunction>
</cfcomponent>
