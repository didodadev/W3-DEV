<cfcomponent>
	<cffunction name="get_position" access="public" returntype="query">
		<cfargument name="collar_type" default="">
		<cfargument name="process_stage" default="">
		<cfargument name="empty_position" default="">
		<cfargument name="status" default="">
		<cfargument name="position_cat_id" default="">
		<cfargument name="unit_id" default="">
		<cfargument name="title_id" default="">
		<cfargument name="organization_step_id" default="">
		<cfargument name="comp_id" default="">
		<cfargument name="keyword" default="">
		<cfargument name="ehesap_control" default="1">
		<cfargument name="hierarchy" default="">
		<cfargument name="emp_code_list" default="">
		<cfargument name="branch_id" default="">
		<cfargument name="department" default="">
		<cfargument name="duty_type" default="">
		<cfargument name="fusebox_dynamic_hierarchy" default="">
		<cfargument name="database_type" default="">
		<cfargument name="startrow" default="">
		<cfargument name="maxrows" default="">
		<cfargument name="reason_id" default="">
        <cfquery name="get_position_" datasource="#this.dsn#">
        	WITH CTE1 AS (
				SELECT
					EMPLOYEE_POSITIONS.EMPLOYEE_ID,
					EMPLOYEE_POSITIONS.POSITION_ID,
					EMPLOYEE_POSITIONS.POSITION_CAT_ID,
					EMPLOYEE_POSITIONS.POSITION_CODE,
					EMPLOYEE_POSITIONS.POSITION_NAME,
					EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
					EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
					EMPLOYEE_POSITIONS.EMPLOYEE_EMAIL,
					EMPLOYEE_POSITIONS.IS_VEKALETEN,
					EMPLOYEE_POSITIONS.VEKALETEN_DATE,
					EMPLOYEE_POSITIONS.TITLE_ID,
					BRANCH.BRANCH_ID,
					BRANCH.BRANCH_NAME,
					OUR_COMPANY.COMP_ID,
					OUR_COMPANY.NICK_NAME,
					DEPARTMENT.DEPARTMENT_ID,
					DEPARTMENT.ADMIN1_POSITION_CODE,
					DEPARTMENT.ADMIN2_POSITION_CODE,
					DEPARTMENT.DEPARTMENT_HEAD,
					ZONE.ZONE_NAME,
					SETUP_TITLE.TITLE,
					E.EMPLOYEE_NO,
					SETUP_POSITION_CAT.POSITION_CAT,
					DEPARTMENT.HIERARCHY_DEP_ID AS HIERARCHY_DEP_ID1,
					CASE 
                        WHEN E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE START_DATE <= GETDATE() AND (FINISH_DATE >= GETDATE() OR FINISH_DATE IS NULL))
                    THEN	
                        DEPARTMENT.HIERARCHY_DEP_ID
                    ELSE 
                    	CASE WHEN 
                        	DEPARTMENT.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID))
                     	THEN
                        	(SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC)
                 		ELSE
                        	DEPARTMENT.HIERARCHY_DEP_ID
                     	END
                    END AS HIERARCHY_DEP_ID
				FROM
					EMPLOYEE_POSITIONS
					<cfif arguments.empty_position neq 1>
						LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
					<cfelse>
						INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
					</cfif>
					INNER JOIN DEPARTMENT ON EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID
					INNER JOIN BRANCH ON DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
					INNER JOIN OUR_COMPANY ON BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
					INNER JOIN ZONE ON BRANCH.ZONE_ID = ZONE.ZONE_ID
					LEFT JOIN SETUP_TITLE ON SETUP_TITLE.TITLE_ID = EMPLOYEE_POSITIONS.TITLE_ID
					LEFT JOIN SETUP_POSITION_CAT ON SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID
				WHERE
					1 = 1
					<cfif len(arguments.collar_type)>
						AND EMPLOYEE_POSITIONS.COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.collar_type#">
					</cfif>
					<cfif len(arguments.process_stage)>
						AND EMPLOYEE_POSITIONS.POSITION_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
					</cfif>
					<cfif len(arguments.empty_position) and (arguments.empty_position eq 0)>
						AND (EMPLOYEE_POSITIONS.POSITION_NAME = '' OR EMPLOYEE_POSITIONS.POSITION_NAME IS NULL OR EMPLOYEE_POSITIONS.EMPLOYEE_ID = '' OR ISNULL(EMPLOYEE_POSITIONS.EMPLOYEE_ID,0) = 0) AND (EMPLOYEE_POSITIONS.EMPLOYEE_NAME = '' OR EMPLOYEE_POSITIONS.EMPLOYEE_NAME IS NULL)
					<cfelseif len(arguments.empty_position) and (arguments.empty_position eq 1)>
						AND EMPLOYEE_POSITIONS.POSITION_NAME <> ''
						AND EMPLOYEE_POSITIONS.POSITION_NAME IS NOT NULL
					</cfif> 
					<cfif len(arguments.status) and (arguments.status eq 0)>
						AND EMPLOYEE_POSITIONS.POSITION_STATUS = 0		  
					<cfelseif len(arguments.status) and (arguments.status eq 1)>
						AND EMPLOYEE_POSITIONS.POSITION_STATUS = 1
					</cfif>
					<cfif len(arguments.position_cat_id)>
						AND EMPLOYEE_POSITIONS.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_cat_id#">
					</cfif>
					<cfif len(arguments.reason_id)>
						AND EMPLOYEE_POSITIONS.IN_COMPANY_REASON_ID IN (#arguments.reason_id#)
					</cfif>
					<cfif len(arguments.unit_id)>
						AND EMPLOYEE_POSITIONS.FUNC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.unit_id#">
					</cfif>
					<cfif len(arguments.title_id)>
						AND EMPLOYEE_POSITIONS.TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.title_id#">
					</cfif>
					<cfif len(arguments.organization_step_id)>
						AND EMPLOYEE_POSITIONS.ORGANIZATION_STEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.organization_step_id#">
					</cfif>
					<cfif len(arguments.comp_id) and arguments.comp_id is not "all">
						AND OUR_COMPANY.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comp_id#">
					</cfif>
					<cfif len(arguments.keyword)>
						AND
						(
						EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#"> COLLATE SQL_Latin1_General_CP1_CI_AI) OR
		                EMPLOYEE_POSITIONS.POSITION_NAME LIKE '<cfif len(arguments.keyword) gt 1>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
						<cfif arguments.database_type is "MSSQL">
							EMPLOYEE_POSITIONS.EMPLOYEE_NAME+' '+EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '<cfif len(arguments.keyword) gt 1>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
						<cfelseif arguments.database_type is "DB2">
							EMPLOYEE_POSITIONS.EMPLOYEE_NAME||' '||EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '<cfif len(arguments.keyword) gt 1>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
						</cfif>
						)
					</cfif>
					<cfif arguments.ehesap_control eq 1 and not session.ep.ehesap>
						AND DEPARTMENT.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> )
					</cfif>
					<cfif len(arguments.hierarchy)>
						AND (
							<cfloop list="#arguments.emp_code_list#" delimiters="+" index="code_i">
								 EMPLOYEE_POSITIONS.OZEL_KOD LIKE '%#code_i#%' OR 
								(SELECT E.HIERARCHY FROM EMPLOYEES E WHERE E.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%"> OR 
								(SELECT E.OZEL_KOD FROM EMPLOYEES E WHERE E.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%"> OR 
								(SELECT E.OZEL_KOD2 FROM EMPLOYEES E WHERE E.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#code_i#%">
								<cfif listlen(arguments.emp_code_list,'+') gt 1 and listlast(arguments.emp_code_list,'+') neq code_i>OR</cfif>	 
							</cfloop>
							<cfif arguments.fusebox_dynamic_hierarchy>
								OR(
									<cfloop list="#arguments.emp_code_list#" delimiters="+" index="code_i">
										<cfif arguments.database_type is "MSSQL">
											('.' + EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY + '.' + EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY_ADD + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
											<cfif listlen(arguments.emp_code_list,'+') gt 1 and listlast(arguments.emp_code_list,'+') neq code_i>AND</cfif>										
										<cfelseif arguments.database_type is "DB2">
											('.' || EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY || '.' || EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY_ADD || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
											<cfif listlen(arguments.emp_code_list,'+') gt 1 and listlast(arguments.emp_code_list,'+') neq code_i>AND</cfif>										
										</cfif>
									</cfloop>
								)			
							</cfif>
							)
					</cfif> 
					<cfif (arguments.branch_id is not '0') and len(trim(arguments.branch_id)) and arguments.branch_id is not "all">
						AND DEPARTMENT.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
					</cfif>
					<cfif len(trim(arguments.department)) and arguments.department is not "all">
						AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department#">
					</cfif>
					<cfif len(arguments.duty_type)>
						AND EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE DUTY_TYPE IN (#arguments.duty_type#) AND FINISH_DATE IS NULL)
					</cfif>
			),
			CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (ORDER BY EMPLOYEE_NAME,EMPLOYEE_SURNAME
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
  		<cfreturn get_position_>
	</cffunction>
</cfcomponent>