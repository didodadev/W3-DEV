<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getComponentFunction">
        <cfquery name="GET_INVOICE_CANCEL" datasource="#DSN#_#session.ep.company_id#">
            SELECT * FROM SETUP_INVOICE_CANCEL_TYPE
        </cfquery>
        <cfreturn GET_INVOICE_CANCEL>        
    </cffunction>
</cfcomponent>
