<cfquery name="get_departments2" datasource="#DSN#">
	SELECT 
		DEPARTMENT.DEPARTMENT_ID, 
		DEPARTMENT.DEPARTMENT_HEAD, 
		BRANCH.BRANCH_NAME,
		DEPARTMENT.ADMIN1_POSITION_CODE,
		DEPARTMENT.ADMIN2_POSITION_CODE
	FROM 
		DEPARTMENT,
		BRANCH
	WHERE
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
		AND
		DEPARTMENT_STATUS = 1
<cfif isDefined("attributes.BRANCH_ID")>
		AND
		BRANCH_ID = #attributes.BRANCH_ID#
</cfif>
	ORDER BY 
		BRANCH.BRANCH_NAME,
		DEPARTMENT_HEAD
</cfquery>
