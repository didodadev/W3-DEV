<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_DUTY_PERIOD" datasource="#dsn#">
                SELECT * FROM SETUP_DUTY_PERIOD
            </cfquery>
          <cfreturn GET_DUTY_PERIOD>
    </cffunction>
</cfcomponent>

