<cfinclude template="../../query/get_emp_codes.cfm">
<cfif isdefined("GET_BRANCH_INFO") and GET_BRANCH_INFO.recordcount>
	<cfset out_branch_list = listsort(listdeleteduplicates(valuelist(GET_BRANCH_INFO.branch_id,',')),'numeric','ASC',',')>
	<!--- <cfset out_branch_list = GET_BRANCH_INFO.branch_id> --->
</cfif>
<cfquery name="get_employees_out" datasource="#dsn#">
	SELECT
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES_IDENTY.FATHER,
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
		EMPLOYEES_IDENTY.BIRTH_DATE,
		EMPLOYEES_IN_OUT.FINISH_DATE AS FINISHDATE,
		<!--- EMPLOYEES_IN_OUT.DETAIL, --->
		EMPLOYEES_IN_OUT.EXPLANATION_ID,
		EMPLOYEES_IN_OUT.SOCIALSECURITY_NO,
		EMPLOYEES_IN_OUT.RETIRED_SGDP_NUMBER,
		EMPLOYEES_IN_OUT.SSK_STATUTE
	FROM
		EMPLOYEES_IN_OUT,
		EMPLOYEES_IDENTY,
		EMPLOYEES
	WHERE
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
		AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID
		AND EMPLOYEES_IN_OUT.FINISH_DATE < #last_day_of_month#
		AND EMPLOYEES_IN_OUT.FINISH_DATE >= #first_day_of_month#
		AND EMPLOYEES_IN_OUT.VALID = 1
		AND EMPLOYEES_IN_OUT.USE_SSK = 1
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
	<cfif isdefined("GET_BRANCH_INFO") and GET_BRANCH_INFO.recordcount>
		AND
		EMPLOYEES_IN_OUT.BRANCH_ID IN (#out_branch_list#)
	</cfif>
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
</cfquery>
