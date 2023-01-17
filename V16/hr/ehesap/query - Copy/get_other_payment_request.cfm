<cfinclude template="../../query/get_emp_codes.cfm">
<cfquery name="GET_OTHER_REQUESTS" datasource="#dsn#">
	SELECT DISTINCT
	    CP.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		EMP_IDENTY.TC_IDENTY_NO
	FROM 
		SALARYPARAM_GET_REQUESTS CP,
		EMPLOYEES_IN_OUT EIO,
		EMPLOYEES E,
		EMPLOYEES_IDENTY EMP_IDENTY,
		BRANCH B
	WHERE
		E.EMPLOYEE_ID = CP.EMPLOYEE_ID AND
		EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		EIO.BRANCH_ID = B.BRANCH_ID AND
		EMP_IDENTY.EMPLOYEE_ID=E.EMPLOYEE_ID AND
		CP.RECORD_DATE >= #attributes.date1#
	<cfif fusebox.dynamic_hierarchy>
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
</cfif>
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		AND	EIO.BRANCH_ID = #attributes.branch_id#
	</cfif>
	<cfif len(attributes.status)>
		AND CP.IS_VALID=#attributes.status#
	</cfif>
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND ((E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2></cfif>%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI 
		OR EMP_IDENTY.TC_IDENTY_NO = '#attributes.keyword#'
		OR CP.DETAIL LIKE '%#attributes.keyword#%' OR E.EMPLOYEE_NO = '#attributes.keyword#' COLLATE SQL_Latin1_General_CP1_CI_AI )
	</cfif>
	<cfif not session.ep.ehesap>
		AND B.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	</cfif>
	ORDER BY 
		CP.TERM DESC,
		CP.START_SAL_MON DESC,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
</cfquery>
