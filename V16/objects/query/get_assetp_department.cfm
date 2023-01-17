<cfquery name="GET_ASSETP_DEP" datasource="#dsn#">
SELECT 
	ZONE.ZONE_NAME,
	BRANCH.BRANCH_NAME, 
	DEPARTMENT.DEPARTMENT_HEAD 
FROM 
	ZONE, 
	BRANCH, 
	DEPARTMENT 
WHERE 
	DEPARTMENT.DEPARTMENT_ID = #attributes.DEPARTMENT_ID# 
	AND 
	BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
	AND 
	ZONE.ZONE_ID = BRANCH.ZONE_ID
</cfquery>
