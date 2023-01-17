<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
	SELECT
		DEPARTMENT.DEPARTMENT_ID,
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_NAME
	FROM
		DEPARTMENT,
		BRANCH
	WHERE
		BRANCH.BRANCH_ID=DEPARTMENT.BRANCH_ID
		<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
		AND DEPARTMENT.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
		</cfif>
	ORDER BY
		DEPARTMENT_ID
</cfquery>
