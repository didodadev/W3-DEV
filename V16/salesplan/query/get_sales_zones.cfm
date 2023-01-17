<cfquery name="GET_SALES_ZONES" datasource="#DSN#">
	SELECT
		SALES_ZONES.SZ_ID,
		SALES_ZONES.IS_ACTIVE,
		SALES_ZONES.OZEL_KOD,
		SALES_ZONES.SZ_NAME,
		SALES_ZONES.SZ_HIERARCHY,
		SALES_ZONES.RESPONSIBLE_PAR_ID,
		SALES_ZONES.RESPONSIBLE_COMPANY_ID,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
		EMPLOYEE_POSITIONS.POSITION_CODE,
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.DEPARTMENT_ID,
		B.BRANCH_NAME	
	FROM
		SALES_ZONES,
		EMPLOYEE_POSITIONS,
		BRANCH B
	WHERE
		B.BRANCH_ID = SALES_ZONES.RESPONSIBLE_BRANCH_ID AND 
		SALES_ZONES.RESPONSIBLE_POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND SALES_ZONES.SZ_NAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
	</cfif>
	<cfif isdefined('attributes.is_active') and attributes.is_active eq 1> 
		AND SALES_ZONES.IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
	</cfif>
	<cfif isdefined('attributes.is_active') and attributes.is_active eq 0> 
		AND SALES_ZONES.IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">
	</cfif>
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		AND SALES_ZONES.RESPONSIBLE_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
	</cfif>
	AND B.BRANCH_ID IN
		(
			SELECT
				BRANCH_ID
			FROM
				EMPLOYEE_POSITION_BRANCHES
			WHERE
				POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
		)
	ORDER BY 
		SALES_ZONES.SZ_HIERARCHY
</cfquery>
