<cfquery name="GET_EMP" datasource="#dsn#">
	SELECT 
		EMPLOYEE_ID,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
	FROM 
		EMPLOYEES
	WHERE 
		EMPLOYEE_ID=#attributes.EMP_ID#
</cfquery>

