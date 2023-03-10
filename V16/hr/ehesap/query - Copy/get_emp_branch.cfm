<cfquery name="get_emp_branch" datasource="#dsn#">
	SELECT
		BRANCH.SSK_OFFICE,
		BRANCH.SSK_NO
	FROM
		BRANCH,
		EMPLOYEES_IN_OUT
	WHERE
		EMPLOYEES_IN_OUT.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		AND
		EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
		AND
		(
			(
			EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
			AND
			EMPLOYEES_IN_OUT.START_DATE <= #attributes.MONTH_ENDS#
			)
			OR
			(
			EMPLOYEES_IN_OUT.FINISH_DATE IS NOT NULL
			AND
			EMPLOYEES_IN_OUT.VALID = 1
			AND
				(
				#attributes.MONTH_STARTS# BETWEEN EMPLOYEES_IN_OUT.START_DATE AND EMPLOYEES_IN_OUT.FINISH_DATE
				OR
				#attributes.MONTH_ENDS# BETWEEN EMPLOYEES_IN_OUT.START_DATE AND EMPLOYEES_IN_OUT.FINISH_DATE
				)
			)
		)
</cfquery>
