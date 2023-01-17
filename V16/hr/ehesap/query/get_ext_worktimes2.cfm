<cfinclude template="../../query/get_emp_codes.cfm">
<cfquery name="get_ext_worktimes" datasource="#dsn#">
	SELECT
		EMPLOYEES_IN_OUT.IN_OUT_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD,
		EMPLOYEES_IN_OUT.BRANCH_ID,
		EMPLOYEES_IN_OUT.PUANTAJ_GROUP_IDS,
        EP.POSITION_NAME,
		EMPLOYEES_OVERTIME.OVERTIME_PERIOD,
		EMPLOYEES_OVERTIME.OVERTIME_MONTH,
		EMPLOYEES_OVERTIME.OVERTIME_VALUE_0,
		EMPLOYEES_OVERTIME.OVERTIME_VALUE_1,
		EMPLOYEES_OVERTIME.OVERTIME_VALUE_2,
		EMPLOYEES_OVERTIME.OVERTIME_VALUE_3,
		EMPLOYEES_OVERTIME.EMPLOYEE_ID,
		EMPLOYEES_OVERTIME.RECORD_DATE,
		EMPLOYEES_OVERTIME.WORKTIMES_ID AS EWT_ID
	FROM
		EMPLOYEES_OVERTIME,
		EMPLOYEES
        LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND EP.IS_MASTER = 1,
		BRANCH,
		DEPARTMENT,
		EMPLOYEES_IDENTY,
		EMPLOYEES_IN_OUT
	WHERE
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
		AND EMPLOYEES_IDENTY.EMPLOYEE_ID=EMPLOYEES.EMPLOYEE_ID
		AND EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES_OVERTIME.EMPLOYEE_ID
		AND EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_OVERTIME.IN_OUT_ID
		AND EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
		AND EMPLOYEES_IN_OUT.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
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
		<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
			AND
				((EMPLOYEES.EMPLOYEE_NAME + ' ' + EMPLOYEES.EMPLOYEE_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2></cfif>%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR EMPLOYEES_IDENTY.TC_IDENTY_NO = '#attributes.keyword#' OR EMPLOYEES.EMPLOYEE_NO = '#attributes.keyword#')			
		</cfif>
		<cfif isdefined('form.branch_id') and form.branch_id is not 'all'>
			AND BRANCH.BRANCH_ID = #attributes.branch_id#
		</cfif>
		<cfif isdefined('attributes.department') and len(attributes.department)>
			AND DEPARTMENT.DEPARTMENT_ID = #attributes.department#
		</cfif>
		<cfif not session.ep.ehesap>
			AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
		</cfif>	
		<!--- <cfif isdefined("attributes.pdks_status") and attributes.pdks_status eq 1>AND IS_FROM_PDKS = 1</cfif>
		<cfif isdefined("attributes.pdks_status") and attributes.pdks_status eq 0>AND (IS_FROM_PDKS = 0 OR IS_FROM_PDKS IS NULL)</cfif> --->
		<cfif isdefined('attributes.period') and len(attributes.period)>
			AND EMPLOYEES_OVERTIME.OVERTIME_PERIOD = #attributes.period# 
		</cfif>
		<cfif isdefined('attributes.mon') and len(attributes.mon)>
			AND EMPLOYEES_OVERTIME.OVERTIME_MONTH >= #attributes.mon# 
		</cfif>
		<cfif isdefined('attributes.end_mon') and len(attributes.end_mon)>
			AND EMPLOYEES_OVERTIME.OVERTIME_MONTH <= #attributes.end_mon# 
		</cfif>
	ORDER BY
		EMPLOYEES_OVERTIME.OVERTIME_PERIOD DESC,
		EMPLOYEES_OVERTIME.OVERTIME_MONTH DESC,		
		EMPLOYEES.EMPLOYEE_NAME ASC,
		EMPLOYEES.EMPLOYEE_SURNAME ASC
</cfquery>
