<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT 
		COMP_ID,
		COMPANY_NAME
	FROM
		OUR_COMPANY
</cfquery>
<cfquery name="GET_BRANCHES" datasource="#DSN#">
	SELECT
		BRANCH.BRANCH_STATUS,
		BRANCH.HIERARCHY,
		BRANCH.HIERARCHY2,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		OUR_COMPANY.COMP_ID,
		OUR_COMPANY.COMPANY_NAME,
		OUR_COMPANY.NICK_NAME
	FROM
		BRANCH,
		OUR_COMPANY
	WHERE
		BRANCH.BRANCH_ID IS NOT NULL
		AND BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
		AND BRANCH.BRANCH_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
	ORDER BY
		OUR_COMPANY.NICK_NAME,
		BRANCH.BRANCH_NAME
</cfquery>
<cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
	<cfquery name="GET_DEPARTMENTS" datasource="#DSN#">
		SELECT 
			DEPARTMENT.DEPARTMENT_ID,
			DEPARTMENT.DEPARTMENT_HEAD,
			BRANCH.BRANCH_NAME,
			BRANCH.BRANCH_ID,		
			ZONE.ZONE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
			OUR_COMPANY.NICK_NAME 
		FROM 
			DEPARTMENT,
			BRANCH,
			ZONE,
			EMPLOYEE_POSITIONS,
			OUR_COMPANY
		WHERE
			BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
			DEPARTMENT.DEPARTMENT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
			BRANCH.BRANCH_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
			ZONE.ZONE_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
			DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
			BRANCH.ZONE_ID = ZONE.ZONE_ID AND
			DEPARTMENT.ADMIN1_POSITION_CODE  = EMPLOYEE_POSITIONS.POSITION_CODE AND
			BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
			<cfif isdefined("attributes.is_branch_control") and not session.ep.ehesap>
				AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>	
	UNION ALL
		SELECT 
			DEPARTMENT.DEPARTMENT_ID,
			DEPARTMENT.DEPARTMENT_HEAD,
			BRANCH.BRANCH_NAME,
			BRANCH.BRANCH_ID,
			ZONE.ZONE_NAME,
			'' AS EMPLOYEE_NAME,
			'' AS EMPLOYEE_SURNAME,
			OUR_COMPANY.NICK_NAME 
		FROM 
			DEPARTMENT,
			BRANCH,
			ZONE,
			OUR_COMPANY
		WHERE
			BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
			DEPARTMENT.DEPARTMENT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
			BRANCH.BRANCH_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
			ZONE.ZONE_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
			DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
			BRANCH.ZONE_ID = ZONE.ZONE_ID AND
			DEPARTMENT.ADMIN1_POSITION_CODE IS NULL AND
			BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
			<cfif isdefined("attributes.is_branch_control") and not session.ep.ehesap>
				AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
		ORDER BY
			BRANCH_NAME,
			DEPARTMENT_HEAD
	</cfquery>
</cfif>
