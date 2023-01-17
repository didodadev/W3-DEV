<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_SETUP_PC_NUMBER" datasource="#dsn#">
            SELECT * FROM SETUP_PC_NUMBER
        </cfquery>
		<cfreturn GET_SETUP_PC_NUMBER>
    </cffunction>
</cfcomponent>
