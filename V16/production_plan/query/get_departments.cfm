<cfquery name="GET_DEPARTMENTS" datasource="#dsn#">
	SELECT 
		DEPARTMENT.DEPARTMENT_ID,
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_NAME,
		ZONE.ZONE_NAME
	FROM 
		DEPARTMENT,
		BRANCH,
		ZONE
	WHERE
		DEPARTMENT.DEPARTMENT_STATUS = 1
		AND
		BRANCH.BRANCH_STATUS = 1
		AND
		ZONE.ZONE_STATUS = 1
		AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
		AND
		BRANCH.ZONE_ID = ZONE.ZONE_ID
	ORDER BY
		ZONE.ZONE_ID,
		BRANCH.BRANCH_ID,
		DEPARTMENT.DEPARTMENT_ID
</cfquery>		
<cfquery name="DEPARTMENTS" datasource="#dsn#">
	SELECT
		*
	FROM
		DEPARTMENT
</cfquery>
