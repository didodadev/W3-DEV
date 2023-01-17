<cfinclude template="../../query/get_emp_codes.cfm">
<cfset aybasi = CreateDate(attributes.yil, attributes.aylar, 1)>
<cfset aysonu = date_add('m',1,aybasi)>
<cfquery name="get_tax_exceptions" datasource="#dsn#">
	SELECT DISTINCT
		ET.TAX_EXCEPTION_ID,
		ET.TAX_EXCEPTION,
		ET.EMPLOYEE_ID,
		ET.AMOUNT,
		ET.START_MONTH,
		ET.FINISH_MONTH,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		B.BRANCH_NAME,
		EIO.DEPARTMENT_ID,
		EMP_IDENTY.TC_IDENTY_NO,
		EIO.IN_OUT_ID,
		EP.POSITION_CAT_ID,
		EP.COLLAR_TYPE,
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMPLOYEE
	FROM
		SALARYPARAM_EXCEPT_TAX ET,
		EMPLOYEES_IN_OUT EIO,
		EMPLOYEES_IDENTY EMP_IDENTY,
		BRANCH B,
		EMPLOYEES E
		LEFT JOIN EMPLOYEE_POSITIONS EP ON (E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.IS_MASTER = 1)
	WHERE
		<cfif isdefined("attributes.collar_type") and len(attributes.collar_type)>
			EP.COLLAR_TYPE = #attributes.collar_type# AND
		</cfif>
		<cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
			EP.POSITION_CAT_ID = #attributes.position_cat_id# AND
		</cfif>
		(
		<cfif attributes.aylar lte attributes.end_mon>
			(START_MONTH <= #attributes.aylar# AND FINISH_MONTH >= #attributes.aylar#)
			OR
			(FINISH_MONTH >= #attributes.aylar# AND FINISH_MONTH <= #attributes.end_mon#)
			OR
			(	
				FINISH_MONTH = #attributes.aylar# OR 
				FINISH_MONTH = #attributes.end_mon# OR 
				START_MONTH = #attributes.aylar# OR 
				START_MONTH = #attributes.end_mon#
			)
		<cfelse>
			START_MONTH IS NULL
		</cfif> 
		)
		AND
		EIO.BRANCH_ID = B.BRANCH_ID AND
		ET.TERM = #attributes.yil# AND
		E.EMPLOYEE_ID = ET.EMPLOYEE_ID AND
		EIO.EMPLOYEE_ID = E.EMPLOYEE_ID	AND
		EIO.IN_OUT_ID = ET.IN_OUT_ID AND
		EMP_IDENTY.EMPLOYEE_ID=E.EMPLOYEE_ID
	<cfif isdefined("attributes.related_company") and len(attributes.related_company)>
		AND	B.RELATED_COMPANY = '#attributes.related_company#'
	</cfif>	
	<cfif isdefined("attributes.BRANCH_ID") and attributes.BRANCH_ID is not "all">
		AND EIO.BRANCH_ID = #attributes.BRANCH_ID#
	<cfelseif not session.ep.ehesap>
		AND
		(
		EIO.BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
						)
		)
	</cfif>
	<cfif isdefined("attributes.DEPARTMENT_ID") and len(attributes.DEPARTMENT_ID) and attributes.DEPARTMENT_ID gt 0>
		AND EIO.DEPARTMENT_ID = #attributes.DEPARTMENT_ID#
	</cfif>
	<cfif len(attributes.odkes)>
		AND ET.TAX_EXCEPTION = '#attributes.odkes#'
	</cfif>
	<cfif len(attributes.keyword)>
	AND ((E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI 
	OR EMP_IDENTY.TC_IDENTY_NO = '#attributes.keyword#' OR E.EMPLOYEE_NO = '#attributes.keyword#' COLLATE SQL_Latin1_General_CP1_CI_AI)
	</cfif>
	<cfif len(emp_code_list)>
		AND 
			(
				<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
					E.OZEL_KOD LIKE '%#code_i#%' OR
					E.OZEL_KOD2 LIKE '%#code_i#%' OR
					E.HIERARCHY LIKE '%#code_i#%' OR
					E.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE OZEL_KOD LIKE '%#code_i#%')
					<cfif listlen(emp_code_list,'+') gt 1 and listlast(emp_code_list,'+') neq code_i>OR</cfif>	 
				</cfloop>
				<cfif fusebox.dynamic_hierarchy>
				OR(
					<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
						<cfif database_type is "MSSQL">
							('.' + E.DYNAMIC_HIERARCHY + '.' + E.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
							<cfif listlen(emp_code_list,'+') gt 1 and listlast(emp_code_list,'+') neq code_i>AND</cfif>
						<cfelseif database_type is "DB2">
							('.' || E.DYNAMIC_HIERARCHY || '.' || E.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
							<cfif listlen(emp_code_list,'+') gt 1 and listlast(emp_code_list,'+') neq code_i>AND</cfif>
						</cfif>
					</cfloop>
				)
				</cfif>
			)
	</cfif>
	<!---<cfif fusebox.dynamic_hierarchy>
		<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
			<cfif database_type is "MSSQL">
				AND 
				('.' + E.DYNAMIC_HIERARCHY + '.' + E.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
					
			<cfelseif database_type is "DB2">
				AND 
				('.' || E.DYNAMIC_HIERARCHY || '.' || E.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
					
			</cfif>
		</cfloop>
	<cfelse>
		<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
			<cfif database_type is "MSSQL">
				AND ('.' + E.HIERARCHY + '.') LIKE '%.#code_i#.%'
			<cfelseif database_type is "DB2">
				AND ('.' || E.HIERARCHY || '.') LIKE '%.#code_i#.%'
			</cfif>
		</cfloop>
	</cfif>--->
</cfquery>
