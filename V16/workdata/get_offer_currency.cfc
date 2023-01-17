<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getComponentFunction">
        <cfquery name="GET_OFFER_CURRENCY" datasource="#DSN#_#session.ep.company_id#">
            SELECT * FROM OFFER_CURRENCY
        </cfquery>
        <cfreturn GET_OFFER_CURRENCY>        
    </cffunction>
</cfcomponent>
