<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_SETUP_MOBILCAT" datasource="#dsn#">
            SELECT * FROM SETUP_MOBILCAT
        </cfquery>
		<cfreturn GET_SETUP_MOBILCAT>
    </cffunction>
</cfcomponent>

