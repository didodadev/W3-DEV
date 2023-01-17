<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_COUNTER_TYPE" datasource="#DSN#_#session.ep.company_id#">
            SELECT * FROM SETUP_COUNTER_TYPE
        </cfquery>
		<cfreturn GET_COUNTER_TYPE>
    </cffunction>
</cfcomponent>

