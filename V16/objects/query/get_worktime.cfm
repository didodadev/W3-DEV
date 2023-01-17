<cfquery name="get_worktime" datasource="#dsn#">
	SELECT
		EMPLOYEES_WORKTIMES.WT_ID,
		EMPLOYEES_WORKTIMES.EMPLOYEE_ID,
		EMPLOYEES_WORKTIMES.START_TIME,
		EMPLOYEES_WORKTIMES.END_TIME,
		EMPLOYEES_WORKTIMES.RECORD_EMP,
		EMPLOYEES_WORKTIMES.UPDATE_EMP,
		EMPLOYEES_WORKTIMES.UPDATE_DATE,
		EMPLOYEES_WORKTIMES.RECORD_DATE,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME
	FROM
		EMPLOYEES_WORKTIMES,
		EMPLOYEE_POSITIONS
	WHERE
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES_WORKTIMES.EMPLOYEE_ID
		AND
		EMPLOYEE_POSITIONS.POSITION_STATUS = 1
		AND
		EMPLOYEES_WORKTIMES.WT_ID = #WT_ID#
</cfquery>
