<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
    	<cfargument name="keyword" default="">
	    	<cfquery name="GET_SUBSCRIPTION_RELATION" datasource="#dsn#">
            	SELECT * FROM SETUP_SUBSCRIPTION_RELATION
            </cfquery>
        <cfreturn GET_SUBSCRIPTION_RELATION>
    </cffunction>
</cfcomponent>
