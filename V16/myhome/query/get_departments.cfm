<cfquery name="DEPARTMENTS" datasource="#DSN#">
	SELECT 
		DEPARTMENT_ID, 
		DEPARTMENT_HEAD, 
		ADMIN1_POSITION_CODE,
		ADMIN2_POSITION_CODE
	FROM 
		DEPARTMENT 
		<cfif isDefined("attributes.BRANCH_ID")>
	WHERE 
		BRANCH_ID = #attributes.BRANCH_ID#
	AND
		DEPARTMENT_STATUS = 1
		</cfif>
</cfquery>
