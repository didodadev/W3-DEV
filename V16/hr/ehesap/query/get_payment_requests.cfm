<cfinclude template="../../query/get_emp_codes.cfm">
<cfquery name="GET_REQUESTS" datasource="#dsn#">
	SELECT DISTINCT
	    CP.ID,
		CP.TO_EMPLOYEE_ID,
		CP.STATUS,
		CP.DEMAND_TYPE,
		CP.DUEDATE,
		CP.SUBJECT,
		CP.AMOUNT,
		CP.AMOUNT_TRANSFER,
		CP.ACTION_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		EMP_IDENTY.TC_IDENTY_NO,
		--B.COMPANY_ID, Çift ücret kartlılarda çokladığı için sayfa içerisinde kontrolü sağlandı.
        CP.MONEY,
		CP.PROCESS_STAGE,
		(SELECT COMMENT_PAY FROM SETUP_PAYMENT_INTERRUPTION SPI WHERE SPI.ODKES_ID=CP.DEMAND_TYPE AND  ISNULL(SPI.IS_DEMAND,0) = 1) AS COMMENT_PAY
	FROM 
		CORRESPONDENCE_PAYMENT CP,
		EMPLOYEES_IN_OUT EIO,
		EMPLOYEES E,
		BRANCH B,
		EMPLOYEES_IDENTY EMP_IDENTY
		
	WHERE
	<cfif attributes.avans_type eq 1>
		CP.RECORD_EMP = CP.TO_EMPLOYEE_ID AND
	<cfelseif attributes.avans_type eq 2>
		CP.RECORD_EMP <> CP.TO_EMPLOYEE_ID AND
	<cfelseif attributes.avans_type eq 3>
		CP.ACTION_ID IS NOT NULL AND 
	<cfelseif attributes.avans_type eq 4>
		CP.ACTION_ID IS NULL AND 
	</cfif>
	<cfif isdefined('attributes.filter_process') and len(attributes.filter_process)>
		CP.PROCESS_STAGE = #attributes.filter_process# AND
	</cfif>
	E.EMPLOYEE_ID = CP.TO_EMPLOYEE_ID AND
	EMP_IDENTY.EMPLOYEE_ID=E.EMPLOYEE_ID AND 
	EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND
	EIO.BRANCH_ID = B.BRANCH_ID AND
	DUEDATE >= #attributes.date1# 
	<cfif isdefined("attributes.date2") and len(attributes.date2)>
	AND DUEDATE < #dateadd('d',1,attributes.date2)#
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
	<!--- <cfif fusebox.dynamic_hierarchy>
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
	</cfif> --->
		<cfif len(trim(attributes.branch_id)) and attributes.branch_id is not "all">
			AND	EIO.BRANCH_ID = #attributes.branch_id#
		</cfif>
		<cfif len(attributes.status) and attributes.status neq 2>
				AND CP.STATUS =#attributes.status# 
		<cfelseif attributes.status eq 2>
				AND CP.STATUS IS NULL
		</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND 
			((E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2></cfif>%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI 
			OR EMP_IDENTY.TC_IDENTY_NO = '#attributes.keyword#'
			OR SUBJECT LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI 
            OR E.EMPLOYEE_NO = '#attributes.keyword#'
			)
		</cfif>
		<cfif not session.ep.ehesap>
			AND B.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
		</cfif>
		AND
			(
				( DUEDATE BETWEEN EIO.START_DATE AND EIO.FINISH_DATE AND EIO.FINISH_DATE IS NOT NULL )
				OR
				( DUEDATE >= EIO.START_DATE AND EIO.FINISH_DATE IS NULL )
			)
		<cfif isdefined('attributes.comp_id') and len(trim(attributes.comp_id)) and attributes.comp_id is not "all">
			AND B.COMPANY_ID = #attributes.comp_id#
		</cfif>
        <cfif isdefined('attributes.money') and len(attributes.money)>
			AND 
                (
                    <cfloop list="#attributes.money#" delimiters="," index="ind">
                	CP.MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ind#">
                   	<cfif listlen(attributes.money,',') gt 1 and listlast(attributes.money,',') neq ind>OR</cfif>
					</cfloop>
                )
        </cfif>
	ORDER BY 
		CP.DUEDATE DESC,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
</cfquery>
