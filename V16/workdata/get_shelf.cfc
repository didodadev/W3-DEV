<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_SHELF" datasource="#dsn#">
            SELECT * FROM SHELF
        </cfquery>
		<cfreturn GET_SHELF>
    </cffunction>
</cfcomponent>

