<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_CREDIT_TYPE" datasource="#dsn#">
            SELECT * FROM SETUP_CREDIT_TYPE
        </cfquery>
		<cfreturn GET_CREDIT_TYPE>
    </cffunction>
</cfcomponent>

