<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_OFFICE_STUFF" datasource="#dsn#">
            SELECT * FROM SETUP_OFFICE_STUFF
        </cfquery>
		<cfreturn GET_OFFICE_STUFF>
    </cffunction>
</cfcomponent>

