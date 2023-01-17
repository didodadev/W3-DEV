<cfcomponent>
	<cfset this.dsn = application.systemParam.systemParam().dsn>
	<cffunction name="get_employee" access="public" returntype="query">
		<cfargument name="keyword" default="">
		<cfargument name="emp_id" default="">
		<cfargument name="position_cat_id" default="">
		<cfargument name="branch_id" default="">
		<cfargument name="position_name" default="">
		<cfargument name="ehesap_control" default="1">		
		<cfargument name="emp_code_list" default="">
		<cfargument name="department" default="">
		<cfargument name="fusebox_dynamic_hierarchy" default="">
		<cfargument name="database_type" default="">
		<cfargument name="startrow" default="">
		<cfargument name="maxrows" default="">
		<cfif (len(arguments.position_cat_id) or (isdefined("arguments.branch_id") and arguments.branch_id is not "all") or len(arguments.position_name))>
			<cfset hr_search_type = "with_position">
		<cfelse>
			<cfset hr_search_type = "">
		</cfif>
		<cfif arguments.ehesap_control eq 1 and not session.ep.ehesap>
			<cfquery name="my_branches" datasource="#this.dsn#">
				SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
			</cfquery>
			<cfif not my_branches.recordcount>
				<script type="text/javascript">alert("<cfoutput>#application.functions.getLang('hr',1746,'Hiçbir Şubeye Yetkiniz Yok!Şube Yetkilerinizi Düzenleyiniz')#</cfoutput>!");window.history.back();</script>
				<cfabort>
			</cfif>
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
        <cfquery name="get_employee" datasource="#this.dsn#">
        	WITH CTE1 AS (
				SELECT 
					BRANCH.BRANCH_NAME,
					DEPARTMENT.DEPARTMENT_HEAD,
					EMPLOYEE_POSITIONS.POSITION_NAME,
			        EMPLOYEE_POSITIONS.POSITION_ID,
					EMPLOYEE_POSITIONS.POSITION_CODE,
					SETUP_POSITION_CAT.POSITION_CAT,
					EMPLOYEES.EMPLOYEE_ID,
					EMPLOYEES.EMPLOYEE_NAME,
					EMPLOYEES.EMPLOYEE_EMAIL,
					EMPLOYEES.EMPLOYEE_USERNAME,
					EMPLOYEES.EMPLOYEE_SURNAME,
					EMPLOYEES.EMPLOYEE_NO,
					EMPLOYEES.GROUP_STARTDATE,
					EMPLOYEES.EMPLOYEE_STATUS,
					EMPLOYEES.MOBILCODE,
					EMPLOYEES.MOBILTEL,
					EMPLOYEES_DETAIL.MOBILCODE_SPC,
					EMPLOYEES_DETAIL.MOBILTEL_SPC,
					EMPLOYEES.DIRECT_TELCODE,
					EMPLOYEES.DIRECT_TEL,
					EMPLOYEES.PHOTO,
					EMPLOYEES_DETAIL.SEX,
					EMPLOYEES.PHOTO_SERVER_ID,
					EMPLOYEES_IDENTY.LAST_SURNAME,
					EMPLOYEES_IDENTY.TC_IDENTY_NO,
			        EMPLOYEES.HIERARCHY,
					EMPLOYEES_IN_OUT.START_DATE,
					EMPLOYEES_IN_OUT.FINISH_DATE
				FROM
					EMPLOYEES
					INNER JOIN EMPLOYEES_IDENTY ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID
					INNER JOIN EMPLOYEES_DETAIL ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_DETAIL.EMPLOYEE_ID
					LEFT JOIN EMPLOYEE_POSITIONS ON EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND EMPLOYEE_POSITIONS.IS_MASTER = 1
					LEFT JOIN DEPARTMENT ON EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
					LEFT JOIN BRANCH ON DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
					LEFT JOIN SETUP_POSITION_CAT ON SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID
					LEFT JOIN EMPLOYEES_IN_OUT ON EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND EMPLOYEES_IN_OUT.IN_OUT_ID = (SELECT TOP 1 IN_OUT_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID <cfif arguments.ehesap_control eq 1 and not session.ep.ehesap>AND BRANCH_ID IN (#my_branch_list#)</cfif> ORDER BY START_DATE DESC,IN_OUT_ID DESC)
				WHERE					
					EMPLOYEES.EMPLOYEE_STATUS=1	
					<cfif len(arguments.emp_id)>
					AND  EMPLOYEES.EMPLOYEE_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#">
					</cfif>
					<cfif len(arguments.keyword)>
						AND
						(
							(
							<cfif arguments.database_type is "MSSQL">
								EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
							<cfelseif arguments.database_type is "DB2">
								EMPLOYEES.EMPLOYEE_NAME||' '||EMPLOYEES.EMPLOYEE_SURNAME LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
							</cfif>
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
					<cfif not len(hr_search_type) and len(arguments.branch_id) and arguments.branch_id is 'all' and arguments.ehesap_control eq 1 and (not session.ep.ehesap)>
						AND 
						(
							EMPLOYEES.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS,DEPARTMENT WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND DEPARTMENT.BRANCH_ID IN (#my_branch_list#))
							OR EMPLOYEES.EMPLOYEE_ID NOT IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID IS NOT NULL AND EMPLOYEE_ID <> 0)
							OR 
							EMPLOYEES.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS)
						)
						AND 
						<!---giriş-çıkış şube yetkisi kontrolü --->
						(
							EMPLOYEES.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT)
							OR EMPLOYEES.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE BRANCH_ID IN (#my_branch_list#))
							OR EMPLOYEES.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM   EMPLOYEES_IN_OUT WHERE  POSITION_CODE IS NULL )
							OR EMPLOYEES.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS)
						)
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
  		<cfreturn get_employee>
	</cffunction>
</cfcomponent>
