<cfquery name="GET_EMPLOYEE_NAME" datasource="#dsn#">
SELECT 
	EMPLOYEE_EMAIL,
	EMPLOYEE_NAME,
	EMPLOYEE_SURNAME
FROM 
	EMPLOYEES
WHERE 
	EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>
