<cfquery name="GET_TASK" datasource="#DSN#">
	SELECT
		*
	FROM	
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH
	WHERE
		EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#position_code#"> AND
		EMPLOYEE_POSITIONS.POSITION_STATUS=1 AND
		EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
</cfquery>