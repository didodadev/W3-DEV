<cfcomponent>
	<cffunction name="last_in_out" access="public" returntype="query">
        <cfargument name="employee_id" type="numeric">
		<cfquery name="get_in_out" datasource="#this.dsn#"> 
            SELECT 
                MAX(IN_OUT_ID) AS IN_OUT_ID
            FROM 
                EMPLOYEES_IN_OUT 
            WHERE 
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">        
        </cfquery>
        <cfreturn get_in_out>
	</cffunction>
</cfcomponent>