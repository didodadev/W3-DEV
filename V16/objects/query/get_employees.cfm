<cfquery name="GET_EMPLOYEES" datasource="#dsn#">
	SELECT 
		<cfif isDefined("attributes.DEPARTMENT_ID") OR (isDefined("attributes.keyword") and len(attributes.keyword))>
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID,
		DEPARTMENT.DEPARTMENT_ID,
		DEPARTMENT.DEPARTMENT_HEAD,
		EMPLOYEE_POSITIONS.POSITION_CODE,
		</cfif>
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NO,
		EMPLOYEES.EMPLOYEE_NAME, 
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.DIRECT_TELCODE,
		EMPLOYEES.DIRECT_TEL,
		EMPLOYEES.EXTENSION
	FROM 
		<cfif isDefined("attributes.DEPARTMENT_ID")>
		EMPLOYEE_POSITIONS,
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		BRANCH,
		</cfif>
		EMPLOYEES
	WHERE
		EMPLOYEES.EMPLOYEE_STATUS = 1
	<cfif isDefined("attributes.EMPLOYEE_IDS")>
		<cfif len(attributes.EMPLOYEE_IDS)>
		AND
		EMPLOYEES.EMPLOYEE_ID IN (#attributes.EMPLOYEE_IDS#)
		</cfif>
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
