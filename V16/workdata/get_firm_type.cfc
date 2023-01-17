<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_FIRM_TYPE" datasource="#dsn#">
            SELECT * FROM SETUP_FIRM_TYPE
        </cfquery>
		<cfreturn GET_FIRM_TYPE>
    </cffunction>
</cfcomponent>

