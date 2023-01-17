<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getComponentFunction">
        <cfquery name="GET_SERVICE_CARE_CAT" datasource="#DSN#_#session.ep.company_id#">
            SELECT * FROM SERVICE_CARE_CAT
		</cfquery>    
        <cfreturn GET_SERVICE_CARE_CAT>
    </cffunction>
</cfcomponent>
