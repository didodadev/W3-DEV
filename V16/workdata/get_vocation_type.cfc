<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_VOCATION_TYPE" datasource="#dsn#">
            SELECT * FROM SETUP_VOCATION_TYPE
        </cfquery>
		<cfreturn GET_VOCATION_TYPE>
    </cffunction>
</cfcomponent>

