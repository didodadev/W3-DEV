<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_MEMBER_ADD_OPTIONS" datasource="#DSN#">
                SELECT * FROM SETUP_MEMBER_ADD_OPTIONS WHERE IS_INTERNET = 1
            </cfquery>
          <cfreturn GET_MEMBER_ADD_OPTIONS>
    </cffunction>
</cfcomponent>

