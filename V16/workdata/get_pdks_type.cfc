<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_PDKS_TYPE" datasource="#dsn#">
            SELECT * FROM SETUP_PDKS_TYPES
        </cfquery>
		<cfreturn GET_PDKS_TYPE>
    </cffunction>
</cfcomponent>
