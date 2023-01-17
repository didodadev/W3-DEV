<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_SENIORITY_BRANCH" datasource="#dsn#">
                SELECT * FROM BRANCH_FOR_SENIORITY
            </cfquery>
          <cfreturn GET_SENIORITY_BRANCH>
    </cffunction>
</cfcomponent>

