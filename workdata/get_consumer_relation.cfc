<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
    	<cfargument name="keyword" default="">
        	<cfquery name="GET_CONSUMER_RELATION" datasource="#dsn#">
            	SELECT * FROM SETUP_CONSUMER_RELATION
            </cfquery>
        <cfreturn GET_CONSUMER_RELATION>
    </cffunction>
</cfcomponent>
