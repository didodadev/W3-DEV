<!---Eğitim ve Deneyim bilgileri raporu SG 20130924--->
<cf_xml_page_edit fuseact='report.employees_edu_work_info'>
<cfset cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps")>
<cfset cmp_org_step.dsn = dsn>
<cfparam name="attributes.module_id_control" default="3">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.edu_level_id" default="">
<cfparam name="attributes.inout_statue" default="2">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.edu_id" default="">
<cfparam name="attributes.part_id" default="">
<cfparam name="attributes.high_part_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.lang_id" default="">
<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfparam name="attributes.startdate" default="#date_add("m",-1,bu_ay_basi)#">
<cfparam name="attributes.finishdate" default="#Createdate(year(bu_ay_basi),month(bu_ay_basi),bu_ay_sonu)#">
<cfif isdefined("attributes.is_submit")>
	<cf_date tarih="attributes.startdate">
	<cf_date tarih="attributes.finishdate">
	<cfquery name="get_info" datasource="#dsn#">
		SELECT
			E.EMPLOYEE_NO,
			E.EMPLOYEE_ID,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			EI.TC_IDENTY_NO,
			EP.POSITION_NAME,
			PC.POSITION_CAT,
			COMP.COMPANY_NAME,
			B.BRANCH_NAME,
			D.DEPARTMENT_HEAD,
			D2.DEPARTMENT_HEAD AS UPPER_DEPARTMENT_HEAD,
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
			<cfif attributes.report_type eq 1>
				,(SELECT EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID = ED.LAST_SCHOOL) AS EDUCATION_NAME,
				LV.EDUCATION_NAME AS EDU_TYPE,
				CASE 
					WHEN LV.EDU_TYPE IN(2) AND EDU.EDU_ID <> -1 THEN (SELECT SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID = EDU.EDU_ID)
					ELSE
					EDU.EDU_NAME
				END AS EDU_NAME,
				CASE 
					WHEN LV.EDU_TYPE IN(2) AND EDU.EDU_PART_ID <> -1 THEN (SELECT PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID = EDU.EDU_PART_ID)
					WHEN LV.EDU_TYPE IN(1) AND EDU.EDU_PART_ID <> -1 THEN (SELECT HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = EDU.EDU_PART_ID)
				ELSE
					EDU.EDU_PART_NAME
				END AS EDU_PART_NAME,
				EDU.EDU_START,
				EDU.EDU_FINISH,
				EDU.EDU_RANK,
                EDU.IS_EDU_CONTINUE,
				EDU.EDUCATION_TIME,
				EDU.EDUCATION_LANG
			<cfelseif attributes.report_type eq 2>
				,EW.EXP,
				EW.EXP_POSITION,
				CAST(EXP_EXTRA as nvarchar) EXP_EXTRA,
				EW.EXP_START,
				EW.EXP_FINISH,
				EW.EXP_TELCODE+' '+EW.EXP_TEL AS TEL,
				SC.SECTOR_CAT,
				PP.PARTNER_POSITION,
				EW.EXP_SALARY,
				EW.EXP_EXTRA_SALARY,
				EW.EXP_REASON
			<cfelseif attributes.report_type eq 3>
				,SL.LANGUAGE_SET,
				EAL.PAPER_DATE,
				EAL.LANG_POINT,
				EAL.LANG_SPEAK,
				EAL.LANG_WRITE,
				EAL.LANG_MEAN,
				EAL.PAPER_FINISH_DATE,
				SLD.DOCUMENT_NAME PAPER_NAME
			</cfif>
		FROM
			EMPLOYEES E LEFT JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
			INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
			INNER JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID
			LEFT JOIN DEPARTMENT as D2 ON D.HIERARCHY_DEP_ID  = CONCAT(D2.HIERARCHY_DEP_ID,'.',D.DEPARTMENT_ID)
			INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
			INNER JOIN OUR_COMPANY COMP ON B.COMPANY_ID = COMP.COMP_ID
			INNER JOIN SETUP_POSITION_CAT PC ON EP.POSITION_CAT_ID = PC.POSITION_CAT_ID
			<cfif attributes.report_type eq 1>
				INNER JOIN EMPLOYEES_APP_EDU_INFO EDU ON E.EMPLOYEE_ID = EDU.EMPLOYEE_ID
				LEFT JOIN EMPLOYEES_DETAIL ED ON ED.EMPLOYEE_ID = E.EMPLOYEE_ID 
				LEFT JOIN SETUP_EDUCATION_LEVEL LV ON LV.EDU_LEVEL_ID = EDU.EDU_TYPE	
			<cfelseif attributes.report_type eq 2>
				INNER JOIN EMPLOYEES_APP_WORK_INFO EW ON EW.EMPLOYEE_ID = E.EMPLOYEE_ID
				LEFT JOIN SETUP_SECTOR_CATS SC ON EW.EXP_SECTOR_CAT = SC.SECTOR_CAT_ID
				LEFT JOIN SETUP_PARTNER_POSITION PP ON PP.PARTNER_POSITION_ID = EW.EXP_TASK_ID
			<cfelseif attributes.report_type eq 3>
				INNER JOIN EMPLOYEES_APP_LANGUAGE EAL ON EAL.EMPLOYEE_ID = E.EMPLOYEE_ID
				LEFT JOIN SETUP_LANGUAGES SL ON SL.LANGUAGE_ID = EAL.LANG_ID
				LEFT JOIN SETUP_LANGUAGES_DOCUMENTS SLD ON SLD.DOCUMENT_ID = EAL.LANG_PAPER_NAME
			</cfif>
		WHERE
			EP.IS_MASTER = 1
            <!---20131025--->
			<cfif attributes.report_type eq 1>
            	<cfif isdefined('attributes.edu_level_id') and len(attributes.edu_level_id)>
                    AND ED.LAST_SCHOOL IN (#attributes.edu_level_id#)
                </cfif> <!--- 20131022 --->
				<cfif len(attributes.edu_id)>
					AND EDU.EDU_TYPE IN(SELECT EDU_LEVEL_ID FROM SETUP_EDUCATION_LEVEL WHERE EDU_TYPE = 2)
					AND EDU.EDU_ID IN(#attributes.edu_id#)
				</cfif>
				<cfif len(attributes.part_id) and len(attributes.high_part_id)>
					AND(
						(	EDU.EDU_TYPE IN(SELECT EDU_LEVEL_ID FROM SETUP_EDUCATION_LEVEL WHERE EDU_TYPE = 2)
							AND EDU.EDU_PART_ID IN(#attributes.part_id#)
						)
						OR
						(	EDU.EDU_TYPE IN(SELECT EDU_LEVEL_ID FROM SETUP_EDUCATION_LEVEL WHERE EDU_TYPE = 1)
							AND EDU.EDU_PART_ID IN(#attributes.high_part_id#)
						)
					)
				<cfelse>
					<cfif len(attributes.part_id)>
						AND EDU.EDU_TYPE IN(SELECT EDU_LEVEL_ID FROM SETUP_EDUCATION_LEVEL WHERE EDU_TYPE = 2)
						AND EDU.EDU_PART_ID IN(#attributes.part_id#)
					</cfif>
					<cfif len(attributes.high_part_id)>
						AND EDU.EDU_TYPE IN(SELECT EDU_LEVEL_ID FROM SETUP_EDUCATION_LEVEL WHERE EDU_TYPE = 1)
						AND EDU.EDU_PART_ID IN(#attributes.high_part_id#)
					</cfif>
				</cfif>
			</cfif>
			<cfif len(attributes.keyword)>
				AND 
					(E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
					OR
					EI.TC_IDENTY_NO LIKE '#attributes.keyword#'
					OR
					E.EMPLOYEE_NO LIKE '#attributes.keyword#'
					)
			</cfif>
			<cfif len(attributes.position_cat_id)>
				AND PC.POSITION_CAT_ID IN(#attributes.position_cat_id#) 
			</cfif>
			<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
				AND B.BRANCH_ID IN(#attributes.branch_id#)
			</cfif>	
			<cfif isdefined('attributes.department') and len(attributes.department)>
				AND D.DEPARTMENT_ID IN(#attributes.department#)
			</cfif>
			<cfif isdefined('attributes.company') and len(attributes.company)>
				AND COMP.COMP_ID IN(#attributes.company#)
			</cfif>
			<cfif not session.ep.ehesap>
				AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
				AND COMP.COMP_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
			<cfif isdefined('attributes.INOUT_STATUE') and attributes.INOUT_STATUE eq 1><!--- Girişler --->
            	<cfif (isdefined('attributes.startdate') and isdate(attributes.startdate)) OR (isdefined('attributes.finishdate') and isdate(attributes.finishdate))>
            		AND E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE 
				</cfif>
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					EMPLOYEES_IN_OUT.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>AND </cfif>EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
				</cfif> 
				<cfif (isdefined('attributes.startdate') and isdate(attributes.startdate)) OR (isdefined('attributes.finishdate') and isdate(attributes.finishdate))>)</cfif>
			<cfelseif isdefined('attributes.INOUT_STATUE') and attributes.INOUT_STATUE eq 0><!--- Çıkışlar --->
            		AND E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE 
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					 EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>AND </cfif>EMPLOYEES_IN_OUT.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
				</cfif>
				<cfif (isdefined('attributes.startdate') and isdate(attributes.startdate)) OR (isdefined('attributes.finishdate') and isdate(attributes.finishdate))>AND </cfif> EMPLOYEES_IN_OUT.FINISH_DATE IS NOT NULL
                )
			<cfelseif isdefined('attributes.INOUT_STATUE') and attributes.INOUT_STATUE eq 2><!--- aktif calisanlar --->
				AND E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE
				(
					<cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
						<cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
						(
							(
							EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
							)
							OR
							(
							EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
							)
						)
						<cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
						(
							(
							EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
							EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
							)
							OR
							(
							EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
							EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
							)
						)
						<cfelse>
						(
							(
							EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
							)
							OR
							(
							EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
							)
							OR
							(
							EMPLOYEES_IN_OUT.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
							)
							OR
							(
							EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EMPLOYEES_IN_OUT.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
							)
						)
						</cfif>
					<cfelse>
						EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
					</cfif>
				) )
			<cfelse><!--- giriş ve çıkışlar Seçili ise --->
				AND E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE
				(
					(
						EMPLOYEES_IN_OUT.START_DATE IS NOT NULL
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EMPLOYEES_IN_OUT.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
						</cfif>
					)
					OR
					(
						EMPLOYEES_IN_OUT.START_DATE IS NOT NULL
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EMPLOYEES_IN_OUT.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
						</cfif>
					)
				) )
			</cfif>
			<cfif isdefined("attributes.lang_id") and len(attributes.lang_id) and attributes.report_type eq 3>
				AND SL.LANGUAGE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.lang_id#" list="yes">)
			</cfif>
        <cfif isdefined('attributes.department') and not len(attributes.department) and isdefined('attributes.branch_id') and not len(attributes.branch_id) and not len(attributes.position_cat_id) and isdefined('attributes.company') and not len(attributes.company)>
        UNION
		SELECT
			E.EMPLOYEE_NO,
			E.EMPLOYEE_ID,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			EI.TC_IDENTY_NO,
			'' AS POSITION_NAME,
			'' AS POSITION_CAT,
			'' AS COMPANY_NAME,
			'' AS BRANCH_NAME,
			'' AS DEPARTMENT_HEAD,
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
			<cfif attributes.report_type eq 1>
				(SELECT EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID = ED.LAST_SCHOOL) AS EDUCATION_NAME,
				LV.EDUCATION_NAME AS EDU_TYPE,
				CASE 
					WHEN LV.EDU_TYPE IN(2) AND EDU.EDU_ID <> -1 THEN (SELECT SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID = EDU.EDU_ID)
					ELSE
					EDU.EDU_NAME
				END AS EDU_NAME,
				CASE 
					WHEN LV.EDU_TYPE IN(2) AND EDU.EDU_PART_ID <> -1 THEN (SELECT PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID = EDU.EDU_PART_ID)
					WHEN LV.EDU_TYPE IN(1) AND EDU.EDU_PART_ID <> -1 THEN (SELECT HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = EDU.EDU_PART_ID)
				ELSE
					EDU.EDU_PART_NAME
				END AS EDU_PART_NAME,
				EDU.EDU_START,
				EDU.EDU_FINISH,
				EDU.EDU_RANK,
                EDU.IS_EDU_CONTINUE
			<cfelseif attributes.report_type eq 2>
				EW.EXP,
				EW.EXP_POSITION,
				CAST(EXP_EXTRA as nvarchar) EXP_EXTRA,
				EW.EXP_START,
				EW.EXP_FINISH,
				EW.EXP_TELCODE+' '+EW.EXP_TEL AS TEL,
				SC.SECTOR_CAT,
				PP.PARTNER_POSITION,
				EW.EXP_SALARY,
				EW.EXP_EXTRA_SALARY,
				EW.EXP_REASON
			<cfelseif attributes.report_type eq 3>
				SL.LANGUAGE_SET,
				EAL.PAPER_NAME,
				EAL.PAPER_DATE,
				EAL.LANG_POINT,
				SLD.DOCUMENT_NAME
			</cfif>
		FROM
			DEPARTMENT D,
			EMPLOYEES E 
			INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
			<cfif attributes.report_type eq 1>
				INNER JOIN EMPLOYEES_APP_EDU_INFO EDU ON E.EMPLOYEE_ID = EDU.EMPLOYEE_ID
				LEFT JOIN EMPLOYEES_DETAIL ED ON ED.EMPLOYEE_ID = E.EMPLOYEE_ID 
				LEFT JOIN SETUP_EDUCATION_LEVEL LV ON LV.EDU_LEVEL_ID = EDU.EDU_TYPE	
			<cfelseif attributes.report_type eq 2>
				INNER JOIN EMPLOYEES_APP_WORK_INFO EW ON EW.EMPLOYEE_ID = E.EMPLOYEE_ID
				LEFT JOIN SETUP_SECTOR_CATS SC ON EW.EXP_SECTOR_CAT = SC.SECTOR_CAT_ID
				LEFT JOIN SETUP_PARTNER_POSITION PP ON PP.PARTNER_POSITION_ID = EW.EXP_TASK_ID
			<cfelseif attributes.report_type eq 3>
				INNER JOIN EMPLOYEES_APP_LANGUAGE EAL ON EAL.EMPLOYEE_ID = E.EMPLOYEE_ID
				LEFT JOIN SETUP_LANGUAGES SL ON SL.LANGUAGE_ID = EAL.LANG_ID
				LEFT JOIN SETUP_LANGUAGES_DOCUMENTS SLD ON SLD.DOCUMENT_ID = EAL.LANG_PAPER_NAME
			</cfif>
		WHERE
            E.EMPLOYEE_ID NOT IN(SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID IS NOT NULL)
			<!---20131025--->
			<cfif attributes.report_type eq 1>
            	<cfif isdefined('attributes.edu_level_id') and len(attributes.edu_level_id)>
                    AND ED.LAST_SCHOOL IN (#attributes.edu_level_id#)
                </cfif> <!--- 20131022 --->
				<cfif len(attributes.edu_id)>
					AND EDU.EDU_TYPE IN(SELECT EDU_LEVEL_ID FROM SETUP_EDUCATION_LEVEL WHERE EDU_TYPE = 2)
					AND EDU.EDU_ID IN(#attributes.edu_id#)
				</cfif>
				<cfif len(attributes.part_id) and len(attributes.high_part_id)>
					AND(
						(	EDU.EDU_TYPE IN(SELECT EDU_LEVEL_ID FROM SETUP_EDUCATION_LEVEL WHERE EDU_TYPE = 2)
							AND EDU.EDU_PART_ID IN(#attributes.part_id#)
						)
						OR
						(	EDU.EDU_TYPE IN(SELECT EDU_LEVEL_ID FROM SETUP_EDUCATION_LEVEL WHERE EDU_TYPE = 1)
							AND EDU.EDU_PART_ID IN(#attributes.high_part_id#)
						)
					)
				<cfelse>
					<cfif len(attributes.part_id)>
						AND EDU.EDU_TYPE IN(SELECT EDU_LEVEL_ID FROM SETUP_EDUCATION_LEVEL WHERE EDU_TYPE = 2)
						AND EDU.EDU_PART_ID IN(#attributes.part_id#)
					</cfif>
					<cfif len(attributes.high_part_id)>
						AND EDU.EDU_TYPE IN(SELECT EDU_LEVEL_ID FROM SETUP_EDUCATION_LEVEL WHERE EDU_TYPE = 1)
						AND EDU.EDU_PART_ID IN(#attributes.high_part_id#)
					</cfif>
				</cfif>
			</cfif>
			<cfif len(attributes.keyword)>
				AND 
					(E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
					OR
					EI.TC_IDENTY_NO LIKE '#attributes.keyword#'
					OR
					E.EMPLOYEE_NO LIKE '#attributes.keyword#'
					)
			</cfif>
			<!---<cfif len(attributes.position_cat_id)>
				AND PC.POSITION_CAT_ID IN(#attributes.position_cat_id#) 
			</cfif>
			<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
				AND B.BRANCH_ID IN(#attributes.branch_id#)
			</cfif>	
			<cfif isdefined('attributes.department') and len(attributes.department)>
				AND D.DEPARTMENT_ID IN(#attributes.department#)
			</cfif>
			<cfif isdefined('attributes.company') and len(attributes.company)>
				AND COMP.COMP_ID IN(#attributes.company#)
			</cfif>--->
			<cfif isdefined('attributes.INOUT_STATUE') and attributes.INOUT_STATUE eq 1><!--- Girişler --->
            	<cfif (isdefined('attributes.startdate') and isdate(attributes.startdate)) OR (isdefined('attributes.finishdate') and isdate(attributes.finishdate))>
            		AND E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE 
				</cfif>
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					EMPLOYEES_IN_OUT.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>AND </cfif>EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
				</cfif> 
				<cfif (isdefined('attributes.startdate') and isdate(attributes.startdate)) OR (isdefined('attributes.finishdate') and isdate(attributes.finishdate))>)</cfif>
			<cfelseif isdefined('attributes.INOUT_STATUE') and attributes.INOUT_STATUE eq 0><!--- Çıkışlar --->
            		AND E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE 
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					 EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>AND </cfif>EMPLOYEES_IN_OUT.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
				</cfif>
				<cfif (isdefined('attributes.startdate') and isdate(attributes.startdate)) OR (isdefined('attributes.finishdate') and isdate(attributes.finishdate))>AND </cfif> EMPLOYEES_IN_OUT.FINISH_DATE IS NOT NULL
                )
			<cfelseif isdefined('attributes.INOUT_STATUE') and attributes.INOUT_STATUE eq 2><!--- aktif calisanlar --->
				AND E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE
				(
					<cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
						<cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
						(
							(
							EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
							)
							OR
							(
							EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
							)
						)
						<cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
						(
							(
							EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
							EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
							)
							OR
							(
							EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#"> AND
							EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
							)
						)
						<cfelse>
						(
							(
							EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
							)
							OR
							(
							EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
							)
							OR
							(
							EMPLOYEES_IN_OUT.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
							)
							OR
							(
							EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#"> AND
							EMPLOYEES_IN_OUT.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
							)
						)
						</cfif>
					<cfelse>
						EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
					</cfif>
				) )
			<cfelse><!--- giriş ve çıkışlar Seçili ise --->
				AND E.EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE
				(
					(
						EMPLOYEES_IN_OUT.START_DATE IS NOT NULL
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EMPLOYEES_IN_OUT.START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
						</cfif>
					)
					OR
					(
						EMPLOYEES_IN_OUT.START_DATE IS NOT NULL
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EMPLOYEES_IN_OUT.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.finishdate#">
						</cfif>
					)
				) )
			</cfif>
			<cfif isdefined("attributes.lang_id") and len(attributes.lang_id) and attributes.report_type eq 3>
				AND SL.LANGUAGE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.lang_id#" list="yes">)
			</cfif>
       </cfif>
		ORDER BY
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
	</cfquery>
<cfelse>
	<cfset get_info.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_info.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="get_position_cats" datasource="#dsn#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<cfquery name="get_edu_level" datasource="#dsn#">
	SELECT EDU_TYPE,EDU_LEVEL_ID,EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL ORDER BY EDUCATION_NAME
</cfquery>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME 
	FROM 
		BRANCH 
	WHERE 
		<cfif isdefined('attributes.company') and len(attributes.company)>
			COMPANY_ID IN(#attributes.company#)
			<cfif not session.ep.ehesap>
                AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
            </cfif>
		<cfelse>
			1=0
		</cfif>
	ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="get_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>BRANCH_ID IN(#attributes.branch_id#)<cfelse>1=0</cfif> AND DEPARTMENT_STATUS = 1 ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfquery name="get_company" datasource="#dsn#">
	SELECT 
		COMP_ID,
		NICK_NAME 
	FROM 
		OUR_COMPANY 
	<cfif not session.ep.ehesap>
        WHERE COMP_ID IN (SELECT DISTINCT B.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH B ON B.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
    </cfif>
	ORDER BY 
		NICK_NAME
</cfquery>
<cfquery name="get_edu" datasource="#dsn#">
	SELECT * FROM SETUP_SCHOOL ORDER BY SCHOOL_NAME
</cfquery>
<cfquery name="get_school_part" datasource="#dsn#">
	SELECT PART_ID,PART_NAME FROM SETUP_SCHOOL_PART ORDER BY PART_NAME
</cfquery>
<cfquery name="get_high_school_part" datasource="#dsn#">
	SELECT HIGH_PART_ID,HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART ORDER BY HIGH_PART_NAME
</cfquery>
<cfquery name="GET_LANGUAGES" datasource="#dsn#">
	SELECT LANGUAGE_ID,LANGUAGE_SET FROM SETUP_LANGUAGES ORDER BY LANGUAGE_SET
</cfquery>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='40432.Eğitim ve Deneyim Bilgileri Raporu' ></cfsavecontent>
<cfform name="list_info" method="post" action="#request.self#?fuseaction=report.employees_edu_work_info">
	<!-- sil -->
	<cf_report_list_search title="#head#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
											<div class="col col-12 col-xs-12">
												<input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>">
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
											<div class="col col-12 col-xs-12">
												<select name="report_type" id="report_type" onchange="satir_gizle()">
													<option value="1"<cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57419.Eğitim'></option>
													<option value="2"<cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id='55307.İş Tecrübesi'></option>
													<option value="3"<cfif attributes.report_type eq 3>selected</cfif>><cf_get_lang dictionary_id='55216.Yabancı Dil'></option>
												</select>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
											<div class="col col-12 col-xs-12">
												<div style="position:relative; z-index:1;">
													<cf_multiselect_check 
													query_name="get_company"  
													name="company"
													style="position:relative; z-index:-1;"
													option_text="#getLang('main',322)#" 
													option_value="COMP_ID"
													option_name="NICK_NAME"
													value="#iif(isdefined("attributes.company"),"attributes.company",DE(""))#"
													onchange="get_branch_list(this.value)">
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
											<div class="col col-12 col-xs-12">
												<div style="position:relative; z-index:1;" id="BRANCH_PLACE">
													<cf_multiselect_check 
														query_name="get_branch"  
														name="branch_id"
														width="150" 
														option_text="#getLang('main',322)#" 
														option_value="BRANCH_ID"
														option_name="BRANCH_NAME"
														value="#iif(isdefined("attributes.branch_id"),"attributes.branch_id",DE(""))#"
														onchange="get_department_list(this.value)">
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57572.Departman'></label>
											<div class="col col-12 col-xs-12">
												<div style="position:relative; z-index:1;" id="DEPARTMENT_PLACE">
													<cf_multiselect_check 
														query_name="get_department"  
														name="department" 
														option_text="#getLang('main',322)#" 
														option_value="department_id"
														option_name="department_head"
														value="#iif(isdefined("attributes.department"),"attributes.department",DE(""))#">
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
											<div class="col col-12 col-xs-12">
												<div style="position:relative; z-index:1;">
													<cf_multiselect_check 
													query_name="get_position_cats"  
													name="position_cat_id"
													width="150" 
													option_value="POSITION_CAT_ID"
													option_name="POSITION_CAT"
													value="#attributes.position_cat_id#">
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='50669.Kriter'></label>
											<div class="col col-12">
												<select name="inout_statue" id="inout_statue">
													<option value=""><cf_get_lang dictionary_id='55904.Giriş ve Çıkışlar'></option>
													<option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang dictionary_id='58535.Girişler'></option>
													<option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang dictionary_id='58536.Çıkışlar'></option>
													<option value="2"<cfif attributes.inout_statue eq 2> selected</cfif>><cf_get_lang dictionary_id='39083.Aktif Çalışanlar'></option>
												</select>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='50669.Kriter'><cf_get_lang dictionary_id='58690.Tarih Aralığı'>*</label>
											<div class="col col-6 col-md-6">
												<div class="input-group">
													<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
													<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
														<cfinput type="text" name="startdate" id="startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#"  value="#dateformat(attributes.startdate,dateformat_style)#">
													<cfelse>
														<cfinput type="text" name="startdate" id="startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" >
													</cfif>
													<span class="input-group-addon">
														<cf_wrk_date_image date_field="startdate">
													</span>
												</div>
											</div>
											<div class="col col-6 col-md-6">
												<div class="input-group">	
													<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</cfsavecontent>
													<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
														<cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
													<cfelse>
														<cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" >
													</cfif>
													<span class="input-group-addon">
														<cf_wrk_date_image date_field="finishdate">	
													</span>	
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group" id="div_1">
											<div id="edu_1">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39521.Eğitim Seviyesi'></label>
											</div>
											<div id="edu_2">
												<div class="col col-12 col-xs-12">
													<div style="position:relative; z-index:1;">
														<cf_multiselect_check 
															query_name="get_edu_level"  
															name="edu_level_id"
															option_value="EDU_LEVEL_ID"
															option_name="EDUCATION_NAME"
															value="#attributes.edu_level_id#">	<!--- onchange="get_edu(this.value)" --->
													</div>
												</div>
											</div>
										</div>
										<div class="form-group"  id="div_2">
											<div id="edu_3">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='40696.Üniversiteler'></label>				
											</div>
											<div id="edu_4">
												<div class="col col-12 col-xs-12">
													<div style="position:relative; z-index:1;">
														<cf_multiselect_check 
														query_name="get_edu"  
														name="edu_id"
														option_value="SCHOOL_ID"
														option_name="SCHOOL_NAME"
														value="#attributes.edu_id#">
													</div>
												</div>
											</div>
										</div>
										<div class="form-group"  id="div_3">
											<div id="edu_5">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='40705.Üniversite Bölümleri'></label>
											</div>
											<div id="edu_6">
												<div class="col col-12 col-xs-12">
													<div style="position:relative; z-index:1;">
														<cf_multiselect_check 
														query_name="get_school_part"  
														name="part_id"
														option_value="PART_ID"
														option_name="PART_NAME"
														value="#attributes.part_id#">
													</div> 
												</div>   
											</div>
										</div>
										<div class="form-group"  id="div_4">
											<div id="edu_7">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='40712.Lise Bölümleri'></label>
											</div>
											<div id="edu_8">
												<div class="col col-12 col-xs-12">
													<div style="position:relative; z-index:1;">
														<cf_multiselect_check 
														query_name="get_high_school_part"  
														name="high_part_id"
														option_value="HIGH_PART_ID"
														option_name="HIGH_PART_NAME"
														value="#attributes.high_part_id#">
													</div>
												</div> 
											</div>
										</div>
										<div class="form-group"  id="div_5">
											<div id="lang_1">
												<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58996.Dil'></label>
											</div>
											<div id="lang_2">
												<div class="col col-12 col-xs-12">
													<div style="position:relative; z-index:1;">
														<cf_multiselect_check 
														query_name="GET_LANGUAGES"  
														name="lang_id"
														option_value="LANGUAGE_ID"
														option_name="LANGUAGE_SET"
														value="#attributes.lang_id#">
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif isDefined("attributes.is_excel") and attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<cfinput type="hidden" name="is_submit" id="is_submit" value="1">
							<cf_wrk_report_search_button button_type="1" is_excel="1" search_function="control()"> 
						</div>
					</div>
				</div>
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search>
	<!-- sil -->
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
<cfif isdefined("attributes.is_submit")>
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
	</cfif>
    <!-- sil -->
        <cf_report_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id="58577.sıra"></th>
                    <th width="75"><cf_get_lang dictionary_id='32328.Sicil No'></th>
                    <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                    <th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='57985.Üst'> <cf_get_lang dictionary_id='57572.Departman'></th>
                    <th><cf_get_lang dictionary_id='57572.Departman'></th>
                    <th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
					<cfif attributes.report_type eq 1>
						<th><cf_get_lang dictionary_id='55337.Eğitim Seviyesi'></th>
						<cfloop from="1" to="4" index="i">
							<th><cf_get_lang dictionary_id='56481.Okul Türü'></th>
							<th><cf_get_lang dictionary_id='57709.Okul'></th>
							<th><cf_get_lang dictionary_id='57995.Bölüm'></th>
							<th><cf_get_lang dictionary_id='57554.Giriş'></th>
							<th><cf_get_lang dictionary_id='30646.Mezuniyet'></th>
							<th><cf_get_lang dictionary_id='35157.Not Ort'></th>
							<th width="50"><cf_get_lang dictionary_id="41520.Öğrenim dili"></th>
							<th width="50"><cf_get_lang dictionary_id="41519.Öğrenim süresi"></th>
							<th width="50"><cf_get_lang dictionary_id='47621.Devam Durumu'></th>
						</cfloop>
                    <cfelseif attributes.report_type eq 2>
                        <th><cf_get_lang dictionary_id='55307.İş Tecrübesi'> <cf_get_lang dictionary_id ='57574.Şirket'></th>
                        <th><cf_get_lang dictionary_id='55307.İş Tecrübesi'> <cf_get_lang dictionary_id ='58497.Pozisyon'></th>
                        <th><cf_get_lang dictionary_id='57579.Sektör'></th>
                        <th><cf_get_lang dictionary_id='57571.Unvan'></th>
                        <th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
						<th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
						<th><cf_get_lang dictionary_id='55866.Toplam Çalışma Süresi'></th>
                        <th><cf_get_lang dictionary_id='55932.Kod/Telefon'></th>
                        <th><cf_get_lang dictionary_id='53127.Ücret'></th>
                        <th><cf_get_lang dictionary_id='56165.Ek Ödemeler'></th>
                        <th><cf_get_lang dictionary_id='56166.Görev Sorumluluk ve Ek Açıklamalar'></th>
                        <th><cf_get_lang dictionary_id='55332.Ayrılma Nedeni'></th>
					<cfelse>
						<cfloop from="1" to="4" index="i">
							<cfoutput><th><cf_get_lang dictionary_id='55216.Yabancı Dil'>#i#</th>
							<th><cf_get_lang dictionary_id='55652.Belge Adı'>#i#</th>
							<th><cf_get_lang dictionary_id='31304.Konuşma'>#i#</th>
							<th><cf_get_lang dictionary_id='56159.Anlama'>#i#</th>
							<th><cf_get_lang dictionary_id='56160.Yazma'>#i#</th>
							<th><cf_get_lang dictionary_id='57073.Belge Tarihi'>#i#</th>
							<th><cf_get_lang dictionary_id='60929.Belge Bitiş Tarihi'>#i#</th>
							<th><cf_get_lang dictionary_id='41169.Dil Puanı'>#i#</th>
							<th><cf_get_lang dictionary_id='31307.Öğrenildiği Yer'>#i#</th></cfoutput>
						</cfloop>
                    </cfif>
					<cfif isDefined("x_show_level") and x_show_level eq 1><th><cf_get_lang dictionary_id='62040.Kademeli Departman'></th></cfif>
                </tr>
            </thead>
				<cfif get_info.recordcount>
                    <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                        <cfset attributes.startrow=1>
                        <cfset attributes.maxrows = get_info.recordcount>
					</cfif>
					<cfset emp_id_list="">
                    <tbody>
						<cfoutput query="get_info" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfif not listfind(emp_id_list,employee_id,',')>
								<cfset emp_id_list=listappend(emp_id_list,'#EMPLOYEE_ID#')>
								<tr>
									<td>#currentrow#</td>
									<td>#employee_no#</td>
									<td>
										<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
											#employee_name# #employee_surname#
										<cfelse>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi"> 
											#employee_name# #employee_surname#
											</a>
										</cfif>
									</td>
									<td>#company_name#</td>
									<td>#branch_name#</td>								
									<td>#UPPER_DEPARTMENT_HEAD#</td>
									<td>#department_head#</td>
									<td>#position_cat#</td>
									<cfif attributes.report_type eq 1>
										<!---eğitim---->
										<td>#education_name#</td>
										<cfquery name="edu_info_emp" datasource="#dsn#">
											SELECT TOP 4 S.EDUCATION_NAME,EAE.EDU_TYPE,EDUCATION_TIME,IS_EDU_CONTINUE, EDU_NAME,EDU_PART_NAME,EDUCATION_LANG,EDU_LANG_RATE,EDU_START,EDU_FINISH
												FROM EMPLOYEES_APP_EDU_INFO EAE LEFT JOIN SETUP_EDUCATION_LEVEL S ON S.EDU_LEVEL_ID = EAE.EDU_TYPE
												WHERE EMPLOYEE_ID = #employee_id#
										</cfquery>
										<cfloop from="1" to="4" index="i">
											<td><cfif len(edu_info_emp.education_name[i])>#edu_info_emp.education_name[i]#</cfif></td>
											<td><cfif len(edu_info_emp.edu_name[i])>#edu_info_emp.edu_name[i]#</cfif></td>
											<td><cfif len(edu_info_emp.edu_part_name[i])>#edu_info_emp.edu_part_name[i]#</cfif></td>
											<td><cfif len(edu_info_emp.edu_start[i])>#dateformat(edu_info_emp.edu_start[i],dateformat_style)#</cfif></td>
											<td><cfif len(edu_info_emp.edu_finish[i])>#dateformat(edu_info_emp.edu_finish[i],dateformat_style)#</cfif></td>
											<td><cfif len(edu_info_emp.edu_lang_rate[i])>#edu_info_emp.edu_lang_rate[i]#</cfif></td>
											<td><cfif len(edu_info_emp.EDUCATION_LANG[i])>#edu_info_emp.EDUCATION_LANG[i]#</cfif></td>
											<td><cfif len(edu_info_emp.EDUCATION_TIME[i])>#edu_info_emp.EDUCATION_TIME[i]#</cfif></td>
											<td><cfif len(edu_info_emp.education_name[i])><cfif edu_info_emp.is_edu_continue eq 1>Evet</cfif></cfif></td>
										</cfloop>
									<cfelseif attributes.report_type eq 2>
										<td>#exp#</td>
										<td>#EXP_POSITION#</td>
										<td>#SECTOR_CAT#</td>
										<td>#PARTNER_POSITION#</td>
										<td>#dateformat(exp_start,dateformat_style)#</td>
										<td>#dateformat(exp_finish,dateformat_style)#</td>

										<cfset start_date = exp_start>
										<cfset finish_date = now()>
										<cfif len(exp_finish)>
											<cfset finish_date = exp_finish>
										</cfif>
										<cfif len(start_date)>
											<cfset total_days = dateDiff('d',start_date,finish_date)>
											<cfset total_years = int(total_days / 365)>
											<cfset remaining_days = total_days - (total_years * 365)>
											<cfset total_months = int(remaining_days / 30)>
											<cfset remaining_days = remaining_days - (total_months * 30)>
											<td>
												<cfif total_years neq 0>
													#total_years# <cf_get_lang dictionary_id="58455.Yıl">
												</cfif>
												<cfif total_months neq 0>
													#total_months# <cf_get_lang dictionary_id="58724.Ay">
												</cfif>
												<cfif remaining_days neq 0>
													#remaining_days# <cf_get_lang dictionary_id="57490.Gün">
												</cfif>
											</td>
										<cfelse>
											<td></td>
										</cfif>

										<td>#tel#</td>
										<td>#EXP_SALARY#</td>
										<td>#EXP_EXTRA_SALARY#</td>
										<td>#EXP_EXTRA#</td>
										<td>#EXP_REASON#</td>
									<cfelse>
										<cfquery name="lang_emp" datasource="#dsn#">
											SELECT TOP 4 LANGUAGE_SET,LANG_POINT,DOCUMENT_NAME,PAPER_DATE,PAPER_FINISH_DATE,LANG_WHERE,PAPER_NAME,LANG_SPEAK,LANG_WRITE,LANG_MEAN,PAPER_FINISH_DATE
											FROM EMPLOYEES_APP_LANGUAGE EA 
											LEFT JOIN SETUP_LANGUAGES S ON S.LANGUAGE_ID = EA.LANG_ID 
											LEFT JOIN SETUP_LANGUAGES_DOCUMENTS SD ON SD.DOCUMENT_ID = EA.LANG_PAPER_NAME
											WHERE EMPLOYEE_ID = #employee_id#
										</cfquery>
										<cfloop from="1" to="4" index="i">
											<td>#lang_emp.LANGUAGE_SET[i]#</td>
											<cfif isdefined('x_document_name') and x_document_name eq 1><td>#lang_emp.document_name[i]#</td><cfelse><td>#lang_emp.paper_name[i]#</td></cfif>
											<td>
												<cfset lang_speak = cmp_org_step.KNOW_LEVELS(knowlevel_id: lang_emp.LANG_SPEAK[i])>
												#lang_speak.KNOWLEVEL#
											</td>
											<td>
												<cfset lang_mean = cmp_org_step.KNOW_LEVELS(knowlevel_id: lang_emp.LANG_MEAN[i])>
												#lang_mean.KNOWLEVEL#
											</td>
											<td>
												<cfset lang_write = cmp_org_step.KNOW_LEVELS(knowlevel_id: lang_emp.LANG_WRITE[i])>
												#lang_write.KNOWLEVEL#
											</td>
											<td>#dateformat(lang_emp.PAPER_DATE[i],dateformat_style)#</td>
											<td>#dateformat(lang_emp.PAPER_FINISH_DATE[i],dateformat_style)#</td>
											<td format="numeric">#tlformat(lang_emp.LANG_POINT[i],2)#</td>
											<td>#lang_emp.lang_where[i]#</td>
										</cfloop>
									</cfif>
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
											</cfif>​
										</td>
									</cfif>
								</tr>
							</cfif>
                        </cfoutput> 
                    </tbody>
                <cfelse>
                	<tbody>
                        <tr>
                            <td colspan="18"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                        </tr>
                    </tbody>
                </cfif>
        </cf_report_list>
    
	<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "">
	<cfset url_str = "#url_str#&is_submit=1&report_type=#attributes.report_type#">
	<cfif len(attributes.position_cat_id)>
		<cfset url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#">
	</cfif>
	<cfif isdefined('attributes.company') and len(attributes.company)>
		<cfset url_str = "#url_str#&company=#attributes.company#">
	</cfif>
	<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
		<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
	</cfif>
	<cfif isdefined('attributes.department') and len(attributes.department)>
		<cfset url_str = "#url_str#&department=#attributes.department#">
	</cfif>
	<cfif isdefined('attributes.startdate') and len(attributes.startdate)>
		<cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
	</cfif>
	<cfif isdefined('attributes.finishdate') and len(attributes.finishdate)>
		<cfset url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
	</cfif>
	<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif isdefined('attributes.edu_id') and len(attributes.edu_id)>
		<cfset url_str = "#url_str#&edu_id=#attributes.edu_id#">
	</cfif>
	<cfif isdefined('attributes.part_id') and len(attributes.part_id)>
		<cfset url_str = "#url_str#&part_id=#attributes.part_id#">
	</cfif>
	<cfif isdefined('attributes.high_part_id') and len(attributes.high_part_id)>
		<cfset url_str = "#url_str#&high_part_id=#attributes.high_part_id#">
	</cfif>
			<cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="report.employees_edu_work_info#url_str#">
	</cfif>
</cfif>
<script type="text/javascript">
	$(document).ready(function(e){
		satir_gizle();
	}); <!---20131022--->
	function control(){
		if(document.getElementById('startdate').value == ''|| document.getElementById('finishdate').value == '')
        {
            alert("<cf_get_lang dictionary_id='40466.Lütfen Tarih Değerlerini Eksiksiz Doldurunuz	'>");
            return false;
        }
		if(!date_check(list_info.startdate,list_info.finishdate,"<cf_get_lang dictionary_id ='40310.Başlama Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
			return false;
		}
		if(document.list_info.is_excel.checked==false)
		{
			document.list_info.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
			return true;
		}
		else
			document.list_info.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_employees_education_and_work_info</cfoutput>"
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
	function get_branch_list(gelen)
	{
		checkedValues_b = $("#company").multiselect("getChecked");
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

	function satir_gizle()
	{
		if(document.getElementById('report_type').value == 2)
		{
			div_1.style.display = "none";
			div_2.style.display = "none";		
			div_3.style.display = "none";		
			div_4.style.display = "none";		
			div_5.style.display = "none";
		}
		else if(document.getElementById('report_type').value == 1)
		{
			div_1.style.display = "";
			div_2.style.display = "";		
			div_3.style.display = "";		
			div_4.style.display = "";		
			div_5.style.display = "none";
		}else if(document.getElementById('report_type').value == 3)
		{
			div_1.style.display = "none";
			div_2.style.display = "none";		
			div_3.style.display = "none";		
			div_4.style.display = "none";		
			div_5.style.display = "";
		}
	}
</script>
