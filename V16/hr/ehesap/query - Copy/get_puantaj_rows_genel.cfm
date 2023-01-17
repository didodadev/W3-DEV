<cfquery name="get_puantaj_rows" datasource="#dsn#">
	SELECT DISTINCT
		EMPLOYEES_PUANTAJ_ROWS.*,
		EMPLOYEES.HIERARCHY,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.GROUP_STARTDATE,
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
		EMPLOYEES_IN_OUT.IS_5084 AS KISI_5084,
		EMPLOYEES_IN_OUT.IS_5510 AS KISI_5510,
		BRANCH.IS_5510
	FROM
		EMPLOYEES_PUANTAJ_ROWS,
		EMPLOYEES_PUANTAJ,
		EMPLOYEES,
		EMPLOYEES_IDENTY,
		EMPLOYEES_IN_OUT,
		BRANCH
	WHERE
		EMPLOYEES_PUANTAJ_ROWS.IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID AND
		EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID AND 
		EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND
		EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND
		EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = #attributes.PUANTAJ_ID# AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND
		EMPLOYEES_IDENTY.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID
	<cfif isdefined("attributes.employee_name") and len(attributes.employee_name)>
		AND EMPLOYEES.EMPLOYEE_NAME LIKE '%#attributes.employee_name#%'
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
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
</cfquery>
