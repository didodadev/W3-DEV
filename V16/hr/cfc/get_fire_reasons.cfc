<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="get_fire_reasons" access="public" returntype="query">
        <cfquery name="get_fire_reasons" datasource="#this.dsn#">
            SELECT REASON_ID,REASON FROM SETUP_EMPLOYEE_FIRE_REASONS WHERE IS_POSITION = 1 ORDER BY REASON 
        </cfquery>
  		<cfreturn get_fire_reasons>
	</cffunction>
</cfcomponent>