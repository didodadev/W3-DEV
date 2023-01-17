<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT 
		B.BRANCH_ID,
		B.BRANCH_NAME
	FROM 
		BRANCH B,
		ZONE Z
	WHERE 
		B.BRANCH_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
		Z.ZONE_ID = B.ZONE_ID AND
		Z.ZONE_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
		B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		B.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
	ORDER BY
		B.BRANCH_NAME
</cfquery>
