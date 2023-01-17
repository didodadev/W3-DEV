<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT
		BRANCH_STATUS,
		BRANCH_ID,
		BRANCH_NAME,
		BRANCH_CITY
	FROM
		BRANCH 
		<cfif isdefined("attributes.BRANCH_ID")>
	WHERE
		BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
		</cfif>
	ORDER BY
		BRANCH_NAME
</cfquery>
