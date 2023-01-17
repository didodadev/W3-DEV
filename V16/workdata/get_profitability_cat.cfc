<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_PROFITABILITY_CAT" datasource="#dsn#">
            SELECT * FROM SETUP_PROFITABILITY_CAT
        </cfquery>
		<cfreturn GET_PROFITABILITY_CAT>
    </cffunction>
</cfcomponent>

