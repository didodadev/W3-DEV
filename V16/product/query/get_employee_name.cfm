<cfquery name="GET_EMPLOYEES" datasource="#DSN#">
	SELECT 
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME 
	FROM 
		EMPLOYEES 
	WHERE 
		EMPLOYEE_ID=#attributes.emp_id#
</cfquery>
