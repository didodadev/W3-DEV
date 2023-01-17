<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_CUSTOMER_POSITION" datasource="#dsn#">
            SELECT * FROM SETUP_CUSTOMER_POSITION
        </cfquery>
		<cfreturn GET_CUSTOMER_POSITION>
    </cffunction>
</cfcomponent>

