<!--- 
File: ProjectWorkBoard.cfc
Author: Melek KOCABEY <melekkocabey@workcube.com>
Date: 05.09.2019
Controller: -
Description:Proje WorkBoard querylerinin bulunduğu cfc'dir.
--->

<cfcomponent displayname="Board"  hint="ColdFusion Component for Kullanicilar">
	<cfset dsn=application.systemParam.systemParam().dsn>
	<cffunction name = "get_employee" returnType = "query" hint = "[Çalışanları getir]">
		<cfquery name = "get_employee" datasource="#dsn#">
		SELECT 
			EMPLOYEES.EMPLOYEE_ID,
			EMPLOYEES.EMPLOYEE_NO,
			EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME AS EMPLOYEE_NS
		FROM	
			EMPLOYEE_POSITIONS,	
			EMPLOYEES
		WHERE
			EMPLOYEES.EMPLOYEE_STATUS = 1 and
			EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
		GROUP BY
			EMPLOYEES.EMPLOYEE_ID,
			EMPLOYEES.EMPLOYEE_NO,
			EMPLOYEES.EMPLOYEE_NAME, 
			EMPLOYEES.EMPLOYEE_SURNAME
		ORDER BY	
			EMPLOYEES.EMPLOYEE_NAME
		</cfquery>
		<cfreturn get_employee>
	</cffunction>
	<cffunction name = "GET_WORK_CAT" returnType = "query" hint = " İş kategorilerini getir ">
		<cfquery name="GET_WORK_CAT" datasource="#DSN#">
			SELECT 
				#dsn#.Get_Dynamic_Language(PRO_WORK_CAT.WORK_CAT_ID,'#session.ep.language#','PRO_WORK_CAT','WORK_CAT',NULL,NULL,PRO_WORK_CAT.WORK_CAT) AS work_cat,
				WORK_CAT_ID,
				TEMPLATE_ID 
			FROM 
				PRO_WORK_CAT
			WHERE
				<cfif isDefined('session.ep.userid')>
					','+OUR_COMPANY_ID+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.company_id#,%">
				<cfelseif isDefined('session.pp.userid')>
					','+OUR_COMPANY_ID+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.our_company_id#,%">
				<cfelseif isDefined('session.pda.userid')>
					','+OUR_COMPANY_ID+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pda.our_company_id#,%">
				</cfif>            
			ORDER BY 
				WORK_CAT
		</cfquery>
		<cfreturn GET_WORK_CAT>
	</cffunction>
	<cffunction name = "GET_WORK_PROCURRENCY" returnType = "query" hint = "iş aşamalarını getir">
		<cfquery name="GET_PROCURRENCY" datasource="#DSN#">
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
				PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%project.works%'>
			ORDER BY
				PTR.LINE_NUMBER
		</cfquery>
		<cfreturn GET_PROCURRENCY>
	</cffunction>
	<cffunction name = "GET_WORKGROUPS" returnType = "query" hint = "iş gruplarını getir">
		<cfquery name="GET_WORKGROUPS" datasource="#DSN#">
			SELECT 
				WORKGROUP_ID,
				WORKGROUP_NAME
			FROM 
				WORK_GROUP
			WHERE
				STATUS = 1
				AND HIERARCHY IS NOT NULL
			ORDER BY 
				HIERARCHY
		</cfquery>
		<cfreturn GET_WORKGROUPS>
	</cffunction>
	<cffunction name = "GET_WORKS" returnType = "query" hint = "işleri getir">
		<cfargument name="start_date">
		<cfargument name="finish_date">
		<cfargument name="last_month_">
		<cfargument name="work_currency_id">
		<cfargument name="consumer_id">
		<cfargument name="work_cat">
		<cfargument name="is_termin">
		<cfargument name="is_services">
		<cfargument name="is_termin_date">
		<cfargument name="work_id">
		<cfargument name="paper_number">
		<cfargument name="cash">
		<cfargument name="action">
		<cfargument name="special_definition_id">
		<cfargument name="branch_id">
		<cfargument name="department">
		<cfargument name="cash_status">
		<cfargument name="action_cash">
		<cfargument name="project_head">
		<cfargument name="project_id">
		<cfargument name="dsn3_alias" default="">
		<cfargument name="lastMonthStartDate" default="">
		<cfargument name="lastMonthFinishDate" default="">
		<cfquery name="get_works" datasource="#dsn#">
			SELECT DISTINCT				
				0 TYPE,
				PW.WORK_ID,
				PW.WORK_HEAD,
				PW.TARGET_FINISH,
				PW.TARGET_START,
				PW.UPDATE_DATE UPDATE_DATE,
				PW.TERMINATE_DATE,
				EP.EMPLOYEE_ID,
				EP.EMPLOYEE_NAME,
				EP.EMPLOYEE_SURNAME,
				EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME NAME_SURNAME,
				0 CC_EMPLOYEE_ID,
				'' CC_NAME_SURNAME,
				PW.PROJECT_ID,
				PP.PROJECT_HEAD,
				SP.PRIORITY,
				PTR.STAGE,
				PWC.WORK_CAT,
				PW.ESTIMATED_TIME,
				ISNULL((SELECT SUM((ISNULL(TOTAL_TIME_HOUR,0)*60) + ISNULL(TOTAL_TIME_MINUTE,0)) FROM PRO_WORKS_HISTORY WHERE PW.WORK_ID = PRO_WORKS_HISTORY.WORK_ID GROUP BY WORK_ID),0)  HARCANAN_DAKIKA,
				S.SERVICE_NO,
				ISNULL(SO.AMOUNT,0) AS AMOUNT,
				ISNULL(SO.PREDICTED_AMOUNT,0) AS PREDICTED_AMOUNT,
				<cfif isdefined("arguments.last_month_") and len(arguments.last_month_)>
					SUM(PWH.EXPENSED_MINUTE) TOTAL_TIME,
					PP.PROJECT_HEAD SUBSCRIPTION_HEAD
				<cfelse>
					PP.PROJECT_HEAD as SUBSCRIPTION_HEAD
				</cfif>
			FROM
				PRO_WORKS PW
				LEFT JOIN SETUP_PRIORITY SP ON SP.PRIORITY_ID = PW.WORK_PRIORITY_ID
				LEFT JOIN SETUP_ACTIVITY SA ON SA.ACTIVITY_ID = PW.ACTIVITY_ID
				<cfif isdefined("arguments.last_month_") and len(arguments.last_month_)>
					LEFT JOIN TIME_COST PWH ON PWH.WORK_ID = PW.WORK_ID
				</cfif>
				LEFT JOIN #DSN3_alias#.SUBSCRIPTION_CONTRACT SC ON SC.PROJECT_ID = PW.PROJECT_ID AND SC.IS_ACTIVE = 1
				LEFT JOIN EMPLOYEES EP ON EP.EMPLOYEE_ID = <cfif isdefined("arguments.last_month_") and len(arguments.last_month_)>PWH.EMPLOYEE_ID <cfelse>PW.PROJECT_EMP_ID</cfif> 
				LEFT JOIN PRO_PROJECTS PP ON PP.PROJECT_ID = PW.PROJECT_ID
				LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = PW.WORK_CURRENCY_ID
				LEFT JOIN PRO_WORK_CAT PWC ON PWC.WORK_CAT_ID = PW.WORK_CAT_ID
				LEFT JOIN EMPLOYEES EP3 ON EP3.EMPLOYEE_ID = <cfif isdefined("arguments.last_month_") and len(arguments.last_month_)>PW.UPDATE_AUTHOR <cfelse>ISNULL(PW.UPDATE_AUTHOR,PW.RECORD_AUTHOR)</cfif> 
				LEFT JOIN #dsn3_alias#.SERVICE S ON S.SERVICE_ID = PW.SERVICE_ID AND SERVICE_STATUS_ID != 375 AND SERVICE_ACTIVE = 1
				LEFT JOIN #dsn3_alias#.SERVICE_OPERATION SO ON SO.SERVICE_ID = S.SERVICE_ID AND SO.PRODUCT_ID IN (259,241)
			WHERE
				<cfif isdefined("arguments.last_month_") and len(arguments.last_month_)>
					<cfif isdefined("arguments.employee_id_list") and len(arguments.employee_id_list)>
						PWH.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id_list#" list="yes">) <!--- Bizden Biri Tarafindan Guncellenen --->
						OR
						(
						PW.WORK_ID IN (SELECT WORK_ID FROM PRO_WORKS_CC WHERE CC_EMP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id_list#"  list="yes">))
						) AND
					</cfif>
					(PWH.EXPENSED_MINUTE) > 0 AND
					PWH.EVENT_DATE BETWEEN #arguments.lastMonthStartDate# AND #arguments.lastMonthFinishDate# AND 
				<cfelse>		
					PW.WORK_STATUS = 1 AND
				</cfif>		
				<cfif IsDefined("arguments.work_currency_id") and Len(arguments.work_currency_id)>
					PW.WORK_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_currency_id#"> AND
				</cfif>
				<cfif isdefined("arguments.project_id") and len(arguments.project_id)>
					PW.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"> AND
				</cfif>
				<cfif isdefined("arguments.work_cat") and len(arguments.work_cat)>
					PW.WORK_CAT_ID = #arguments.work_cat# AND
				</cfif>
				<cfif isdefined('arguments.is_termin') and len(arguments.is_termin)>
					PW.TERMINATE_DATE <= #now()# AND
				</cfif>
				<cfif isdefined("arguments.is_services") and len(arguments.is_services)>
					PW.SERVICE_ID IS NOT NULL AND
					S.SERVICE_STATUS_ID NOT IN (8,373,125) AND
				</cfif>
				<cfif isdefined("arguments.is_termin_date") and len(arguments.is_termin_date)>
					PW.TERMINATE_DATE IS NULL AND
					PW.SERVICE_ID IS NOT NULL AND
					S.SERVICE_STATUS_ID NOT IN (8,373,125) AND
				</cfif>
				<cfif isdefined("arguments.start_date") and len(arguments.start_date)>
					PW.TERMINATE_DATE >= #arguments.start_date# AND
				</cfif>
				<cfif isdefined("arguments.finish_date") and len(arguments.finish_date)>
					PW.TERMINATE_DATE <= #arguments.finish_date# AND
				</cfif>
				<cfif isdefined("arguments.workgroup_id") and len(arguments.workgroup_id)>
					PW.WORKGROUP_ID = #arguments.workgroup_id# AND
				</cfif>
				<cfif isdefined("arguments.work_id") and Len(arguments.work_id)>
					PW.WORK_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value='#arguments.work_id#' list="yes"> )AND
				</cfif>
				<cfif isdefined("arguments.employee_id_list") and len(arguments.employee_id_list)>
					PW.PROJECT_EMP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id_list#" list="yes">) AND
				</cfif>
				<cfif isdefined("arguments.branch_id") and len(arguments.branch_id)>
					PW.PROJECT_EMP_ID IN (	
										SELECT EMPLOYEE_ID 
										FROM EMPLOYEE_POSITIONS,DEPARTMENT
										WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND DEPARTMENT.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
										) AND
				</cfif>
				<cfif isdefined("arguments.department") and len(arguments.department)>
					PW.PROJECT_EMP_ID IN (	
										SELECT EMPLOYEE_ID 
										FROM EMPLOYEE_POSITIONS
										WHERE 
										<cfif listlen(arguments.department,',') gt 1>
											EMPLOYEE_POSITIONS.DEPARTMENT_ID IN (#arguments.department#)
										<cfelse>
											EMPLOYEE_POSITIONS.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department#">
										
										</cfif>
										) AND
				</cfif>
				1 = 1
			<cfif isdefined("arguments.last_month_")>
				GROUP BY
					PW.WORK_ID,
					PW.PROJECT_ID,
					PW.WORK_HEAD,
					PW.TARGET_FINISH,
					PW.TARGET_START,
					PW.UPDATE_DATE,
					PW.RECORD_DATE,
					PW.TERMINATE_DATE,
					EP.EMPLOYEE_ID,
					EP.EMPLOYEE_NAME,
					EP.EMPLOYEE_SURNAME,
					PP.PROJECT_ID,
					PP.PROJECT_HEAD,
					PTR.STAGE,
					PWC.WORK_CAT,
					PW.ESTIMATED_TIME,
					EP3.EMPLOYEE_ID,
					EP3.EMPLOYEE_NAME,
					EP3.EMPLOYEE_SURNAME,
					S.SERVICE_NO,
					SP.PRIORITY,
					SO.AMOUNT,
					SO.PREDICTED_AMOUNT
			</cfif>
			ORDER BY
				NAME_SURNAME,
				TYPE,
				UPDATE_DATE DESC,
				PROJECT_HEAD
		</cfquery>
		<cfreturn get_works>
	</cffunction>
	<cfif isdefined("get_works.recordcount") and len(get_works.recordcount)>
		<cffunction name = "GET_TERMİN_WORK" returnType = "query" hint = "termini geçmiş iş sayısını getir">
			<cfquery name="GET_TERMİN_WORK" dbtype="query">
				SELECT COUNT(WORK_ID) WORK_COUNT FROM GET_WORKS WHERE TERMINATE_DATE <= #now()#
			</cfquery>
			<cfreturn GET_TERMİN_WORK>
		</cffunction>
	</cfif>
	<cfif isdefined("get_works.recordcount") and len(get_works.recordcount)>
		<cffunction name = "CatWorkSummary" returnType = "query" hint = "kategorilere göre işler getir">
			<cfquery name="cat_work_summary" dbtype="query">
				SELECT 
					COUNT(WORK_ID) WORK_COUNT,
					WORK_CAT
				FROM 
					get_works
				GROUP BY
					WORK_CAT		
			</cfquery>
			<cfreturn cat_work_summary>
		</cffunction>
		<cffunction name = "StageWorkSummary" returnType = "query" hint = "aşamalara göre iş getir">
			<cfquery name = "get_stage_work" dbtype="query">
				SELECT 
					COUNT(WORK_ID) WORK_COUNT, 
					STAGE AS STAGE
				FROM 
					get_works
				GROUP BY
					STAGE
			</cfquery>
			<cfreturn get_stage_work>
		</cffunction>
	</cfif>
</cfcomponent>