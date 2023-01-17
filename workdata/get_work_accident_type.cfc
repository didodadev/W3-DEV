<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="get_work_accident_type" datasource="#dsn#">
                SELECT * FROM EMPLOYEE_WORK_ACCIDENT_TYPE
            </cfquery>
          <cfreturn get_work_accident_type>
    </cffunction>
</cfcomponent>
