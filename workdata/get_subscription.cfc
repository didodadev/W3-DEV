<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getComponentFunction">
	    <cfargument name="keyword" default="">
            <cfquery name="GET_SUBSCRIPTION" datasource="#DSN#_#session.ep.company_id#">
                SELECT * FROM SETUP_SUBSCRIPTION_ADD_OPTIONS
            </cfquery>
        <cfreturn GET_SUBSCRIPTION>        
    </cffunction>
</cfcomponent>
