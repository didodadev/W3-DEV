<cfquery name="get_employee_last_in_out" datasource="#dsn#">
	SELECT
		FINISH_DATE,
		START_DATE,
		EMPLOYEE_ID,
		BRANCH_ID,
		IN_OUT_ID
	FROM
		EMPLOYEES_IN_OUT
</cfquery>
