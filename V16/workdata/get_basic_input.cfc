<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
    	<cfargument name="keyword" default="">
        	<cfquery name="GET_BASIC_INPUT" datasource="#DSN#_#session.ep.company_id#">
            	SELECT * FROM SETUP_BASIC_INPUT_COST
            </cfquery>
        <cfreturn GET_BASIC_INPUT> 
    </cffunction>
</cfcomponent>
