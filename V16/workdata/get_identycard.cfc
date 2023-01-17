<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_IDENTYCARD" datasource="#dsn#">
            SELECT * FROM SETUP_IDENTYCARD
        </cfquery>
		<cfreturn GET_IDENTYCARD>
    </cffunction>
</cfcomponent>

