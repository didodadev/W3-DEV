<cfquery name="GET_EMPLOYEES" datasource="#DSN#">
	SELECT 
		EMPLOYEE_ID,
		EMPLOYEE_NAME, 
		EMPLOYEE_SURNAME
	FROM 
		EMPLOYEES
	WHERE
		EMPLOYEE_ID <> 0
		<cfif isDefined("attributes.employee_ids")>
            <cfif len(attributes.employee_ids)>
           		AND EMPLOYEE_ID IN (#attributes.employee_ids#)
            </cfif>
        </cfif>
        <cfif isDefined("attributes.department_id")>
            AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
        </cfif>
</cfquery>
