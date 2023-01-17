<cf_xml_page_edit fuseact='report.emp_ext_worktimes'>
<cfset cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps")>
<cfset cmp_org_step.dsn = dsn>
<cfsetting showdebugoutput="no" >
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.pos_cat_id" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.report_base" default="1">
<cfparam name="attributes.data_type" default="1">
<cfparam name="attributes.sal_year" default="#year(now())#">
<cfparam name="attributes.sal_mon" default="#month(now())#">
<cfparam name="attributes.sal_year_end" default="#year(now())#">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.sal_mon_end" default="#month(now())#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset last_month_1 = CreateDateTime(attributes.sal_year, attributes.sal_mon_end,1,0,0,0)>
<cfset last_month_30 = CreateDateTime(attributes.sal_year, attributes.sal_mon_end,daysinmonth(last_month_1),23,59,59)>
<cfquery name="get_company" datasource="#dsn#">
	SELECT 
		COMP_ID,
		NICK_NAME
	FROM
		OUR_COMPANY 
	<cfif not session.ep.ehesap>
		WHERE COMP_ID IN (SELECT DISTINCT B.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH B ON B.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
	</cfif>
	ORDER BY NICK_NAME
</cfquery>
<cfquery name="get_branches" datasource="#dsn#">
    SELECT 
		BRANCH_ID,
		BRANCH_NAME 
	FROM
		BRANCH
	WHERE 
		<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
			COMPANY_ID IN(#attributes.comp_id#)
			<cfif not session.ep.ehesap>
                AND BRANCH_ID IN (SELECT EBR.BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES EBR WHERE EBR.POSITION_CODE = #session.ep.position_code#)
            </cfif>
		<cfelse>
			1=0
		</cfif>
	ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="get_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>BRANCH_ID IN(#attributes.branch_id#)<cfelse>1=0</cfif> AND DEPARTMENT_STATUS = 1 ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfquery name="get_pos_cats" datasource="#dsn#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_STATUS = 1 ORDER BY POSITION_CAT
</cfquery>
<cfquery name="get_process" datasource="#dsn#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND		
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%ehesap.list_ext_worktimes%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="get_list_type" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = #session.ep.company_id# AND
		FUSEACTION_NAME = 'ehesap.list_ext_worktimes' AND
		PROPERTY_NAME = 'is_extwork_type'
</cfquery>
<cfif isdefined("attributes.is_form_submit")>
	<cfif get_list_type.property_value eq 0>
		<cfquery name="get_ext_worktimes" datasource="#dsn#">
			WITH CTE1 AS (
			SELECT
				1 TYPE,
				<cfif attributes.report_base eq 1 or attributes.report_base eq 3>
					D.DEPARTMENT_HEAD,
					D2.DEPARTMENT_HEAD AS UPPER_DEPARTMENT_HEAD,
				</cfif>
				<cfif attributes.report_base eq 5>
					D2.DEPARTMENT_HEAD AS UPPER_DEPARTMENT_HEAD,
				</cfif>
				<cfif attributes.report_base eq 1 or attributes.report_base eq 4>
					SPC.POSITION_CAT,
				</cfif>
				<cfif attributes.report_base neq 4>
					OC.NICK_NAME,
					B.BRANCH_NAME,
				</cfif>
				EO.OVERTIME_PERIOD,
				EO.OVERTIME_MONTH,
				D.HIERARCHY_DEP_ID AS HIERARCHY_DEP_ID1,
				<cfif attributes.report_base eq 1>
					<cfif attributes.data_type eq 1>
						EO.OVERTIME_VALUE_0,
						EO.OVERTIME_VALUE_1,
						EO.OVERTIME_VALUE_2,
						EO.OVERTIME_VALUE_3,
					<cfelseif attributes.data_type eq 2>
						(EO.OVERTIME_VALUE_0 * 60) OVERTIME_VALUE_0,
						(EO.OVERTIME_VALUE_1 * 60) OVERTIME_VALUE_1,
						(EO.OVERTIME_VALUE_2 * 60) OVERTIME_VALUE_2,
						(EO.OVERTIME_VALUE_3 * 60) OVERTIME_VALUE_3,
					</cfif>
				<cfelseif attributes.report_base eq 2 or attributes.report_base eq 3 or attributes.report_base eq 4 or attributes.report_base eq 5>
					<cfif attributes.data_type eq 1>
						SUM(EO.OVERTIME_VALUE_0) AS OVERTIME_VALUE_0,
						SUM(EO.OVERTIME_VALUE_1) AS OVERTIME_VALUE_1,
						SUM(EO.OVERTIME_VALUE_2) AS OVERTIME_VALUE_2,
						SUM(EO.OVERTIME_VALUE_3) AS OVERTIME_VALUE_3
					<cfelseif attributes.data_type eq 2>
						SUM(EO.OVERTIME_VALUE_0 * 60) AS OVERTIME_VALUE_0,
						SUM(EO.OVERTIME_VALUE_1 * 60) AS OVERTIME_VALUE_1,
						SUM(EO.OVERTIME_VALUE_2 * 60) AS OVERTIME_VALUE_2,
						SUM(EO.OVERTIME_VALUE_3 * 60) AS OVERTIME_VALUE_3
					</cfif>
				</cfif>
				<cfif attributes.report_base eq 1>
					EI.TC_IDENTY_NO,
					E.EMPLOYEE_NAME,
					E.EMPLOYEE_SURNAME,
					EO.EMPLOYEE_ID,
					E.EMPLOYEE_NO
				</cfif>
			FROM
				EMPLOYEES_OVERTIME EO
				LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EO.EMPLOYEE_ID
				LEFT JOIN EMPLOYEES_IN_OUT EIO ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND EIO.IN_OUT_ID = EO.IN_OUT_ID
				LEFT JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID
			    LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EP.IS_MASTER = 1
				LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
				LEFT JOIN BRANCH B ON EIO.BRANCH_ID = B.BRANCH_ID
				LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
				LEFT JOIN DEPARTMENT D ON EIO.DEPARTMENT_ID = D.DEPARTMENT_ID
				LEFT JOIN DEPARTMENT as D2 ON D.HIERARCHY_DEP_ID  = CONCAT(D2.HIERARCHY_DEP_ID,'.',D.DEPARTMENT_ID)
			WHERE
				1=1
				<cfif len(attributes.comp_id)>
					AND OC.COMP_ID IN (#attributes.comp_id#)
				</cfif>
				<cfif len(attributes.branch_id)>
					AND B.BRANCH_ID IN (#attributes.branch_id#)
				</cfif>
				<cfif not session.ep.ehesap>
                    AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
                    AND OC.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
                </cfif>
				<cfif len(attributes.department)>
					AND D.DEPARTMENT_ID IN (#attributes.department#)
				</cfif>
				<cfif len(attributes.pos_cat_id)>
					AND SPC.POSITION_CAT_ID IN (#attributes.pos_cat_id#)
				</cfif>
				<cfif len(attributes.keyword)>
					AND E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
				</cfif>
				AND (
					(EO.OVERTIME_PERIOD > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EO.OVERTIME_PERIOD < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
					OR
					(
						EO.OVERTIME_PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
						EO.OVERTIME_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
						(
							EO.OVERTIME_PERIOD < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">
							OR
							(EO.OVERTIME_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EO.OVERTIME_PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
						)
					)
					OR
					(
						EO.OVERTIME_PERIOD > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
						(
							EO.OVERTIME_PERIOD < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">
							OR
							(EO.OVERTIME_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EO.OVERTIME_PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
						)
					)
					OR
					(
						EO.OVERTIME_PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND 
						EO.OVERTIME_PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
						EO.OVERTIME_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
						EO.OVERTIME_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
					)
				)
				<cfif attributes.report_base eq 2 or attributes.report_base eq 3 or attributes.report_base eq 4 or attributes.report_base eq 5>
					GROUP BY
						<cfif attributes.report_base eq 3>
							D.DEPARTMENT_ID,
							D.DEPARTMENT_HEAD,
							D2.DEPARTMENT_HEAD,
						</cfif>
						<cfif attributes.report_base eq 5>
							D2.DEPARTMENT_HEAD,
						</cfif>
						<cfif attributes.report_base eq 4>
							SPC.POSITION_CAT_ID,
							SPC.POSITION_CAT,
						</cfif>
						B.BRANCH_ID,
						OC.NICK_NAME,
						B.BRANCH_NAME,
						EO.OVERTIME_PERIOD,
						EO.OVERTIME_MONTH,
						D.HIERARCHY_DEP_ID
				</cfif>

			UNION ALL

				SELECT
					2 TYPE,
					<cfif attributes.report_base eq 1 or attributes.report_base eq 3>
						D.DEPARTMENT_HEAD,
						D2.DEPARTMENT_HEAD AS UPPER_DEPARTMENT_HEAD,
					</cfif>
					<cfif attributes.report_base eq 5>
						D2.DEPARTMENT_HEAD AS UPPER_DEPARTMENT_HEAD,
					</cfif>
					<cfif attributes.report_base eq 1 or attributes.report_base eq 4>
						SPC.POSITION_CAT,
					</cfif>
					<cfif attributes.report_base neq 4>
						OC.NICK_NAME,
						B.BRANCH_NAME,
					</cfif>
					#attributes.sal_year# OVERTIME_PERIOD,
					#attributes.sal_mon# OVERTIME_MONTH,
					D.HIERARCHY_DEP_ID AS HIERARCHY_DEP_ID1,
					<cfif attributes.report_base eq 1>
						<cfif attributes.data_type eq 1>
							FAZLA_MESAI_SAAT OVERTIME_VALUE_0,
							0 AS OVERTIME_VALUE_1,
							0 AS OVERTIME_VALUE_2,
							0 AS OVERTIME_VALUE_3,
						<cfelseif attributes.data_type eq 2>
							(FAZLA_MESAI_SAAT * 60) OVERTIME_VALUE_0,
							0 OVERTIME_VALUE_1,
							0 OVERTIME_VALUE_2,
							0 OVERTIME_VALUE_3,
						</cfif>
					<cfelseif attributes.report_base eq 2 or attributes.report_base eq 3 or attributes.report_base eq 4 or attributes.report_base eq 5>
						<cfif attributes.data_type eq 1>
							SUM(FAZLA_MESAI_SAAT) AS OVERTIME_VALUE_0,
							0 AS OVERTIME_VALUE_1,
							0 AS OVERTIME_VALUE_2,
							0 AS OVERTIME_VALUE_3
						<cfelseif attributes.data_type eq 2>
							SUM(FAZLA_MESAI_SAAT * 60) AS OVERTIME_VALUE_0,
							0 AS OVERTIME_VALUE_1,
							0 AS OVERTIME_VALUE_2,
							0 AS OVERTIME_VALUE_3
						</cfif>
					</cfif>
					<cfif attributes.report_base eq 1>
						EI.TC_IDENTY_NO,
						E.EMPLOYEE_NAME,
						E.EMPLOYEE_SURNAME,
						E.EMPLOYEE_ID,
						E.EMPLOYEE_NO
					</cfif>
				FROM
					EMPLOYEES E
					LEFT JOIN EMPLOYEES_IN_OUT EIO ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
					LEFT JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID
					LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EP.IS_MASTER = 1
					LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
					LEFT JOIN BRANCH B ON EIO.BRANCH_ID = B.BRANCH_ID
					LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
					LEFT JOIN DEPARTMENT D ON EIO.DEPARTMENT_ID = D.DEPARTMENT_ID
					LEFT JOIN DEPARTMENT as D2 ON D.HIERARCHY_DEP_ID  = CONCAT(D2.HIERARCHY_DEP_ID,'.',D.DEPARTMENT_ID)
				WHERE
					1=1
					<cfif len(attributes.comp_id)>
						AND OC.COMP_ID IN (#attributes.comp_id#)
					</cfif>
					<cfif len(attributes.branch_id)>
						AND B.BRANCH_ID IN (#attributes.branch_id#)
					</cfif>
					<cfif not session.ep.ehesap>
						AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
						AND OC.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
					</cfif>
					<cfif len(attributes.department)>
						AND D.DEPARTMENT_ID IN (#attributes.department#)
					</cfif>
					<cfif len(attributes.pos_cat_id)>
						AND SPC.POSITION_CAT_ID IN (#attributes.pos_cat_id#)
					</cfif>
					<cfif len(attributes.keyword)>
						AND E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
					</cfif>
					AND (
						EIO.FAZLA_MESAI_SAAT IS NOT NULL 
						AND  EIO.FAZLA_MESAI_SAAT > 0
						AND 
							(
								EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
								OR
								EIO.FINISH_DATE IS NULL
							)
					)
					<cfif attributes.report_base eq 2 or attributes.report_base eq 3 or attributes.report_base eq 4 or attributes.report_base eq 5>
						GROUP BY
							<cfif attributes.report_base eq 3>
								D.DEPARTMENT_ID,
								D.DEPARTMENT_HEAD,
								D2.DEPARTMENT_HEAD,
							</cfif>
							<cfif attributes.report_base eq 5>
								D2.DEPARTMENT_HEAD,
							</cfif>
							<cfif attributes.report_base eq 4>
								SPC.POSITION_CAT_ID,
								SPC.POSITION_CAT,
							</cfif>
							B.BRANCH_ID,
							OC.NICK_NAME,
							B.BRANCH_NAME,
							D.HIERARCHY_DEP_ID
					</cfif>
			),
		    	CTE2 AS (
		      		SELECT
		           		CTE1.*,
		                 	ROW_NUMBER() OVER (	ORDER BY
		                    	OVERTIME_PERIOD DESC, OVERTIME_MONTH DESC <cfif attributes.report_base eq 1>,EMPLOYEE_NAME ASC,EMPLOYEE_SURNAME ASC</cfif>
		                 	) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
		           	FROM
		        		CTE1
		       		)
		       		SELECT
		            	CTE2.*
		         	FROM
		             	CTE2
		         	WHERE
		              	RowNum BETWEEN #attributes.startrow# and (#attributes.startrow#+(#attributes.maxrows#-1))
		</cfquery>
	<cfelse>
		<cfquery name="get_ext_worktimes" datasource="#dsn#">
			WITH CTE1 AS (
			<cfif attributes.report_base eq 2 or attributes.report_base eq 3 or attributes.report_base eq 4 or attributes.report_base eq 5>
			SELECT
				TYPE,
				<cfif attributes.report_base eq 2 or attributes.report_base eq 3 or attributes.report_base eq 5>
					T1.BRANCH_NAME,
					T1.NICK_NAME,	
				</cfif>
				<cfif attributes.report_base eq 3>
					T1.DEPARTMENT_HEAD,
					T1.UPPER_DEPARTMENT_HEAD,
				</cfif>
				<cfif attributes.report_base eq 4>
					T1.POSITION_CAT,
				</cfif>
				<cfif attributes.report_base eq 5>
					T1.UPPER_DEPARTMENT_HEAD,
				</cfif>
				T1.OVERTIME_MONTH,
				T1.OVERTIME_PERIOD,
				SUM(T1.OVERTIME_VALUE_0) AS OVERTIME_VALUE_0,
				SUM(T1.OVERTIME_VALUE_1) AS OVERTIME_VALUE_1,
				SUM(T1.OVERTIME_VALUE_2) AS OVERTIME_VALUE_2,
				SUM(T1.OVERTIME_VALUE_3) AS OVERTIME_VALUE_3
			FROM
			(
			</cfif>
			SELECT
				1 TYPE,
				EW.EMPLOYEE_ID,
				EI.TC_IDENTY_NO,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				E.EMPLOYEE_NO,
				OC.NICK_NAME,
				B.BRANCH_NAME,
				D.DEPARTMENT_HEAD,
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
				END AS HIERARCHY_DEP_ID,
				D2.DEPARTMENT_HEAD AS UPPER_DEPARTMENT_HEAD,	
				SPC.POSITION_CAT,
				MONTH(EW.START_TIME) OVERTIME_MONTH,
				YEAR(EW.START_TIME) OVERTIME_PERIOD,
				ISNULL((SELECT SUM(DATEDIFF(MINUTE,START_TIME,END_TIME)) FROM EMPLOYEES_EXT_WORKTIMES WHERE EMPLOYEE_ID = EW.EMPLOYEE_ID 
					AND MONTH(START_TIME) = MONTH(EW.START_TIME) AND YEAR(START_TIME) = YEAR(EW.START_TIME) AND DAY_TYPE = 0),0) AS OVERTIME_VALUE_0,
				ISNULL((SELECT SUM(DATEDIFF(MINUTE,START_TIME,END_TIME)) FROM EMPLOYEES_EXT_WORKTIMES WHERE EMPLOYEE_ID = EW.EMPLOYEE_ID 
					AND MONTH(START_TIME) = MONTH(EW.START_TIME) AND YEAR(START_TIME) = YEAR(EW.START_TIME) AND DAY_TYPE = 1),0) AS OVERTIME_VALUE_1,
				ISNULL((SELECT SUM(DATEDIFF(MINUTE,START_TIME,END_TIME)) FROM EMPLOYEES_EXT_WORKTIMES WHERE EMPLOYEE_ID = EW.EMPLOYEE_ID 
					AND MONTH(START_TIME) = MONTH(EW.START_TIME) AND YEAR(START_TIME) = YEAR(EW.START_TIME) AND DAY_TYPE = 2),0) AS OVERTIME_VALUE_2,
				ISNULL((SELECT SUM(DATEDIFF(MINUTE,START_TIME,END_TIME)) FROM EMPLOYEES_EXT_WORKTIMES WHERE EMPLOYEE_ID = EW.EMPLOYEE_ID 
					AND MONTH(START_TIME) = MONTH(EW.START_TIME) AND YEAR(START_TIME) = YEAR(EW.START_TIME) AND DAY_TYPE = 3),0) AS OVERTIME_VALUE_3
			FROM
				EMPLOYEES_EXT_WORKTIMES EW
				INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EW.EMPLOYEE_ID
				INNER JOIN EMPLOYEES_IN_OUT EIO ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND EIO.IN_OUT_ID = EW.IN_OUT_ID
				LEFT JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID
				LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EP.IS_MASTER = 1
				LEFT JOIN BRANCH B ON EIO.BRANCH_ID = B.BRANCH_ID
				LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
				LEFT JOIN DEPARTMENT D ON EIO.DEPARTMENT_ID = D.DEPARTMENT_ID
				LEFT JOIN DEPARTMENT as D2 ON D.HIERARCHY_DEP_ID  = CONCAT(D2.HIERARCHY_DEP_ID,'.',D.DEPARTMENT_ID)
				LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
			WHERE
				1=1
				<cfif len(attributes.process_stage)>
					AND EW.PROCESS_STAGE IN (#attributes.process_stage#)
				</cfif>
				<cfif len(attributes.comp_id)>
					AND OC.COMP_ID IN (#attributes.comp_id#)
				</cfif>
				<cfif len(attributes.branch_id)>
					AND B.BRANCH_ID IN (#attributes.branch_id#)
				</cfif>
				<cfif not session.ep.ehesap>
                    AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
                    AND OC.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
                </cfif>
				<cfif len(attributes.department)>
					AND D.DEPARTMENT_ID IN (#attributes.department#)
				</cfif>
				<cfif len(attributes.pos_cat_id)>
					AND SPC.POSITION_CAT_ID IN (#attributes.pos_cat_id#)
				</cfif>
				<cfif attributes.report_base eq 4>
					AND EP.POSITION_CAT_ID IS NOT NULL
				</cfif>
				<cfif len(attributes.keyword)>
					AND E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
				</cfif>
				AND (
					(YEAR(EW.START_TIME) > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND YEAR(EW.START_TIME) < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
					OR
					(
						YEAR(EW.START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
						MONTH(EW.START_TIME) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
						(
							YEAR(EW.START_TIME) < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">
							OR
							(MONTH(EW.START_TIME) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND YEAR(EW.START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
						)
					)
					OR
					(
						YEAR(EW.START_TIME) > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
						(
							YEAR(EW.START_TIME) < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">
							OR
							(MONTH(EW.START_TIME) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND YEAR(EW.START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
						)
					)
					OR
					(
						YEAR(EW.START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND 
						YEAR(EW.START_TIME) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
						MONTH(EW.START_TIME) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
						MONTH(EW.START_TIME) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
					)
				)
			GROUP BY
				MONTH(EW.START_TIME),
				YEAR(EW.START_TIME),
				EW.EMPLOYEE_ID,
				EI.TC_IDENTY_NO,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				E.EMPLOYEE_NO,
				D.DEPARTMENT_HEAD,
				D2.DEPARTMENT_HEAD,
				SPC.POSITION_CAT,
				B.BRANCH_ID,
				B.BRANCH_NAME,
				D.HIERARCHY_DEP_ID,
				D.DEPARTMENT_ID,
				E.EMPLOYEE_ID,
				OC.NICK_NAME

				UNION ALL

					SELECT
						2 TYPE,
						E.EMPLOYEE_ID,
						EI.TC_IDENTY_NO,
						E.EMPLOYEE_NAME,
						E.EMPLOYEE_SURNAME,
						E.EMPLOYEE_NO,
						OC.NICK_NAME,
						B.BRANCH_NAME,
						D.DEPARTMENT_HEAD,
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
						END AS HIERARCHY_DEP_ID,
						D2.DEPARTMENT_HEAD AS UPPER_DEPARTMENT_HEAD,	
						SPC.POSITION_CAT,
						#attributes.sal_mon# OVERTIME_MONTH,
						#attributes.sal_year# OVERTIME_PERIOD,
						EIO.FAZLA_MESAI_SAAT AS OVERTIME_VALUE_0,
						0 AS OVERTIME_VALUE_1,
						0 AS OVERTIME_VALUE_2,
						0 AS OVERTIME_VALUE_3
					FROM
						EMPLOYEES E
						INNER JOIN EMPLOYEES_IN_OUT EIO ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND EIO.EMPLOYEE_ID = E.EMPLOYEE_ID
						LEFT JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID
						LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EP.IS_MASTER = 1
						LEFT JOIN BRANCH B ON EIO.BRANCH_ID = B.BRANCH_ID
						LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
						LEFT JOIN DEPARTMENT D ON EIO.DEPARTMENT_ID = D.DEPARTMENT_ID
						LEFT JOIN DEPARTMENT as D2 ON D.HIERARCHY_DEP_ID  = CONCAT(D2.HIERARCHY_DEP_ID,'.',D.DEPARTMENT_ID)
						LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
					WHERE
						1=1
						<cfif len(attributes.comp_id)>
							AND OC.COMP_ID IN (#attributes.comp_id#)
						</cfif>
						<cfif len(attributes.branch_id)>
							AND B.BRANCH_ID IN (#attributes.branch_id#)
						</cfif>
						<cfif not session.ep.ehesap>
							AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
							AND OC.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
						</cfif>
						<cfif len(attributes.department)>
							AND D.DEPARTMENT_ID IN (#attributes.department#)
						</cfif>
						<cfif len(attributes.pos_cat_id)>
							AND SPC.POSITION_CAT_ID IN (#attributes.pos_cat_id#)
						</cfif>
						<cfif attributes.report_base eq 4>
							AND EP.POSITION_CAT_ID IS NOT NULL
						</cfif>
						<cfif len(attributes.keyword)>
							AND E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
						</cfif>
						AND (
							EIO.FAZLA_MESAI_SAAT IS NOT NULL 
							AND  EIO.FAZLA_MESAI_SAAT > 0
							AND
							(
								EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
								OR
								EIO.FINISH_DATE IS NULL
							)
						)
					GROUP BY
						E.EMPLOYEE_ID,
						EI.TC_IDENTY_NO,
						E.EMPLOYEE_NAME,
						E.EMPLOYEE_SURNAME,
						E.EMPLOYEE_NO,
						D.DEPARTMENT_HEAD,
						D2.DEPARTMENT_HEAD,
						SPC.POSITION_CAT,
						EIO.FAZLA_MESAI_SAAT,
						B.BRANCH_ID,
						B.BRANCH_NAME,
						D.HIERARCHY_DEP_ID,
						D.DEPARTMENT_ID,
						E.EMPLOYEE_ID,
						OC.NICK_NAME
			<cfif attributes.report_base eq 2 or attributes.report_base eq 3 or attributes.report_base eq 4 or attributes.report_base eq 5>
			) T1
			GROUP BY
				<cfif attributes.report_base eq 2 or attributes.report_base eq 3 or attributes.report_base eq 5>
					T1.BRANCH_NAME,
					T1.NICK_NAME,
				</cfif>
				<cfif attributes.report_base eq 3>
					T1.DEPARTMENT_HEAD,
					T1.UPPER_DEPARTMENT_HEAD,
				</cfif>
				<cfif attributes.report_base eq 4>
					T1.POSITION_CAT,
				</cfif>
				<cfif attributes.report_base eq 5>
					T1.UPPER_DEPARTMENT_HEAD,
				</cfif>
				T1.OVERTIME_MONTH,
				T1.OVERTIME_PERIOD
			</cfif>
			),
		    	CTE2 AS (
		      		SELECT
		           		CTE1.*,
		                 	ROW_NUMBER() OVER (	ORDER BY
		                    	OVERTIME_PERIOD DESC, OVERTIME_MONTH DESC <cfif attributes.report_base eq 1>,EMPLOYEE_NAME ASC,EMPLOYEE_SURNAME ASC</cfif>
		                 	) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
		           	FROM
		        		CTE1
		       		)
		       		SELECT
		            	CTE2.*
		         	FROM
		             	CTE2
					<cfif attributes.is_excel neq 1>
						WHERE
							RowNum BETWEEN #attributes.startrow# and (#attributes.startrow#+(#attributes.maxrows#-1))
					</cfif>
		</cfquery>
	</cfif>
<cfelse>
	<cfset get_ext_worktimes.query_count = 0>
	<cfset get_ext_worktimes.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_ext_worktimes.query_count#">
<cfsavecontent variable="head"><cf_get_lang dictionary_id='47816.Fazla Mesai Raporu	'></cfsavecontent>
<cfform name="search_form" method="post" action="#request.self#?fuseaction=report.emp_ext_worktimes">
	<cf_report_list_search title="#head#">
        <cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
                    <div class="row formContent">
						<div class="row" type="row">
                            <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="form-group" <cfif attributes.report_base neq 1>style="display:none;"</cfif>>
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
										<div class="col col-12 col-md-12 col-xs-12" id="keyword_td">
											<input type="text" id="keyword" name="keyword" <cfoutput>value="#attributes.keyword#"</cfoutput>>
										</div>	
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'></label>			
										<div class="col col-6">
											<select name="sal_mon" id="sal_mon">
												<cfloop from="1" to="12" index="i">
													<cfoutput>
														<option value="#i#" <cfif (isdefined("attributes.sal_mon") and attributes.sal_mon eq i) or (not isdefined("attributes.sal_mon") and month(now()) gt 1 and i eq month(now())-1)>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
													</cfoutput>
												</cfloop>
											</select>	
										</div>
										<div class="col col-6">
											<select name="sal_year" id="sal_year">
												<cfloop from="#year(now())-3#" to="#year(now())+3#" index="i">
													<cfoutput>
														<option value="#i#" <cfif (isdefined("attributes.sal_year") and attributes.sal_year eq i) or (not isdefined("attributes.sal_year") and year(now()) eq i)>selected</cfif>>#i#</option>
													</cfoutput>
												</cfloop>
											</select>	
										</div>					
									</div>
									<div class="form-group">	
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'></label>				
										<div class="col col-6">
											<select name="sal_mon_end" id="sal_mon_end">
												<cfloop from="1" to="12" index="i">
													<cfoutput>
														<option value="#i#" <cfif (isdefined("attributes.sal_mon_end") and attributes.sal_mon_end eq i) or (not isdefined("attributes.sal_mon_end") and month(now()) gt 1 and i eq month(now())-1)>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
													</cfoutput>
												</cfloop>
											</select>

										</div>
										<div class="col col-6">
											<select name="sal_year_end" id="sal_year_end">
												<cfloop from="#year(now())-3#" to="#year(now())+3#" index="i">
													<cfoutput>
														<option value="#i#" <cfif (isdefined("attributes.sal_year_end") and attributes.sal_year_end eq i) or (not isdefined("attributes.sal_year_end") and year(now()) eq i)>selected</cfif>>#i#</option>
													</cfoutput>
												</cfloop>
											</select>	
										</div>					
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
											<div class="multiselect-z2 no-print">
											<cf_multiselect_check 
												query_name="get_company"  
												name="comp_id"
												option_value="COMP_ID"
												option_name="NICK_NAME"
												option_text="#getLang('main',162)#"
												value="#attributes.comp_id#"
												onchange="get_branch_list(this.value)">
											</div>
										</div>	
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
											<div id="BRANCH_PLACE" class="multiselect-z2 no-print">
												<cf_multiselect_check 
												query_name="get_branches"  
												name="branch_id"
												option_value="BRANCH_ID"
												option_name="BRANCH_NAME"
												option_text="#getLang('main',41)#"
												value="#attributes.branch_id#">
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
											<div id="DEPARTMENT_PLACE" class="multiselect-z2 no-print">
												<cf_multiselect_check 
												query_name="get_department"  
												name="department"
												option_text="#getLang('main',160)#"
												option_value="department_id"
												option_name="department_head"
												value="#iif(isdefined("attributes.department"),"attributes.department",DE(""))#">
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
											<div class="multiselect-z1 no-print">
												<cf_multiselect_check 
												query_name="get_pos_cats"  
												name="pos_cat_id" 
												option_value="POSITION_CAT_ID"
												option_name="POSITION_CAT"
												option_text="#getLang('main',1592)#"
												value="#attributes.pos_cat_id#">
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<cfif get_list_type.property_value neq 0>
											<div class="form-group">
												<label class="col col-12 col-xs-12 paddingNone"><cf_get_lang dictionary_id='58859.Süreç'></label>
												<div class="col col-12 col-xs-12 paddingNone">
													<select name="process_stage" id="process_stage" style="width:193px;height:75px;" multiple>
														<cfoutput query="get_process">
															<option value="#process_row_id#"<cfif listfind(attributes.process_stage,process_row_id)>selected</cfif>>#stage#</option>
														</cfoutput>
													</select>
												</div>
											</div>
										</cfif>
										<div class="form-group">
											<label class="col col-12 col-xs-12 paddingNone"><cf_get_lang dictionary_id='39174.Rapor Baz'></label>
											<div class="col col-12 col-md-12 col-xs-12 paddingNone">
												<select name="report_base" id="report_base" onchange="filtre_goster(this.value)">
													<option value="1" <cfif attributes.report_base eq 1>selected</cfif>><cf_get_lang dictionary_id='39722.Çalışan Bazında'></option>
													<option value="2" <cfif attributes.report_base eq 2>selected</cfif>><cf_get_lang dictionary_id='39350.Şube Bazında'></option>
													<option value="3" <cfif attributes.report_base eq 3>selected</cfif>><cf_get_lang dictionary_id='40563.Departman Bazında'></option>
													<option value="4" <cfif attributes.report_base eq 4>selected</cfif>><cf_get_lang dictionary_id='59004.Pozisyon Tipi'> <cf_get_lang dictionary_id='58601.Bazında'></option>
													<option value="5" <cfif attributes.report_base eq 5>selected</cfif>><cf_get_lang dictionary_id='57985.Üst'> <cf_get_lang dictionary_id='40563.Departman Bazında'></option>
												</select>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12 paddingNone"><cf_get_lang dictionary_id='39229.Veri'></label>
											<div class="col col-12 col-md-12 col-xs-12 paddingNone">
												<select name="data_type" id="data_type">
													<option value="1" <cfif attributes.data_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57491.Saat'></option>
													<option value="2" <cfif attributes.data_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58127.Dakika'></option>
												</select>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>	
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<input name="is_form_submit" id="is_form_submit" value="1" type="hidden">
							<cf_wrk_report_search_button button_type="1" is_excel='1' search_function="control()">
						</div>
					</div>	
				</div>
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
		<cfset type_ = 1>
		<cfset filename = "#createuuid()#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-8">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<cfelse>
		<cfset type_ = 0>
</cfif>
<cfif isdefined("is_form_submit")>
	<cf_report_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57487.No'></th>
				<cfif attributes.report_base eq 1>
					<th><cf_get_lang dictionary_id='32328.Sicil No'></th>
					<th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
					<th><cf_get_lang dictionary_id='57576.Çalışan'></th>
				</cfif>
				<cfif attributes.report_base neq 4>
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
				</cfif>
				<cfif attributes.report_base eq 1 or attributes.report_base eq 3>
					<th><cf_get_lang dictionary_id='57985.Üst'> <cf_get_lang dictionary_id='57572.Departman'></th>
					<th><cf_get_lang dictionary_id='57572.Departman'></th>
				</cfif>
				<cfif attributes.report_base eq 5>
					<th><cf_get_lang dictionary_id='57985.Üst'> <cf_get_lang dictionary_id='57572.Departman'></th>
				</cfif>
				<cfif attributes.report_base eq 1 or attributes.report_base eq 4>
					<th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
				</cfif>
				<th><cf_get_lang dictionary_id='58472.Dönem'></th>
				<th><cf_get_lang dictionary_id='58724.Ay'></th>
				<th><cf_get_lang dictionary_id='55887.Normal Mesai'></th>
				<th><cf_get_lang dictionary_id='53743.Hafta sonu Mesai'></th>
				<th><cf_get_lang dictionary_id='29482.Genel Tatil'></th>
				<th><cf_get_lang dictionary_id='54251.Gece Çalışması'></th>
				<th><cf_get_lang dictionary_id='40024.Toplam Mesai'></th>
				<cfif isDefined("x_show_level") and x_show_level eq 1 and attributes.report_base eq 1><th><cf_get_lang dictionary_id='62040.Kademeli Departman'></th></cfif>
			</tr>
		</thead>
		<tbody>
			<cfif get_ext_worktimes.recordcount>
				<cfset all_total_work_time = 0>
				<cfset total_overtime_value_0 = 0>
				<cfset total_overtime_value_1 = 0>
				<cfset total_overtime_value_2 = 0>
				<cfset total_overtime_value_3 = 0>
				<cfoutput query="get_ext_worktimes">
					<cfset total_work_time = 0>
					<tr>
						<td <cfif type eq 2> style="color:red"</cfif>>#rownum#</td>
						<cfif attributes.report_base eq 1>
							<td>#employee_no#</td>
							<td>#tc_identy_no#</td>
							<cfif attributes.is_excel eq 1>
							<td>#employee_name# #employee_surname#</td>
							<cfelse>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
							</cfif>
						</cfif>
						<cfif attributes.report_base neq 4>
							<td>#nick_name#</td>
							<td>#branch_name#</td>
						</cfif>
						<cfif attributes.report_base eq 1 or attributes.report_base eq 3>
							<td>#upper_department_head#</td>
							<td>#department_head#</td>
						</cfif>
						<cfif attributes.report_base eq 5>
							<td>#upper_department_head#</td>
						</cfif>
						<cfif attributes.report_base eq 1 or attributes.report_base eq 4>
							<td>#position_cat#</td>
						</cfif>
						<td>#overtime_period#</td>
						<td>#listgetat(ay_list(),overtime_month,',')#</td>
						<cfif get_list_type.property_value eq 1 and attributes.data_type eq 1>
							<cfif data_type eq 1 and type eq 2>
								<cfset overtime_value_0_ = overtime_value_0>
							<cfelseif data_type eq 2 and type eq 2>
								<cfset overtime_value_0_ = overtime_value_0 * 60>
							<cfelse>
								<cfset overtime_value_0_ = wrk_round(overtime_value_0 / 60)>
							</cfif>
							<cfset overtime_value_1_ = wrk_round(overtime_value_1 / 60)>
							<cfset overtime_value_2_ = wrk_round(overtime_value_2 / 60)>
							<cfset overtime_value_3_ = wrk_round(overtime_value_3 / 60)>
						<cfelse>
							<cfset overtime_value_0_ = overtime_value_0>
							<cfset overtime_value_1_ = overtime_value_1>
							<cfset overtime_value_2_ = overtime_value_2>
							<cfset overtime_value_3_ = overtime_value_3>						
						</cfif>
						<td style="text-align:right; mso-number-format:0\.00;">#overtime_value_0_#<cfset total_work_time = total_work_time + overtime_value_0_><cfset total_overtime_value_0 = total_overtime_value_0 + overtime_value_0_></td>
						<td style="text-align:right; mso-number-format:0\.00;">#overtime_value_1_#<cfset total_work_time = total_work_time + overtime_value_1_><cfset total_overtime_value_1 = total_overtime_value_1 + overtime_value_1_></td>
						<td style="text-align:right; mso-number-format:0\.00;">#overtime_value_2_#<cfset total_work_time = total_work_time + overtime_value_2_><cfset total_overtime_value_2 = total_overtime_value_2 + overtime_value_2_></td>
						<td style="text-align:right; mso-number-format:0\.00;">#overtime_value_3_#<cfset total_work_time = total_work_time + overtime_value_3_><cfset total_overtime_value_3 = total_overtime_value_3 + overtime_value_3_></td>
						<td style="text-align:right; mso-number-format:0\.00;">#total_work_time#<cfset all_total_work_time = all_total_work_time + total_work_time></td>
						<cfif attributes.report_base eq 1>
							<cfif isDefined("x_show_level") and x_show_level eq 1>
								<td>                            
									<cfset up_dep_len = listlen(HIERARCHY_DEP_ID1,'.')>
									<cfif up_dep_len gt 0>
										<cfset temp = up_dep_len> 
										<cfloop from="1" to="#up_dep_len#" index="i" step="1">
											<cfif isdefined("HIERARCHY_DEP_ID1") and listlen(HIERARCHY_DEP_ID1,'.') gt temp>
												<cfset up_dep_id = ListGetAt(HIERARCHY_DEP_ID1, listlen(HIERARCHY_DEP_ID1,'.')-temp,".")>
												<cfquery name="get_upper_departments" datasource="#dsn#">
													SELECT DEPARTMENT_HEAD, LEVEL_NO FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#up_dep_id#">
												</cfquery>
												<cfset up_dep_head = get_upper_departments.department_head>
												#up_dep_head# 
													<cfset get_org_level = cmp_org_step.get_organization_step(level_no : get_upper_departments.LEVEL_NO)>
													<cfif get_org_level.recordcount>
														(#get_org_level.ORGANIZATION_STEP_NAME#)
													</cfif>
												<cfif up_dep_len neq i>
													>
												</cfif>
											<cfelse>
												<cfset up_dep_head = ''>
											</cfif>
											<cfset temp = temp - 1>
										</cfloop>
								    </cfif>
								</td>
							</cfif>
						</cfif>
					</tr>
				</cfoutput>
				<foot>
					<tr class="txtbold">
						<cfif attributes.report_base eq 1>
							<td colspan="11" style="text-align:right"><cf_get_lang dictionary_id='57492.Toplam'></td>
						<cfelseif attributes.report_base eq 2>
							<td colspan="5" style="text-align:right"><cf_get_lang dictionary_id='57492.Toplam'></td>
						<cfelseif attributes.report_base eq 3>
							<td colspan="6" style="text-align:right"><cf_get_lang dictionary_id='57492.Toplam'></td>
						<cfelseif attributes.report_base eq 4>
							<td colspan="4" style="text-align:right"><cf_get_lang dictionary_id='57492.Toplam'></td>
						<cfelseif attributes.report_base eq 5>
							<td colspan="6" style="text-align:right"><cf_get_lang dictionary_id='57492.Toplam'></td>
						</cfif>
						<cfoutput>
							<td style="text-align:right; mso-number-format:0\.00;">#total_overtime_value_0#</td>
							<td style="text-align:right; mso-number-format:0\.00;">#total_overtime_value_1#</td>
							<td style="text-align:right; mso-number-format:0\.00;">#total_overtime_value_2#</td>
							<td style="text-align:right; mso-number-format:0\.00;">#total_overtime_value_3#</td>
							<td style="text-align:right; mso-number-format:0\.00;">#all_total_work_time#</td>
						</cfoutput>
					</tr>
				</foot>
			<cfelse>
				<tr>
						<td colspan="16"><cfif isdefined('attributes.is_form_submit')><cf_get_lang dictionary_id='57484.Kayıt yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_report_list>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfscript>
		url_str = "report.emp_ext_worktimes";
		if(isdefined('attributes.is_form_submit'))
			url_str = '#url_str#&is_form_submit=1';
		if(len('attributes.keyword'))
			url_str = '#url_str#&keyword=#attributes.keyword#';
		if(len('attributes.comp_id'))
			url_str = '#url_str#&comp_id=#attributes.comp_id#';
		if(len('attributes.branch_id'))
			url_str = '#url_str#&branch_id=#attributes.branch_id#';
		if(len('attributes.department'))
			url_str = '#url_str#&department=#attributes.department#';
		if(len('attributes.pos_cat_id'))
			url_str = '#url_str#&pos_cat_id=#attributes.pos_cat_id#';
		if(len('attributes.data_type'))
			url_str = '#url_str#&data_type=#attributes.data_type#';
		if(len('attributes.sal_mon'))
			url_str = '#url_str#&sal_mon=#attributes.sal_mon#';
		if(len('attributes.sal_year'))
			url_str = '#url_str#&sal_year=#attributes.sal_year#';
		if(len('attributes.sal_mon_end'))
			url_str = '#url_str#&sal_mon_end=#attributes.sal_mon_end#';
		if(len('attributes.sal_year_end'))
			url_str = '#url_str#&sal_year_end=#attributes.sal_year_end#';
	</cfscript>
	<cfif attributes.is_excel neq 1>
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#url_str#">
	</cfif>
</cfif>
<script type="text/javascript">
 	function control()	
	{
			if(search_form.sal_mon.value < search_form.sal_mon_end.value)
			{	
				if(search_form.sal_year.value > search_form.sal_year_end.value)
				{
					alert("<cf_get_lang dictionary_id='58492.Tarih Kontrol'>");
					return false;
				}
			}
			else if(search_form.sal_mon.value > search_form.sal_mon_end.value)
			{
				if(search_form.sal_year.value >= search_form.sal_year_end.value)
				{
					alert("<cf_get_lang dictionary_id='58492.Tarih Kontrol'>");
					return false;
				}
			}
			else if(search_form.sal_mon.value == search_form.sal_mon_end.value)
			{
				if(search_form.sal_year.value > search_form.sal_year_end.value)
				{
					alert("<cf_get_lang dictionary_id='58492.Tarih Kontrol'>");
					return false;
				}
			}
            if(document.search_form.is_excel.checked==false)
            {
                document.search_form.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
                return true;
            }
            else
                document.search_form.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_emp_ext_worktimes</cfoutput>"
	}
	function get_branch_list(gelen)
	{
		checkedValues_b = $("#comp_id").multiselect("getChecked");
		var comp_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(comp_id_list == '')
				comp_id_list = checkedValues_b[kk].value;
			else
				comp_id_list = comp_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=branch_id&comp_id="+comp_id_list;
		AjaxPageLoad(send_address,'BRANCH_PLACE',1,'İlişkili Şubeler');
	}
	function get_department_list(gelen)
	{
		checkedValues_b = $("#branch_id").multiselect("getChecked");
		var branch_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(branch_id_list == '')
				branch_id_list = checkedValues_b[kk].value;
			else
				branch_id_list = branch_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department&branch_id="+branch_id_list;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}
	function filtre_goster(i)
	{
		if (i == 1)
		{
			$('#keyword').prop('disabled', false);
		}
		else 
		{
			$('#keyword').prop('disabled', true);
			$('#keyword').val('');
		}
	}
</script>