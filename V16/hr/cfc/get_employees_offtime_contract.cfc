<cfcomponent>
	<cfset this.dsn = application.systemParam.systemParam().dsn>
	<cffunction name="get_employees_offtime_contract" access="public" returntype="query">
		<cfargument name="keyword" default="">
		<cfargument name="position_cat_id" default="">
		<cfargument name="branch_id" default="">
		<cfargument name="position_name" default="">
		<cfargument name="ehesap_control" default="1">		
		<cfargument name="emp_code_list" default="">
		<cfargument name="department" default="">
		<cfargument name="fusebox_dynamic_hierarchy" default="">
        <cfargument name="is_approve" default="">
        <cfargument name="is_mail" default="">
		<cfargument name="startrow" default="">
		<cfargument name="maxrows" default="">
		<cfargument name="employees_offtime_contract_id" default="">

		<cfif (len(arguments.position_cat_id) or (isdefined("arguments.branch_id") and arguments.branch_id is not "all") or len(arguments.position_name))>
			<cfset hr_search_type = "with_position">
		<cfelse>
			<cfset hr_search_type = "">
		</cfif>
		<cfif arguments.ehesap_control eq 1 and not session.ep.ehesap>
			<cfquery name="my_branches" datasource="#this.dsn#">
				SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
			</cfquery>
			<cfset my_branch_list = valuelist(my_branches.branch_id)>
			<cfquery name="get_emps_ins" datasource="#this.dsn#">
				SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE
				<cfif listlen(my_branch_list)>
					BRANCH_ID IN (#my_branch_list#)
				<cfelse>
					BRANCH_ID=0
				</cfif>
				<cfif len(arguments.branch_id) and arguments.branch_id is not "all">AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"></cfif>
			</cfquery>
			<cfset in_out_employee_list = valuelist(get_emps_ins.employee_id)>
		</cfif>
        
        <cfquery name="get_employees_offtime_contract_query" datasource="#this.dsn#">
        	WITH CTE1 AS (
				SELECT 
                    EMPLOYEES_OFFTIME_CONTRACT.*,
					BRANCH.BRANCH_NAME,
					DEPARTMENT.DEPARTMENT_HEAD,
					EMPLOYEE_POSITIONS.POSITION_NAME,
			        EMPLOYEE_POSITIONS.POSITION_ID,
					EMPLOYEE_POSITIONS.POSITION_CODE,
					SETUP_POSITION_CAT.POSITION_CAT,
					EMPLOYEES.EMPLOYEE_NAME,
					EMPLOYEES.EMPLOYEE_EMAIL,
					EMPLOYEES.EMPLOYEE_USERNAME,
					EMPLOYEES.EMPLOYEE_SURNAME,
					EMPLOYEES.EMPLOYEE_NO,
					EMPLOYEES.GROUP_STARTDATE,
					EMPLOYEES.EMPLOYEE_STATUS,
                    EMPLOYEES_IDENTY.LAST_SURNAME,
					EMPLOYEES_IDENTY.TC_IDENTY_NO
				FROM
                    EMPLOYEES_OFFTIME_CONTRACT
					LEFT JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_OFFTIME_CONTRACT.EMPLOYEE_ID
					INNER JOIN EMPLOYEES_IDENTY ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID
					INNER JOIN EMPLOYEES_DETAIL ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_DETAIL.EMPLOYEE_ID
					LEFT JOIN EMPLOYEE_POSITIONS ON EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND EMPLOYEE_POSITIONS.IS_MASTER = 1
					LEFT JOIN DEPARTMENT ON EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
					LEFT JOIN BRANCH ON DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
					LEFT JOIN SETUP_POSITION_CAT ON SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID
				WHERE					
					EMPLOYEES.EMPLOYEE_STATUS=1	
					<cfif len(arguments.employees_offtime_contract_id)>
                        AND EMPLOYEES_OFFTIME_CONTRACT.EMPLOYEES_OFFTIME_CONTRACT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employees_offtime_contract_id#" list="yes">)
                    </cfif>
                    <cfif len(arguments.is_approve)>
                        AND EMPLOYEES_OFFTIME_CONTRACT.IS_APPROVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_approve#">
                    </cfif>
                    <cfif len(arguments.IS_MAIL)>
                        AND EMPLOYEES_OFFTIME_CONTRACT.IS_MAIL = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_mail#">
                    </cfif>
					<cfif len(arguments.keyword)>
						AND
						(
							(
								EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
							)
							OR EMPLOYEES_IDENTY.LAST_SURNAME LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
							OR EMPLOYEES_IDENTY.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#">
						)
					</cfif>
					<cfif (len(arguments.branch_id) and arguments.branch_id is not 'all')>
						AND DEPARTMENT.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
					</cfif>
					<cfif len(arguments.position_cat_id)>
						AND EMPLOYEE_POSITIONS.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_cat_id#">
					</cfif>
					<cfif len(arguments.position_name)>
						AND EMPLOYEE_POSITIONS.POSITION_NAME LIKE '<cfif len(arguments.position_name) gt 2>%</cfif>#arguments.position_name#%'
					</cfif>
					<cfif len(hr_search_type) and len(arguments.branch_id) and arguments.branch_id is 'all' and arguments.ehesap_control eq 1 and not session.ep.ehesap>
						AND DEPARTMENT.BRANCH_ID IN (#my_branch_list#)
					</cfif>
					<cfif len(arguments.department)>
						AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department#">
					</cfif>
					
			),
			CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (ORDER BY EMPLOYEE_NAME
			) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			<cfif len(arguments.startrow) and len(arguments.maxrows)>
				WHERE
					RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)
			</cfif>
		</cfquery>
  		<cfreturn get_employees_offtime_contract_query>
	</cffunction>
	<!--- Employee Id ye göre Mutabakat 20191231ERU--->
	<cffunction name="get_contract_employees" access="public" returntype="query">
		<cfargument name="employee_id" default="">
		<cfquery name="get_contract_employees" datasource="#this.dsn#">
			SELECT * FROM EMPLOYEES_OFFTIME_CONTRACT WHERE EMPLOYEE_ID = #arguments.employee_id# ORDER BY SAL_YEAR DESC
		</cfquery>  
		<cfreturn get_contract_employees>
	</cffunction> 
</cfcomponent>