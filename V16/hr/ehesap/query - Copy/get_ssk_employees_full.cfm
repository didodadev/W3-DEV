<cfinclude template="../../query/get_emp_codes.cfm">
<cfquery name="GET_SSK_EMPLOYEES_FULL" datasource="#DSN#">
	SELECT 
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES_IN_OUT.DUTY_TYPE,
		EMPLOYEES_IN_OUT.SOCIALSECURITY_NO,
		EMPLOYEES_IN_OUT.RETIRED_SGDP_NUMBER,
		EMPLOYEES_IN_OUT.START_DATE AS STARTDATE,
		EMPLOYEES_IDENTY.FATHER,
		EMPLOYEES_IDENTY.BIRTH_DATE,
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
		EMPLOYEES_DETAIL.SEX,
		EMPLOYEES_IN_OUT.SSK_STATUTE		
	FROM
		EMPLOYEES_IDENTY,
		EMPLOYEES_DETAIL,
		EMPLOYEES,
		BRANCH,
		EMPLOYEES_IN_OUT
				
	WHERE
		EMPLOYEES_IN_OUT.USE_SSK = 1 AND
		EMPLOYEES_IN_OUT.START_DATE >= #CREATEDATE(attributes.sal_year,attributes.SAL_MON,1)# AND
		EMPLOYEES_IN_OUT.START_DATE <= #CREATEDATE(attributes.sal_year,attributes.SAL_MON,DAYSINMONTH(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1)))# AND
			(
			EMPLOYEES_IN_OUT.FINISH_DATE >= #CREATEDATE(attributes.sal_year,attributes.SAL_MON,1)#
			OR
			EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
			)
		AND
		EMPLOYEES_DETAIL.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
		EMPLOYEES_IDENTY.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
		EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID AND
		BRANCH.BRANCH_STATUS = 1 AND
		BRANCH.BRANCH_ID = #attributes.SSK_OFFICE#
		<!--- BRANCH.SSK_OFFICE = '#LISTGETAT(attributes.SSK_OFFICE,1,'-')#' AND
		BRANCH.SSK_NO = '#LISTGETAT(attributes.SSK_OFFICE,2,'-')#' --->
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
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
</cfquery>
