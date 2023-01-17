<cfcomponent>
	<cfset this.dsn = application.systemParam.systemParam().dsn>
	<cffunction name="get_hr" access="public" returntype="query">
		<cfargument name="keyword" default="">
		<cfargument name="keyword2" default="">
		<cfargument name="position_cat_id" default="">
		<cfargument name="title_id" default="">
		<cfargument name="branch_id" default="">
		<cfargument name="func_id" default="">
		<cfargument name="organization_step_id" default="">
		<cfargument name="position_name" default="">
		<cfargument name="collar_type" default="">
		<cfargument name="ehesap_control" default="1">
		<cfargument name="emp_status" default="">
		<cfargument name="hierarchy" default="">
		<cfargument name="emp_code_list" default="">
		<cfargument name="department" default="">
		<cfargument name="process_stage" default="">
		<cfargument name="duty_type" default="">
		<cfargument name="fusebox_dynamic_hierarchy" default="">
		<cfargument name="database_type" default="">
		<cfargument name="startrow" default="">
		<cfargument name="maxrows" default="">
		<cfargument name="employee_id" default="">
		<cfargument name="fuseaction" default="">
		<cfif len(arguments.keyword2) and listlen(arguments.keyword2,'-') eq 3><!--- 20141107 SG 82595 idli işte Çalışan no filtresi ile ilgili düzenleme --->
			<cfquery name="get_temp_table" datasource="#this.dsn#">
				IF object_id('tempdb..##Employee_No_List') IS NOT NULL
				   BEGIN DROP TABLE ##Employee_No_List END
			</cfquery>
		    <cfquery name="temp_table" datasource="#this.dsn#">
		        CREATE TABLE ##Employee_No_List 
		        (
		        	EMPLOYEE_ID	int,
		            EMP_NO_FIRST nvarchar(100),
		            EMP_NO_LAST int
		        )
		    </cfquery>	
		    <cfquery name="Add_Employee_No_List" datasource="#this.dsn#">
		        INSERT INTO ##Employee_No_List 
		        (	
		        	EMPLOYEE_ID,
		            EMP_NO_FIRST,
		            EMP_NO_LAST
		        )
		        SELECT 
		            *
		         FROM 
		        (
		        SELECT 
		            EMPLOYEE_ID,
		            CASE WHEN CHARINDEX('-',EMPLOYEE_NO) >0 THEN
		            SUBSTRING(EMPLOYEE_NO,1,(CHARINDEX('-',EMPLOYEE_NO)-1))
		            END AS EMP_NO_FIRST,
		            CASE WHEN CHARINDEX('-',EMPLOYEE_NO) >0 THEN
		            SUBSTRING(EMPLOYEE_NO,(CHARINDEX('-',EMPLOYEE_NO)+1),LEN(EMPLOYEE_NO))	
		            END AS EMP_NO_LAST
		        FROM
		            EMPLOYEES
		        ) EMP_NO_TABLE
		        WHERE
		            ISNUMERIC(EMP_NO_TABLE.EMP_NO_LAST) = 1            
			</cfquery>
		</cfif>
		<cfif (len(arguments.position_cat_id) or len(arguments.title_id) or (isdefined("arguments.branch_id") and arguments.branch_id is not "all") or len(arguments.func_id) or len(arguments.organization_step_id) or len(arguments.position_name)) OR Len(arguments.collar_type)>
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
        <cfquery name="get_hrs" datasource="#this.dsn#">
        	WITH CTE1 AS (
				SELECT 
					BRANCH.BRANCH_NAME,
					DEPARTMENT.DEPARTMENT_HEAD,
					EMPLOYEE_POSITIONS.POSITION_NAME,
			        EMPLOYEE_POSITIONS.POSITION_ID,
					EMPLOYEE_POSITIONS.POSITION_CODE,
					EMPLOYEE_POSITIONS.UPPER_POSITION_CODE,
					EMPLOYEE_POSITIONS.UPPER_POSITION_CODE2,
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
					EMPLOYEES_IN_OUT.FINISH_DATE,
					DEPARTMENT.HIERARCHY_DEP_ID AS HIERARCHY_DEP_ID1,
					CASE 
                        WHEN EMPLOYEES.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE START_DATE <= GETDATE() AND (FINISH_DATE >= GETDATE() OR FINISH_DATE IS NULL))
                    THEN	
                        DEPARTMENT.HIERARCHY_DEP_ID
                    ELSE 
                    	CASE WHEN 
                        	DEPARTMENT.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID))
                     	THEN
                        	(SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC)
                 		ELSE
                        	DEPARTMENT.HIERARCHY_DEP_ID
                     	END
                    END AS HIERARCHY_DEP_ID
				FROM
					EMPLOYEES
					INNER JOIN EMPLOYEES_IDENTY ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID
					INNER JOIN EMPLOYEES_DETAIL ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_DETAIL.EMPLOYEE_ID
					<cfif len(arguments.keyword2) and listlen(arguments.keyword2,'-') eq 3>
						INNER JOIN ##Employee_No_List EMPLOYEE_NO_TABLE ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_NO_TABLE.EMPLOYEE_ID
					</cfif>
					LEFT JOIN EMPLOYEE_POSITIONS ON EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND EMPLOYEE_POSITIONS.IS_MASTER = 1
					LEFT JOIN DEPARTMENT ON EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
					LEFT JOIN BRANCH ON DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
					LEFT JOIN SETUP_POSITION_CAT ON SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID
					LEFT JOIN EMPLOYEES_IN_OUT ON EMPLOYEES_IN_OUT.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND EMPLOYEES_IN_OUT.IN_OUT_ID = (SELECT TOP 1 IN_OUT_ID FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID <cfif arguments.ehesap_control eq 1 and not session.ep.ehesap>AND BRANCH_ID IN (#my_branch_list#)</cfif> ORDER BY START_DATE DESC,IN_OUT_ID DESC)
				WHERE
					<cfif len(arguments.emp_status)>
					    <cfif arguments.emp_status eq 1>
							EMPLOYEES.EMPLOYEE_STATUS = 1
						<cfelseif arguments.emp_status eq -1>
							EMPLOYEES.EMPLOYEE_STATUS = 0
						<cfelseif arguments.emp_status eq 0>
							EMPLOYEES.EMPLOYEE_STATUS IS NOT NULL
						</cfif>
					<cfelse>
						EMPLOYEES.EMPLOYEE_STATUS=1
					</cfif>
					<cfif len(arguments.keyword)>
						AND
						(
							(
							<cfif arguments.database_type is "MSSQL">
								EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#IIf(len(arguments.keyword) gt 2,DE("%"),DE(""))##arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
							<cfelseif arguments.database_type is "DB2">
								EMPLOYEES.EMPLOYEE_NAME||' '||EMPLOYEES.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#IIf(len(arguments.keyword) gt 2,DE("%"),DE(""))##arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
							</cfif>
							)
							OR EMPLOYEES_IDENTY.LAST_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#IIf(len(arguments.keyword) gt 2,DE("%"),DE(""))##arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
							OR EMPLOYEES_IDENTY.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#">
						)
					</cfif>
					<cfif len(arguments.hierarchy)>
						AND 
						(
							<cfloop list="#arguments.emp_code_list#" delimiters="+" index="code_i">
								EMPLOYEES.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%"> OR
								EMPLOYEES.OZEL_KOD2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%"> OR
								EMPLOYEES.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%"> OR
								EMPLOYEES.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%">)
								<cfif listlen(arguments.emp_code_list,'+') gt 1 and listlast(arguments.emp_code_list,'+') neq code_i>OR</cfif>	 
							</cfloop>
							<cfif arguments.fusebox_dynamic_hierarchy>
							OR(
								<cfloop list="#arguments.emp_code_list#" delimiters="+" index="code_i">
									<cfif arguments.database_type is "MSSQL">
										('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
										<cfif listlen(arguments.emp_code_list,'+') gt 1 and listlast(arguments.emp_code_list,'+') neq code_i>AND</cfif>
									<cfelseif arguments.database_type is "DB2">
										('.' || EMPLOYEES.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
										<cfif listlen(arguments.emp_code_list,'+') gt 1 and listlast(arguments.emp_code_list,'+') neq code_i>AND</cfif>
									</cfif>
								</cfloop>
							)
							</cfif>
						)
					</cfif>
					<cfif (len(arguments.branch_id) and arguments.branch_id is not 'all')>
						AND DEPARTMENT.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
					</cfif>
					<cfif len(hr_search_type) and len(arguments.collar_type)>
						AND EMPLOYEE_POSITIONS.COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.collar_type#">
					</cfif>
					<cfif len(arguments.position_cat_id)>
						AND EMPLOYEE_POSITIONS.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_cat_id#">
					</cfif>
					<cfif len(arguments.position_name)>
						AND EMPLOYEE_POSITIONS.POSITION_NAME LIKE '<cfif len(arguments.position_name) gt 2>%</cfif>#arguments.position_name#%'
					</cfif>
					<cfif len(arguments.title_id)>
						AND EMPLOYEE_POSITIONS.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.title_id#">
					</cfif>
					<cfif len(arguments.func_id)>
						AND EMPLOYEE_POSITIONS.FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.func_id#">
					</cfif>
					<cfif len(arguments.organization_step_id)>
						AND EMPLOYEE_POSITIONS.ORGANIZATION_STEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.organization_step_id#">
					</cfif>
					<cfif len(hr_search_type) and len(arguments.branch_id) and arguments.branch_id is 'all' and arguments.ehesap_control eq 1 and not session.ep.ehesap>
						AND DEPARTMENT.BRANCH_ID IN (#my_branch_list#)
					</cfif>
					<cfif len(arguments.department)>
						AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department#">
					</cfif> 
					<cfif len(arguments.process_stage)>
						AND EMPLOYEES.EMPLOYEE_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
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
					<cfif len(arguments.duty_type)>
						AND EMPLOYEES.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE DUTY_TYPE IN (#arguments.duty_type#) AND FINISH_DATE IS NULL)
					</cfif>
					<cfif isDefined("arguments.employee_id") and len(arguments.employee_id)>
						AND EMPLOYEES.EMPLOYEE_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#" list="yes">)
					</cfif>
			        <cfif len(arguments.keyword2) and listlen(arguments.keyword2,'-') eq 3>
			        	AND EMPLOYEE_NO_TABLE.EMP_NO_FIRST = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.keyword2,1,'-')#"> 
			            AND EMPLOYEE_NO_TABLE.EMP_NO_LAST >= <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.keyword2,2,'-')#"> 
						AND EMPLOYEE_NO_TABLE.EMP_NO_LAST <= <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.keyword2,3,'-')#">
					<cfelseif len(arguments.keyword2)>
						AND EMPLOYEES.EMPLOYEE_NO LIKE '<cfif len(arguments.keyword2) gt 1>%</cfif>#arguments.keyword2#%'
			        </cfif>
					<cfif arguments.fuseaction neq 'hr.list_hr'>
						AND EMPLOYEE_POSITIONS.POSITION_ID IS NOT NULL 
					</cfif>
					<!----<cfif not len(hr_search_type) and arguments.ehesap_control eq 1 and not session.ep.ehesap>
						AND 
			            (
			            	EMPLOYEES.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> 
							OR
							EMPLOYEES.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS,DEPARTMENT WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND DEPARTMENT.BRANCH_ID IN (#my_branch_list#))
							OR 
							EMPLOYEES.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS)
						)
			      	</cfif>----->
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
  		<cfreturn get_hrs>
	</cffunction>
</cfcomponent>
