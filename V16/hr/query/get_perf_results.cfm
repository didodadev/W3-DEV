<cfinclude template="get_emp_codes.cfm">
<!--- ın_outa bagli cekmesinde sorunlar var dogru inout alinmiyor kaldirildi hedefin istegi ile düzeltilirse koyula bilir  --->
<cfquery name="GET_PERF_RESULTS" datasource="#dsn#" cachedwithin="#fusebox.general_cached_time#">
	SELECT DISTINCT
		EPERF.PER_ID,
		EPERF.START_DATE,
		EPERF.FINISH_DATE,
		EPERF.EVAL_DATE,
		EPERF.RECORD_DATE,
		EPERF.RECORD_TYPE,
		EPERF.IS_CLOSED,
		EQ.QUIZ_ID,
		EQ.QUIZ_HEAD,
		EQ.POSITION_CAT_ID,
		EQ.POSITION_ID AS POSITION_IDS,
		EMPLOYEES.EMPLOYEE_ID,		
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EPOS.POSITION_ID,
		EPOS.POSITION_NAME
	FROM 
		EMPLOYEE_PERFORMANCE EPERF,
		EMPLOYEE_POSITIONS EPOS,
		EMPLOYEE_QUIZ EQ,
		EMPLOYEE_QUIZ_RESULTS EQR,
		DEPARTMENT,
		BRANCH,
		EMPLOYEES
	WHERE
		<cfif len(attributes.CLOSED_TYPE)>
			EPERF.IS_CLOSED = #attributes.CLOSED_TYPE# AND	
		</cfif>
		<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
			EPERF.PER_STAGE = #attributes.process_stage# AND
		</cfif>
		<cfif isdefined("attributes.valid_type") and attributes.valid_type eq 1>
			EPERF.VALID_3 = 1 AND
		</cfif>
		<cfif isdefined("attributes.valid_type") and attributes.valid_type eq 2>
			EPERF.VALID_3 IS NULL AND
		</cfif>
		EPERF.RESULT_ID = EQR.RESULT_ID AND
		EQR.QUIZ_ID = EQ.QUIZ_ID AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
		EPOS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		EMPLOYEES.EMPLOYEE_ID = EPOS.EMPLOYEE_ID AND
		EPOS.EMPLOYEE_ID > 0 AND
		<cfif not session.ep.ehesap>
			BRANCH.BRANCH_ID IN 
							(
								SELECT 
									BRANCH_ID 
								FROM	
									EMPLOYEE_POSITION_BRANCHES
								WHERE
									POSITION_CODE=#session.ep.position_code#
							) AND
		</cfif>
		<cfif len(attributes.eval_date)>
			EPERF.EVAL_DATE=#attributes.eval_date# AND
		<cfelseif not len(attributes.eval_date) and len(attributes.period_year)>
			YEAR(EPERF.START_DATE) = #attributes.period_year# AND
		<cfelseif len(attributes.eval_date) and len(attributes.period_year)>
			EPERF.EVAL_DATE=#attributes.eval_date# AND
		<cfelseif not len(attributes.eval_date) and not len(attributes.period_year)>
			YEAR(EPERF.START_DATE) = #session.ep.period_year# AND 
		</cfif>
		<cfif len(attributes.department_id)>
			DEPARTMENT.DEPARTMENT_ID = #attributes.department_id# AND
		</cfif> 
		<cfif len(attributes.branch_id)>
			BRANCH.BRANCH_ID = #attributes.branch_id# AND
		</cfif> 
		<cfif isdefined("attributes.record_type") and len(attributes.record_type)>
			EPERF.RECORD_TYPE = #attributes.record_type# AND
		</cfif>
			EPERF.EMP_ID = EMPLOYEES.EMPLOYEE_ID AND
			(EQ.IS_EDUCATION = 0 OR EQ.IS_EDUCATION IS NULL) AND
			(EQ.IS_TRAINER = 0 OR EQ.IS_TRAINER IS NULL)
		<cfif IsDefined("attributes.form_POSITION_CAT_ID") and len(attributes.form_POSITION_CAT_ID)>
			AND EPOS.POSITION_CAT_ID = #attributes.form_POSITION_CAT_ID#
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(
				EQ.QUIZ_HEAD LIKE '%#attributes.keyword#%' OR
			<cfif IsDefined("attributes.POSITION_CAT_ID") and len(attributes.POSITION_CAT_ID)>
				EPOS.POSITION_NAME LIKE '%#attributes.keyword#%' OR
			</cfif>
				EMPLOYEES.EMPLOYEE_NAME + ' ' + EMPLOYEES.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
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
	ORDER BY 
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EPERF.EVAL_DATE DESC,
		EPERF.RECORD_DATE DESC
</cfquery>
