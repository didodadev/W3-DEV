<cfset puantaj_gun_ = daysinmonth(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1))>
<cfset puantaj_start_ = CREATEODBCDATETIME(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1))>
<cfset puantaj_finish_ = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(attributes.sal_year,attributes.SAL_MON,puantaj_gun_)))>
<cfquery name="get_puantaj_rows" datasource="#dsn#">
	SELECT DISTINCT
		EMPLOYEES_PUANTAJ_ROWS.*,
		EMPLOYEES.HIERARCHY,
		EMPLOYEES.DYNAMIC_HIERARCHY,
		EMPLOYEES.DYNAMIC_HIERARCHY_ADD,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.GROUP_STARTDATE,
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
		EMPLOYEES_IN_OUT.USE_SSK,
		EMPLOYEES_IN_OUT.IN_OUT_ID,
		EMPLOYEES_IN_OUT.SSK_STATUTE,
		EMPLOYEES_IN_OUT.DEFECTION_LEVEL,
		EMPLOYEES_IN_OUT.TRADE_UNION_DEDUCTION,
		EMPLOYEES_IN_OUT.USE_TAX,
		BRANCH.BRANCH_ID,
		EMPLOYEES_IN_OUT.START_DATE
	FROM
		EMPLOYEES_PUANTAJ_ROWS,
		EMPLOYEES_PUANTAJ,
		EMPLOYEES,
		EMPLOYEES_IDENTY,
		EMPLOYEES_IN_OUT,
		BRANCH
		<cfif (isdefined("attributes.branch_id_x") and len(attributes.branch_id_x) or (isdefined("attributes.department") and len(attributes.department)))>
			,EMPLOYEE_POSITIONS,
			DEPARTMENT
		</cfif>
	WHERE		
		EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND
		EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID IN (#attributes.PUANTAJ_ID#) AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND
		EMPLOYEES_PUANTAJ.SSK_OFFICE = BRANCH.SSK_OFFICE AND
		EMPLOYEES_PUANTAJ.SSK_OFFICE_NO = BRANCH.SSK_NO AND
		EMPLOYEES_IDENTY.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND 
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
		<cfif (isdefined("attributes.branch_id_x") and len(attributes.branch_id_x) or (isdefined("attributes.department") and len(attributes.department)))>
			EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND
			EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
			EMPLOYEE_POSITIONS.IS_MASTER = 1 AND
		</cfif>
		EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID AND
		EMPLOYEES_IN_OUT.START_DATE < #puantaj_finish_# AND 
		(EMPLOYEES_IN_OUT.FINISH_DATE >= #puantaj_start_# OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL)
		<cfif isdefined("attributes.department") and len(attributes.department)>
			AND DEPARTMENT.DEPARTMENT_ID IN (#attributes.department#)
		</cfif>
		<cfif isdefined("attributes.is_normal") or  isdefined("attributes.is_emekli") or isdefined("attributes.is_ozurlu")>
			AND <cfif (isdefined("attributes.is_normal") and isdefined("attributes.is_emekli")) or (isdefined("attributes.is_ozurlu") and isdefined("attributes.is_emekli")) or (isdefined("attributes.is_normal") and isdefined("attributes.is_ozurlu"))>(</cfif>
				<cfif isdefined("attributes.is_normal")>EMPLOYEES_IN_OUT.SSK_STATUTE = 1</cfif>
				<cfif isdefined("attributes.is_normal") and isdefined("attributes.is_emekli")>OR</cfif>
				<cfif isdefined("attributes.is_emekli")>EMPLOYEES_IN_OUT.SSK_STATUTE = 2</cfif>
				<cfif isdefined("attributes.is_ozurlu") and (isdefined("attributes.is_normal") or isdefined("attributes.is_emekli"))>OR</cfif>
				<cfif isdefined("attributes.is_ozurlu")>EMPLOYEES_IN_OUT.DEFECTION_LEVEL <> 0</cfif>
				<cfif (isdefined("attributes.is_normal") and isdefined("attributes.is_emekli")) or (isdefined("attributes.is_ozurlu") and isdefined("attributes.is_emekli")) or (isdefined("attributes.is_normal") and isdefined("attributes.is_ozurlu"))>)</cfif>
		</cfif>
	<cfif isdefined("attributes.employee_name") and len(attributes.employee_name)>
		AND EMPLOYEES.EMPLOYEE_NAME LIKE '%#attributes.employee_name#%'
	</cfif>
	<cfif isdefined("attributes.branch_id_x") and len(attributes.branch_id_x)>
		AND DEPARTMENT.BRANCH_ID IN (#attributes.branch_id_x#)
	</cfif>
	<cfinclude template="../../query/get_emp_codes.cfm">
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
	ORDER BY
		EMPLOYEES_IN_OUT.SSK_STATUTE,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID DESC,
		EMPLOYEES_IN_OUT.DEFECTION_LEVEL,
		EMPLOYEES_IN_OUT.TRADE_UNION_DEDUCTION,
		EMPLOYEES_IN_OUT.USE_SSK,
		EMPLOYEES_IN_OUT.USE_TAX,
		EMPLOYEES_IN_OUT.IN_OUT_ID
</cfquery>
