<cfinclude template="../../query/get_emp_codes.cfm">
 <cfquery name="get_my_branches" datasource="#dsn#">
 	SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#
 </cfquery>
 <cfset branch_id_list = valuelist(get_my_branches.BRANCH_ID)>
 <cfquery name="GET_OFFTIMES" datasource="#DSN#">
	SELECT DISTINCT
		OFFTIME.VALID, 
		OFFTIME.VALIDDATE, 
		OFFTIME.EMPLOYEE_ID, 
		OFFTIME.OFFTIME_ID, 
		OFFTIME.VALID_EMPLOYEE_ID, 
		OFFTIME.STARTDATE, 
		OFFTIME.FINISHDATE, 
		OFFTIME.WORK_STARTDATE, 
		OFFTIME.TOTAL_HOURS,
		OFFTIME.IS_ADDED_OFFTIME,
		OFFTIME.IS_PUANTAJ_OFF,
		OFFTIME.VALIDATOR_POSITION_CODE_1,
		OFFTIME.VALID_1,
		OFFTIME.VALIDATOR_POSITION_CODE_2,	
		OFFTIME.VALID_2,
		OFFTIME.OFFTIME_STAGE,
		EMPLOYEES.EMPLOYEE_NAME, 
		EMPLOYEES.EMPLOYEE_SURNAME, 
		EMPLOYEES.EMPLOYEE_NO, 
		SETUP_OFFTIME.OFFTIMECAT,
		SETUP_OFFTIME.IS_PAID,
		SETUP_OFFTIME.EBILDIRGE_TYPE_ID,
		SETUP_OFFTIME.CALC_CALENDAR_DAY,
		SETUP_OFFTIME.IS_PUANTAJ_OFF AS SETUP_PUANTAJ_OFF,
		OFFTIME.IS_PLAN,
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
        IN_OUT_TABLE.BRANCH_NAME,
		IN_OUT_TABLE.BRANCH_ID,
		IN_OUT_TABLE.DEPARTMENT_HEAD,
		IN_OUT_TABLE.COMPANY_ID,
        VE.EMPLOYEE_NAME AS VALID_EMPLOYEE_NAME,
        VE.EMPLOYEE_SURNAME AS VALID_EMPLOYEE_SURNAME,
		CASE 
            WHEN ISNULL(OFFTIME.SUB_OFFTIMECAT_ID,0) <> 0 THEN (SELECT top 1 OFFTIMECAT FROM SETUP_OFFTIME A WHERE A.OFFTIMECAT_ID = OFFTIME.SUB_OFFTIMECAT_ID)
            WHEN ISNULL(OFFTIME.SUB_OFFTIMECAT_ID,0) = 0 THEN (SELECT top 1  OFFTIMECAT FROM OFFTIME B WHERE B.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID)
        END AS NEW_CAT_NAME,
		EMPLOYEE_POSITIONS.POSITION_NAME
	FROM 
		OFFTIME INNER JOIN EMPLOYEES ON OFFTIME.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
        LEFT JOIN EMPLOYEES VE ON VE.EMPLOYEE_ID = OFFTIME.VALID_EMPLOYEE_ID
		LEFT JOIN EMPLOYEE_POSITIONS ON EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND EMPLOYEE_POSITIONS.IS_MASTER = 1
        INNER JOIN SETUP_OFFTIME ON OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID
		INNER JOIN EMPLOYEES_IDENTY ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID
        LEFT JOIN
        (
        	SELECT
            	BRANCH.BRANCH_NAME,
				BRANCH.COMPANY_ID,
				EMPLOYEES_IN_OUT.IN_OUT_ID,
				EMPLOYEES_IN_OUT.BRANCH_ID,
				DEPARTMENT.DEPARTMENT_HEAD
            FROM
            	EMPLOYEES_IN_OUT 
				INNER JOIN BRANCH ON EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
				INNER JOIN DEPARTMENT ON EMPLOYEES_IN_OUT.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
        ) IN_OUT_TABLE ON OFFTIME.IN_OUT_ID = IN_OUT_TABLE.IN_OUT_ID
	WHERE
    	OFFTIME.OFFTIME_ID IS NOT NULL
		<cfif attributes.izin_type eq 1>
			AND OFFTIME.RECORD_EMP = OFFTIME.EMPLOYEE_ID
		<cfelseif attributes.izin_type eq 2>
			AND OFFTIME.RECORD_EMP <> OFFTIME.EMPLOYEE_ID 
		</cfif>
		<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
			AND IN_OUT_TABLE.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list="true">)
		</cfif> 
		<cfif len(emp_code_list)>
		AND 
			(
				<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
					EMPLOYEES.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%"> OR
					EMPLOYEES.OZEL_KOD2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%"> OR
					EMPLOYEES.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%"> OR
					EMPLOYEES.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%">)
					<cfif listlen(emp_code_list,'+') gt 1 and listlast(emp_code_list,'+') neq code_i>OR</cfif>	 
				</cfloop>
				<cfif fusebox.dynamic_hierarchy>
				OR(
					<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
						<cfif database_type is "MSSQL">
							('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
							<cfif listlen(emp_code_list,'+') gt 1 and listlast(emp_code_list,'+') neq code_i>AND</cfif>
						<cfelseif database_type is "DB2">
							('.' || EMPLOYEES.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
							<cfif listlen(emp_code_list,'+') gt 1 and listlast(emp_code_list,'+') neq code_i>AND</cfif>
						</cfif>
					</cfloop>
				)
				</cfif>
			)
		</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND
			(
				<cfif database_type is "MSSQL">
				EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#IIf(len(attributes.keyword) gt 2,DE("%"),DE(""))##attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI 
				OR EMPLOYEES.EMPLOYEE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#IIf(len(attributes.keyword) gt 2,DE("%"),DE(""))##attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI 
				<cfelseif database_type is "DB2">
				EMPLOYEES.EMPLOYEE_NAME||' '||EMPLOYEES.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI 
				OR EMPLOYEES.EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> COLLATE SQL_Latin1_General_CP1_CI_AI 
                </cfif>
			)
	</cfif>
	<cfif isdefined("attributes.employee_name") and len(attributes.employee_name)>
		AND EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME LIKE '<cfif len(attributes.employee_name) gt 2>%</cfif>#attributes.employee_name#%'
	</cfif>
	<cfif isDefined("attributes.offtimecat_id") and len(attributes.offtimecat_id)>
		AND (
				SETUP_OFFTIME.OFFTIMECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offtimecat_id#">
				OR
				OFFTIME.SUB_OFFTIMECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offtimecat_id#">
			)
	</cfif>
	<cfif isDefined("attributes.STARTDATE")>
		<cfif len(attributes.STARTDATE) AND len(attributes.FINISHDATE)>
		<!--- IKI TARIH DE VAR --->
		AND
		(
			(
			OFFTIME.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.STARTDATE#"> AND
			OFFTIME.STARTDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,attributes.FINISHDATE)#">
			)
		OR
			(
			OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.STARTDATE#"> AND
			OFFTIME.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.STARTDATE#">
			)
		)
		<cfelseif len(attributes.STARTDATE)>
		<!--- SADECE BAŞLANGIÇ --->
		AND
		(
		OFFTIME.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.STARTDATE#">
		OR
			(
			OFFTIME.STARTDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.STARTDATE#"> AND
			OFFTIME.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.STARTDATE#">
			)
		)
		<cfelseif len(attributes.FINISHDATE)>
		<!--- SADECE BITIŞ --->
		AND
		(
		OFFTIME.FINISHDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,attributes.FINISHDATE)#">
		OR
			(
			OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,attributes.FINISHDATE)#"> AND
			OFFTIME.FINISHDATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,attributes.FINISHDATE)#">
			)
		)
		</cfif>
	</cfif>
	<cfif isDefined("attributes.department") and len(attributes.department)>
	 AND OFFTIME.EMPLOYEE_ID IN (SELECT EP.EMPLOYEE_ID FROM EMPLOYEE_POSITIONS EP,DEPARTMENT D WHERE EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#"> )<!--- AND EP.IS_MASTER = 1 --->
	</cfif>
	<cfif isdefined("attributes.branch_id") and attributes.branch_id is not "all">
	AND 
		(
		OFFTIME.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE BRANCH_ID = #attributes.branch_id# <cfif isdefined("attributes.STARTDATE") and isdate(attributes.STARTDATE)>AND (START_DATE <= #attributes.STARTDATE# AND (FINISH_DATE IS NULL OR FINISH_DATE >= #attributes.STARTDATE#))</cfif>)
		OR
		OFFTIME.EMPLOYEE_ID IN (SELECT EP.EMPLOYEE_ID FROM EMPLOYEE_POSITIONS EP,DEPARTMENT D WHERE EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.BRANCH_ID = #attributes.branch_id# AND EP.IS_MASTER = 1)
		)
	</cfif>
	<cfif not session.ep.ehesap>
		<cfif len(branch_id_list)>
			AND	OFFTIME.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE BRANCH_ID IN (#branch_id_list#))
		<cfelse>
			 AND OFFTIME.EMPLOYEE_ID = 0
		</cfif>
	</cfif>
	<cfif isdefined("attributes.filter_process") and len(attributes.filter_process)>
		AND OFFTIME.OFFTIME_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.filter_process#">
	</cfif>
	<cfif isdefined("attributes.off_validate") and attributes.off_validate eq 1>
		AND	OFFTIME.VALID = 1
	<cfelseif isdefined("attributes.off_validate") and  attributes.off_validate eq 2> 
		AND	OFFTIME.VALID = 0
	<cfelseif isdefined("attributes.off_validate") and  attributes.off_validate eq 3> 
		AND	OFFTIME.VALIDATOR_POSITION_CODE_1 IS NOT NULL AND OFFTIME.VALID IS NULL AND OFFTIME.VALID_1 IS NULL
	<cfelseif isdefined("attributes.off_validate") and attributes.off_validate eq 5> 
		AND	OFFTIME.VALIDATOR_POSITION_CODE_2 IS NOT NULL AND OFFTIME.VALID IS NULL AND OFFTIME.VALID_1 =1  AND OFFTIME.VALID_2 IS NULL
	<cfelseif isdefined("attributes.off_validate") and  attributes.off_validate eq 4>
		AND OFFTIME.IS_PLAN = 1
	<cfelseif isdefined("attributes.off_validate") and  attributes.off_validate eq 6>
		AND OFFTIME.VALID_1 = 0 AND OFFTIME.VALID IS NULL
	<cfelseif isdefined("attributes.off_validate") and  attributes.off_validate eq 7>
		AND OFFTIME.VALID_2 = 0 AND OFFTIME.VALID IS NULL
	<cfelseif isdefined("attributes.off_validate") and  attributes.off_validate eq 8>
		AND OFFTIME.VALIDDATE IS NULL 
		AND ((VALIDATOR_POSITION_CODE_1 IS NOT NULL AND OFFTIME.VALID_1 IS NOT NULL) OR VALIDATOR_POSITION_CODE_1 IS NULL)
		AND ((VALIDATOR_POSITION_CODE_2 IS NOT NULL AND OFFTIME.VALID_2 IS NOT NULL) OR VALIDATOR_POSITION_CODE_2 IS NULL)
	</cfif>
	<cfif len(attributes.group_paper_no)>
		AND OFFTIME.OFFTIME_ID IN (SELECT * FROM #dsn#.fnSplit((SELECT TOP 1 ACTION_LIST_ID FROM GENERAL_PAPER WHERE GENERAL_PAPER_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.group_paper_no#"> AND STAGE_ID = OFFTIME.OFFTIME_STAGE), ','))
	</cfif>
	ORDER BY
		OFFTIME.STARTDATE DESC,
		OFFTIME_ID DESC
</cfquery>
