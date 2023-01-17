<cfinclude template="../../query/get_emp_codes.cfm">
<cfscript>
	bu_ay_basi = CreateDate(attributes.salary_year,attributes.salary_month,1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfset attributes.start_date = bu_ay_basi>
<cfset attributes.finish_date = Createdate(year(bu_ay_basi),month(bu_ay_basi),bu_ay_sonu)>
<cfif len(attributes.law_startdate)>
	<cf_date tarih="attributes.law_startdate">
</cfif>
<cfif len(attributes.law_finishdate)>
	<cf_date tarih="attributes.law_finishdate">
</cfif>
<cfquery name="get_salary_list" datasource="#dsn#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		EMPLOYEES.EMPLOYEE_NO,
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
        EMPLOYEES.KIDEM_DATE,
		EMPLOYEES_IN_OUT.START_DATE AS STARTDATE,
		EMPLOYEES_IN_OUT.FINISH_DATE,
		EMPLOYEES_IN_OUT.SALARY_TYPE,
		EMPLOYEES_IN_OUT.MONEY,
		EMPLOYEES_IN_OUT.GROSS_NET,
		EMPLOYEES_IN_OUT.SOCIALSECURITY_NO,
		EMPLOYEES_IN_OUT.FAZLA_MESAI_SAAT,
		EMPLOYEES_IN_OUT.IN_OUT_ID,
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
        DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_NAME,
		EMPLOYEES_IN_OUT.DUTY_TYPE,
		EMPLOYEES_IN_OUT.MONTHLY_AVERAGE_NET
	FROM
		EMPLOYEES,
		EMPLOYEES_IN_OUT,
		EMPLOYEES_IDENTY,
        DEPARTMENT,
		BRANCH
	WHERE
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
		AND EMPLOYEES_IDENTY.EMPLOYEE_ID=EMPLOYEES.EMPLOYEE_ID
        AND DEPARTMENT.DEPARTMENT_ID=EMPLOYEES_IN_OUT.DEPARTMENT_ID
		AND EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
		<cfif isdefined("attributes.upper_salary_range") and attributes.upper_salary_range eq 0 and attributes.upper_salary_range eq 0>
			AND
			(
				EMPLOYEES_IN_OUT.IN_OUT_ID IN (SELECT IN_OUT_ID FROM EMPLOYEES_SALARY WHERE PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.salary_year#"> AND M#attributes.salary_month# = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.lower_salary_range#">)
				OR
				EMPLOYEES_IN_OUT.IN_OUT_ID NOT IN (SELECT IN_OUT_ID FROM EMPLOYEES_SALARY WHERE PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.salary_year#"> AND M#attributes.salary_month# >= <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.lower_salary_range#">)
			)
		<cfelse>
			<cfif isdefined("attributes.upper_salary_range") and len(attributes.lower_salary_range)>
				AND EMPLOYEES_IN_OUT.IN_OUT_ID IN (SELECT IN_OUT_ID FROM EMPLOYEES_SALARY WHERE PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.salary_year#"> AND M#attributes.salary_month# >= <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.lower_salary_range#">)
			</cfif>
			<cfif isdefined("attributes.upper_salary_range") and len(attributes.upper_salary_range)>
				AND EMPLOYEES_IN_OUT.IN_OUT_ID IN (SELECT IN_OUT_ID FROM EMPLOYEES_SALARY WHERE PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.salary_year#"> AND M#attributes.salary_month# <= <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.upper_salary_range#">)
			</cfif>
		</cfif>
		<cfif isdefined("attributes.collar_type") and Len(attributes.collar_type)>
			AND EMPLOYEES.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#">)
		</cfif>
		<cfif isDefined("attributes.defection_level") and len(attributes.defection_level)>
			AND EMPLOYEES_IN_OUT.DEFECTION_LEVEL = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.defection_level#">
		</cfif>
		<cfif len(attributes.ssk_statute)>
			AND EMPLOYEES_IN_OUT.SSK_STATUTE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statute#">
		</cfif>
		<cfif isdefined("attributes.duty_type") and len(attributes.duty_type)>
			AND EMPLOYEES_IN_OUT.DUTY_TYPE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.duty_type#">)
		</cfif>
		<cfif isdefined("attributes.ssk_status") and len(attributes.ssk_status)>
			AND EMPLOYEES_IN_OUT.USE_SSK = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.ssk_status#">
		</cfif>
		<cfif isDefined('attributes.status_isactive')>	
			AND EMPLOYEES.EMPLOYEE_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.status_isactive#">
		</cfif>
		AND
			(
				<!---(EMPLOYEES_IN_OUT.FINISH_DATE IS NULL AND EMPLOYEES_IN_OUT.START_DATE < <cfif attributes.salary_month lt 12>#createdatetime(attributes.salary_year,attributes.salary_month+1,1,0,0,0)#<cfelse>#createdatetime(attributes.salary_year+1,1,1,0,0,0)#</cfif> )
				OR
				(
					EMPLOYEES_IN_OUT.FINISH_DATE <= #createdatetime(attributes.salary_year,attributes.salary_month,1,0,0,0)# 
				)--->
				(
					EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
					EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
					)
					OR
					(
					EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
					EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
					)
					OR
					(
					EMPLOYEES_IN_OUT.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
					EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
					)
					OR
					(
					EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
					EMPLOYEES_IN_OUT.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
					)
			)
		<cfif not session.ep.ehesap>
			AND EMPLOYEES_IN_OUT.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		</cfif>
		<cfif fusebox.dynamic_hierarchy>
			<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
				<cfif database_type is "MSSQL">
					AND 
					(
						('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
						OR EMPLOYEES.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%">
						OR EMPLOYEES.OZEL_KOD2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%">
						OR EMPLOYEES.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%">
					)
				<cfelseif database_type is "DB2">
					AND 
					(
						('.' || EMPLOYEES.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
						OR EMPLOYEES.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%">
						OR EMPLOYEES.OZEL_KOD2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%">
						OR EMPLOYEES.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%">
					)
				</cfif>
			</cfloop>
		<cfelse>
			<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
				<cfif database_type is "MSSQL">
					AND 
					(
						('.' + EMPLOYEES.HIERARCHY + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
						OR EMPLOYEES.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%">
						OR EMPLOYEES.OZEL_KOD2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%">
					)
					
				<cfelseif database_type is "DB2">
					AND 
					(
						('.' || EMPLOYEES.HIERARCHY || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
						OR EMPLOYEES.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%">
						OR EMPLOYEES.OZEL_KOD2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%">
					)
				</cfif>
			</cfloop>
		</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		<cfif database_type is "MSSQL">
			AND ((EMPLOYEES.EMPLOYEE_NAME + ' ' + EMPLOYEES.EMPLOYEE_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR EMPLOYEES_IN_OUT.SOCIALSECURITY_NO = '#attributes.keyword#' OR EMPLOYEES_IDENTY.TC_IDENTY_NO = '#attributes.keyword#' OR EMPLOYEES.EMPLOYEE_NO = '#attributes.keyword#')
		<cfelse>
			AND ((EMPLOYEES.EMPLOYEE_NAME || ' ' || EMPLOYEES.EMPLOYEE_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR EMPLOYEES_IN_OUT.SOCIALSECURITY_NO = '#attributes.keyword#' OR EMPLOYEES_IDENTY.TC_IDENTY_NO = '#attributes.keyword#' OR EMPLOYEES.EMPLOYEE_NO LIKE '%#attributes.keyword#%')
		</cfif>
	</cfif>
	<cfif not get_module_power_user(48)>
		AND (EMPLOYEES_IN_OUT.IS_PUANTAJ_OFF = 0 OR EMPLOYEES_IN_OUT.IS_PUANTAJ_OFF IS NULL)
	</cfif>	
	<cfif isdefined("attributes.status_sabit_prim") and len(attributes.status_sabit_prim)>
		AND EMPLOYEES_IN_OUT.SABIT_PRIM = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.status_sabit_prim#">
	</cfif>
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id) and (attributes.branch_id is not 'all')>
		AND EMPLOYEES_IN_OUT.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
	</cfif>
    <cfif isdefined('attributes.department') and len(attributes.department)>
		AND EMPLOYEES_IN_OUT.DEPARTMENT_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
	</cfif>
    <cfif isdefined('attributes.salary_type') and len(attributes.salary_type)>
		AND EMPLOYEES_IN_OUT.SALARY_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.salary_type#">
	</cfif>
	<cfif len(attributes.law_numbers)>
		<cfif attributes.law_numbers eq '5763'>
			AND EMPLOYEES_IN_OUT.IS_5510 = 1
		<cfelseif attributes.law_numbers eq '5084'>
			AND EMPLOYEES_IN_OUT.IS_5084 = 1
		<cfelseif attributes.law_numbers eq '6486'>
			AND EMPLOYEES_IN_OUT.IS_6486 = 1
		<cfelseif attributes.law_numbers eq '6322'>
			AND EMPLOYEES_IN_OUT.IS_6322 = 1
		<cfelseif attributes.law_numbers eq '25510'>
			AND EMPLOYEES_IN_OUT.IS_25510 = 1
      	<cfelseif attributes.law_numbers eq '46486'>
			AND EMPLOYEES_IN_OUT.IS_46486 = 1
     	<cfelseif attributes.law_numbers eq '56486'>
			AND EMPLOYEES_IN_OUT.IS_56486 = 1
      	<cfelseif attributes.law_numbers eq '66486'>
			AND EMPLOYEES_IN_OUT.IS_66486 = 1
		<cfelse>
			AND EMPLOYEES_IN_OUT.LAW_NUMBERS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.law_numbers#">
		</cfif>
		<cfif attributes.law_numbers eq '6111' and (len(attributes.law_startdate) or len(attributes.law_finishdate))>
           <cfif len(attributes.law_startdate)>
            AND EMPLOYEES_IN_OUT.DATE_6111 >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.law_startdate#"> 
           </cfif>
           <cfif len(attributes.law_finishdate)>
            AND EMPLOYEES_IN_OUT.DATE_6111 <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.law_finishdate#"> 
           </cfif>
        <cfelseif attributes.law_numbers eq '5763' and (len(attributes.law_startdate) or len(attributes.law_finishdate))>
            <cfif len(attributes.law_startdate)>
            AND EMPLOYEES_IN_OUT.DATE_5763 >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.law_startdate#"> 
            </cfif>
            <cfif len(attributes.law_finishdate)>
            AND EMPLOYEES_IN_OUT.DATE_5763 <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.law_finishdate#"> 
            </cfif>
        </cfif>
    </cfif>
		AND GROSS_NET IS NOT NULL
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
</cfquery>