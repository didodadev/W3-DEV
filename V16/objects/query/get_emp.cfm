<cfquery name="GET_EMP" datasource="#DSN#">
	SELECT 
		EMPLOYEE_ID,
		MEMBER_CODE,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
	FROM 
		EMPLOYEES
	WHERE 
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
</cfquery>
