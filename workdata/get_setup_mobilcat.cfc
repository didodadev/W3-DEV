<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_SETUP_MOBILCAT" datasource="#dsn#">
                SELECT * FROM SETUP_MOBILCAT ORDER BY MOBILCAT ASC
            </cfquery>
          <cfreturn GET_SETUP_MOBILCAT>
    </cffunction>
</cfcomponent>

