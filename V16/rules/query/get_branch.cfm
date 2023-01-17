<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT
		BRANCH_ID,
		BRANCH_NAME
	FROM
		BRANCH
	ORDER BY
		BRANCH_NAME
</cfquery>