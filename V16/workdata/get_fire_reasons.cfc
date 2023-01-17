<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
        <cfargument name="where" default="">
        <cfquery name="GET_EMPLOYEE_FIRE_REASONS" datasource="#dsn#">
            SELECT * FROM SETUP_EMPLOYEE_FIRE_REASONS <cfif isdefined('arguments.where') and len(arguments.where)>WHERE #arguments.where#</cfif>
        </cfquery>
		<cfreturn GET_EMPLOYEE_FIRE_REASONS>
    </cffunction>
</cfcomponent>

