<cfparam name="attributes.puantaj_type" default="-1">
<cfset puantaj_gun_ = daysinmonth(CREATEDATE(attributes.sal_year,attributes.sal_mon,1))>
<cfset puantaj_start_ = CREATEODBCDATETIME(CREATEDATE(attributes.sal_year,attributes.sal_mon,1))>
<cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_mon_end)>
	<cfset temp_puantaj_gun_ = daysinmonth(CREATEDATE(attributes.sal_year_end,attributes.sal_mon_end,1))>
	<cfset puantaj_finish_ = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(attributes.sal_year_end,attributes.sal_mon_end,temp_puantaj_gun_)))>
	<cfset bu_ay_sonu = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(attributes.sal_year_end,attributes.sal_mon_end,temp_puantaj_gun_)))>
<cfelse>
	<cfset puantaj_finish_ = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(attributes.sal_year,attributes.sal_mon,puantaj_gun_)))>
	<cfset bu_ay_sonu = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(attributes.sal_year,attributes.sal_mon,puantaj_gun_)))>
</cfif>
<cfquery name="GET_PUANTAJ_PERSONAL" datasource="#DSN#">
	SELECT
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_FULLNAME,
		BRANCH.BRANCH_NAME,
		BRANCH.SSK_M,
		BRANCH.SSK_JOB,
		BRANCH.SSK_BRANCH,
		BRANCH.SSK_BRANCH_OLD,
		BRANCH.SSK_CITY,
		BRANCH.SSK_COUNTRY,
		BRANCH.SSK_CD,
		BRANCH.SSK_AGENT,
		BRANCH.SSK_NO B_SSK_NO,
		BRANCH.IS_5510,
		BRANCH.COMPANY_ID,
		BRANCH.ISKUR_BRANCH_NO,
		BRANCH.BRANCH_TAX_NO,
		BRANCH.BRANCH_TAX_OFFICE,
		BRANCH.BRANCH_ADDRESS,
		BRANCH.BRANCH_COUNTY,
		BRANCH.BRANCH_CITY,
		BRANCH.DANGER_DEGREE_NO,
		OUR_COMPANY.ADDRESS,
		OUR_COMPANY.T_NO,
		OUR_COMPANY.MERSIS_NO,
		OUR_COMPANY.WEB,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.EMPLOYEE_NO,
		EMPLOYEES.GROUP_STARTDATE,
		EMPLOYEES.KIDEM_DATE,
		EMPLOYEES.MOBILTEL,
		EMPLOYEES.EMPLOYEE_EMAIL,
		EMPLOYEES_IN_OUT.IS_5084 AS KISI_5084,
		EMPLOYEES_IN_OUT.IS_5510 AS KISI_5510,
		EMPLOYEES_IN_OUT.IN_OUT_ID,
		EMPLOYEES_IN_OUT.USE_SSK,
		EMPLOYEES_IN_OUT.USE_PDKS,
		EMPLOYEES_IN_OUT.START_DATE,
		EMPLOYEES_IN_OUT.FINISH_DATE,
		EMPLOYEES_IN_OUT.SOCIALSECURITY_NO,
		EMPLOYEES_IN_OUT.DUTY_TYPE,
		EMPLOYEES_IN_OUT.START_CUMULATIVE_TAX,
		EMPLOYEES_IN_OUT.IS_START_CUMULATIVE_TAX,
		EMPLOYEES_IN_OUT.CUMULATIVE_TAX_TOTAL,
		EMPLOYEES_IN_OUT.USE_PDKS,
		EMPLOYEES_IN_OUT.BRANCH_ID,
		EMPLOYEES_IN_OUT.PUANTAJ_GROUP_IDS,
		EMPLOYEES_IN_OUT.GRADE,
		EMPLOYEES_IN_OUT.STEP,
		EMPLOYEES_IN_OUT.ACADEMIC_INCENTIVE_ALLOWANCE,
		EMPLOYEES_IN_OUT.HIGH_EDUCATION_COMPENSATION,
		EMPLOYEES_IN_OUT.REGISTRY_NO,
		EMPLOYEES_IN_OUT.RETIRED_REGISTRY_NO,
		EMPLOYEES_IN_OUT.SERVICE_CLASS,
		EMPLOYEES_IN_OUT.SERVICE_TITLE,
		EMPLOYEES_IN_OUT.ADDITIONAL_SCORE,
		EMPLOYEES_IN_OUT.EXPLANATION_ID,
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
		EMPLOYEES_IDENTY.BIRTH_DATE,
		EMPLOYEES_PUANTAJ.*,
		EMPLOYEES_PUANTAJ_ROWS.*,
		OPR.*,
		OUR_COMPANY.ASSET_FILE_NAME1,
		OUR_COMPANY.ASSET_FILE_NAME1_SERVER_ID,
		OUR_COMPANY.ASSET_FILE_NAME2,
		OUR_COMPANY.ASSET_FILE_NAME2_SERVER_ID,
		OUR_COMPANY.ASSET_FILE_NAME3,
		OUR_COMPANY.ASSET_FILE_NAME3_SERVER_ID,
		DEFECTION_LEVEL,
		DEFECTION_STARTDATE,
    	DEFECTION_FINISHDATE,
		IS_VETERAN,
		PAST_AGI_DAY,
		LAND_COMPENSATION_SCORE,
        LAND_COMPENSATION_PERIOD,
		JURY_MEMBERSHIP,
        JURY_MEMBERSHIP_PERIOD,
		JURY_NUMBER,
		DAILY_MINIMUM_WAGE_BASE_CUMULATE,
		MINIMUM_WAGE_CUMULATIVE,
		DAILY_MINIMUM_INCOME_TAX,
		DAILY_MINIMUM_WAGE_STAMP_TAX,
		DAILY_MINIMUM_WAGE,
		USE_MINIMUM_WAGE
	FROM
		BRANCH,
		EMPLOYEES_IN_OUT,
		EMPLOYEES,
		EMPLOYEES_PUANTAJ,
		EMPLOYEES_PUANTAJ_ROWS
		LEFT JOIN OFFICER_PAYROLL_ROW OPR ON OPR.EMPLOYEE_PAYROLL_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID,
		EMPLOYEES_IDENTY,
		OUR_COMPANY
	WHERE
		EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_PUANTAJ_ROWS.IN_OUT_ID AND
		EMPLOYEES_IDENTY.EMPLOYEE_ID = #attributes.employee_id#
		AND EMPLOYEES_PUANTAJ.PUANTAJ_TYPE = #attributes.PUANTAJ_TYPE#
		AND EMPLOYEES.EMPLOYEE_ID = #attributes.employee_id#
		<cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_mon_end)>
			AND (
				(EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
				OR
				(
					EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
					EMPLOYEES_PUANTAJ.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
					(
						EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">
						OR
						(EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
					)
				)
				OR
				(
					EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
					(
						EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">
						OR
						(EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
					)
				)
				OR
				(
					EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND 
					EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
					EMPLOYEES_PUANTAJ.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
					EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
				)
			)
		<cfelse>
			AND EMPLOYEES_PUANTAJ.SAL_MON = #attributes.sal_mon#
			AND EMPLOYEES_PUANTAJ.SAL_YEAR = #attributes.sal_year#
		</cfif>
		AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #attributes.employee_id#
		AND EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
		AND EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID
		AND EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
		AND BRANCH.SSK_OFFICE = EMPLOYEES_PUANTAJ.SSK_OFFICE
		AND BRANCH.SSK_NO = EMPLOYEES_PUANTAJ.SSK_OFFICE_NO
		<cfif (isdefined("get_program_parameters.FIRST_DAY_MONTH") and len(get_program_parameters.FIRST_DAY_MONTH) and not(get_program_parameters.FIRST_DAY_MONTH eq 1 and get_program_parameters.LAST_DAY_MONTH eq 0)) >
			AND EMPLOYEES_IN_OUT.START_DATE < <cfqueryparam CFSQLType = "cf_sql_timestamp" value = "#finish_date_new#">
			AND (EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam CFSQLType = "cf_sql_timestamp" value = "#start_date_new#"> OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL)
		<cfelse>
			AND EMPLOYEES_IN_OUT.START_DATE < #puantaj_finish_#
			AND (EMPLOYEES_IN_OUT.FINISH_DATE >= #puantaj_start_# OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL)
		</cfif>
		AND OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
		<cfif not session.ep.ehesap and not isdefined("is_bireysel_bordro")>
			AND BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
		</cfif>
		<cfif isDefined("attributes.in_out_id") and len(attributes.in_out_id)>
			AND EMPLOYEES_IN_OUT.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
		</cfif>
	ORDER BY
		EMPLOYEES_PUANTAJ.SAL_YEAR ASC,
		EMPLOYEES_PUANTAJ.SAL_MON ASC
</cfquery>
<cfquery name="get_position_detail" datasource="#dsn#">
	SELECT
		EMPLOYEE_POSITIONS.*,
		DEPARTMENT.DEPARTMENT_ID,
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.BRANCH_ID
	FROM
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH
	WHERE
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND 
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
</cfquery>
