<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="get_packetship_problem_case" datasource="#DSN#">
            SELECT * FROM PACKETSHIP_PROBLEM_CASE
        </cfquery>
		<cfreturn get_packetship_problem_case>
    </cffunction>
</cfcomponent>

