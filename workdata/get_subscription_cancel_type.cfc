<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getComponentFunction">
	    <cfargument name="keyword" default="">
            <cfquery name="GET_SUBSCRIPTION_CANCEL_TYPE" datasource="#DSN#_#session.ep.company_id#">
                SELECT * FROM SETUP_SUBSCRIPTION_CANCEL_TYPE
            </cfquery>
        <cfreturn GET_SUBSCRIPTION_CANCEL_TYPE>        
    </cffunction>
</cfcomponent>
