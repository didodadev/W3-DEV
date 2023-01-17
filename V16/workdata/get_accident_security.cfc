<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="get_accident_security" datasource="#dsn#">
                SELECT * FROM EMPLOYEE_ACCIDENT_SECURITY
            </cfquery>
          <cfreturn get_accident_security>
    </cffunction>
</cfcomponent>
