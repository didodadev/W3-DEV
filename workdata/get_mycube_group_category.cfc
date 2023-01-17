<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_MYCUBE_GROUP_CATEGORY" datasource="#dsn#">
                SELECT * FROM SETUP_MYCUBE_GROUP_CATEGORY
            </cfquery>
          <cfreturn GET_MYCUBE_GROUP_CATEGORY>
    </cffunction>
</cfcomponent>

