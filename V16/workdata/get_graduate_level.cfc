<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_GRADUATE_LEVEL" datasource="#dsn#">
            SELECT * FROM SETUP_GRADUATE_LEVEL
        </cfquery>
		<cfreturn GET_GRADUATE_LEVEL>
    </cffunction>
</cfcomponent>

