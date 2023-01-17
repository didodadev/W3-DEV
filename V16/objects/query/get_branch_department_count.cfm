<cfquery name="GET_BRANCH_DEPARTMENT_COUNT" datasource="#dsn#">
	SELECT 
		BRANCH_ID, 
		COUNT(DEPARTMENT_ID) AS TOTAL
	FROM 
		DEPARTMENT
	WHERE 
		BRANCH_ID=#attributes.BRANCH_ID#
	GROUP BY
		BRANCH_ID
</cfquery>
