<cfquery name="get_branch" datasource="#DSN#">
	SELECT * FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>
