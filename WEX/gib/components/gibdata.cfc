<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="parameters" access="public">
        <cfquery name="query_parameters" datasource="#dsn#">
            SELECT * FROM SETUP_GIB
        </cfquery>

        <cfif query_parameters.recordcount eq 0>
            <cfreturn { status: 0 }>
        <cfelse>
            <cfreturn { status: 1, username: query_parameters.GIB_USERNAME, password: query_parameters.GIB_PASSWORD  }>
        </cfif>
    </cffunction>

</cfcomponent>