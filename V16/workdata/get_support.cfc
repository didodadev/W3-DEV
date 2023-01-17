<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_SUPPORT" datasource="#dsn#">
            SELECT * FROM SETUP_SUPPORT
        </cfquery>
		<cfreturn GET_SUPPORT>
    </cffunction>
</cfcomponent>

