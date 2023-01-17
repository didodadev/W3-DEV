<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_VISIT_STAGES" datasource="#dsn#">
            SELECT * FROM SETUP_VISIT_STAGES
        </cfquery>
		<cfreturn GET_VISIT_STAGES>
    </cffunction>
</cfcomponent>
