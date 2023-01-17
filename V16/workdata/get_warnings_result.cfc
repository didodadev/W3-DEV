<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_WARNINGS_RESULT" datasource="#dsn#">
            SELECT * FROM SETUP_WARNING_RESULT
        </cfquery>
		<cfreturn GET_WARNINGS_RESULT>
    </cffunction>
</cfcomponent>

