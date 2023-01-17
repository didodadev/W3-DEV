<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_HIGH_SCHOOL" datasource="#dsn#">
            SELECT * FROM SETUP_HIGH_SCHOOL_PART
        </cfquery>
		<cfreturn GET_HIGH_SCHOOL>
    </cffunction>
</cfcomponent>

