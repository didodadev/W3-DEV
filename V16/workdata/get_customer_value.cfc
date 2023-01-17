<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_CUSTOMER_VALUE" datasource="#dsn#">
            SELECT * FROM SETUP_CUSTOMER_VALUE
        </cfquery>
		<cfreturn GET_CUSTOMER_VALUE>
    </cffunction>
</cfcomponent>

