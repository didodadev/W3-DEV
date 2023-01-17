<cfinclude template="../../query/get_emp_codes.cfm">
<cfquery name="get_company_info" datasource="#DSN#">
	SELECT 
		COMPANY_NAME,
		MANAGER
	FROM 
		OUR_COMPANY
	WHERE
		COMP_ID = #SESSION.EP.COMPANY_ID#
</cfquery>

<cfquery name="get_branch_info" datasource="#DSN#">
	SELECT 
		BRANCH_ADDRESS,
		BRANCH_POSTCODE,
		BRANCH_COUNTY,
		BRANCH_CITY,
		BRANCH_WORK,
		ADMIN1_POSITION_CODE,
		BRANCH_FULLNAME,
		SSK_M,
		SSK_JOB,
		SSK_BRANCH,
		SSK_NO,
		SSK_CITY,
		SSK_COUNTRY,
		SSK_CD
	FROM 
		BRANCH
	WHERE
	<cfif database_type IS 'MSSQL'>
		SSK_OFFICE + '-' + SSK_NO = '#attributes.SSK_OFFICE#'
	<cfelseif database_type IS 'DB2'>
		SSK_OFFICE || '-' || SSK_NO = '#attributes.SSK_OFFICE#'
	</cfif>
	<cfif not session.ep.ehesap>
		AND 
		BRANCH.BRANCH_ID IN (
							SELECT
								BRANCH_ID
							FROM
								EMPLOYEE_POSITION_BRANCHES
							WHERE
								EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
							)
	</cfif>
		AND BRANCH_STATUS = 1
</cfquery>

<cfquery name="PUANTAJ_LIST" datasource="#dsn#">
	SELECT DISTINCT
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID,
		EMPLOYEES_PUANTAJ_ROWS.SSK_NO AS SOCIALSECURITY_NO,
		EMPLOYEES.EMPLOYEE_NAME, 
		EMPLOYEES.EMPLOYEE_SURNAME, 
		EMPLOYEES_IN_OUT.START_DATE AS STARTDATE, 
		EMPLOYEES_IN_OUT.FINISH_DATE AS FINISHDATE
	FROM
		EMPLOYEES_PUANTAJ_ROWS,
		EMPLOYEES_PUANTAJ,
		EMPLOYEES,
		EMPLOYEES_IN_OUT,
		BRANCH
	WHERE
	EMPLOYEES_PUANTAJ.SSK_BRANCH_ID = #listgetat(attributes.SSK_OFFICE,3,'-')#
	<cfif not session.ep.ehesap>
		AND 
		BRANCH.BRANCH_ID IN (
							SELECT
								BRANCH_ID
							FROM
								EMPLOYEE_POSITION_BRANCHES
							WHERE
								EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
							)
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
		AND
		EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID AND
		EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID AND
		EMPLOYEES_IN_OUT.USE_SSK = 1 AND
		EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND
		EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
		EMPLOYEES_PUANTAJ.SAL_MON IN (#attributes.SAL_MON#) AND
		EMPLOYEES_PUANTAJ.SAL_YEAR = #session.ep.period_year# AND 
		EMPLOYEES_IN_OUT.SSK_STATUTE <> 2 AND
		BRANCH.BRANCH_STATUS = 1
	ORDER BY
		EMPLOYEES_PUANTAJ_ROWS.SSK_NO
</cfquery>
