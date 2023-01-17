<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_RISK_CAT" datasource="#dsn#">
            SELECT * FROM SETUP_RISK_CAT
        </cfquery>
		<cfreturn GET_RISK_CAT>
    </cffunction>
</cfcomponent>

