<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="get_packetship_error_case" datasource="#DSN#">
            SELECT * FROM PACKETSHIP_ERROR_CASE
        </cfquery>
		<cfreturn get_packetship_error_case>
    </cffunction>
</cfcomponent>

