<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getComponentFunction">
        <cfquery name="GET_PROD_BUG_TYPE" datasource="#DSN#_#session.ep.company_id#">
            SELECT * FROM SETUP_PROD_BUG_TYPE
        </cfquery>
        <cfreturn GET_PROD_BUG_TYPE>
	</cffunction>                  
</cfcomponent>
