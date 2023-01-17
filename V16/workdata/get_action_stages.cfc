<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_ACTION_STAGES" datasource="#dsn#">
                SELECT * FROM SETUP_ACTION_STAGES
            </cfquery>
          <cfreturn GET_ACTION_STAGES>
    </cffunction>
</cfcomponent>

