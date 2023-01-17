<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_KNOWLEVELCATEGORIES" datasource="#dsn#">
            SELECT * FROM SETUP_KNOWLEVEL
        </cfquery>
		<cfreturn GET_KNOWLEVELCATEGORIES>
    </cffunction>
</cfcomponent>

