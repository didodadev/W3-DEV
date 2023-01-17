<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_SETUP_IT_CONCERNED" datasource="#dsn#">
            SELECT * FROM SETUP_IT_CONCERNED
        </cfquery>
		<cfreturn GET_SETUP_IT_CONCERNED>
    </cffunction>
</cfcomponent>
