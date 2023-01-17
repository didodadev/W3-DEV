<cfquery name="GET_RECORDER" datasource="#DSN#">
	SELECT
		DISTINCT
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	FROM
		REPORTS,
		EMPLOYEES
	WHERE
	    EMPLOYEES.EMPLOYEE_ID = REPORTS.RECORD_EMP
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
</cfquery>