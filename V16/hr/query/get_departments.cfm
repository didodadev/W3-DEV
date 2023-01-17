<cfquery name="DEPARTMENTS" datasource="#DSN#">
	SELECT 
		BRANCH_ID,
		DEPARTMENT_ID, 
		DEPARTMENT_HEAD, 
		ADMIN1_POSITION_CODE,
		ADMIN2_POSITION_CODE
	FROM 
		DEPARTMENT 
	WHERE
		DEPARTMENT_STATUS = 1
		AND DEPARTMENT.IS_STORE <> 1 
		<cfif isDefined("attributes.BRANCH_ID") and len(attributes.BRANCH_ID)>
		AND BRANCH_ID = #attributes.BRANCH_ID#
		</cfif>
</cfquery>
