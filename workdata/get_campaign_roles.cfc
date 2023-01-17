<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getComponentFunction">
	    <cfargument name="keyword" default="">
            <cfquery name="GET_CAMPAIGN_ROLES" datasource="#DSN#_#session.ep.company_id#">
                SELECT * FROM SETUP_CAMPAIGN_ROLES
            </cfquery>
        <cfreturn GET_CAMPAIGN_ROLES>        
    </cffunction>
</cfcomponent>
