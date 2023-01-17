<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_RAW_MATERIAL" datasource="#dsn#">
            SELECT * FROM SETUP_RAW_MATERIAL
        </cfquery>
		<cfreturn GET_RAW_MATERIAL>
    </cffunction>
</cfcomponent>
