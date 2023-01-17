<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_SETUP_WARNINGS" datasource="#dsn#">
            SELECT * FROM SETUP_WARNINGS
        </cfquery>
		<cfreturn GET_SETUP_WARNINGS>
    </cffunction>
</cfcomponent>

