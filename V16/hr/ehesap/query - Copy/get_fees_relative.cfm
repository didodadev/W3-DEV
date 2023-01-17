<cfinclude template="../../query/get_emp_codes.cfm">
<cfif len(attributes.startdate)>
	<cf_date tarih = "attributes.startdate">
</cfif>
<cfif len(attributes.finishdate)>
	<cf_date tarih = "attributes.finishdate">
</cfif>

<cfquery name="GET_FEES_RELATIVE" datasource="#dsn#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		ES.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
 	FROM
		EMPLOYEES_SSK_FEE_RELATIVE ES,
		EMPLOYEES E
	WHERE 
		E.EMPLOYEE_ID = ES.EMPLOYEE_ID
	<cfif fusebox.dynamic_hierarchy>
		<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
			<cfif database_type is "MSSQL">
				AND 
				('.' + E.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
					
			<cfelseif database_type is "DB2">
				AND 
				('.' || E.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
					
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
	<cfif len(attributes.keyword)>
		AND
		(
		<cfif database_type is "MSSQL">
			E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
		<cfelseif database_type is "DB2">
			E.EMPLOYEE_NAME||' '||E.EMPLOYEE_SURNAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
		</cfif>
		ES.ILL_NAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
		ES.ILL_SURNAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		)
	</cfif>
	<cfif isdate(attributes.startdate) and isdate(attributes.finishdate)>
		AND FEE_DATE BETWEEN #attributes.startdate# and  #attributes.finishdate#
	</cfif>	
	<cfif len(attributes.branch_id)>
		AND ES.BRANCH_ID = #attributes.branch_id#
	</cfif>
	<cfif not session.ep.ehesap>
		AND ES.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
	</cfif>
	ORDER BY FEE_DATE DESC	
</cfquery>
