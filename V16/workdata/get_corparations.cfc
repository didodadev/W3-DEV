<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_CORPARATIONS" datasource="#dsn#">
            SELECT * FROM SETUP_CORPORATIONS
        </cfquery>
		<cfreturn GET_CORPARATIONS>
    </cffunction>
</cfcomponent>
