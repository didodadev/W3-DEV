<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_SCHOOL_PART" datasource="#dsn#">
            SELECT * FROM SETUP_SCHOOL_PART ORDER BY PART_NAME
        </cfquery>
		<cfreturn GET_SCHOOL_PART>
    </cffunction>
</cfcomponent>

