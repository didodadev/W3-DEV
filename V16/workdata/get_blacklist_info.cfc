<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_BLACKLIST_INFO" datasource="#dsn#">
                SELECT * FROM SETUP_BLACKLIST_INFO
            </cfquery>
          <cfreturn GET_BLACKLIST_INFO>
    </cffunction>
</cfcomponent>

