<cfquery name="GET_SEARCH_RESULTS" datasource="#DSN#">
	SELECT 
		EMPLOYEE_ID,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		EMPLOYEE_USERNAME,
		EMPLOYEE_EMAIL,
		IM,
		IMCAT_ID,
		MOBILTEL,
		MOBILCODE,
		TASK,
		BRANCH_ID
	FROM 
		EMPLOYEES
	WHERE 
		(
		EMPLOYEE_NAME LIKE '%#attributes.SEARCH_PHRASE#%'
		OR
		EMPLOYEE_SURNAME LIKE '%#attributes.SEARCH_PHRASE#%'
		)
	<cfif attributes.BRANCH_ID NEQ 0>
		AND
		BRANCH_ID = #attributes.BRANCH_ID#
	</cfif>
</cfquery>
