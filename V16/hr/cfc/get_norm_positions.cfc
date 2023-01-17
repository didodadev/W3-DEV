<cfcomponent>
	<cffunction name="get_norm_pos" access="public" returntype="query">
		<cfargument name="branch_id" default="">
		<cfargument name="company_id" default="">
		<cfargument name="keyword" default="">
		<cfargument name="ehesap_control" default="1">
		<cfargument name="norm_year" default="">
		<cfargument name="position_cat_id" default="">
		<cfargument name="startrow" default="">
		<cfargument name="maxrows" default="">
        <cfquery name="get_norm_pos_" datasource="#this.dsn#">
        	WITH CTE1 AS (
				SELECT
					ZONE.ZONE_NAME,
					BRANCH.BRANCH_NAME,
					BRANCH.BRANCH_ID,
					OUR_COMPANY.NICK_NAME,
					SUM(EMPLOYEE_NORM_POSITIONS.EMPLOYEE_COUNT1) AS EMPLOYEE_COUNT1,
	                SUM(EMPLOYEE_NORM_POSITIONS.EMPLOYEE_COUNT2) AS EMPLOYEE_COUNT2,
	                SUM(EMPLOYEE_NORM_POSITIONS.EMPLOYEE_COUNT3) AS EMPLOYEE_COUNT3,
	                SUM(EMPLOYEE_NORM_POSITIONS.EMPLOYEE_COUNT4) AS EMPLOYEE_COUNT4,
	                SUM(EMPLOYEE_NORM_POSITIONS.EMPLOYEE_COUNT5) AS EMPLOYEE_COUNT5,
	                SUM(EMPLOYEE_NORM_POSITIONS.EMPLOYEE_COUNT6) AS EMPLOYEE_COUNT6,
	                SUM(EMPLOYEE_NORM_POSITIONS.EMPLOYEE_COUNT7) AS EMPLOYEE_COUNT7,
	                SUM(EMPLOYEE_NORM_POSITIONS.EMPLOYEE_COUNT8) AS EMPLOYEE_COUNT8,
	                SUM(EMPLOYEE_NORM_POSITIONS.EMPLOYEE_COUNT9) AS EMPLOYEE_COUNT9,
	                SUM(EMPLOYEE_NORM_POSITIONS.EMPLOYEE_COUNT10) AS EMPLOYEE_COUNT10,
	                SUM(EMPLOYEE_NORM_POSITIONS.EMPLOYEE_COUNT11) AS EMPLOYEE_COUNT11,
	                SUM(EMPLOYEE_NORM_POSITIONS.EMPLOYEE_COUNT12) AS EMPLOYEE_COUNT12
				FROM 
					BRANCH
					INNER JOIN ZONE ON ZONE.ZONE_ID = BRANCH.ZONE_ID
					INNER JOIN OUR_COMPANY ON BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
					LEFT JOIN EMPLOYEE_NORM_POSITIONS ON EMPLOYEE_NORM_POSITIONS.BRANCH_ID = BRANCH.BRANCH_ID
					<cfif len(arguments.norm_year)>
                        AND EMPLOYEE_NORM_POSITIONS.NORM_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.norm_year#">
                    </cfif>
				WHERE 
					ZONE_STATUS = 1 AND
					BRANCH_STATUS = 1
					<cfif len(arguments.position_cat_id)>
                        AND EMPLOYEE_NORM_POSITIONS.POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_cat_id#">
                    </cfif>
					<cfif arguments.ehesap_control eq 1 and not session.ep.ehesap>
						AND BRANCH.BRANCH_ID IN (
										SELECT
											BRANCH_ID
										FROM
											EMPLOYEE_POSITION_BRANCHES
										WHERE
											POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
									)
					</cfif>
					<cfif len(arguments.keyword)>
						AND BRANCH.BRANCH_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
					</cfif>
					<cfif len(arguments.company_id)>
						AND OUR_COMPANY.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
					</cfif>
					<cfif len(arguments.branch_id)>
						AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
					</cfif>
				GROUP BY
					BRANCH.BRANCH_ID,
					BRANCH.BRANCH_NAME,
					ZONE.ZONE_NAME,
					OUR_COMPANY.NICK_NAME
			),
			CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (ORDER BY ZONE_NAME,BRANCH_NAME
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
  		<cfreturn get_norm_pos_>
	</cffunction>
	
	<cffunction name="get_norm_pos_minus" access="public" returntype="query">
		<cfargument name="ehesap_control" default="1">
		<cfargument name="sal_year" default="">
		<cfargument name="sal_mon" default="">
		<cfargument name="comp_id" default="">
		<cfargument name="branch_id" default="">
		<cfargument name="start_date" default="">
		<cfargument name="finish_date" default="">
		<cfquery name="get_norm_pos_minus_" datasource="#this.dsn#">
			SELECT 
				ENP.EMPLOYEE_COUNT#arguments.sal_mon#,
				ENP.POSITION_CAT_ID,
				D.DEPARTMENT_ID,
				D.DEPARTMENT_HEAD,
				B.BRANCH_NAME,
				B.BRANCH_ID,
				O.NICK_NAME,
				SP.POSITION_CAT,
				(SELECT COUNT(T1.EMPLOYEE_ID) FROM (SELECT DISTINCT
                        EP.EMPLOYEE_ID
                    FROM
                        EMPLOYEE_POSITIONS EP
                        INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND E.EMPLOYEE_STATUS = 1
                    WHERE
                        EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
						EP.EMPLOYEE_ID > 0 AND
						EP.POSITION_CAT_ID = ENP.POSITION_CAT_ID AND
						(E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE
						(
							(START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_date#"> AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#finish_date#">)
							OR
							(START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_date#"> AND FINISH_DATE IS NULL)
							OR
							(START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_date#"> AND START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#finish_date#">)
							OR
							(FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_date#"> AND FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#finish_date#">)
						)) OR E.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT))) AS T1) AS POS_COUNT
			FROM
				EMPLOYEE_NORM_POSITIONS ENP
				INNER JOIN DEPARTMENT D ON ENP.DEPARTMENT_ID = D.DEPARTMENT_ID
				INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
				INNER JOIN OUR_COMPANY O ON B.COMPANY_ID = O.COMP_ID
				INNER JOIN SETUP_POSITION_CAT SP ON SP.POSITION_CAT_ID = ENP.POSITION_CAT_ID
			WHERE
				ENP.EMPLOYEE_COUNT#arguments.sal_mon# IS NOT NULL
				<cfif len(arguments.sal_year)>
					AND ENP.NORM_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year#">
				</cfif>
				<cfif arguments.ehesap_control eq 1 and not session.ep.ehesap>
					AND B.BRANCH_ID IN (SELECT
						BRANCH_ID
					FROM
						EMPLOYEE_POSITION_BRANCHES
					WHERE
						POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				</cfif>
				<cfif len(arguments.comp_id)>
					AND O.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comp_id#">
				</cfif>
				<cfif len(arguments.branch_id)>
					AND ENP.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
				</cfif>
				<cfif len(arguments.department)>
					AND ENP.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department#">
				</cfif>
				<cfif len(arguments.keyword)>
					AND SP.POSITION_CAT LIKE '<cfif len(arguments.keyword) gt 1>%</cfif>#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
				</cfif>
			ORDER BY
				O.NICK_NAME ASC,
				BRANCH_NAME ASC,
				DEPARTMENT_HEAD ASC
		</cfquery>
		<cfreturn get_norm_pos_minus_>
	</cffunction>
</cfcomponent>
