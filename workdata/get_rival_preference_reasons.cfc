<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_RIVAL_PREFERENCE_REASONS" datasource="#dsn#">
                SELECT * FROM SETUP_RIVAL_PREFERENCE_REASONS
            </cfquery>
          <cfreturn GET_RIVAL_PREFERENCE_REASONS>
    </cffunction>
</cfcomponent>

