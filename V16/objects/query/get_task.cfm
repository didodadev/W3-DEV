<cfquery name="GET_TASK" datasource="#dsn#">
	SELECT
		*
	FROM	
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH
	WHERE
		EMPLOYEE_POSITIONS.POSITION_CODE=#POSITION_CODE#
	AND
		EMPLOYEE_POSITIONS.POSITION_STATUS=1
	AND
		EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID
	AND
		DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
</cfquery>
