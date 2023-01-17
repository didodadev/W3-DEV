<cfquery name="GET_EMP_DETAIL" datasource="#dsn#">
	SELECT
		EMPLOYEES.*,
		SETUP_TITLE.*
	FROM
		EMPLOYEES,
		EMPLOYEE_POSITIONS,
		SETUP_TITLE
	WHERE
		EMPLOYEES.EMPLOYEE_ID = #EMP_ID# AND
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
		EMPLOYEE_POSITIONS.TITLE_ID = SETUP_TITLE.TITLE_ID
</cfquery>