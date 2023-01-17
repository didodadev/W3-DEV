<cfquery name="GET_BRANCHS_DEPS" datasource="#dsn#">
	SELECT 
		DEPARTMENT.DEPARTMENT_ID, 
		DEPARTMENT.BRANCH_ID,
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME
	FROM 
		BRANCH,
		DEPARTMENT 
	WHERE
		BRANCH.BRANCH_ID=DEPARTMENT.BRANCH_ID
		<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
		AND	DEPARTMENT_ID = #attributes.department_id#
		</cfif>
	ORDER BY
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD
</cfquery>

