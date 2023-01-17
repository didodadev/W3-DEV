<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_MAIN_LOCATION_CAT" datasource="#dsn#">
            SELECT * FROM SETUP_MAIN_LOCATION_CAT
        </cfquery>
		<cfreturn GET_MAIN_LOCATION_CAT>
    </cffunction>
</cfcomponent>

