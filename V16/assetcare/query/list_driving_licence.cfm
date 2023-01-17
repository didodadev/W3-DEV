<cfquery name="GET_DRIVING_LICENCE" datasource="#DSN#">
		SELECT 
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NAME,	
		EMPLOYEES.EMPLOYEE_SURNAME
	FROM 
		EMPLOYEES
	WHERE
		0 = 1
<!--- 
		<cfif len(attributes.keyword)>AND ASSET_P.ASSETP LIKE '%#attributes.keyword#%'</cfif>
		<cfif len(attributes.asset_cat)>AND CARE_STATES.CARE_STATE_ID = #attributes.asset_cat#</cfif>
		<cfif len(attributes.department_id)>AND ASSET_P.DEPARTMENT_ID = #attributes.department_id#</cfif>
		<cfif len(attributes.branch_id)>AND BRANCH.BRANCH_ID =#attributes.branch_id#</cfif>--->
</cfquery>
