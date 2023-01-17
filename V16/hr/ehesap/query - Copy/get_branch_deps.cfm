<cfquery name="get_branch_dep" datasource="#DSN#">
	SELECT
		DEPARTMENT_ID
	FROM
		DEPARTMENT
	WHERE
		BRANCH_ID IN (
					SELECT
						BRANCH_ID
					FROM
						EMPLOYEE_POSITION_BRANCHES
					WHERE
						EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
					)
</cfquery>
