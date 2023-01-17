<cfquery name="get_all_branches" datasource="#dsn#">
	SELECT
		BRANCH_ID,
		BRANCH_NAME,		
		SSK_OFFICE,
		COMPANY_ID,
		SSK_NO
	FROM
		BRANCH
	WHERE
		1 = 1
		<cfif not session.ep.ehesap>
			AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		</cfif>
	ORDER BY
		BRANCH_NAME
</cfquery>