<cfset puantaj_gun_ = daysinmonth(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1))>
<cfset puantaj_start_ = CREATEODBCDATETIME(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1))>
<cfset puantaj_finish_ = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(attributes.sal_year,attributes.SAL_MON,puantaj_gun_)))>
<cfquery name="get_puantaj_comp" datasource="#DSN#">
	SELECT DISTINCT
		EMPLOYEES_PUANTAJ_ROWS.*,
		EMPLOYEES_IN_OUT.USE_SSK,
		EMPLOYEES_IN_OUT.IS_5084 AS KISI_5084,
		EMPLOYEES_IN_OUT.IS_5510 AS KISI_5510,
		EMPLOYEES_IN_OUT.START_CUMULATIVE_TAX,
		EMPLOYEES_IN_OUT.IS_START_CUMULATIVE_TAX,
		BRANCH.IS_5510,
		OUR_COMPANY.COMPANY_NAME
	FROM
		EMPLOYEES_IN_OUT,
		EMPLOYEES_PUANTAJ,
		EMPLOYEES_PUANTAJ_ROWS,
		BRANCH,
		OUR_COMPANY
	WHERE
		EMPLOYEES_IN_OUT.START_DATE < #puantaj_finish_# AND 
		(EMPLOYEES_IN_OUT.FINISH_DATE >= #puantaj_start_# OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL) AND
		EMPLOYEES_PUANTAJ.SAL_MON = #attributes.SAL_MON# AND
		EMPLOYEES_PUANTAJ.SAL_YEAR = #attributes.sal_year# AND
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
		EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND
		EMPLOYEES_PUANTAJ.SSK_OFFICE = BRANCH.SSK_OFFICE AND
		EMPLOYEES_PUANTAJ.SSK_OFFICE_NO = BRANCH.SSK_NO AND
		BRANCH.BRANCH_ID = EMPLOYEES_IN_OUT.BRANCH_ID AND
		OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
	<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
		AND OUR_COMPANY.COMP_ID = #attributes.comp_id#
	</cfif>
	<cfif fusebox.dynamic_hierarchy>
		<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
			<cfif database_type is "MSSQL">
				AND 
				('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
					
			<cfelseif database_type is "DB2">
				AND 
				('.' || EMPLOYEES.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
					
			</cfif>
		</cfloop>
	<cfelse>
		<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
			<cfif database_type is "MSSQL">
				AND ('.' + EMPLOYEES.HIERARCHY + '.') LIKE '%.#code_i#.%'
			<cfelseif database_type is "DB2">
				AND ('.' || EMPLOYEES.HIERARCHY || '.') LIKE '%.#code_i#.%'
			</cfif>
		</cfloop>
	</cfif>
</cfquery>

<cfset get_puantaj_comp_sql = "">
<cfset get_puantaj_comp_sql = get_puantaj_comp_sql & "
	SELECT DISTINCT
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID 
	FROM
		EMPLOYEES_IN_OUT,
		EMPLOYEES_PUANTAJ,
		EMPLOYEES_PUANTAJ_ROWS,
		BRANCH,
		OUR_COMPANY
	WHERE
		EMPLOYEES_IN_OUT.START_DATE < #puantaj_finish_# AND 
		(EMPLOYEES_IN_OUT.FINISH_DATE >= #puantaj_start_# OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL) AND
		EMPLOYEES_PUANTAJ.SAL_MON = #attributes.SAL_MON# AND
		EMPLOYEES_PUANTAJ.SAL_YEAR = #attributes.sal_year# AND
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
		EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND
		EMPLOYEES_PUANTAJ.SSK_OFFICE = BRANCH.SSK_OFFICE AND
		EMPLOYEES_PUANTAJ.SSK_OFFICE_NO = BRANCH.SSK_NO AND
		BRANCH.BRANCH_ID = EMPLOYEES_IN_OUT.BRANCH_ID AND
		OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
		">

<cfif fusebox.dynamic_hierarchy>
	<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
	<cfif database_type is "MSSQL">
		<cfset get_puantaj_comp_sql = get_puantaj_comp_sql & " AND ('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.')  LIKE '%.#code_i#.%'">
	<cfelseif database_type is "DB2">
		<cfset get_puantaj_comp_sql = get_puantaj_comp_sql & " AND ('.' || EMPLOYEES.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'">
	</cfif>
</cfloop>
<cfelse>
	<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
	<cfif database_type is "MSSQL">
		<cfset get_puantaj_comp_sql = get_puantaj_comp_sql & " AND ('.' + EMPLOYEES.HIERARCHY + '.') LIKE '%.#code_i#.%'">
	<cfelseif database_type is "DB2">
		<cfset get_puantaj_comp_sql = get_puantaj_comp_sql & " AND ('.' || EMPLOYEES.HIERARCHY || '.') LIKE '%.#code_i#.%'">
	</cfif>
</cfloop>
</cfif>

<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
		<cfset get_puantaj_comp_sql = get_puantaj_comp_sql & "
		AND
		OUR_COMPANY.COMP_ID = #attributes.comp_id#">
</cfif>
