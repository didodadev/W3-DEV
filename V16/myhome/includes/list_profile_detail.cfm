<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.from_count_report") and attributes.from_count_report eq 1>
	<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
		<cf_date tarih = "attributes.start_date">
	</cfif>
	<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
		<cf_date tarih = "attributes.finish_date">
	</cfif>
	<cfquery name="get_detail" datasource="#dsn#">
		SELECT DISTINCT
			<cfif attributes.report_type eq 1>
				OC.COMPANY_NAME,OC.COMP_ID,
			<cfelseif attributes.report_type eq 2>
				Z.ZONE_NAME,Z.ZONE_ID,
			<cfelseif attributes.report_type eq 3>
				B.BRANCH_ID,EP.POSITION_NAME,
			<cfelseif attributes.report_type eq 4>
				D.DEPARTMENT_ID,
			<cfelseif attributes.report_type eq 5>
				SPC.POSITION_CAT,EP.POSITION_CAT_ID,
			<cfelseif attributes.report_type eq 6>
				ST.TITLE,EP.TITLE_ID,
			<cfelseif attributes.report_type eq 7>
				SCU.UNIT_NAME,EP.FUNC_ID AS UNIT_ID,
			<cfelseif attributes.report_type eq 8>
				SOS.ORGANIZATION_STEP_NAME,EP.ORGANIZATION_STEP_ID,
			<cfelseif attributes.report_type eq 9>
				EP.COLLAR_TYPE,
			<cfelseif attributes.report_type eq 10>
				CASE 
				WHEN EI.BIRTH_DATE IS NULL THEN 0
				WHEN ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) <= 18 THEN 1
				WHEN ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) >= 19 AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) <= 24 THEN 2
				WHEN ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) >= 25 AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) <= 34 THEN 3
				WHEN ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) >= 35 AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) <= 54 THEN 4
				WHEN ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) >= 55 THEN 5 END AS YAS,
			<cfelseif attributes.report_type eq 11>
				SEL.EDUCATION_NAME,ED.LAST_SCHOOL AS EDU_LEVEL_ID,
			<cfelseif attributes.report_type eq 12>
				EIO.DEFECTION_LEVEL,
			<cfelseif attributes.report_type eq 13>
				EIO.USE_SSK,
			<cfelseif attributes.report_type eq 14>
				EIO.SSK_STATUTE,
			<cfelseif attributes.report_type eq 15>
				ED.SEX,
			<cfelseif attributes.report_type eq 16>
				EI.BLOOD_TYPE,
			<cfelseif attributes.report_type eq 18>
				EIO.DUTY_TYPE,
			</cfif>
			E.EMPLOYEE_NO,
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
			<cfif isdefined("attributes.report_type") and attributes.report_type eq 1>
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
			<cfif isdefined('attributes.is_get_pos_chng') and len(attributes.is_get_pos_chng)>
				AND E.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS_CHANGE_HISTORY)
			</cfif>
			<cfif not session.ep.ehesap>
				AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
				AND OC.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
			<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
				AND OC.COMP_ID IN (#attributes.comp_id#)
			</cfif>
			<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
				AND B.BRANCH_ID IN (#attributes.branch_id#)
			</cfif>
			<cfif isdefined('attributes.zone_id') and len(attributes.zone_id)>
				AND Z.ZONE_ID IN (#attributes.zone_id#)
			</cfif>
			<cfif isdefined('attributes.department') and len(attributes.department)>
				AND D.DEPARTMENT_ID IN 
					<cfif isdefined('attributes.is_all_dep') and len(attributes.is_all_dep) and attributes.is_all_dep eq 1>
						(SELECT DISTINCT DEPARTMENT_ID FROM DEPARTMENT WHERE (<cfloop list="#attributes.department#" index="i">'.'+HIERARCHY_DEP_ID+'.' LIKE '%.#i#.%' <cfif i neq listlast(attributes.department,',')>OR </cfif></cfloop>) AND DEPARTMENT_STATUS = 1)
					<cfelse>
						(#attributes.department#)
					</cfif>
			</cfif>
			<cfif isdefined('attributes.title_id') and len(attributes.title_id)>
				AND EP.TITLE_ID IN (#attributes.title_id#)
			<cfelseif isdefined('attributes.title_id') and not len(attributes.title_id)>
				AND EP.TITLE_ID IS NULL
			</cfif>
			<cfif isdefined('attributes.collar_type') and len(attributes.collar_type)>
				AND EP.COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#">
			<cfelseif isdefined('attributes.collar_type') and not len(attributes.collar_type)>
				AND EP.COLLAR_TYPE IS NULL
			</cfif>
			<cfif isdefined('attributes.yas') and len(attributes.yas)>
				<cfif attributes.yas eq 0>AND EI.BIRTH_DATE IS NULL
				<cfelseif attributes.yas eq 1>AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) <= 18
				<cfelseif attributes.yas eq 2>AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) >= 19 AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) <= 24
				<cfelseif attributes.yas eq 3>AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) >= 25 AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) <= 34
				<cfelseif attributes.yas eq 4>AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) >= 35 AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) <= 54
				<cfelseif attributes.yas eq 5>AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) >= 55
				</cfif>
			</cfif>
			<cfif isdefined('attributes.pos_cat_id') and len(attributes.pos_cat_id)>
				AND EP.POSITION_CAT_ID IN (#attributes.pos_cat_id#)
			</cfif>
			<cfif isdefined('attributes.org_step_id') and len(attributes.org_step_id)>
				AND EP.ORGANIZATION_STEP_ID IN (#attributes.org_step_id#)
			<cfelseif isdefined('attributes.org_step_id') and not len(attributes.org_step_id)>
				AND EP.ORGANIZATION_STEP_ID IS NULL
			</cfif>
			<cfif isdefined('attributes.func_id') and len(attributes.func_id)>
				AND EP.FUNC_ID IN (#attributes.func_id#)
			<cfelseif isdefined('attributes.func_id') and not len(attributes.func_id)>
				AND EP.FUNC_ID IS NULL
			</cfif>
			<cfif isdefined('attributes.status') and len(attributes.status)>
				AND E.EMPLOYEE_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.status#">
			</cfif>
			<cfif isdefined('attributes.blood_type') and len(attributes.blood_type)>
				AND EI.BLOOD_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.blood_type#">
			<cfelseif isdefined('attributes.blood_type') and not len(attributes.blood_type)>
				AND EI.BLOOD_TYPE IS NULL
			</cfif>
			<cfif isdefined('attributes.gender') and len(attributes.gender)>
				AND ED.SEX = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gender#">
			</cfif>
			<cfif isdefined('attributes.education') and len(attributes.education)>
				AND ED.LAST_SCHOOL = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.education#">
			<cfelseif isdefined('attributes.education') and not len(attributes.education)>
				AND ED.LAST_SCHOOL IS NULL
			</cfif>
			<cfif isdefined('attributes.defection_level') and len(attributes.defection_level)>
				AND EIO.DEFECTION_LEVEL = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.defection_level#">
			</cfif>
			<cfif isdefined('attributes.duty_type') and len(attributes.duty_type)>
				AND EIO.DUTY_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.duty_type#">
			<cfelseif isdefined('attributes.duty_type') and not len(attributes.duty_type)>
				AND EIO.DUTY_TYPE IS NULL
			</cfif>
			<cfif isdefined('attributes.ssk_statute') and len(attributes.ssk_statute)>
				AND EIO.SSK_STATUTE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statute#">
			<cfelseif isdefined('attributes.ssk_statute') and not len(attributes.ssk_statute)>
				AND EIO.SSK_STATUTE IS NULL
			</cfif>
			<cfif isdefined('attributes.use_ssk') and len(attributes.use_ssk)>
				AND EIO.USE_SSK = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.use_ssk#">
			</cfif>
			<cfif isdefined("attributes.inout_statue") and attributes.inout_statue eq 1><!--- Girişler --->
				<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
					AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
				</cfif>
				<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
					AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				</cfif>
			<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 0><!--- Çıkışlar --->
				<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
					AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
				</cfif>
				<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
					AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				</cfif>
				AND	EIO.FINISH_DATE IS NOT NULL
			<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 2><!--- aktif calisanlar --->
				AND 
				(
					<cfif isdate(attributes.start_date) or isdate(attributes.finish_date)>
						<cfif isdate(attributes.start_date) and not isdate(attributes.finish_date)>
						(
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
							)
							OR
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
							EIO.FINISH_DATE IS NULL
							)
						)
						<cfelseif not isdate(attributes.start_date) and isdate(attributes.finish_date)>
						(
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> AND
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
							)
							OR
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> AND
							EIO.FINISH_DATE IS NULL
							)
						)
						<cfelse>
						(
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
							)
							OR
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
							EIO.FINISH_DATE IS NULL
							)
							OR
							(
							EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
							)
							OR
							(
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
							EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
							)
						)
						</cfif>
					<cfelse>
						EIO.FINISH_DATE IS NULL
					</cfif>
				)
			<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 3><!--- giriş ve çıkışlar Seçili ise --->
				AND 
				(
					(
						EIO.START_DATE IS NOT NULL
						<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
							AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
						</cfif>
						<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
							AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
						</cfif>
					)
					OR
					(
						EIO.START_DATE IS NOT NULL
						<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
							AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
						</cfif>
						<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
							AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
						</cfif>
					)
				)
				<cfelse>
					AND 
					(
						<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
							(
								(EIO.START_DATE >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">)
								OR
								(EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> AND EIO.FINISH_DATE IS NULL)
								OR
								(EIO.START_DATE >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">)
								OR
								(EIO.FINISH_DATE >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">  AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> )
							)
						<cfelse>
							EIO.FINISH_DATE IS NULL
						</cfif>
					)
			</cfif>
		<cfif isdefined('attributes.is_get_pos_chng') and len(attributes.is_get_pos_chng)>
		UNION ALL
		SELECT DISTINCT
			E.EMPLOYEE_NO,
			EP.EMPLOYEE_ID,
			E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMP_NAME,
			EP.POSITION_NAME,
			OC.NICK_NAME,
			B.BRANCH_NAME,
			D.DEPARTMENT_HEAD
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
			<cfif not session.ep.ehesap>
				AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
				AND OC.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
			<cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
				AND OC.COMP_ID IN (#attributes.comp_id#)
			</cfif>
			<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
				AND B.BRANCH_ID IN (#attributes.branch_id#)
			</cfif>
			<cfif isdefined('attributes.zone_id') and len(attributes.zone_id)>
				AND Z.ZONE_ID IN (#attributes.zone_id#)
			</cfif>
			<cfif isdefined('attributes.department') and len(attributes.department)>
				AND D.DEPARTMENT_ID IN
				<cfif isdefined('attributes.is_all_dep') and len(attributes.is_all_dep) and attributes.is_all_dep eq 1>
					(SELECT DISTINCT DEPARTMENT_ID FROM DEPARTMENT WHERE (<cfloop list="#attributes.department#" index="i">'.'+HIERARCHY_DEP_ID+'.' LIKE '%.#i#.%' <cfif i neq listlast(attributes.department,',')>OR </cfif></cfloop>) AND DEPARTMENT_STATUS = 1)
				<cfelse>
					(#attributes.department#)
				</cfif>
			</cfif>
			<cfif isdefined('attributes.title_id') and len(attributes.title_id)>
				AND EP.TITLE_ID IN (#attributes.title_id#)
			<cfelseif isdefined('attributes.title_id') and not len(attributes.title_id)>
				AND EP.TITLE_ID IS NULL
			</cfif>
			<cfif isdefined('attributes.collar_type') and len(attributes.collar_type)>
				AND EP.COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#">
			<cfelseif isdefined('attributes.collar_type') and not len(attributes.collar_type)>
				AND EP.COLLAR_TYPE IS NULL
			</cfif>
			<cfif isdefined('attributes.yas') and len(attributes.yas)>
				<cfif attributes.yas eq 0>AND EI.BIRTH_DATE IS NULL
				<cfelseif attributes.yas eq 1>AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) <= 18
				<cfelseif attributes.yas eq 2>AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) >= 19 AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) <= 24
				<cfelseif attributes.yas eq 3>AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) >= 25 AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) <= 34
				<cfelseif attributes.yas eq 4>AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) >= 35 AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) <= 54
				<cfelseif attributes.yas eq 5>AND ((DATEDIFF(DAY,EI.BIRTH_DATE,GETDATE()))/365) >= 55
				</cfif>
			</cfif>
			<cfif isdefined('attributes.pos_cat_id') and len(attributes.pos_cat_id)>
				AND EP.POSITION_CAT_ID IN (#attributes.pos_cat_id#)
			</cfif>
			<cfif isdefined('attributes.org_step_id') and len(attributes.org_step_id)>
				AND EP.ORGANIZATION_STEP_ID IN (#attributes.org_step_id#)
			<cfelseif isdefined('attributes.org_step_id') and not len(attributes.org_step_id)>
				AND EP.ORGANIZATION_STEP_ID IS NULL
			</cfif>
			<cfif isdefined('attributes.func_id') and len(attributes.func_id)>
				AND EP.FUNC_ID IN (#attributes.func_id#)
			<cfelseif isdefined('attributes.func_id') and not len(attributes.func_id)>
				AND EP.FUNC_ID IS NULL
			</cfif>
			<cfif isdefined('attributes.status') and len(attributes.status)>
				AND E.EMPLOYEE_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.status#">
			</cfif>
			<cfif isdefined('attributes.blood_type') and len(attributes.blood_type)>
				AND EI.BLOOD_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.blood_type#">
			<cfelseif isdefined('attributes.blood_type') and not len(attributes.blood_type)>
				AND EI.BLOOD_TYPE IS NULL
			</cfif>
			<cfif isdefined('attributes.gender') and len(attributes.gender)>
				AND ED.SEX = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gender#">
			</cfif>
			<cfif isdefined('attributes.education') and len(attributes.education)>
				AND ED.LAST_SCHOOL = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.education#">
			<cfelseif isdefined('attributes.education') and not len(attributes.education)>
				AND ED.LAST_SCHOOL IS NULL
			</cfif>
			<cfif isdefined('attributes.defection_level') and len(attributes.defection_level)>
				AND EIO.DEFECTION_LEVEL = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.defection_level#">
			</cfif>
			<cfif isdefined('attributes.duty_type') and len(attributes.duty_type)>
				AND EIO.DUTY_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.duty_type#">
			<cfelseif isdefined('attributes.duty_type') and not len(attributes.duty_type)>
				AND EIO.DUTY_TYPE IS NULL
			</cfif>
			<cfif isdefined('attributes.ssk_statute') and len(attributes.ssk_statute)>
				AND EIO.SSK_STATUTE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statute#">
			<cfelseif isdefined('attributes.ssk_statute') and not len(attributes.ssk_statute)>
				AND EIO.SSK_STATUTE IS NULL
			</cfif>
			<cfif isdefined('attributes.use_ssk') and len(attributes.use_ssk)>
				AND EIO.USE_SSK = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.use_ssk#">
			</cfif>
			<cfif isdefined("attributes.inout_statue") and attributes.inout_statue eq 1><!--- Girişler --->
				<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
					AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
				</cfif>
				<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
					AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				</cfif>
			<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 0><!--- Çıkışlar --->
				<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
					AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
				</cfif>
				<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
					AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				</cfif>
				AND	EIO.FINISH_DATE IS NOT NULL
			<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 2><!--- aktif calisanlar --->
				AND 
				(
					<cfif isdate(attributes.start_date) or isdate(attributes.finish_date)>
						<cfif isdate(attributes.start_date) and not isdate(attributes.finish_date)>
						(
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
							)
							OR
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
							EIO.FINISH_DATE IS NULL
							)
						)
						<cfelseif not isdate(attributes.start_date) and isdate(attributes.finish_date)>
						(
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> AND
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
							)
							OR
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> AND
							EIO.FINISH_DATE IS NULL
							)
						)
						<cfelse>
						(
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
							)
							OR
							(
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
							EIO.FINISH_DATE IS NULL
							)
							OR
							(
							EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
							EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
							)
							OR
							(
							EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
							EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
							)
						)
						</cfif>
					<cfelse>
						EIO.FINISH_DATE IS NULL
					</cfif>
				)
			<cfelseif isdefined("attributes.inout_statue") and attributes.inout_statue eq 3><!--- giriş ve çıkışlar Seçili ise --->
				AND 
				(
					(
						EIO.START_DATE IS NOT NULL
						<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
							AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
						</cfif>
						<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
							AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
						</cfif>
					)
					OR
					(
						EIO.START_DATE IS NOT NULL
						<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
							AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
						</cfif>
						<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
							AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
						</cfif>
					)
				)
				<cfelse>
					AND 
					(
						<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
							(
								(EIO.START_DATE >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">)
								OR
								(EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> AND EIO.FINISH_DATE IS NULL)
								OR
								(EIO.START_DATE >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">)
								OR
								(EIO.FINISH_DATE >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">  AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> )
							)
						<cfelse>
							EIO.FINISH_DATE IS NULL
						</cfif>

					)
			</cfif>
		</cfif>
		ORDER BY
			EMP_NAME,
			E.EMPLOYEE_NO
	</cfquery>
<cfelse>
<cfif isdefined("attributes.is_empty") and attributes.is_empty eq 1>
	<cfquery name="get_detail" datasource="#dsn#">
	SELECT  DISTINCT
		EP.EMPLOYEE_ID,
		EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS EMP_NAME,
		EP.POSITION_NAME,
		EP.POSITION_CAT_ID,
		EP.COLLAR_TYPE ,
		B.COMPANY_ID,
		B.BRANCH_ID,
		D.DEPARTMENT_ID,
		EP.IS_MASTER,
		EP.FUNC_ID,
		OC.NICK_NAME,
		B.BRANCH_NAME,
		D.DEPARTMENT_HEAD
	FROM  
		EMPLOYEE_POSITIONS EP,
		DEPARTMENT D,
		BRANCH B,
		OUR_COMPANY OC,
		ZONE Z
	WHERE 
		EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.BRANCH_ID = B.BRANCH_ID AND
		B.ZONE_ID = Z.ZONE_ID AND
		B.COMPANY_ID = OC.COMP_ID AND
		EP.POSITION_STATUS = 1 AND
		(EMPLOYEE_ID = 0 OR EMPLOYEE_ID IS NULL )
		<cfif isdefined("attributes.func_id") and len(attributes.func_id)>
			AND EP.FUNC_ID = #attributes.func_id#
		</cfif>		
		<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
			AND B.COMPANY_ID = #attributes.comp_id#
		</cfif>		
	</cfquery>
<cfelse>
	<cfquery name="get_detail" datasource="#dsn#">
		SELECT  DISTINCT
			EP.EMPLOYEE_ID,
			EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS EMP_NAME,
			EP.POSITION_NAME,
			EP.POSITION_CAT_ID,
			EP.COLLAR_TYPE ,
			B.COMPANY_ID,
			B.BRANCH_ID,
			D.DEPARTMENT_ID,
			EP.IS_MASTER,
			E.EMPLOYEE_STATUS,
			EP.FUNC_ID,
			OC.NICK_NAME,
			B.BRANCH_NAME,
			D.DEPARTMENT_HEAD,
			E.EMPLOYEE_NO
		FROM  
			EMPLOYEES_IN_OUT EIO 
			INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
			INNER JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
			INNER JOIN DEPARTMENT D ON EIO.DEPARTMENT_ID = D.DEPARTMENT_ID
			INNER JOIN BRANCH B ON EIO.BRANCH_ID = B.BRANCH_ID
			INNER JOIN OUR_COMPANY OC ON B.COMPANY_ID = OC.COMP_ID
			INNER JOIN ZONE Z ON B.ZONE_ID = Z.ZONE_ID
		WHERE 
			EP.POSITION_STATUS = 1   AND  
			EP.IS_MASTER = 1  AND
			EP.EMPLOYEE_ID <> 0 AND 
			EP.EMPLOYEE_ID IS NOT NULL AND
			(
				(EIO.START_DATE <= #NOW()# AND EIO.FINISH_DATE >= #NOW()#)
	        	OR
	        	(EIO.START_DATE <= #NOW()# AND EIO.FINISH_DATE IS NULL)
	        )
			<cfif isdefined("attributes.blood_type") and len(attributes.blood_type)>
				AND E.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEES_IDENTY WHERE BLOOD_TYPE = #attributes.blood_type#)
			</cfif>
			<cfif isdefined("attributes.age_18")  and attributes.age_18 eq 1>
				AND E.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEES_IDENTY WHERE DATEDIFF(YEAR,BIRTH_DATE,GETDATE()) <18)
			</cfif>
			<cfif isdefined("attributes.age_18_25")  and attributes.age_18_25 eq 1>
				AND E.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEES_IDENTY WHERE DATEDIFF(YEAR,BIRTH_DATE,GETDATE()) >18 AND DATEDIFF(YEAR,BIRTH_DATE,GETDATE()) < 25)
			</cfif>
			<cfif isdefined("attributes.age_25_35")  and attributes.age_25_35 eq 1>
				AND E.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEES_IDENTY WHERE DATEDIFF(YEAR,BIRTH_DATE,GETDATE()) >=25 AND DATEDIFF(YEAR,BIRTH_DATE,GETDATE()) < 35)
			</cfif>
			<cfif isdefined("attributes.age_50")  and attributes.age_50 eq 1>
				AND E.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEES_IDENTY WHERE DATEDIFF(YEAR,BIRTH_DATE,GETDATE()) >=35 AND DATEDIFF(YEAR,BIRTH_DATE,GETDATE()) < 50)
			</cfif>
			<cfif isdefined("attributes.age_50_")  and attributes.age_50_ eq 1>
				AND E.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEES_IDENTY WHERE DATEDIFF(YEAR,BIRTH_DATE,GETDATE()) >50)
			</cfif>	
			<cfif isdefined("attributes.kidem1") and attributes.kidem1 eq 1>
	            AND DATEDIFF(YEAR,E.KIDEM_DATE,GETDATE()) < 1
	        </cfif>
			<cfif isdefined("attributes.kidem2") and attributes.kidem2 eq 1>
	            AND DATEDIFF(YEAR,E.KIDEM_DATE,GETDATE()) >= 1 AND DATEDIFF(YEAR,E.KIDEM_DATE,GETDATE())<3
	        </cfif>
			<cfif isdefined('attributes.kidem3') and attributes.kidem3 eq 1>
	            AND DATEDIFF(YEAR,E.KIDEM_DATE,GETDATE()) >= 3 AND DATEDIFF(YEAR,E.KIDEM_DATE,GETDATE())<5
	        </cfif>
			<cfif isdefined("attributes.kidem4") and attributes.kidem4 eq 1>
	            AND DATEDIFF(YEAR,E.KIDEM_DATE,GETDATE()) >= 5 AND DATEDIFF(YEAR,E.KIDEM_DATE,GETDATE())<9
	        </cfif>
			<cfif isdefined("attributes.kidem5") and attributes.kidem5 eq 1>
	            AND DATEDIFF(YEAR,E.KIDEM_DATE,GETDATE()) > 9
	        </cfif>	
	        <cfif isdefined("attributes.edu_level_id") and len(attributes.edu_level_id)>
	            AND E.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEES_DETAIL WHERE LAST_SCHOOL = #attributes.edu_level_id#)
	        </cfif>	
	        <cfif isdefined("attributes.func_id") and len(attributes.func_id)>
	            AND EP.FUNC_ID = #attributes.func_id#
	        </cfif>
	        <cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
	            AND B.COMPANY_ID = #attributes.comp_id#
	        </cfif>
	        <cfif isdefined("attributes.is_dolu") and attributes.is_dolu eq 1>
	            AND E.EMPLOYEE_ID <> 0 AND E.EMPLOYEE_ID IS NOT NULL
	        </cfif>
	        <cfif isdefined("attributes.is_male") and attributes.is_male eq 1>
	            AND E.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEES_DETAIL WHERE SEX = 1)
	        </cfif>
			<cfif isdefined("attributes.is_female") and attributes.is_female eq 1>
	            AND E.EMPLOYEE_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEES_DETAIL WHERE SEX = 0)
	        </cfif>
	        <cfif isdefined("attributes.collar_type") and len(attributes.collar_type)>
	            AND EP.COLLAR_TYPE = #attributes.collar_type#
	        </cfif>
	        <cfif isdefined("attributes.org_step") and len(attributes.org_step)>
	        	AND EP.ORGANIZATION_STEP_ID IN(SELECT ORGANIZATION_STEP_ID FROM SETUP_ORGANIZATION_STEPS WHERE ORGANIZATION_STEP_ID = EP.ORGANIZATION_STEP_ID AND ORGANIZATION_STEP_NO =#attributes.org_step#)
	        </cfif>
		ORDER BY
			EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME
	</cfquery>
</cfif>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Çalışanlar','58875')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" uidrop="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id="58577.Sıra"></th>
					<cfif not isdefined("attributes.is_empty")>
						<th><cf_get_lang dictionary_id="57487.No"></th>
						<th><cf_get_lang dictionary_id="57570.Ad Soyad"></th>
					</cfif>
					<th><cf_get_lang dictionary_id="58497.Pozisyon"></th>
					<th><cf_get_lang dictionary_id="57574.Şirket"></th>
					<th><cf_get_lang dictionary_id="57453.Şube"></th>
					<th><cf_get_lang dictionary_id="57572.Departman"></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_detail.recordcount>
					<cfoutput query="get_detail">	
						<tr>
							<td>#currentrow#</td>
							<cfif not isdefined("attributes.is_empty")>			
								<td>#employee_no#</td>
								<td><a href="##" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','','ui-draggable-box-medium')">#EMP_NAME#</a></td>
							</cfif>
							<td>#position_name#</td>
							<td>#nick_name#</td>
							<td>#branch_name#</td>
							<td>#department_head#</td>
						</tr>
					</cfoutput>
				<cfelse>
				<tr>
					<td><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı"></td>
				</tr>
			</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>
<script>
	$('.list_settings').remove();
</script>