<cfcomponent>
	<cffunction name="get_standby" access="public" returntype="query">
		<cfargument name="positions" default="">
		<cfargument name="ehesap_control" default="1">
		<cfargument name="branch_id" default="">
		<cfargument name="department" default="">
		<cfargument name="keyword" default="">
		<cfargument name="fusebox_dynamic_hierarchy" default="">
		<cfargument name="emp_code_list" default="">
		<cfargument name="database_type" default="">
		<cfargument name="maxrows" default="">
		<cfargument name="startrow" default="">
        <cfquery name="get_standby_" datasource="#this.dsn#">
        	WITH CTE1 AS (
	            SELECT
					EMPLOYEE_POSITIONS.POSITION_ID,
					EMPLOYEE_POSITIONS.POSITION_CODE,
					EMPLOYEE_POSITIONS.POSITION_CAT_ID,
					EMPLOYEE_POSITIONS.POSITION_NAME,
					EMPLOYEE_POSITIONS.EMPLOYEE_ID,
					EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
					EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
					EMPLOYEE_POSITIONS_STANDBY.SB_ID,
					EMPLOYEE_POSITIONS_STANDBY.CHIEF1_CODE,
					EMPLOYEE_POSITIONS_STANDBY.CHIEF2_CODE,
					EMPLOYEE_POSITIONS_STANDBY.CHIEF3_CODE,
			        EMPLOYEE_POSITIONS_STANDBY.CANDIDATE_POS_1,
					D.DEPARTMENT_HEAD,
					B.BRANCH_NAME,
					CF1.EMPLOYEE_NAME AS CF1_NAME,
					CF1.EMPLOYEE_SURNAME AS CF1_SURNAME,
					CF1.POSITION_NAME AS CF1_POSITION_NAME,
					CF2.EMPLOYEE_NAME AS CF2_NAME,
					CF2.EMPLOYEE_SURNAME AS CF2_SURNAME,
					CF2.POSITION_NAME AS CF2_POSITION_NAME,
					CF3.EMPLOYEE_NAME AS CF3_NAME,
					CF3.EMPLOYEE_SURNAME AS CF3_SURNAME,
					CF3.POSITION_NAME AS CF3_POSITION_NAME,
					CD1.EMPLOYEE_NAME AS CD1_NAME,
					CD1.EMPLOYEE_SURNAME AS CD1_SURNAME,
					CD1.POSITION_NAME AS CD1_POSITION_NAME,
					D.HIERARCHY_DEP_ID AS HIERARCHY_DEP_ID1,
					CASE 
                        WHEN E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE START_DATE <= GETDATE() AND (FINISH_DATE >= GETDATE() OR FINISH_DATE IS NULL))
                    THEN	
                        D.HIERARCHY_DEP_ID
                    ELSE 
                    	CASE WHEN 
                        	D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID))
                     	THEN
                        	(SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = D.DEPARTMENT_ID AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC)
                 		ELSE
                        	D.HIERARCHY_DEP_ID
                     	END
                    END AS HIERARCHY_DEP_ID
				FROM
					EMPLOYEES E,
					EMPLOYEE_POSITIONS_STANDBY
					INNER JOIN EMPLOYEE_POSITIONS ON EMPLOYEE_POSITIONS.POSITION_CODE = EMPLOYEE_POSITIONS_STANDBY.POSITION_CODE
					INNER JOIN DEPARTMENT D ON EMPLOYEE_POSITIONS.DEPARTMENT_ID = D.DEPARTMENT_ID
					INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
					LEFT JOIN EMPLOYEE_POSITIONS CF1 ON CF1.POSITION_CODE = EMPLOYEE_POSITIONS_STANDBY.CHIEF1_CODE
					LEFT JOIN EMPLOYEE_POSITIONS CF2 ON CF2.POSITION_CODE = EMPLOYEE_POSITIONS_STANDBY.CHIEF2_CODE
					LEFT JOIN EMPLOYEE_POSITIONS CF3 ON CF3.POSITION_CODE = EMPLOYEE_POSITIONS_STANDBY.CHIEF3_CODE
					LEFT JOIN EMPLOYEE_POSITIONS CD1 ON CD1.POSITION_CODE = EMPLOYEE_POSITIONS_STANDBY.CANDIDATE_POS_1
				WHERE
					1 = 1
					<cfif len(arguments.positions) and arguments.positions eq 2>
						AND EMPLOYEE_POSITIONS.EMPLOYEE_ID <> 0
					<cfelseif len(arguments.positions) and arguments.positions eq 3>
						AND EMPLOYEE_POSITIONS.EMPLOYEE_ID = 0
					</cfif>
					<cfif arguments.ehesap_control eq 1 and not session.ep.ehesap>
						AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
					</cfif>
					<cfif len(arguments.branch_id) and (arguments.branch_id is not 'all')>
						AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
					</cfif>
					<cfif len(arguments.department)>
						AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department#">
					</cfif>
					<cfif len(arguments.keyword)>
						AND
						(
							<cfif arguments.database_type is "MSSQL">
								EMPLOYEE_POSITIONS.EMPLOYEE_NAME+' '+EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '<cfif len(arguments.keyword) gt 1>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
							<cfelseif arguments.database_type is "DB2">
								EMPLOYEE_POSITIONS.EMPLOYEE_NAME||' '||EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '<cfif len(arguments.keyword) gt 1>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
							</cfif>
							OR
							EMPLOYEE_POSITIONS.POSITION_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
						)
					</cfif>
					<cfif len(arguments.fusebox_dynamic_hierarchy) and arguments.fusebox_dynamic_hierarchy>
						<cfloop list="#arguments.emp_code_list#" delimiters="+" index="code_i">
							<cfif arguments.database_type is "MSSQL">
								AND ('.' + EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY + '.' + EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY_ADD + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
							<cfelseif database_type is "DB2">
								AND ('.' || EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY || '.' || EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY_ADD || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
							</cfif>
						</cfloop>
					<cfelse>
						<cfloop list="#arguments.emp_code_list#" delimiters="+" index="code_i">
							<cfif arguments.database_type is "MSSQL">
								AND ('.' + EMPLOYEE_POSITIONS.HIERARCHY + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
							<cfelseif arguments.database_type is "DB2">
								AND ('.' || EMPLOYEE_POSITIONS.HIERARCHY || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
							</cfif>
						</cfloop>
					</cfif>
				UNION
				SELECT
					EMPLOYEE_POSITIONS.POSITION_ID,
					EMPLOYEE_POSITIONS.POSITION_CODE,
					EMPLOYEE_POSITIONS.POSITION_CAT_ID,
					EMPLOYEE_POSITIONS.POSITION_NAME,
					EMPLOYEE_POSITIONS.EMPLOYEE_ID,
					EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
					EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
					'' AS SB_ID,
					'' AS CHIEF1_CODE,
					'' AS CHIEF2_CODE,
					'' AS CHIEF3_CODE,
			        '' AS CANDIDATE_POS_1,
					D.DEPARTMENT_HEAD,
					B.BRANCH_NAME,
					'' AS CF1_NAME,
					'' AS CF1_SURNAME,
					'' AS CF1_POSITION_NAME,
					'' AS CF2_NAME,
					'' AS CF2_SURNAME,
					'' AS CF2_POSITION_NAME,
					'' AS CF3_NAME,
					'' AS CF3_SURNAME,
					'' AS CF3_POSITION_NAME,
					'' AS CD1_NAME,
					'' AS CD1_SURNAME,
					'' AS CD1_POSITION_NAME,
					D.HIERARCHY_DEP_ID AS HIERARCHY_DEP_ID1,
					CASE 
                        WHEN E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE START_DATE <= GETDATE() AND (FINISH_DATE >= GETDATE() OR FINISH_DATE IS NULL))
                    THEN	
                        D.HIERARCHY_DEP_ID
                    ELSE 
                    	CASE WHEN 
                        	D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM DEPARTMENT_HISTORY WHERE CHANGE_DATE IS NOT NULL AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID))
                     	THEN
                        	(SELECT TOP 1 HIERARCHY_DEP_ID FROM DEPARTMENT_HISTORY WHERE DEPARTMENT_ID = D.DEPARTMENT_ID AND CONVERT(DATE,CHANGE_DATE) <= (SELECT CONVERT(DATE,MAX(FINISH_DATE)) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = E.EMPLOYEE_ID) ORDER BY CHANGE_DATE DESC, DEPT_HIST_ID DESC)
                 		ELSE
                        	D.HIERARCHY_DEP_ID
                     	END
                    END AS HIERARCHY_DEP_ID
				FROM
					EMPLOYEES E,
					EMPLOYEE_POSITIONS
					INNER JOIN DEPARTMENT D ON EMPLOYEE_POSITIONS.DEPARTMENT_ID = D.DEPARTMENT_ID
					INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
				WHERE
					EMPLOYEE_POSITIONS.POSITION_CODE NOT IN (SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS_STANDBY)
					<cfif len(arguments.positions) and arguments.positions eq 2>
						AND EMPLOYEE_POSITIONS.EMPLOYEE_ID <> 0
					<cfelseif len(arguments.positions) and arguments.positions eq 3>
						AND EMPLOYEE_POSITIONS.EMPLOYEE_ID = 0
					</cfif>
					<cfif arguments.ehesap_control eq 1 and not session.ep.ehesap>
						AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
					</cfif>
					<cfif len(arguments.branch_id) and arguments.branch_id is not 'all'>
						AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
					</cfif>
					<cfif len(arguments.department)>
						AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department#">
					</cfif>
					<cfif len(arguments.keyword)>
						AND
						(
							<cfif arguments.database_type is "MSSQL">
							EMPLOYEE_POSITIONS.EMPLOYEE_NAME+' '+EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '<cfif len(arguments.keyword) gt 1>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
						<cfelseif arguments.database_type is "DB2">
							EMPLOYEE_POSITIONS.EMPLOYEE_NAME||' '||EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '<cfif len(arguments.keyword) gt 1>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
						</cfif>
						OR
							EMPLOYEE_POSITIONS.POSITION_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
						)
					</cfif>
					<cfif arguments.fusebox_dynamic_hierarchy>
						<cfloop list="#arguments.emp_code_list#" delimiters="+" index="code_i">
							<cfif arguments.database_type is "MSSQL">
								AND ('.' + EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY + '.' + EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY_ADD + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
							<cfelseif arguments.database_type is "DB2">
								AND ('.' || EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY || '.' || EMPLOYEE_POSITIONS.DYNAMIC_HIERARCHY_ADD || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">''
							</cfif>
						</cfloop>
					<cfelse>
						<cfloop list="#arguments.emp_code_list#" delimiters="+" index="code_i">
							<cfif arguments.database_type is "MSSQL">
								AND ('.' + EMPLOYEE_POSITIONS.HIERARCHY + '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
							<cfelseif arguments.database_type is "DB2">
								AND ('.' || EMPLOYEE_POSITIONS.HIERARCHY || '.') LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#code_i#.%">
							</cfif>
						</cfloop>
					</cfif>
			),
			CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (ORDER BY BRANCH_NAME,DEPARTMENT_HEAD,EMPLOYEE_NAME,EMPLOYEE_SURNAME
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
  		<cfreturn get_standby_>
	</cffunction>
</cfcomponent>
