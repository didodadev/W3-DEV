<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_STOCKBOND_TYPE" datasource="#dsn#">
            SELECT * FROM SETUP_STOCKBOND_TYPE
        </cfquery>
		<cfreturn GET_STOCKBOND_TYPE>
    </cffunction>
</cfcomponent>

