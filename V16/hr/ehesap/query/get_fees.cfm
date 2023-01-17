<cfinclude template="../../query/get_emp_codes.cfm">
<cfif len(attributes.startdate)>
	<cf_date tarih = "attributes.startdate">
</cfif>
<cfif len(attributes.finishdate)>
	<cf_date tarih = "attributes.finishdate">
</cfif>
<cfquery name="GET_FEES" datasource="#dsn#" cachedwithin="#fusebox.general_cached_time#">
	SELECT
		ES.ACCIDENT,
        ES.ACCIDENT_TYPE_ID,
		ES.BRANCH_ID,
		ES.FEE_ID,
		ES.FEE_DATE,
		ES.EMPLOYEE_ID,
		ES.FEE_HOUR,
		ES.FEE_HOUROUT,
		ES.FEE_DATEOUT,
		ES.VALID,
		ES.VALID_EMP,
		ES.VALIDATOR_POS_CODE,
        ES.VALID_1,
		ES.VALID_EMP_1,
		ES.VALIDATOR_POS_CODE_1,
        ES.VALID_2,
		ES.VALID_EMP_2,
		ES.VALIDATOR_POS_CODE_2,
		ES.IN_OUT_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
 	FROM
		EMPLOYEES_SSK_FEE ES,
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
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND
			(
				<cfif database_type is "MSSQL">
				E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
				<cfelseif database_type is "DB2">
				E.EMPLOYEE_NAME||' '||E.EMPLOYEE_SURNAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
				</cfif>
			)
		</cfif>
		<cfif isdate(attributes.startdate) and isdate(attributes.finishdate)>
			AND FEE_DATEOUT BETWEEN #attributes.startdate# and  #attributes.finishdate#
		</cfif>
		<cfif len(attributes.branch_id)>
			AND ES.BRANCH_ID = #attributes.branch_id#
		</cfif>
		<cfif not session.ep.ehesap>
			AND ES.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
		</cfif>
        <cfif isdefined("attributes.ACC_TYPE_ID") and len(attributes.ACC_TYPE_ID)>
			AND ES.ACCIDENT_TYPE_ID = #attributes.ACC_TYPE_ID#
		</cfif>
	ORDER BY
		FEE_DATE DESC
</cfquery>
