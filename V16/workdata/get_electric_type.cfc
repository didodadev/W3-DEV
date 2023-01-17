<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_ELECTRIC_TYPE" datasource="#dsn#">
            SELECT * FROM SETUP_ELECTRIC_TYPE
        </cfquery>
		<cfreturn GET_ELECTRIC_TYPE>
    </cffunction>
</cfcomponent>
