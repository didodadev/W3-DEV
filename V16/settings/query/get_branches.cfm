<cfquery name="GET_BRANCHES" datasource="#DSN#">
	SELECT 
		BRANCH_NAME,
		BRANCH_ID
	FROM 
		BRANCH
<cfif isDefined("attributes.branch_id")>		
	WHERE
		BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
</cfif>
	ORDER BY 
		BRANCH_NAME
</cfquery>
