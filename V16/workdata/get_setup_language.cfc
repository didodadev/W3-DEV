<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_SETUP_LANGUAGE" datasource="#dsn#">
            SELECT * FROM SETUP_LANGUAGE
        </cfquery>
		<cfreturn GET_SETUP_LANGUAGE>
    </cffunction>
</cfcomponent>

