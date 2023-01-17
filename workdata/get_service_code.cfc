<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getComponentFunction">
	    <cfargument name="keyword" default="">
            <cfquery name="GET_SERVICE_CODE" datasource="#DSN#_#session.ep.company_id#">
                SELECT * FROM SETUP_SERVICE_CODE
            </cfquery>
        <cfreturn GET_SERVICE_CODE>        
    </cffunction>
</cfcomponent>
