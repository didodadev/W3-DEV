<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getComponentFunction">
	    <cfargument name="keyword" default="">
        	<cfquery name="GET_PROD_RETURN" datasource="#DSN#_#session.ep.company_id#">
            	SELECT * FROM SETUP_PROD_RETURN_CATS
            </cfquery>
        <cfreturn GET_PROD_RETURN>
	</cffunction>                  
</cfcomponent>
