<cfquery name="GET_EMP" datasource="#DSN#">
	SELECT 
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		EMPLOYEE_ID
	FROM
		EMPLOYEES
	WHERE 
		EMPLOYEE_ID=#SESSION.EP.USERID#
</cfquery>
