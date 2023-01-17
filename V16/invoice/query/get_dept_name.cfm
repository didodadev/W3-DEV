<cfquery name="GET_DEPT_NAME" datasource="#DSN#">
	SELECT
		DEPARTMENT_HEAD,
		BRANCH_ID
	FROM
		DEPARTMENT
	WHERE
		DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
</cfquery>

