<cfinclude template="../../query/get_emp_codes.cfm">
<cfquery name="get_ext_worktimes" datasource="#dsn#">
	SELECT
		EMPLOYEES_IN_OUT.IN_OUT_ID,
		EMPLOYEES_EXT_WORKTIMES.IS_PUANTAJ_OFF,
		EMPLOYEES_EXT_WORKTIMES.EWT_ID,
		EMPLOYEES_EXT_WORKTIMES.EMPLOYEE_ID,
		EMPLOYEES_EXT_WORKTIMES.START_TIME,
		EMPLOYEES_EXT_WORKTIMES.DAY_TYPE,
		EMPLOYEES_EXT_WORKTIMES.END_TIME,
		EMPLOYEES_EXT_WORKTIMES.WORK_START_TIME,
		EMPLOYEES_EXT_WORKTIMES.WORK_END_TIME,
		EMPLOYEES_EXT_WORKTIMES.RECORD_DATE,
        EMPLOYEES_EXT_WORKTIMES.VALID,<!---20131026 GSO--->
        EMPLOYEES_EXT_WORKTIMES.VALID_EMPLOYEE_ID,
        EMPLOYEES_EXT_WORKTIMES.VALIDDATE, 
		EMPLOYEES_EXT_WORKTIMES.VALID_1,
		EMPLOYEES_EXT_WORKTIMES.VALID_2,
		EMPLOYEES_EXT_WORKTIMES.VALIDATOR_POSITION_CODE_1,
		EMPLOYEES_EXT_WORKTIMES.VALIDATOR_POSITION_CODE_2,<!---20131026 GSO--->
		EMPLOYEES_EXT_WORKTIMES.PROCESS_STAGE,
		EMPLOYEES_EXT_WORKTIMES.WORKTIME_WAGE_STATU,
		EMPLOYEES_EXT_WORKTIMES.WORKING_SPACE,
		EMPLOYEES_EXT_WORKTIMES.VALID_DETAIL,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
		BRANCH.BRANCH_NAME,
		BRANCH.RELATED_COMPANY,
		DEPARTMENT.DEPARTMENT_HEAD,
		EMPLOYEES_IN_OUT.BRANCH_ID,
		EMPLOYEES_IN_OUT.PUANTAJ_GROUP_IDS,
        EP.POSITION_NAME
	FROM
		EMPLOYEES_EXT_WORKTIMES,
		EMPLOYEES
        LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND EP.IS_MASTER = 1,
		BRANCH,
		DEPARTMENT,
		EMPLOYEES_IDENTY,
		EMPLOYEES_IN_OUT
	WHERE
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
		AND EMPLOYEES_IDENTY.EMPLOYEE_ID=EMPLOYEES.EMPLOYEE_ID
		AND EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES_EXT_WORKTIMES.EMPLOYEE_ID
		AND EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_EXT_WORKTIMES.IN_OUT_ID
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
		<cfif isdefined('attributes.date1') and len(attributes.date1) and (attributes.date1 is not "NULL")>
			AND EMPLOYEES_EXT_WORKTIMES.START_TIME >= #attributes.date1#	 
		</cfif>
		<cfif isdefined('attributes.date2') and len(attributes.date2) and (attributes.date2 is not "NULL")>
			AND EMPLOYEES_EXT_WORKTIMES.END_TIME <= #DATEADD('d',1,attributes.date2)#	 
		</cfif>
		<cfif isdefined('attributes.work_date1') and len(attributes.work_date1) and (attributes.work_date1 is not "NULL")>
			AND EMPLOYEES_EXT_WORKTIMES.WORK_START_TIME >= #attributes.work_date1#	 
		</cfif>
		<cfif isdefined('attributes.work_date2') and len(attributes.work_date2) and (attributes.work_date2 is not "NULL")>
			AND EMPLOYEES_EXT_WORKTIMES.WORK_END_TIME <= #DATEADD('d',1,attributes.work_date2)#	 
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
		<cfif IsDefined('attributes.day_type') and len(attributes.day_type)>
			AND EMPLOYEES_EXT_WORKTIMES.DAY_TYPE=#attributes.day_type#
		</cfif>
		<cfif isdefined("attributes.filter_process") and len(attributes.filter_process)>
			AND EMPLOYEES_EXT_WORKTIMES.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.filter_process#">
		</cfif>
		<cfif isdefined("attributes.pdks_status") and attributes.pdks_status eq 1>AND IS_FROM_PDKS = 1</cfif>
		<cfif isdefined("attributes.pdks_status") and attributes.pdks_status eq 0>AND (IS_FROM_PDKS = 0 OR IS_FROM_PDKS IS NULL)</cfif>
		<cfif len(attributes.group_paper_no)>
			AND EMPLOYEES_EXT_WORKTIMES.EWT_ID IN (SELECT * FROM #dsn#.fnSplit((SELECT TOP 1 ACTION_LIST_ID FROM GENERAL_PAPER WHERE GENERAL_PAPER_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.group_paper_no#"> AND STAGE_ID = EMPLOYEES_EXT_WORKTIMES.PROCESS_STAGE), ','))
		</cfif>
		<cfif len(attributes.related_company)>
			AND BRANCH.RELATED_COMPANY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.related_company#">
		</cfif>
		<cfif isdefined('attributes.shift_status') and len(attributes.shift_status)>
			AND EMPLOYEES_EXT_WORKTIMES.WORKTIME_WAGE_STATU = #attributes.shift_status#
		</cfif>
		<cfif isdefined('attributes.working_space') and len(attributes.working_space)>
			AND EMPLOYEES_EXT_WORKTIMES.WORKING_SPACE = #attributes.working_space#
		</cfif>
	ORDER BY
		EMPLOYEES_EXT_WORKTIMES.START_TIME DESC,
		EMPLOYEES_EXT_WORKTIMES.RECORD_DATE DESC,		
		EMPLOYEES.EMPLOYEE_NAME ASC,
		EMPLOYEES.EMPLOYEE_SURNAME ASC
</cfquery>
