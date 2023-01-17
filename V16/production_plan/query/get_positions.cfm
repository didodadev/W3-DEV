<cfquery name="GET_POSITIONS" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH,
		ZONE,
		EMPLOYEES
	
	WHERE
		EMPLOYEES.EMPLOYEE_ID=EMPLOYEE_POSITIONS.EMPLOYEE_ID
	AND
		EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID
	AND
		DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
	AND
		BRANCH.ZONE_ID=ZONE.ZONE_ID
	AND 
		EMPLOYEE_POSITIONS.POSITION_STATUS=1
	AND
		EMPLOYEE_POSITIONS.VALID=2
	AND
		EMPLOYEE_POSITIONS.EMPLOYEE_ID<>0
	
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
			EMPLOYEE_POSITIONS.POSITION_NAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%'
			OR
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%'
			OR
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
		)
	</cfif>
	<cfif isDefined("attributes.DEPARTMENT_ID") and len(DEPARTMENT_ID)>
		AND
		EMPLOYEE_POSITIONS.DEPARTMENT_ID=#attributes.DEPARTMENT_ID#
	</cfif>
	ORDER BY
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME
</cfquery>
