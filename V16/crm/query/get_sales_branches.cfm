<cfquery name="GET_BRANCHS" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME
	FROM 
		BRANCH
	WHERE
		BRANCH_STATUS = 1
	ORDER BY
		BRANCH_NAME
</cfquery>

