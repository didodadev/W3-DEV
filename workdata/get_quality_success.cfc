<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getComponentFunction">
	    <cfargument name="keyword" default="">
        	<cfquery name="GET_QUALITY_SUCCESS" datasource="#DSN#_#session.ep.company_id#">
            	SELECT * FROM QUALITY_SUCCESS
            </cfquery>
        <cfreturn GET_QUALITY_SUCCESS>
	</cffunction>                  
</cfcomponent>
