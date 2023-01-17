<cfquery name="GET_EMPLOYEES" datasource="#dsn#">
	SELECT 
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NO,
		EMPLOYEES.EMPLOYEE_NAME, 
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.DIRECT_TELCODE,
		EMPLOYEES.DIRECT_TEL,
		EMPLOYEES.EXTENSION,
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID,
		DEPARTMENT.DEPARTMENT_ID,
		DEPARTMENT.DEPARTMENT_HEAD,
		<!--- EMPLOYEES.POSITION_ID, --->
		EMPLOYEE_POSITIONS.POSITION_CODE
	FROM 
		EMPLOYEES,
		BRANCH,
		DEPARTMENT,
		EMPLOYEE_POSITIONS
	WHERE
		EMPLOYEE_POSITIONS.POSITION_STATUS = 1
		AND
		EMPLOYEES.EMPLOYEE_STATUS =1
		AND
		DEPARTMENT.DEPARTMENT_STATUS =1
		AND
		BRANCH.BRANCH_STATUS =1
		AND
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
		AND
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
		AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
    <cfif isDefined("attributes.BRANCH_ID")>
	    AND
		BRANCH.BRANCH_ID = #attributes.BRANCH_ID#
	</cfif>
	<cfif isDefined("attributes.EMPLOYEE_IDS") and len(attributes.EMPLOYEE_IDS)>
		AND
		EMPLOYEES.EMPLOYEE_ID IN (#attributes.EMPLOYEE_IDS#)
	</cfif>
	<cfif isDefined("attributes.DEPARTMENT_ID")>
		AND
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = #attributes.DEPARTMENT_ID#
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		<cfif len(attributes.keyword) eq 1>
			AND
			EMPLOYEES.EMPLOYEE_NAME LIKE '#attributes.keyword#%'
		<cfelse>
			AND
			(
			EMPLOYEES.EMPLOYEE_NAME LIKE '%#attributes.keyword#%'
			OR
			EMPLOYEES.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
			OR
			DEPARTMENT.DEPARTMENT_HEAD LIKE '%#attributes.keyword#%'
			OR
			BRANCH.BRANCH_NAME LIKE '%#attributes.keyword#%'
			)
		</cfif>
	</cfif>
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
</cfquery>
