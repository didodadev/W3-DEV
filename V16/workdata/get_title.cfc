<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_TITLE" datasource="#dsn#">
            SELECT * FROM SETUP_TITLE
        </cfquery>
		<cfreturn GET_TITLE>
    </cffunction>
</cfcomponent>
