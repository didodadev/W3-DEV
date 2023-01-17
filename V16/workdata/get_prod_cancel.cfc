<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_PROD_CANCEL" datasource="#DSN#_#session.ep.company_id#">
            SELECT * FROM SETUP_PROD_CANCEL_CATS
        </cfquery>
        <cfreturn GET_PROD_CANCEL>
    </cffunction>
</cfcomponent>
