<cfquery name="GET_POSITIONS" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH,		
		ZONE
	WHERE
		EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID
	AND
		DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
	AND
		BRANCH.ZONE_ID=ZONE.ZONE_ID
	AND
		EMPLOYEE_POSITIONS.EMPLOYEE_ID > 0

	<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
		AND
		(
			EMPLOYEE_POSITIONS.POSITION_NAME LIKE '%#attributes.KEYWORD#%'
		OR
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE '%#attributes.KEYWORD#%'
		OR
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '%#attributes.KEYWORD#%'
		)
	</cfif>
	<cfif isDefined("attributes.DEPARTMENT_ID") and len(attributes.DEPARTMENT_ID) and attributes.DEPARTMENT_ID is not "all">
		AND
		EMPLOYEE_POSITIONS.DEPARTMENT_ID=#attributes.DEPARTMENT_ID#
	</cfif>
	ORDER BY EMPLOYEE_POSITIONS.POSITION_NAME
</cfquery>
