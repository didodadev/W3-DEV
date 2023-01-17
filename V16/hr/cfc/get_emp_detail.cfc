<cfcomponent>
<cffunction name="get_employee_detail" access="public" returntype="query">
		<cfargument name="employee_id" type="numeric">
        <cfquery name="get_employee" datasource="#this.dsn#">
            SELECT 
            	EMPLOYEE_NAME,
                EMPLOYEE_SURNAME
            FROM 
            	EMPLOYEES 
             WHERE 
             	EMPLOYEE_ID IS NOT NULL
                <cfif isdefined('arguments.employee_id') and len(arguments.employee_id)>
                    AND EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> 
                </cfif>
        </cfquery>
  <cfreturn get_employee>
</cffunction>
<cffunction name="get_emp_identy" access="public" returntype="query">
		<cfargument name="employee_id" type="numeric">
        <cfquery name="get_identy" datasource="#this.dsn#">
            SELECT 
            	TC_IDENTY_NO
            FROM 
            	EMPLOYEES_IDENTY 
             WHERE 
             	TC_IDENTY_NO IS NOT NULL
                <cfif isdefined('arguments.employee_id') and len(arguments.employee_id)>
                    AND EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> 
                </cfif>
        </cfquery>
  <cfreturn get_identy>
</cffunction>
</cfcomponent>
