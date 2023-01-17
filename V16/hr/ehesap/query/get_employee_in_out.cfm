<cfquery name="get_employees_in_out" datasource="#dsn#" maxrows="1">
	SELECT
		FINISH_DATE,
		START_DATE
	FROM
		EMPLOYEES_IN_OUT
	WHERE
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
	ORDER BY
		IN_OUT_ID DESC
</cfquery>
