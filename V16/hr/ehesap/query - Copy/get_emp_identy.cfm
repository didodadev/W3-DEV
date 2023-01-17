<cfquery name="get_emp_identy" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEES_IDENTY
	WHERE
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>
