<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_PARTNER_TASK" datasource="#dsn#">
                SELECT * FROM SETUP_PARTNER_POSITION
            </cfquery>
          <cfreturn GET_PARTNER_TASK>
    </cffunction>
</cfcomponent>

