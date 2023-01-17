<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_PROJECT_ROL" datasource="#dsn#">
            SELECT * FROM SETUP_PROJECT_ROLES
        </cfquery>
		<cfreturn GET_PROJECT_ROL>
    </cffunction>
</cfcomponent>

