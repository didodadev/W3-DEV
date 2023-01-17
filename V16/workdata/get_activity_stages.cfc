<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_ACTIVITY_STAGES" datasource="#dsn#">
                SELECT * FROM SETUP_ACTIVITY_STAGES
            </cfquery>
          <cfreturn GET_ACTIVITY_STAGES>
    </cffunction>
</cfcomponent>

