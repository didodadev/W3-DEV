<cfinclude template="../../query/get_emp_codes.cfm">
<cf_date tarih="attributes.startdate">
<cf_date tarih="attributes.finishdate">
<cfif isDefined("attributes.record_startdate") and len(attributes.record_startdate)>
	<cf_date tarih="attributes.record_startdate">
</cfif>
<cfif isDefined("attributes.record_finishdate") and len(attributes.record_finishdate)>
	<cf_date tarih="attributes.record_finishdate">
</cfif>
<cfquery name="GET_IN_OUTS" datasource="#dsn#" cachedwithin="#fusebox.general_cached_time#">
	SELECT DISTINCT
		EMPLOYEES.EMPLOYEE_NO,
        EMPLOYEES_IN_OUT.VALID,
        EMPLOYEES_IN_OUT.DUTY_TYPE,
		EMPLOYEES_IN_OUT.IN_OUT_ID,
		EMPLOYEES_IN_OUT.IS_5084,
		EMPLOYEES_IN_OUT.START_DATE,
		EMPLOYEES_IN_OUT.FINISH_DATE,
		EMPLOYEES_IN_OUT.KIDEM_AMOUNT,
		EMPLOYEES_IN_OUT.IHBAR_AMOUNT,
		EMPLOYEES_IN_OUT.RECORD_DATE,
		EMPLOYEES_IN_OUT.UPDATE_DATE,
		EMPLOYEES_IN_OUT.EXPLANATION_ID,
		EMPLOYEES_IN_OUT.EX_IN_OUT_ID,<!--- nakil in yapildigi giris cikis kaydi--->
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
		EMPLOYEES.KIDEM_DATE,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.EMPLOYEE_ID,
		BRANCH.BRANCH_NAME,
		BRANCH.RELATED_COMPANY,
		D.DEPARTMENT_HEAD,
		D.HIERARCHY_DEP_ID AS HIERARCHY_DEP_ID1,
		CASE 
			WHEN EMPLOYEES.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE START_DATE <= GETDATE() AND (FINISH_DATE >= GETDATE() OR FINISH_DATE IS NULL))
		THEN	
			D.HIERARCHY_DEP_ID
		ELSE 
			CASE WHEN 
				D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID))
			THEN
				(SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = D.DEPARTMENT_ID AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC)
			ELSE
				D.HIERARCHY_DEP_ID
			END
		END AS HIERARCHY_DEP_ID
        <cfif isdefined("x_get_position_cat") and x_get_position_cat eq 1>
            ,(CASE WHEN EP.EMPLOYEE_ID IS NULL THEN EPH.POSITION_ID ELSE EP.POSITION_ID END) AS POSITION_ID
            ,SPC.POSITION_CAT
		</cfif>
		,(CASE WHEN EP.EMPLOYEE_ID IS NULL THEN EPH.POSITION_NAME ELSE EP.POSITION_NAME END) AS POSITION_NAME
	FROM 
		EMPLOYEES_IN_OUT,
		EMPLOYEES
		OUTER APPLY (SELECT TOP 1 EMPLOYEE_ID, IS_MASTER, POSITION_CAT_ID, POSITION_STATUS, POSITION_ID, POSITION_NAME FROM EMPLOYEE_POSITIONS_HISTORY WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID ORDER BY HISTORY_ID DESC) AS EPH
		LEFT JOIN EMPLOYEE_POSITIONS AS EP ON EMPLOYEES.EMPLOYEE_ID = (CASE WHEN EP.EMPLOYEE_ID IS NULL THEN EPH.EMPLOYEE_ID ELSE EP.EMPLOYEE_ID END) AND (CASE WHEN EP.EMPLOYEE_ID IS NULL THEN EPH.IS_MASTER ELSE EP.IS_MASTER END) = 1 AND (CASE WHEN EP.EMPLOYEE_ID IS NULL THEN EPH.POSITION_STATUS ELSE EP.POSITION_STATUS END) = 1 AND EP.POSITION_ID = EPH.POSITION_ID
        <cfif isdefined("x_get_position_cat") and x_get_position_cat eq 1>
            LEFT JOIN SETUP_POSITION_CAT AS SPC ON SPC.POSITION_CAT_ID = (CASE WHEN EP.EMPLOYEE_ID IS NULL THEN EPH.POSITION_CAT_ID ELSE EP.POSITION_CAT_ID END)
        </cfif>,
		EMPLOYEES_IDENTY,
		BRANCH,
		DEPARTMENT D
	WHERE
		EMPLOYEES_IN_OUT.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
	<cfif isdefined('attributes.INOUT_STATUE') and attributes.INOUT_STATUE eq 1><!--- Girişler --->
		<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
			AND EMPLOYEES_IN_OUT.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
		</cfif>
        <cfif isdefined('attributes.is_out_statue') and attributes.is_out_statue eq 1 and x_finish_null eq 1>
        	AND EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
        </cfif>
		<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
			AND EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
		</cfif>
        <cfif isdefined('attributes.explanation_id2') and len(attributes.explanation_id2)>
        	<cfif attributes.explanation_id2 eq 0>
            	AND FINISH_DATE IS NULL AND EX_IN_OUT_ID IS NOT NULL
            <cfelseif attributes.explanation_id2 eq 1>
            	AND FINISH_DATE IS NULL AND EX_IN_OUT_ID IS NULL
            </cfif>
		</cfif>
	<cfelseif isdefined('attributes.INOUT_STATUE') and attributes.INOUT_STATUE eq 0><!--- Çıkışlar --->
		<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
			AND EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
		</cfif>
		<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
			AND EMPLOYEES_IN_OUT.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
		</cfif>
        <cfif isdefined('attributes.explanation_id') and len(attributes.explanation_id)>
			AND EMPLOYEES_IN_OUT.EXPLANATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.explanation_id#">
		</cfif>
		AND	EMPLOYEES_IN_OUT.FINISH_DATE IS NOT NULL
	<cfelseif isdefined('attributes.INOUT_STATUE') and attributes.INOUT_STATUE eq 2><!--- aktif calisanlar --->
		AND 
		(
			<cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
				<cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
				(
					(
					EMPLOYEES_IN_OUT.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
					EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
					)
					OR
					(
					EMPLOYEES_IN_OUT.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
					EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
					)
				)
				<cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
				(
					(
					EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
					EMPLOYEES_IN_OUT.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
					)
					OR
					(
					EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
					EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
					)
				)
				<cfelse>
				(
					(
					EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
					EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
					)
					OR
					(
					EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
					EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
					)
					OR
					(
					EMPLOYEES_IN_OUT.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
					EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
					)
					OR
					(
					EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
					EMPLOYEES_IN_OUT.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
					)
				)
				</cfif>
			<cfelse>
				EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
			</cfif>
		)
	<cfelse><!--- giriş ve çıkışlar Seçili ise --->
		AND 
		(
			(
				EMPLOYEES_IN_OUT.START_DATE IS NOT NULL
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					AND EMPLOYEES_IN_OUT.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					AND EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
				</cfif>
			)
			OR
			(
				EMPLOYEES_IN_OUT.START_DATE IS NOT NULL
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					AND EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					AND EMPLOYEES_IN_OUT.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
				</cfif>
			)
		)
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		<cfif database_type is "MSSQL">
			AND ((EMPLOYEES.EMPLOYEE_NAME + ' ' + EMPLOYEES.EMPLOYEE_SURNAME) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR EMPLOYEES_IDENTY.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> COLLATE SQL_Latin1_General_CP1_CI_AI OR EMPLOYEES.EMPLOYEE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
		<cfelse>
			AND ((EMPLOYEES.EMPLOYEE_NAME || ' ' || EMPLOYEES.EMPLOYEE_SURNAME) LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR EMPLOYEES_IDENTY.TC_IDENTY_NO = '#attributes.keyword#' COLLATE SQL_Latin1_General_CP1_CI_AI OR EMPLOYEES.EMPLOYEE_NO LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
		</cfif>
	</cfif>
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id) and (attributes.branch_id is not 'all')>
		AND EMPLOYEES_IN_OUT.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#" list="true">)
	</cfif>
	<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
		AND BRANCH.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#" list="true">)
	</cfif>
    <cfif isdefined("attributes.duty_type") and len(attributes.duty_type)>
		AND EMPLOYEES_IN_OUT.DUTY_TYPE IN(#attributes.duty_type#)
	</cfif>
    <cfif isdefined('attributes.department') and  len(attributes.department)>
		AND EMPLOYEES_IN_OUT.DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#" list="true">)
	</cfif>
	
	<cfif not session.ep.ehesap>
		AND EMPLOYEES_IN_OUT.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> )
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
							('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
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
	<!--- <cfif fusebox.dynamic_hierarchy>
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
	</cfif> --->
	<cfif isDefined("attributes.record_startdate")>
		<cfif len(attributes.record_startdate) and len(attributes.record_finishdate)>
			AND EMPLOYEES_IN_OUT.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_startdate#"> 
			AND EMPLOYEES_IN_OUT.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_finishdate#">
		<cfelseif len(attributes.record_startdate)>
			AND EMPLOYEES_IN_OUT.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_startdate#">
		<cfelseif len(attributes.record_finishdate)>
			AND EMPLOYEES_IN_OUT.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_finishdate#">
		</cfif>
	</cfif>
	<cfif isdefined('attributes.out_statue') and len(attributes.out_statue)>
		AND EMPLOYEES_IN_OUT.FINISH_DATE IS NOT NULL
		<cfif attributes.out_statue eq 1>
			AND EMPLOYEES_IN_OUT.VALID = 1
		<cfelseif attributes.out_statue eq 2>
			AND EMPLOYEES_IN_OUT.VALID IS NULL
		<cfelseif attributes.out_statue eq 3>
			AND EMPLOYEES_IN_OUT.VALID = 0
		</cfif>
	</cfif>
	<cfif isdefined("attributes.emp_status") and (attributes.emp_status eq 0)>
		AND EMPLOYEES.EMPLOYEE_STATUS = 0		  
	<cfelseif isdefined("attributes.emp_status") and (attributes.emp_status eq 1)>
		AND EMPLOYEES.EMPLOYEE_STATUS = 1
	</cfif>
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES_IN_OUT.START_DATE
</cfquery>