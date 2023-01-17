<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_BRANCH_CAT" datasource="#dsn#">
                SELECT * FROM SETUP_BRANCH_CAT
            </cfquery>
          <cfreturn GET_BRANCH_CAT>
    </cffunction>
</cfcomponent>

