<cfset puantaj_gun_ = daysinmonth(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1))>
<cfif not isdefined("attributes.puantaj_id")>
	<cfset puantaj_start_ = CREATEODBCDATETIME(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1))>
	<cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_mon_end)>
		<cfset temp_puantaj_gun_ = daysinmonth(CREATEDATE(attributes.sal_year_end,attributes.sal_mon_end,1))>
		<cfset puantaj_finish_ = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(attributes.sal_year_end,attributes.sal_mon_end,temp_puantaj_gun_)))>
		<cfset bu_ay_sonu = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(attributes.sal_year_end,attributes.sal_mon_end,temp_puantaj_gun_)))>
	<cfelse>
		<cfset puantaj_finish_ = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(attributes.sal_year,attributes.sal_mon,puantaj_gun_)))>
		<cfset bu_ay_sonu = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(attributes.sal_year,attributes.sal_mon,puantaj_gun_)))>
	</cfif>
</cfif>
<cfset bu_ay_sonu = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(attributes.sal_year,attributes.SAL_MON,puantaj_gun_)))>
<cfquery name="get_puantaj_rows" datasource="#dsn#">
	SELECT
		EMPLOYEES_PUANTAJ_ROWS.*,
		EMPLOYEES_PUANTAJ.*,
		EMPLOYEES_IN_OUT.IN_OUT_ID,
		EMPLOYEES_IN_OUT.USE_SSK,
		EMPLOYEES_IN_OUT.START_DATE,
		EMPLOYEES_IN_OUT.FINISH_DATE,
		EMPLOYEES_IN_OUT.SOCIALSECURITY_NO,
		EMPLOYEES_IN_OUT.DUTY_TYPE,
		EMPLOYEES.HIERARCHY,
		EMPLOYEES.EMPLOYEE_NO,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.GROUP_STARTDATE,
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
		EMPLOYEES_IDENTY.BIRTH_DATE,
		BRANCH.*,
		EMPLOYEES_IN_OUT.IS_5084 AS KISI_5084,
		EMPLOYEES_IN_OUT.IS_5510 AS KISI_5510,
		EMPLOYEES_IN_OUT.START_CUMULATIVE_TAX,
		EMPLOYEES_IN_OUT.IS_START_CUMULATIVE_TAX,
		EMPLOYEES_IN_OUT.USE_PDKS,
		EMPLOYEES_IN_OUT.ADDITIONAL_SCORE,
		BRANCH.SSK_NO AS B_SSK_NO,
		DEPARTMENT.DEPARTMENT_HEAD,
		OUR_COMPANY.COMPANY_NAME,
		EMPLOYEES_IN_OUT.BRANCH_ID,
		EMPLOYEES_IN_OUT.PUANTAJ_GROUP_IDS,
        EMPLOYEES.KIDEM_DATE,
		OUR_COMPANY.WEB,
		OUR_COMPANY.ADDRESS,
		OUR_COMPANY.T_NO,
		OUR_COMPANY.MERSIS_NO,
		EMPLOYEES_PUANTAJ.SAL_MON,
		EMPLOYEES_IN_OUT.CUMULATIVE_TAX_TOTAL,
		OUR_COMPANY.ASSET_FILE_NAME1,
		OUR_COMPANY.ASSET_FILE_NAME1_SERVER_ID,
		OUR_COMPANY.ASSET_FILE_NAME2,
		OUR_COMPANY.ASSET_FILE_NAME2_SERVER_ID,
		OUR_COMPANY.ASSET_FILE_NAME3,
		OUR_COMPANY.ASSET_FILE_NAME3_SERVER_ID,
		OPR.*
	FROM
		EMPLOYEES_PUANTAJ,
		EMPLOYEES_PUANTAJ_ROWS
		LEFT JOIN OFFICER_PAYROLL_ROW OPR ON OPR.EMPLOYEE_PAYROLL_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID,
		DEPARTMENT,
		EMPLOYEES,
		EMPLOYEES_IDENTY,
		EMPLOYEES_IN_OUT,
		BRANCH,
		OUR_COMPANY
	WHERE
		EMPLOYEES_PUANTAJ.PUANTAJ_TYPE = #attributes.puantaj_type# AND
		EMPLOYEES_IN_OUT.IN_OUT_ID = EMPLOYEES_PUANTAJ_ROWS.IN_OUT_ID AND
		OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID AND
		BRANCH.SSK_OFFICE = EMPLOYEES_PUANTAJ.SSK_OFFICE AND
		BRANCH.SSK_NO = EMPLOYEES_PUANTAJ.SSK_OFFICE_NO AND
		EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND
		EMPLOYEES_IDENTY.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID AND
		EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID AND
		EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID 
		AND EMPLOYEES_IN_OUT.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
		<cfif not isdefined("attributes.puantaj_id")> 
			AND EMPLOYEES_IN_OUT.START_DATE < #puantaj_finish_# 
			AND (EMPLOYEES_IN_OUT.FINISH_DATE >= #puantaj_start_# OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL)
		</cfif>
	<cfif isdefined("attributes.employee_name") and len(attributes.employee_name)>
		AND EMPLOYEES.EMPLOYEE_NAME LIKE '%#attributes.employee_name#%'
	</cfif>
    <cfif isdefined("attributes.collar_type") and Len(attributes.collar_type)>
        AND EMPLOYEES.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#">)
    </cfif>
    <cfif isdefined('attributes.duty_type') and len(attributes.duty_type)>
        AND EMPLOYEES_IN_OUT.DUTY_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.duty_type#">
    </cfif>
    <cfif isdefined('attributes.title_id') and len(attributes.title_id)>
        AND EMPLOYEES_PUANTAJ_ROWS.TITLE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.title_id#">)
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
		<cfif not isdefined("attributes.puantaj_id") and not isdefined("attributes.list_employee_id")>
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
			AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfif isdefined("attributes.sal_year") and isnumeric(attributes.sal_year)>#attributes.sal_year#<cfelse>#session.ep.period_year#</cfif>
			<cfif isdefined("attributes.SSK_OFFICE") and len(attributes.SSK_OFFICE)>
				<cfif ListLen(attributes.SSK_OFFICE,'-') gt 0>
					AND REPLACE(EMPLOYEES_PUANTAJ.SSK_OFFICE,'-',' ') = '#listgetat(attributes.SSK_OFFICE,1,'-')#'
				</cfif>
				<cfif ListLen(attributes.SSK_OFFICE,'-') gt 1>
					AND EMPLOYEES_PUANTAJ.SSK_OFFICE_NO = '#listgetat(attributes.SSK_OFFICE,2,'-')#'
				</cfif>
			</cfif>
		<cfelseif isdefined("attributes.puantaj_id")>
			AND EMPLOYEES_PUANTAJ.PUANTAJ_ID = #attributes.PUANTAJ_ID#
		<cfelseif attributes.style is 'list' and isdefined("attributes.list_employee_id")>
			AND EMPLOYEES_PUANTAJ.SAL_MON = #attributes.SAL_MON#
			AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfif isdefined("attributes.sal_year") and isnumeric(attributes.sal_year)>#attributes.sal_year#<cfelse>#session.ep.period_year#</cfif>
			AND EMPLOYEES.EMPLOYEE_ID IN (#attributes.list_employee_id#)
		</cfif>
		<cfif not session.ep.ehesap>
			AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
		</cfif>

		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			<cfif database_type is "MSSQL">
				AND ((EMPLOYEES.EMPLOYEE_NAME + ' ' + EMPLOYEES.EMPLOYEE_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2></cfif>%#attributes.keyword#%' OR EMPLOYEES_IN_OUT.SOCIALSECURITY_NO = '#attributes.keyword#' OR EMPLOYEES_IDENTY.TC_IDENTY_NO = '#attributes.keyword#')
			<cfelse>
				AND ((EMPLOYEES.EMPLOYEE_NAME || ' ' || EMPLOYEES.EMPLOYEE_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2></cfif>%#attributes.keyword#%' OR EMPLOYEES_IN_OUT.SOCIALSECURITY_NO = '#attributes.keyword#' OR EMPLOYEES_IDENTY.TC_IDENTY_NO = '#attributes.keyword#')
			</cfif>
		</cfif>

		<cfif isdefined('attributes.department') and len(attributes.department)>
			AND EMPLOYEES_IN_OUT.DEPARTMENT_ID = #attributes.department#
		</cfif>
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.EMPLOYEE_ID
</cfquery>


