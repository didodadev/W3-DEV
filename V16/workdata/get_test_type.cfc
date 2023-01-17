<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="get_test_type" datasource="#dsn#">
            SELECT * FROM SETUP_TEST_TYPE
        </cfquery>
		<cfreturn get_test_type>
    </cffunction>
</cfcomponent>

