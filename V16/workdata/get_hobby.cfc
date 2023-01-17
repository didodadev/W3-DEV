<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_HOBBY" datasource="#dsn#">
            SELECT * FROM SETUP_HOBBY
        </cfquery>
		<cfreturn GET_HOBBY>
    </cffunction>
</cfcomponent>

