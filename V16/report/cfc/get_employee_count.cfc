<cfcomponent>
	<cffunction name="get_emp_count" access="public" returntype="query">
		<cfargument name="startrow" default="">
		<cfargument name="maxrows" default="">
		<cfargument name="comp_id" default="">
		<cfargument name="branch_id" default="">
		<cfargument name="zone_id" default="">
		<cfargument name="department" default="">
		<cfargument name="title_id" default="">
		<cfargument name="report_type" default="">
		<cfargument name="is_get_pos_chng" default="">
		<cfargument name="collar_type" default="">
		<cfargument name="pos_cat_id" default="">
		<cfargument name="org_step_id" default="">
		<cfargument name="func_id" default="">
		<cfargument name="status" default="">
		<cfargument name="blood_type" default="">
		<cfargument name="gender" default="">
		<cfargument name="education" default="">
		<cfargument name="inout_statue" default="">
		<cfargument name="defection_level" default="">
		<cfargument name="duty_type" default="">
		<cfargument name="ssk_statute" default="">
		<cfargument name="use_ssk" default="">
		<cfargument name="start_date" default="">
		<cfargument name="finish_date" default="">
		<cfargument name="is_all_dep" default="">
		<cfquery name="get_count" datasource="#this.dsn#">
				SELECT DISTINCT
					<cfif arguments.report_type eq 1>
						OC.COMPANY_NAME,OC.COMP_ID,
					<cfelseif arguments.report_type eq 2>
						Z.ZONE_NAME,Z.ZONE_ID,
					<cfelseif arguments.report_type eq 3>
						B.BRANCH_ID,EP.POSITION_NAME,
					<cfelseif arguments.report_type eq 4>
						D.DEPARTMENT_ID,
					<cfelseif arguments.report_type eq 5>
						SPC.POSITION_CAT,EP.POSITION_CAT_ID,
					<cfelseif arguments.report_type eq 6>
						ST.TITLE,EP.TITLE_ID,
					<cfelseif arguments.report_type eq 7>
						SCU.UNIT_NAME,EP.FUNC_ID AS UNIT_ID,
					<cfelseif arguments.report_type eq 8>
						SOS.ORGANIZATION_STEP_NAME,EP.ORGANIZATION_STEP_ID,
					<cfelseif arguments.report_type eq 9>
						EP.COLLAR_TYPE,
					<cfelseif arguments.report_type eq 10>
						CASE 
						WHEN EI.BIRTH_DATE IS NULL THEN 0
						WHEN ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) <= 18 THEN 1
						WHEN ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) >= 19 AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) <= 24 THEN 2
						WHEN ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) >= 25 AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) <= 34 THEN 3
						WHEN ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) >= 35 AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) <= 54 THEN 4
						WHEN ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) >= 55 THEN 5 END AS YAS,
					<cfelseif arguments.report_type eq 11>
						SEL.EDUCATION_NAME,ED.LAST_SCHOOL AS EDU_LEVEL_ID,
					<cfelseif arguments.report_type eq 12>
						EIO.DEFECTION_LEVEL,
					<cfelseif arguments.report_type eq 13>
						EIO.USE_SSK,
					<cfelseif arguments.report_type eq 14>
						EIO.SSK_STATUTE,
					<cfelseif arguments.report_type eq 15>
						ED.SEX,
					<cfelseif arguments.report_type eq 16>
						EI.BLOOD_TYPE,
					<cfelseif arguments.report_type eq 18>
						EIO.DUTY_TYPE,
					</cfif>
					EP.EMPLOYEE_ID,
					EIO.START_DATE,
					EIO.FINISH_DATE,
					E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMP_NAME,
					EP.POSITION_NAME,
					OC.NICK_NAME,
					B.BRANCH_NAME,
					D.DEPARTMENT_HEAD
				FROM
					EMPLOYEES E
					INNER JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
					INNER JOIN EMPLOYEES_IN_OUT EIO ON EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID
					<cfif isdefined("arguments.report_type") and arguments.report_type eq 1>
						INNER JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID
					<cfelse>
						INNER JOIN DEPARTMENT D ON EIO.DEPARTMENT_ID = D.DEPARTMENT_ID
					</cfif>
					INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
					INNER JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
					INNER JOIN ZONE Z ON Z.ZONE_ID = B.ZONE_ID
					LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
					LEFT JOIN SETUP_TITLE ST ON ST.TITLE_ID = EP.TITLE_ID
					LEFT JOIN SETUP_CV_UNIT SCU ON SCU.UNIT_ID = EP.FUNC_ID
					LEFT JOIN SETUP_ORGANIZATION_STEPS SOS ON SOS.ORGANIZATION_STEP_ID = EP.ORGANIZATION_STEP_ID
					LEFT JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID
					LEFT JOIN EMPLOYEES_DETAIL ED ON ED.EMPLOYEE_ID = E.EMPLOYEE_ID
					LEFT JOIN SETUP_EDUCATION_LEVEL SEL ON ED.LAST_SCHOOL = SEL.EDU_LEVEL_ID
				WHERE
					EP.IS_MASTER = 1
					<cfif len(arguments.is_get_pos_chng)>
						AND E.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS_CHANGE_HISTORY)
					</cfif>
					<cfif len(arguments.comp_id)>
						AND OC.COMP_ID IN (#arguments.comp_id#)
					</cfif>
					<cfif len(arguments.branch_id)>
						AND B.BRANCH_ID IN (#arguments.branch_id#)
					</cfif>
					<cfif not session.ep.ehesap>
						AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
						AND OC.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
					</cfif>
					<cfif len(arguments.zone_id)>
						AND Z.ZONE_ID IN (#arguments.zone_id#)
					</cfif>
					<cfif len(arguments.department)>
						AND D.DEPARTMENT_ID IN 
							<cfif len(arguments.is_all_dep) and arguments.is_all_dep eq 1>
								(SELECT DISTINCT DEPARTMENT_ID FROM DEPARTMENT WHERE (<cfloop list="#arguments.department#" index="i">'.'+HIERARCHY_DEP_ID+'.' LIKE '%.#i#.%' <cfif i neq listlast(arguments.department,',')>OR </cfif></cfloop>) AND DEPARTMENT_STATUS = 1)
							<cfelse>
								(#arguments.department#)
							</cfif>
					</cfif>
					<cfif len(arguments.title_id)>
						AND EP.TITLE_ID IN (#arguments.title_id#)
					</cfif>
					<cfif len(arguments.collar_type)>
						AND EP.COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.collar_type#">
					</cfif>
					<cfif len(arguments.pos_cat_id)>
						AND EP.POSITION_CAT_ID IN (#arguments.pos_cat_id#)
					</cfif>
					<cfif len(arguments.org_step_id)>
						AND EP.ORGANIZATION_STEP_ID IN (#arguments.org_step_id#)
					</cfif>
					<cfif len(arguments.func_id)>
						AND EP.FUNC_ID IN (#arguments.func_id#)
					</cfif>
					<cfif len(arguments.status)>
						AND E.EMPLOYEE_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status#">
					</cfif>
					<cfif len(arguments.blood_type)>
						AND EI.BLOOD_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.blood_type#">
					</cfif>
					<cfif len(arguments.gender)>
						AND ED.SEX = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gender#">
					</cfif>
					<cfif len(arguments.education)>
						AND ED.LAST_SCHOOL = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.education#">
					</cfif>
					<cfif len(arguments.defection_level)>
						AND EIO.DEFECTION_LEVEL = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.defection_level#">
					</cfif>
					<cfif len(arguments.duty_type)>
						AND EIO.DUTY_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.duty_type#">
					</cfif>
					<cfif len(arguments.ssk_statute)>
						AND EIO.SSK_STATUTE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ssk_statute#">
					</cfif>
					<cfif len(arguments.use_ssk)>
						AND EIO.USE_SSK = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.use_ssk#">
					</cfif>
					<cfif isdefined("arguments.inout_statue") and arguments.inout_statue eq 1><!--- Girişler --->
						<cfif isdefined('arguments.start_date') and isdate(arguments.start_date)>
							AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
						</cfif>
						<cfif isdefined('arguments.finish_date') and isdate(arguments.finish_date)>
							AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
						</cfif>
					<cfelseif isdefined("arguments.inout_statue") and arguments.inout_statue eq 0><!--- Çıkışlar --->
						<cfif isdefined('arguments.start_date') and isdate(arguments.start_date)>
							AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
						</cfif>
						<cfif isdefined('arguments.finish_date') and isdate(arguments.finish_date)>
							AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
						</cfif>
						AND	EIO.FINISH_DATE IS NOT NULL
					<cfelseif isdefined("arguments.inout_statue") and arguments.inout_statue eq 2><!--- aktif calisanlar --->
						AND 
						(
							<cfif isdate(arguments.start_date) or isdate(arguments.finish_date)>
								<cfif isdate(arguments.start_date) and not isdate(arguments.finish_date)>
								(
									(
									EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
									EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
									)
									OR
									(
									EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
									EIO.FINISH_DATE IS NULL
									)
								)
								<cfelseif not isdate(arguments.start_date) and isdate(arguments.finish_date)>
								(
									(
									EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#"> AND
									EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
									)
									OR
									(
									EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#"> AND
									EIO.FINISH_DATE IS NULL
									)
								)
								<cfelse>
								(
									(
									EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
									EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
									)
									OR
									(
									EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
									EIO.FINISH_DATE IS NULL
									)
									OR
									(
									EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
									EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
									)
									OR
									(
									EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
									EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
									)
								)
								</cfif>
							<cfelse>
								EIO.FINISH_DATE IS NULL
							</cfif>
						)
					<cfelseif isdefined("arguments.inout_statue") and arguments.inout_statue eq 3><!--- giriş ve çıkışlar Seçili ise --->
						AND 
						(
							(
								EIO.START_DATE IS NOT NULL
								<cfif isdefined('arguments.start_date') and isdate(arguments.start_date)>
									AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
								</cfif>
								<cfif isdefined('arguments.finish_date') and isdate(arguments.finish_date)>
									AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
								</cfif>
							)
							OR
							(
								EIO.START_DATE IS NOT NULL
								<cfif isdefined('arguments.start_date') and isdate(arguments.start_date)>
									AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
								</cfif>
								<cfif isdefined('arguments.finish_date') and isdate(arguments.finish_date)>
									AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
								</cfif>
							)
						)
					<cfelse>
						AND 
						(
							<cfif isdate(arguments.start_date) and isdate(arguments.finish_date)>
								(
									(EIO.START_DATE >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">)
									OR
									(EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#"> AND EIO.FINISH_DATE IS NULL)
									OR
									(EIO.START_DATE >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">)
									OR
									(EIO.FINISH_DATE >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">  AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#"> )
								)
							<cfelse>
								EIO.FINISH_DATE IS NULL
							</cfif>
						)
					</cfif>
				<cfif len(arguments.is_get_pos_chng)>
					UNION ALL
					SELECT
						<cfif arguments.report_type eq 1>
							OC.COMPANY_NAME,OC.COMP_ID,
						<cfelseif arguments.report_type eq 2>
							Z.ZONE_NAME,Z.ZONE_ID,
						<cfelseif arguments.report_type eq 3>
							B.BRANCH_NAME,B.BRANCH_ID,EP.POSITION_NAME,
						<cfelseif arguments.report_type eq 4>
							D.DEPARTMENT_HEAD,D.DEPARTMENT_ID,
						<cfelseif arguments.report_type eq 5>
							SPC.POSITION_CAT,SPC.POSITION_CAT_ID,
						<cfelseif arguments.report_type eq 6>
							ST.TITLE,EP.TITLE_ID,
						<cfelseif arguments.report_type eq 7>
							SCU.UNIT_NAME,EP.FUNC_ID AS UNIT_ID,
						<cfelseif arguments.report_type eq 8>
							SOS.ORGANIZATION_STEP_NAME,EP.ORGANIZATION_STEP_ID,
						<cfelseif arguments.report_type eq 9>
							EP.COLLAR_TYPE,
						<cfelseif arguments.report_type eq 10>
							CASE 
							WHEN EI.BIRTH_DATE IS NULL THEN 0
							WHEN ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) <= 18 THEN 1
							WHEN ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) >= 19 AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) <= 24 THEN 2
							WHEN ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) >= 25 AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) <= 34 THEN 3
							WHEN ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) >= 35 AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) <= 54 THEN 4
							WHEN ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) >= 55 THEN 5 END AS YAS,
						<cfelseif arguments.report_type eq 11>
							SEL.EDUCATION_NAME,ED.LAST_SCHOOL AS EDU_LEVEL_ID,
						<cfelseif arguments.report_type eq 12>
							EIO.DEFECTION_LEVEL,
						<cfelseif arguments.report_type eq 13>
							EIO.USE_SSK,
						<cfelseif arguments.report_type eq 14>
							EIO.SSK_STATUTE,
						<cfelseif arguments.report_type eq 15>
							ED.SEX,
						<cfelseif arguments.report_type eq 16>
							EI.BLOOD_TYPE,
						<cfelseif arguments.report_type eq 18>
							EI.DUTY_TYPE,
						</cfif>
						EP.EMPLOYEE_ID,
						EIO.START_DATE,
						EIO.FINISH_DATE
					FROM
						EMPLOYEES E
						INNER JOIN EMPLOYEE_POSITIONS_CHANGE_HISTORY EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
						INNER JOIN EMPLOYEES_IN_OUT EIO ON EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID
						INNER JOIN DEPARTMENT D ON EIO.DEPARTMENT_ID = D.DEPARTMENT_ID
						INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
						INNER JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
						INNER JOIN ZONE Z ON Z.ZONE_ID = B.ZONE_ID
						LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
						LEFT JOIN SETUP_TITLE ST ON ST.TITLE_ID = EP.TITLE_ID
						LEFT JOIN SETUP_CV_UNIT SCU ON SCU.UNIT_ID = EP.FUNC_ID
						LEFT JOIN SETUP_ORGANIZATION_STEPS SOS ON SOS.ORGANIZATION_STEP_ID = EP.ORGANIZATION_STEP_ID
						LEFT JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID
						LEFT JOIN EMPLOYEES_DETAIL ED ON ED.EMPLOYEE_ID = E.EMPLOYEE_ID
						LEFT JOIN SETUP_EDUCATION_LEVEL SEL ON ED.LAST_SCHOOL = SEL.EDU_LEVEL_ID
					WHERE
						1=1
						<cfif len(arguments.comp_id)>
							AND OC.COMP_ID IN (#arguments.comp_id#)
						</cfif>
						<cfif len(arguments.branch_id)>
							AND B.BRANCH_ID IN (#arguments.branch_id#)
						</cfif>
						<cfif len(arguments.zone_id)>
							AND Z.ZONE_ID IN (#arguments.zone_id#)
						</cfif>
						<cfif len(arguments.department)>
							AND D.DEPARTMENT_ID IN
							<cfif len(arguments.is_all_dep) and arguments.is_all_dep eq 1>
								(SELECT DISTINCT DEPARTMENT_ID FROM DEPARTMENT WHERE (<cfloop list="#arguments.department#" index="i">'.'+HIERARCHY_DEP_ID+'.' LIKE '%.#i#.%' <cfif i neq listlast(arguments.department,',')>OR </cfif></cfloop>) AND DEPARTMENT_STATUS = 1)
							<cfelse>
								(#arguments.department#)
							</cfif>
						</cfif>
						<cfif len(arguments.title_id)>
							AND EP.TITLE_ID IN (#arguments.title_id#)
						</cfif>
						<cfif len(arguments.collar_type)>
							AND EP.COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.collar_type#">
						</cfif>
						<cfif len(arguments.pos_cat_id)>
							AND EP.POSITION_CAT_ID IN (#arguments.pos_cat_id#)
						</cfif>
						<cfif len(arguments.org_step_id)>
							AND EP.ORGANIZATION_STEP_ID IN (#arguments.org_step_id#)
						</cfif>
						<cfif len(arguments.func_id)>
							AND EP.FUNC_ID IN (#arguments.func_id#)
						</cfif>
						<cfif len(arguments.status)>
							AND E.EMPLOYEE_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status#">
						</cfif>
						<cfif len(arguments.blood_type)>
							AND EI.BLOOD_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.blood_type#">
						</cfif>
						<cfif len(arguments.gender)>
							AND ED.SEX = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.gender#">
						</cfif>
						<cfif len(arguments.education)>
							AND ED.LAST_SCHOOL = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.education#">
						</cfif>
						<cfif len(arguments.defection_level)>
							AND EIO.DEFECTION_LEVEL = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.defection_level#">
						</cfif>
						<cfif len(arguments.duty_type)>
							AND EIO.DUTY_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.duty_type#">
						</cfif>
						<cfif len(arguments.ssk_statute)>
							AND EIO.SSK_STATUTE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ssk_statute#">
						</cfif>
						<cfif len(arguments.use_ssk)>
							AND EIO.USE_SSK = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.use_ssk#">
						</cfif>
						<cfif isdefined("arguments.inout_statue") and arguments.inout_statue eq 1><!--- Girişler --->
						<cfif isdefined('arguments.start_date') and isdate(arguments.start_date)>
							AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
						</cfif>
						<cfif isdefined('arguments.finish_date') and isdate(arguments.finish_date)>
							AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
						</cfif>
					<cfelseif isdefined("arguments.inout_statue") and arguments.inout_statue eq 0><!--- Çıkışlar --->
						<cfif isdefined('arguments.start_date') and isdate(arguments.start_date)>
							AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
						</cfif>
						<cfif isdefined('arguments.finish_date') and isdate(arguments.finish_date)>
							AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
						</cfif>
						AND	EIO.FINISH_DATE IS NOT NULL
					<cfelseif isdefined("arguments.inout_statue") and arguments.inout_statue eq 2><!--- aktif calisanlar --->
						AND 
						(
							<cfif isdate(arguments.start_date) or isdate(arguments.finish_date)>
								<cfif isdate(arguments.start_date) and not isdate(arguments.finish_date)>
								(
									(
									EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
									EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
									)
									OR
									(
									EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
									EIO.FINISH_DATE IS NULL
									)
								)
								<cfelseif not isdate(arguments.start_date) and isdate(arguments.finish_date)>
								(
									(
									EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#"> AND
									EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
									)
									OR
									(
									EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#"> AND
									EIO.FINISH_DATE IS NULL
									)
								)
								<cfelse>
								(
									(
									EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
									EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
									)
									OR
									(
									EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
									EIO.FINISH_DATE IS NULL
									)
									OR
									(
									EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
									EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
									)
									OR
									(
									EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND
									EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
									)
								)
								</cfif>
							<cfelse>
								EIO.FINISH_DATE IS NULL
							</cfif>
						)
					<cfelseif isdefined("arguments.inout_statue") and arguments.inout_statue eq 3><!--- giriş ve çıkışlar Seçili ise --->
						AND 
						(
							(
								EIO.START_DATE IS NOT NULL
								<cfif isdefined('arguments.start_date') and isdate(arguments.start_date)>
									AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
								</cfif>
								<cfif isdefined('arguments.finish_date') and isdate(arguments.finish_date)>
									AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
								</cfif>
							)
							OR
							(
								EIO.START_DATE IS NOT NULL
								<cfif isdefined('arguments.start_date') and isdate(arguments.start_date)>
									AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
								</cfif>
								<cfif isdefined('arguments.finish_date') and isdate(arguments.finish_date)>
									AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
								</cfif>
							)
						)
					</cfif>
				</cfif>
		</cfquery>
		<cfreturn get_count>
	</cffunction>
</cfcomponent>
