<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_STATION" datasource="#dsn#_#session.ep.company_id#">
            select * from WORKSTATIONS
        </cfquery>
		<cfreturn GET_STATION>
    </cffunction>
</cfcomponent>

