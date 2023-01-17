<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getComponentFunction">
        <cfquery name="GET_PBS_CAT" datasource="#DSN#_#session.ep.company_id#">
            SELECT * FROM SETUP_PBS_CAT
        </cfquery>
        <cfreturn GET_PBS_CAT>
	</cffunction>                  
</cfcomponent>
