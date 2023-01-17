<cfquery name="get_hr_count" datasource="#dsn#">
	SELECT
		COUNT(EMPLOYEE_ID) AS TOTAL_EMPS
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		POSITION_STATUS = 1
</cfquery>
