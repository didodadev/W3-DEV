<cfquery name="get_branches" datasource="#dsn#">
	SELECT 
		BRANCH_NAME,
		BRANCH_ID
	FROM 
		BRANCH
	ORDER BY
		BRANCH_NAME
</cfquery>
