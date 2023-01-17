<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getComponentFunction">
        <cfquery name="GET_SERVICE_SPARE_PART" datasource="#DSN#_#session.ep.company_id#">
            SELECT * FROM SERVICE_SPARE_PART
        </cfquery>
        <cfreturn GET_SERVICE_SPARE_PART>        
    </cffunction>
</cfcomponent>
