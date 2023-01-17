<cfquery name="GET_employee_name" datasource="#dsn#">
	SELECT
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
	FROM
		EMPLOYEES
	WHERE
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>
