<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_FUEL_TYPE" datasource="#dsn#">
            SELECT * FROM SETUP_FUEL_TYPE
        </cfquery>
		<cfreturn GET_FUEL_TYPE>
    </cffunction>
</cfcomponent>

