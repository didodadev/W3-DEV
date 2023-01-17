<cfquery name="GET_EMPLOYEE" datasource="#DSN#">
	SELECT 
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		EMPLOYEE_EMAIL
	FROM 
		EMPLOYEES 
	WHERE 
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>
