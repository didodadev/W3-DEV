<cfquery name="GET_BRANCHS" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME
	FROM 
		BRANCH
	WHERE
		BRANCH_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
		AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY
		BRANCH_NAME
</cfquery>

