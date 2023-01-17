<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_INCOME_LEVEL" datasource="#dsn#">
            SELECT * FROM SETUP_INCOME_LEVEL
        </cfquery>
		<cfreturn GET_INCOME_LEVEL>
    </cffunction>
</cfcomponent>

