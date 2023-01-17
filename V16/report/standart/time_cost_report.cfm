<!--- 
	Rapor Tipleri
	1	Calisanlara Gore
	2	Projelere Gore
	3	Masraf Merkezlerine Gore
	4	Cari Hesaplara Gore
	5	Sistemlere Gore
	6	Islere Gore
	7	Servislere Gore
	8	Egitimlere Gore
	9	Aciklamalara Gore
	10	Proje Gruplarina Gore
	11	Proje Gruplarina Gore Onaylanmis
	12	Proje Grubu ve Aciklamalara Gore
	13	Aktivitelere Gore
	14	Departmanlara Gore
	15	Is Kategorilerine Gore
	16	Etkilesim Kategorisine Gore
--->
<cfsetting showdebugoutput="no">
<cf_xml_page_edit fuseact="report.time_cost_report">
<cfparam name="attributes.module_id_control" default="49,1">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.order_type" default="1">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.activity_type" default="">
<cfparam name="attributes.overtime_type" default="">
<cfparam name="attributes.graph_type" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.special_definition" default="">
<cfparam name="attributes.interaction_cat" default="">
<cfparam name="attributes.workgroup_ids" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelseif isdefined("attributes.real_start_date_") and isdate(attributes.real_start_date_)>
	<cfset attributes.start_date = attributes.real_start_date_>
	<cfparam name="attributes.is_submit" default="1">
<cfelse>	
	<cfset attributes.start_date = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))> 
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelseif isdefined("attributes.real_finish_date_") and isdate(attributes.real_finish_date_)>
	<cfset attributes.finish_date = attributes.real_finish_date_>
<cfelse>
	<cfset attributes.finish_date = date_add('d',7,attributes.start_date)> 
</cfif>
<cfset attributes.finish_date = date_add('h',23,attributes.finish_date)>
<cfset attributes.finish_date = date_add('n',59,attributes.finish_date)>
<cfinclude template="/V16/project/query/get_workgroups.cfm">
<cfquery name="GET_OUR_COMPANY" datasource="#DSN#">
	SELECT 
		COMP_ID,
		COMPANY_NAME 
	FROM 
		OUR_COMPANY 
	<cfif not session.ep.ehesap>
		WHERE
			COMP_ID IN (SELECT DISTINCT B.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH B ON B.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
	</cfif>
	ORDER BY COMPANY_NAME
</cfquery>
<cfquery name="GET_ACTIVITY_TYPES" datasource="#DSN#">
	SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY ORDER BY ACTIVITY_NAME
</cfquery>

<cfquery name="GET_SUBSCRIPTION_STAGES" datasource="#DSN#">
	SELECT
  		PTR.STAGE,
		PTR.PROCESS_ROW_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.upd_subscription_contract%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfif not isdefined("attributes.project_head") and isdefined("attributes.project_id") and len(attributes.project_id)>
	<cfquery name="GET_PROJECT_HEAD" datasource="#DSN#">
		SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
	</cfquery>
	<cfset attributes.project_head = get_project_head.project_head>
</cfif>
<cfif isdefined("attributes.is_submit")>
	<cfif isdefined("attributes.report_type") and attributes.report_type eq 9>
		<cfquery name="TIME_COST_" datasource="#DSN#">
			SELECT
				TIME_COST.EMPLOYEE_ID,
				TIME_COST.EVENT_DATE,
				TIME_COST.EXPENSED_MINUTE,
				ISNULL(TIME_COST.EXPENSED_MONEY,0) AS EXPENSED_MONEY,
				TIME_COST.WORK_ID,
				TIME_COST.PROJECT_ID,
				TIME_COST.OVERTIME_TYPE,
				TIME_COST.ACTIVITY_ID,
				TIME_COST.COMMENT
			FROM 
				<cfif isdefined('attributes.is_cus_help') and len(attributes.is_cus_help)>
					CUSTOMER_HELP,
				<cfelseif isDefined("attributes.is_service_relation") and Len(attributes.is_service_relation)>
					#dsn3_alias#.SERVICE,
				</cfif>
				TIME_COST
			WHERE
				1=1
				<cfif isdefined('attributes.is_cus_help') and len(attributes.is_cus_help)>
					AND TIME_COST.CUS_HELP_ID = CUSTOMER_HELP.CUS_HELP_ID
                    <cfif len(attributes.special_definition)>
						AND CUSTOMER_HELP.SPECIAL_DEFINITION_ID IN (#attributes.special_definition#)
                    </cfif>
                    <cfif len(attributes.interaction_cat)>
                    	AND CUSTOMER_HELP.INTERACTION_CAT IN (#attributes.interaction_cat#)
                    </cfif>
				<cfelseif isDefined("attributes.is_service_relation") and Len(attributes.is_service_relation)>
					AND TIME_COST.SERVICE_ID = SERVICE.SERVICE_ID
				</cfif>
				<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company)>
					AND TIME_COST.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				<cfelseif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
					AND TIME_COST.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.employee") and len(attributes.employee)>
					AND TIME_COST.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
				</cfif>
				<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>
					AND TIME_COST.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and isdefined("attributes.subscription_no") and len(attributes.subscription_no)>
					AND TIME_COST.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
				</cfif>
				<cfif isdefined("attributes.work_id") and len(attributes.work_id) and isdefined("attributes.work_head") and len(attributes.work_head)>
					AND TIME_COST.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
				</cfif>
				<cfif isdefined("attributes.expense_id") and len(attributes.expense_id) and isdefined("attributes.expense") and len(attributes.expense)>
					AND TIME_COST.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
				</cfif>
				<cfif isdefined("attributes.crm_id") and len(attributes.crm_id) and isdefined("attributes.crm_head") and len(attributes.crm_head)>
					AND TIME_COST.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.crm_id#">
				</cfif>
				<cfif isdefined("attributes.class_id") and len(attributes.class_id) and isdefined("attributes.class_name") and len(attributes.class_name)>
					AND TIME_COST.CLASS_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
				</cfif>
				<cfif isdefined("attributes.our_company_id") and len(attributes.our_company_id)>
					AND TIME_COST.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
				</cfif>
				<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND TIME_COST.EVENT_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				<cfelseif isdate(attributes.start_date)>
					AND TIME_COST.EVENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
				<cfelseif isdate(attributes.finish_date)>
					AND TIME_COST.EVENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				</cfif>
                <cfif isdefined("attributes.activity_type") and len(attributes.activity_type)>AND ACTIVITY_ID IN (#attributes.activity_type#)</cfif>
				<cfif isdefined("attributes.overtime_type") and len(attributes.overtime_type)>AND OVERTIME_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.overtime_type#"></cfif>
				<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
					AND TIME_COST.EMPLOYEE_ID IN (	
										SELECT 
											EMPLOYEE_ID 
										FROM 
											EMPLOYEE_POSITIONS,DEPARTMENT
										WHERE 
											EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID 
											AND DEPARTMENT.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
										)
				</cfif>

				<cfif isdefined("attributes.department") and len(attributes.department)>
					AND TIME_COST.EMPLOYEE_ID IN (	
										SELECT EMPLOYEE_ID 
										FROM EMPLOYEE_POSITIONS
										WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
										)
				</cfif>
				<cfif not session.ep.ehesap>
					AND 
					(
						TIME_COST.EMPLOYEE_ID IN 
						(
							SELECT 
								EMPLOYEE_ID 
							FROM 
								EMPLOYEE_POSITIONS,DEPARTMENT
							WHERE 
								EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID 
								AND DEPARTMENT.BRANCH_ID IN 
								(
									SELECT
										EPB.BRANCH_ID
									FROM
										EMPLOYEE_POSITION_BRANCHES EPB
										INNER JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = EPB.POSITION_CODE
									WHERE
									EPB.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
								)
						)
					)
				</cfif>
			ORDER BY 
				<cfif isdefined("attributes.order_type") and attributes.order_type eq 1>
					TIME_COST.EXPENSED_MONEY DESC
				<cfelseif isdefined("attributes.order_type") and attributes.order_type eq 2>
					TIME_COST.EXPENSED_MINUTE DESC
				<cfelse>
					TIME_COST.EVENT_DATE DESC
				</cfif>
		</cfquery>
	<cfelseif (isdefined("attributes.report_type") and attributes.report_type eq 10) or (isdefined("attributes.report_type") and attributes.report_type eq 11)>
		<cfquery name="GET_PROJECT_GROUP_TIME" datasource="#DSN#">
			SELECT 
				SUM(EXPENSED_MINUTE) EXPENSED_MINUTE,
				TC.EMPLOYEE_ID, 
                COUNT(TC.EMPLOYEE_ID) TOPLAM,
				WEP.PRODUCT_UNIT_PRICE,
				WEP.PRODUCT_MONEY,
				WG.PROJECT_ID,
				WEP.PRODUCT_ID,
				P.PRODUCT_NAME
			FROM
				<cfif isdefined('attributes.is_cus_help') and len(attributes.is_cus_help)>
					CUSTOMER_HELP CH,
				<cfelseif isDefined("attributes.is_service_relation") and Len(attributes.is_service_relation)>
					#dsn3_alias#.SERVICE S,
				</cfif>			
				TIME_COST TC,
				WORK_GROUP WG,
				WORKGROUP_EMP_PAR WEP,
				#dsn3_alias#.PRODUCT P
			WHERE
				TC.EMPLOYEE_ID = WEP.EMPLOYEE_ID AND
				WG.WORKGROUP_ID = WEP.WORKGROUP_ID AND 
				<cfif isdefined("attributes.workgroup_ids") and len(attributes.workgroup_ids)>
					WG.WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_ids#"> AND
				</cfif>
				TC.PROJECT_ID = WG.PROJECT_ID AND
				P.PRODUCT_ID = WEP.PRODUCT_ID AND
				WEP.EMPLOYEE_ID IS NOT NULL
				<cfif isdefined('attributes.is_cus_help') and len(attributes.is_cus_help)>
					AND TC.CUS_HELP_ID = CH.CUS_HELP_ID
                    <cfif len(attributes.special_definition)>
						AND CH.SPECIAL_DEFINITION_ID IN (#attributes.special_definition#)
                    </cfif>
                    <cfif len(attributes.interaction_cat)>
                    	AND CH.INTERACTION_CAT IN (#attributes.interaction_cat#)
                    </cfif>
				<cfelseif isDefined("attributes.is_service_relation") and Len(attributes.is_service_relation)>
					AND TC.SERVICE_ID = S.SERVICE_ID
				</cfif>
				<cfif attributes.report_type eq 11>
					AND TC.IS_VALID = 1 
				</cfif>
				<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company)>
					AND TC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				<cfelseif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
					AND TC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.employee") and len(attributes.employee)>
					AND TC.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> 
				</cfif>
				<cfif isdefined("attributes.project_id") and len(attributes.project_id)  and isdefined("attributes.project_head") and len(attributes.project_head)>
					AND TC.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and isdefined("attributes.subscription_no") and len(attributes.subscription_no)>
					AND TC.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
				</cfif>
				<cfif isdefined("attributes.work_id") and len(attributes.work_id) and isdefined("attributes.work_head") and len(attributes.work_head)>
					AND TC.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
				</cfif>
				<cfif isdefined("attributes.expense_id") and len(attributes.expense_id) and isdefined("attributes.expense") and len(attributes.expense)>
					AND TC.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
				</cfif>
				<cfif isdefined("attributes.crm_id") and len(attributes.crm_id) and isdefined("attributes.crm_head") and len(attributes.crm_head)>
					AND TC.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.crm_id#">
				</cfif>
				<cfif isdefined("attributes.class_id") and len(attributes.class_id) and isdefined("attributes.class_name") and len(attributes.class_name)>
					AND TC.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
				</cfif>
				<cfif isdefined("attributes.our_company_id") and len(attributes.our_company_id)>
					AND TC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
				</cfif>
				<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND TC.EVENT_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				<cfelseif isdate(attributes.start_date)>
					AND TC.EVENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
				<cfelseif isdate(attributes.finish_date)>
					AND TC.EVENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				</cfif>
                <cfif isdefined("attributes.activity_type") and len(attributes.activity_type)>AND ACTIVITY_ID IN (#attributes.activity_type#)</cfif>
				<cfif isdefined("attributes.overtime_type") and len(attributes.overtime_type)>AND OVERTIME_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.overtime_type#"></cfif>
				<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
					AND TC.EMPLOYEE_ID IN (	
										SELECT EMPLOYEE_ID 
										FROM EMPLOYEE_POSITIONS,DEPARTMENT
										WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND DEPARTMENT.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
										)
				</cfif>
				<cfif isdefined("attributes.department") and len(attributes.department)>
					AND TC.EMPLOYEE_ID IN (	
										SELECT EMPLOYEE_ID 
										FROM EMPLOYEE_POSITIONS
										WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
										)
				</cfif>
				<cfif not session.ep.ehesap>
					AND 
					(
						TC.EMPLOYEE_ID IN 
						(
							SELECT 
								EMPLOYEE_ID 
							FROM 
								EMPLOYEE_POSITIONS,DEPARTMENT
							WHERE 
								EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID 
								AND DEPARTMENT.BRANCH_ID IN 
								(
									SELECT
										EPB.BRANCH_ID
									FROM
										EMPLOYEE_POSITION_BRANCHES EPB
										INNER JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = EPB.POSITION_CODE
									WHERE
									EPB.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
								)
						)
					)
				</cfif>
			GROUP BY
				WG.PROJECT_ID,
				TC.EMPLOYEE_ID,
				WEP.PRODUCT_UNIT_PRICE,
				WEP.PRODUCT_MONEY,
				WEP.PRODUCT_ID,
				P.PRODUCT_NAME
		</cfquery>
	<cfelseif isdefined("attributes.report_type") and attributes.report_type eq 12>
		
		<cfquery name="GET_PROJECT_GROUP_TIME" datasource="#DSN#">
			SELECT 
				SUM(EXPENSED_MINUTE) EXPENSED_MINUTE,
				TC.EMPLOYEE_ID, 
				COUNT(TC.EMPLOYEE_ID) TOPLAM,
				WEP.PRODUCT_UNIT_PRICE,
				WEP.PRODUCT_MONEY,
				WG.PROJECT_ID,
				WEP.PRODUCT_ID,
				P.PRODUCT_NAME
			FROM 
				<cfif isdefined('attributes.is_cus_help') and len(attributes.is_cus_help)>
					CUSTOMER_HELP CH,
				<cfelseif isDefined("attributes.is_service_relation") and Len(attributes.is_service_relation)>
					#dsn3_alias#.SERVICE S,
				</cfif>
				TIME_COST TC,
				WORK_GROUP WG,
				WORKGROUP_EMP_PAR WEP,
				#dsn3_alias#.PRODUCT P
			WHERE
				TC.EMPLOYEE_ID = WEP.EMPLOYEE_ID AND
				WG.WORKGROUP_ID = WEP.WORKGROUP_ID AND 
				<cfif isdefined("attributes.workgroup_ids") and len(attributes.workgroup_ids)>
					WG.WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_ids#"> AND
				</cfif>
				TC.PROJECT_ID = WG.PROJECT_ID AND
				P.PRODUCT_ID = WEP.PRODUCT_ID AND
				WEP.EMPLOYEE_ID IS NOT NULL
				<cfif isdefined('attributes.is_cus_help') and len(attributes.is_cus_help)>
					AND TC.CUS_HELP_ID = CH.CUS_HELP_ID
                    <cfif len(attributes.special_definition)>
						AND CH.SPECIAL_DEFINITION_ID IN (#attributes.special_definition#)
                    </cfif>
                    <cfif len(attributes.interaction_cat)>
                    	AND CH.INTERACTION_CAT IN (#attributes.interaction_cat#)
                    </cfif>
				<cfelseif isDefined("attributes.is_service_relation") and Len(attributes.is_service_relation)>
					AND TC.SERVICE_ID = S.SERVICE_ID
				</cfif>
				<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company)>
					AND TC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				<cfelseif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
					AND TC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.employee") and len(attributes.employee)>
					AND TC.EMPLOYEE_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
				</cfif>
				<cfif isdefined("attributes.project_id") and len(attributes.project_id)  and isdefined("attributes.project_head") and len(attributes.project_head)>
					AND TC.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and isdefined("attributes.subscription_no") and len(attributes.subscription_no)>
					AND TC.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
				</cfif>
				<cfif isdefined("attributes.work_id") and len(attributes.work_id) and isdefined("attributes.work_head") and len(attributes.work_head)>
					AND TC.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
				</cfif>
				<cfif isdefined("attributes.expense_id") and len(attributes.expense_id) and isdefined("attributes.expense") and len(attributes.expense)>
					AND TC.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
				</cfif>
				<cfif isdefined("attributes.crm_id") and len(attributes.crm_id) and isdefined("attributes.crm_head") and len(attributes.crm_head)>
					AND TC.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.crm_id#">
				</cfif>
				<cfif isdefined("attributes.class_id") and len(attributes.class_id) and isdefined("attributes.class_name") and len(attributes.class_name)>
					AND TC.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
				</cfif>
				<cfif isdefined("attributes.our_company_id") and len(attributes.our_company_id)>
					AND TC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
				</cfif>
				<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND TC.EVENT_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> 
				<cfelseif isdate(attributes.start_date)>
					AND TC.EVENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
				<cfelseif isdate(attributes.finish_date)>
					AND TC.EVENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				</cfif>
                <cfif isdefined("attributes.activity_type") and len(attributes.activity_type)>AND ACTIVITY_ID IN (#attributes.activity_type#)</cfif>
				<cfif isdefined("attributes.overtime_type") and len(attributes.overtime_type)>AND OVERTIME_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.overtime_type#"></cfif>
				<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
					AND TC.EMPLOYEE_ID IN (	
										SELECT EMPLOYEE_ID 
										FROM EMPLOYEE_POSITIONS,DEPARTMENT
										WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND DEPARTMENT.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
										)
				</cfif>
				<cfif isdefined("attributes.department") and len(attributes.department)>
					AND TC.EMPLOYEE_ID IN (	
										SELECT EMPLOYEE_ID 
										FROM EMPLOYEE_POSITIONS
										WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
										)
				</cfif>
				<cfif not session.ep.ehesap>
					AND 
					(
						TC.EMPLOYEE_ID IN 
						(
							SELECT 
								EMPLOYEE_ID 
							FROM 
								EMPLOYEE_POSITIONS,DEPARTMENT
							WHERE 
								EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID 
								AND DEPARTMENT.BRANCH_ID IN 
								(
									SELECT
										EPB.BRANCH_ID
									FROM
										EMPLOYEE_POSITION_BRANCHES EPB
										INNER JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = EPB.POSITION_CODE
									WHERE
									EPB.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
								)
						)
					)
				</cfif>
			GROUP BY
				WG.PROJECT_ID,
				TC.EMPLOYEE_ID,
				WEP.PRODUCT_UNIT_PRICE,
				WEP.PRODUCT_MONEY,
				WEP.PRODUCT_ID,
				P.PRODUCT_NAME
		</cfquery>
		<cfif GET_PROJECT_GROUP_TIME.recordcount>
			<cfset get_all_emp_id = valueList(GET_PROJECT_GROUP_TIME.employee_id)>

			<cfquery name="TIME_COST_" datasource="#DSN#">
				SELECT
					EMPLOYEE_ID,
					EVENT_DATE,
					EXPENSED_MINUTE,
					COMMENT
				FROM 
					<cfif isdefined('attributes.is_cus_help') and len(attributes.is_cus_help)>
						CUSTOMER_HELP,
					<cfelseif isDefined("attributes.is_service_relation") and Len(attributes.is_service_relation)>
						#dsn3_alias#.SERVICE,
					</cfif>
					TIME_COST
				WHERE
					1=1
					<cfif isdefined('attributes.is_cus_help') and len(attributes.is_cus_help)>
						AND TIME_COST.CUS_HELP_ID = CUSTOMER_HELP.CUS_HELP_ID
						<cfif len(attributes.special_definition)>
							AND CUSTOMER_HELP.SPECIAL_DEFINITION_ID IN (#attributes.special_definition#)
						</cfif>
						<cfif len(attributes.interaction_cat)>
							AND CUSTOMER_HELP.INTERACTION_CAT IN (#attributes.interaction_cat#)
						</cfif>
					<cfelseif isDefined("attributes.is_service_relation") and Len(attributes.is_service_relation)>
						AND TIME_COST.SERVICE_ID = SERVICE.SERVICE_ID
					</cfif>
					<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company)>
						AND TIME_COST.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
					<cfelseif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
						AND TIME_COST.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
					</cfif>
					<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.employee") and len(attributes.employee)>
						AND TIME_COST.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
					</cfif>
					<cfif isdefined("attributes.project_id") and len(attributes.project_id)  and isdefined("attributes.project_head") and len(attributes.project_head)>
						AND TIME_COST.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
					</cfif>
					<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and isdefined("attributes.subscription_no") and len(attributes.subscription_no)>
						AND TIME_COST.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
					</cfif>
					<cfif isdefined("attributes.work_id") and len(attributes.work_id) and isdefined("attributes.work_head") and len(attributes.work_head)>
						AND TIME_COST.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
					</cfif>
					<cfif isdefined("attributes.expense_id") and len(attributes.expense_id) and isdefined("attributes.expense") and len(attributes.expense)>
						AND TIME_COST.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
					</cfif>
					<cfif isdefined("attributes.crm_id") and len(attributes.crm_id) and isdefined("attributes.crm_head") and len(attributes.crm_head)>
						AND TIME_COST.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.crm_id#">
					</cfif>
					<cfif isdefined("attributes.class_id") and len(attributes.class_id) and isdefined("attributes.class_name") and len(attributes.class_name)>
						AND TIME_COST.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
					</cfif>
					<cfif isdefined("attributes.our_company_id") and len(attributes.our_company_id)>
						AND TIME_COST.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
					</cfif>
					<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
						AND TIME_COST.EVENT_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
					<cfelseif isdate(attributes.start_date)>
						AND TIME_COST.EVENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
					<cfelseif isdate(attributes.finish_date)>
						AND TIME_COST.EVENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
					</cfif>
					<cfif isdefined("attributes.activity_type") and len(attributes.activity_type)>AND ACTIVITY_ID IN (#attributes.activity_type#)</cfif>
					<cfif isdefined("attributes.overtime_type") and len(attributes.overtime_type)>AND OVERTIME_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.overtime_type#"></cfif>
					<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
						AND TIME_COST.EMPLOYEE_ID IN 	(	
														SELECT EMPLOYEE_ID 
														FROM EMPLOYEE_POSITIONS,DEPARTMENT
														WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND DEPARTMENT.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
														)
					</cfif>
					<cfif isdefined("attributes.department") and len(attributes.department)>
						AND TIME_COST.EMPLOYEE_ID IN 	(	
														SELECT EMPLOYEE_ID 
														FROM EMPLOYEE_POSITIONS
														WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
														)
					</cfif>
					<cfif not session.ep.ehesap>
						AND 
						(
							TIME_COST.EMPLOYEE_ID IN 
							(
								SELECT 
									EMPLOYEE_ID 
								FROM 
									EMPLOYEE_POSITIONS,DEPARTMENT
								WHERE 
									EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID 
									AND DEPARTMENT.BRANCH_ID IN 
									(
										SELECT
											EPB.BRANCH_ID
										FROM
											EMPLOYEE_POSITION_BRANCHES EPB
											INNER JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = EPB.POSITION_CODE
										WHERE
										EPB.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
									)
							)
						)
					</cfif>
					<cfif isdefined("attributes.workgroup_ids") and len(attributes.workgroup_ids) and len(get_all_emp_id)>
						AND EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_emp_id#" list="yes">)
					</cfif>
				ORDER BY 
					<cfif isdefined("attributes.order_type") and attributes.order_type eq 1>
						TIME_COST.EXPENSED_MONEY DESC
					<cfelseif isdefined("attributes.order_type") and attributes.order_type eq 2>
						TIME_COST.EXPENSED_MINUTE DESC
					<cfelse>
						1
					</cfif>
			</cfquery>
		<cfelse>
			<cfset TIME_COST_.recordcount = 0>
		</cfif>
	<cfelseif isdefined("attributes.report_type") and attributes.report_type eq 16>
		<cfquery name="TIME_COST_" datasource="#DSN#">
			SELECT
				SUM(TC.EXPENSED_MINUTE) EXPENSED_MINUTE,
				SUM(ISNULL(TC.EXPENSED_MONEY,0)) EXPENSED_MONEY,
				CH.INTERACTION_CAT,
				COUNT(ISNULL(CH.INTERACTION_CAT,0)) TOPLAM
			FROM
				<cfif isDefined("attributes.is_service_relation") and Len(attributes.is_service_relation)>
					#dsn3_alias#.SERVICE S,
				</cfif>
				TIME_COST TC,
				CUSTOMER_HELP CH
			WHERE
				
				TC.CUS_HELP_ID = CH.CUS_HELP_ID
				<cfif isDefined("attributes.is_service_relation") and Len(attributes.is_service_relation)>
					AND TC.SERVICE_ID = S.SERVICE_ID
				</cfif>
				<cfif len(attributes.special_definition)>
					AND CH.SPECIAL_DEFINITION_ID IN (#attributes.special_definition#)
				</cfif>
				<cfif len(attributes.interaction_cat)>
					AND CH.INTERACTION_CAT IN (#attributes.interaction_cat#)
				</cfif>
				<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company)>
					AND TC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				<cfelseif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
					AND TC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.employee") and len(attributes.employee)>
					AND TC.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> 
				</cfif>
				<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>
					AND TC.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and isdefined("attributes.subscription_no") and len(attributes.subscription_no)>
					AND TC.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
				</cfif>
				<cfif isdefined("attributes.work_id") and len(attributes.work_id) and isdefined("attributes.work_head") and len(attributes.work_head)>
					AND TC.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
				</cfif>
				<cfif isdefined("attributes.expense_id") and len(attributes.expense_id) and isdefined("attributes.expense") and len(attributes.expense)>
					AND TC.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
				</cfif>
				<cfif isdefined("attributes.crm_id") and len(attributes.crm_id) and isdefined("attributes.crm_head") and len(attributes.crm_head)>
					AND TC.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.crm_id#">
				</cfif>
				<cfif isdefined("attributes.class_id") and len(attributes.class_id) and isdefined("attributes.class_name") and len(attributes.class_name)>
					AND TC.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
				</cfif>
				<cfif isdefined("attributes.our_company_id") and len(attributes.our_company_id)>
					AND TC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
				</cfif>
				<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND TC.EVENT_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				<cfelseif isdate(attributes.start_date)>
					AND TC.EVENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
				<cfelseif isdate(attributes.finish_date)>
					AND TC.EVENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				</cfif>
                <cfif isdefined("attributes.activity_type") and len(attributes.activity_type)>AND ACTIVITY_ID IN (#attributes.activity_type#)</cfif>
				<cfif isdefined("attributes.overtime_type") and len(attributes.overtime_type)>AND OVERTIME_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.overtime_type#"></cfif>
				<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
					AND TC.EMPLOYEE_ID IN (	
										SELECT EMPLOYEE_ID 
										FROM EMPLOYEE_POSITIONS,DEPARTMENT
										WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND DEPARTMENT.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
										)
				</cfif>
				<cfif isdefined("attributes.department") and len(attributes.department)>
					AND TC.EMPLOYEE_ID IN (	
										SELECT EMPLOYEE_ID 
										FROM EMPLOYEE_POSITIONS
										WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
										)
				</cfif>
				<cfif not session.ep.ehesap>
					AND 
					(
						TC.EMPLOYEE_ID IN 
						(
							SELECT 
								EMPLOYEE_ID 
							FROM 
								EMPLOYEE_POSITIONS,DEPARTMENT
							WHERE 
								EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID 
								AND DEPARTMENT.BRANCH_ID IN 
								(
									SELECT
										EPB.BRANCH_ID
									FROM
										EMPLOYEE_POSITION_BRANCHES EPB
										INNER JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = EPB.POSITION_CODE
									WHERE
									EPB.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
								)
						)
					)
				</cfif>
			GROUP BY
				CH.INTERACTION_CAT
		</cfquery>
	<cfelse>
		<cfquery name="GET_TIME_COST" datasource="#dsn#">
			SELECT
			<cfif attributes.report_type eq 1 and isdefined('attributes.is_graph_show')><!--- Grafik Göster Denilmiş ise --->
				ISNULL(TC.EMPLOYEE_ID,0) EMPLOYEE_ID,
				CONVERT (nvarchar(10) , TC.EVENT_DATE,105) EVENT_DATE,
				SUM(TC.EXPENSED_MINUTE) EXPENSED_MINUTE,
				SUM(ISNULL(TC.EXPENSED_MONEY,0)) EXPENSED_MONEY
			<cfelse>
				SUM(TC.EXPENSED_MINUTE) EXPENSED_MINUTE,
				SUM(ISNULL(TC.EXPENSED_MONEY,0)) EXPENSED_MONEY
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 1>
					,TC.EMPLOYEE_ID, COUNT(TC.EMPLOYEE_ID) TOPLAM
				</cfif>
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 2>
					,TC.PROJECT_ID, COUNT(TC.PROJECT_ID) TOPLAM
				</cfif>
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 3>
					,TC.EXPENSE_ID, COUNT(TC.EXPENSE_ID) TOPLAM
				</cfif>
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 4>
					,TC.CONSUMER_ID, COUNT(TC.CONSUMER_ID) TOPLAM, TC.COMPANY_ID, COUNT(TC.COMPANY_ID) TOPLAM2
				</cfif>
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 5>
					,TC.SUBSCRIPTION_ID, COUNT(TC.SUBSCRIPTION_ID) TOPLAM
				</cfif>
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 6>
					,TC.WORK_ID, COUNT(TC.WORK_ID) TOPLAM
				</cfif>
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 15>
					,PW.WORK_CAT_ID, COUNT(PW.WORK_CAT_ID) TOPLAM
				</cfif>
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 7>
					,TC.SERVICE_ID, COUNT(TC.SERVICE_ID) TOPLAM
				</cfif>
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 8>
					,TC.CLASS_ID, COUNT(TC.CLASS_ID) TOPLAM
				</cfif>
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 13>
					,TC.ACTIVITY_ID, COUNT(TC.ACTIVITY_ID) TOPLAM
				</cfif>
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 14>
					,EP.DEPARTMENT_ID, COUNT(EP.DEPARTMENT_ID) TOPLAM
				</cfif>
			</cfif>    
			FROM 
				<cfif isdefined('attributes.is_cus_help') and len(attributes.is_cus_help)>
					CUSTOMER_HELP CH,
				<cfelseif isDefined("attributes.is_service_relation") and Len(attributes.is_service_relation)>
					#dsn3_alias#.SERVICE S,
				</cfif>
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 14>
					EMPLOYEE_POSITIONS EP,	
				</cfif>
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 15>
					PRO_WORKS PW,
				</cfif> 
				TIME_COST TC
			WHERE
				1=1 
				<cfif not session.ep.ehesap>
					AND 
					(
							TC.EMPLOYEE_ID IN 
						(
							SELECT 
								EMPLOYEE_ID 
							FROM 
								EMPLOYEE_POSITIONS,DEPARTMENT
							WHERE 
								EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID 
								AND DEPARTMENT.BRANCH_ID IN 
								(
									SELECT
										EPB.BRANCH_ID
									FROM
										EMPLOYEE_POSITION_BRANCHES EPB
										INNER JOIN EMPLOYEE_POSITIONS EP ON EP.POSITION_CODE = EPB.POSITION_CODE
									WHERE
									EPB.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
								)
						)
					)
				</cfif>
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 15>
					AND PW.WORK_ID = TC.WORK_ID
				</cfif>
				<cfif isdefined('attributes.is_cus_help') and len(attributes.is_cus_help)>
					AND TC.CUS_HELP_ID = CH.CUS_HELP_ID
                    <cfif len(attributes.special_definition)>
						AND CH.SPECIAL_DEFINITION_ID IN (#attributes.special_definition#)
                    </cfif>
                    <cfif len(attributes.interaction_cat)>
                    	AND CH.INTERACTION_CAT IN (#attributes.interaction_cat#)
                    </cfif>
				<cfelseif isDefined("attributes.is_service_relation") and Len(attributes.is_service_relation)>
					AND TC.SERVICE_ID = S.SERVICE_ID
				</cfif>
				<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company)>
					AND TC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				<cfelseif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
					AND TC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 14>
					AND TC.EMPLOYEE_ID = EP.EMPLOYEE_ID
					AND EP.IS_MASTER = 1
				</cfif>
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 4>
					AND (TC.CONSUMER_ID IS NOT NULL OR TC.COMPANY_ID IS NOT NULL)
				</cfif>
				<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.employee") and len(attributes.employee)>
					AND TC.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> 
				</cfif>
				<cfif isdefined("attributes.project_id") and len(attributes.project_id)  and isdefined("attributes.project_head") and len(attributes.project_head)>
					AND TC.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 2>
					AND TC.PROJECT_ID IS NOT NULL
				</cfif>
				<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and isdefined("attributes.subscription_no") and len(attributes.subscription_no)>
					AND TC.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
				</cfif>
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 5>
					AND TC.SUBSCRIPTION_ID IS NOT NULL
				</cfif>
				<cfif isdefined("attributes.work_id") and len(attributes.work_id) and isdefined("attributes.work_head") and len(attributes.work_head)>
					AND TC.WORK_ID IS NOT NULL
					AND TC.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
				</cfif>
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 6>
					AND TC.WORK_ID IS NOT NULL
				</cfif>
				<cfif isdefined("attributes.expense_id") and len(attributes.expense_id) and isdefined("attributes.expense") and len(attributes.expense)>
					AND TC.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_id#">
				</cfif>
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 3>
					AND TC.EXPENSE_ID IS NOT NULL
				</cfif>		
				<cfif isdefined("attributes.crm_id") and len(attributes.crm_id) and isdefined("attributes.crm_head") and len(attributes.crm_head)>
					AND TC.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.crm_id#">
				</cfif>
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 7>
					AND TC.SERVICE_ID IS NOT NULL
				</cfif>
				<cfif isdefined("attributes.class_id") and len(attributes.class_id) and isdefined("attributes.class_name") and len(attributes.class_name)>
					AND TC.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
				</cfif>
				<cfif isdefined("attributes.report_type") and attributes.report_type eq 8>
					AND TC.CLASS_ID IS NOT NULL
				</cfif>
				<cfif isdefined("attributes.our_company_id") and len(attributes.our_company_id)>
					AND TC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
				</cfif>
				<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND TC.EVENT_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				<cfelseif isdate(attributes.start_date)>
					AND TC.EVENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
				<cfelseif isdate(attributes.finish_date)>
					AND TC.EVENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				</cfif>
				<cfif isdefined("attributes.activity_type") and len(attributes.activity_type)>AND TC.ACTIVITY_ID IN(#attributes.activity_type#)</cfif>
				<cfif isdefined("attributes.overtime_type") and len(attributes.overtime_type)>AND OVERTIME_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.overtime_type#"></cfif>
				<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
					AND TC.EMPLOYEE_ID IN (	
										SELECT EMPLOYEE_ID 
										FROM EMPLOYEE_POSITIONS,DEPARTMENT
										WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND DEPARTMENT.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
										)
				</cfif>
				<cfif isdefined("attributes.department") and len(attributes.department)>
					AND TC.EMPLOYEE_ID IN (	
										SELECT EMPLOYEE_ID 
										FROM EMPLOYEE_POSITIONS
										WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
										)
				</cfif>
			<cfif attributes.report_type eq 1 and isdefined('attributes.is_graph_show')><!--- Grafik Göster Denilmiş ise --->
				GROUP BY 
					TC.EMPLOYEE_ID,
					CONVERT (nvarchar(10), TC.EVENT_DATE,105)
				ORDER BY
					TC.EMPLOYEE_ID
			<cfelse>
				GROUP BY
					<cfif isdefined("attributes.report_type") and attributes.report_type eq 1>
						TC.EMPLOYEE_ID
					</cfif>
					<cfif isdefined("attributes.report_type") and attributes.report_type eq 2>
						TC.PROJECT_ID
					</cfif>
					<cfif isdefined("attributes.report_type") and attributes.report_type eq 3>
						TC.EXPENSE_ID
					</cfif>
					<cfif isdefined("attributes.report_type") and attributes.report_type eq 4>
						TC.CONSUMER_ID, TC.COMPANY_ID
					</cfif>
					<cfif isdefined("attributes.report_type") and attributes.report_type eq 5>
						TC.SUBSCRIPTION_ID
					</cfif>
					<cfif isdefined("attributes.report_type") and attributes.report_type eq 6>
						TC.WORK_ID
					</cfif>
					<cfif isdefined("attributes.report_type") and attributes.report_type eq 15>
						PW.WORK_CAT_ID
					</cfif>
					<cfif isdefined("attributes.report_type") and attributes.report_type eq 7>
						TC.SERVICE_ID
					</cfif>
					<cfif isdefined("attributes.report_type") and attributes.report_type eq 8>
						TC.CLASS_ID
					</cfif>
					<cfif isdefined("attributes.report_type") and attributes.report_type eq 13>
						TC.ACTIVITY_ID
					</cfif>
					<cfif isdefined("attributes.report_type") and attributes.report_type eq 14>
						EP.DEPARTMENT_ID
					</cfif>
				ORDER BY 
					<cfif isdefined("attributes.order_type") and attributes.order_type eq 1>
						EXPENSED_MONEY DESC
					<cfelseif isdefined("attributes.order_type") and attributes.order_type eq 2>
						EXPENSED_MINUTE DESC
					<cfelseif attributes.report_type neq 4>
						TOPLAM DESC
					<cfelse>
						<cfif  isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
							TC.CONSUMER_ID DESC
						<cfelse>
							TC.COMPANY_ID DESC
						</cfif>
					</cfif>
			</cfif>
		</cfquery>
	</cfif>
<cfelse>
	<cfif attributes.report_type eq 9>
		<cfset time_cost_.recordcount = 0>
	<cfelseif attributes.report_type eq 10>
		<cfset get_project_group_time.recordcount = 0>
	<cfelseif attributes.report_type eq 12>
		<cfset get_project_group_time.recordcount = 0>
		<cfset time_cost_.recordcount = 0>
	<cfelseif attributes.report_type eq 16>
		<cfset time_cost_.recordcount = 0>
	<cfelse>
		<cfset get_time_cost.recordcount = 0>
	</cfif>
</cfif>
<cfquery name="GET_BRANCHES" datasource="#DSN#">
	SELECT
		BRANCH.BRANCH_STATUS,
		BRANCH.HIERARCHY,
		BRANCH.HIERARCHY2,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		OUR_COMPANY.COMP_ID,
		OUR_COMPANY.COMPANY_NAME,
		OUR_COMPANY.NICK_NAME
	FROM
		BRANCH,
		OUR_COMPANY
	WHERE
		BRANCH.BRANCH_ID IS NOT NULL
		AND BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
		AND BRANCH.BRANCH_STATUS = 1
		<cfif session.ep.ehesap neq 1>
			AND BRANCH.BRANCH_ID IN (
				SELECT
					BRANCH_ID
				FROM
					EMPLOYEE_POSITION_BRANCHES
				WHERE
					POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
			)
		</cfif>
	ORDER BY
		OUR_COMPANY.NICK_NAME,
		BRANCH.BRANCH_NAME
</cfquery>
<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#"><!--- 5: Etkilesim Kategorisindeki Ozel Tanimlar --->
    SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 5 ORDER BY SPECIAL_DEFINITION
</cfquery>
<cfquery name="GET_INTERACTION_CAT" datasource="#DSN#">
    SELECT INTERACTIONCAT_ID,INTERACTIONCAT FROM SETUP_INTERACTION_CAT ORDER BY INTERACTIONCAT
</cfquery>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.page" default="1">
<cfif attributes.report_type eq 9>
	<cfparam name="attributes.totalrecords" default = "#time_cost_.recordcount#">
<cfelseif (attributes.report_type eq 10) or (attributes.report_type eq 11)>
	<cfparam name="attributes.totalrecords" default = "#get_project_group_time.recordcount#">
<cfelseif attributes.report_type eq 12>
	<cfparam name="attributes.totalrecords" default = "#time_cost_.recordcount#">
<cfelseif attributes.report_type eq 16>
	<cfparam name="attributes.totalrecords" default = "#time_cost_.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default = "#get_time_cost.recordcount#">
</cfif>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset attributes.startrow=1>
    <cfset attributes.maxrows = attributes.totalrecords>
</cfif>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfform name="time_cost" method="post" action="#request.self#?fuseaction=report.time_cost_report">
<cf_report_list_search title="#getLang('report',712)#">
	<cf_report_list_search_area>		
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='164.Çalışan'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id")><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
												<input type="text" name="employee" id="employee" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','150');" value="<cfif isdefined("attributes.employee")><cfoutput>#attributes.employee#</cfoutput></cfif>"  autocomplete="off">	
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=time_cost.employee_id&field_name=time_cost.employee&select_list=1','list');"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12col-xs-12"><cf_get_lang_main no='107.Cari Hesap'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
												<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
												<input type="text" name="company" id="company" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','250');"  value="<cfif isdefined("attributes.company")><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_name=time_cost.company&field_comp_id=time_cost.company_id&field_consumer=time_cost.consumer_id&field_member_name=time_cost.company','list')"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
													<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id")><cfoutput>#attributes.project_id#</cfoutput></cfif>">
													<input type="text" name="project_head" id="project_head"  onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','time_cost','3','250');" value="<!---<cfif len(attributes.project_id) and len(get_project_head.project_head)>#get_project_head.project_head#</cfif>---><cfif isdefined('attributes.project_head')><cfoutput>#attributes.project_head#</cfoutput></cfif>" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_head=time_cost.project_head&project_id=time_cost.project_id');"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1048.Masraf Merkezi'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="expense_id" id="expense_id" value="<cfif isdefined("attributes.expense_id")><cfoutput>#attributes.expense_id#</cfoutput></cfif>">
												<input type="text" name="expense" id="expense" onfocus="AutoComplete_Create('expense','EXPENSE','EXPENSE','get_expense_center','','EXPENSE_ID','expense_id','time_cost','3','250');" value="<cfif isdefined("attributes.expense")><cfoutput>#attributes.expense#</cfoutput></cfif>" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id=time_cost.expense_id&field_name=time_cost.expense&is_invoice=1','list');"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1420.Abone'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="subscription_id" id="subscription_id" value="<cfif isdefined("attributes.subscription_id")><cfoutput>#attributes.subscription_id#</cfoutput></cfif>">
												<input type="text" name="subscription_no" id="subscription_no" onfocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','200');" value="<cfif isdefined("attributes.subscription_no")><cfoutput>#attributes.subscription_no#</cfoutput></cfif>" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_subscription&field_id=time_cost.subscription_id&field_no=time_cost.subscription_no','list','popup_list_subscription');"></span>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='244.Servis'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="crm_id" id="crm_id" value="<cfif isdefined("attributes.crm_id")><cfoutput>#attributes.crm_id#</cfoutput></cfif>">
												<input type="text" name="crm_head" id="crm_head" value="<cfif isdefined("attributes.crm_head")><cfoutput>#attributes.crm_head#</cfoutput></cfif>">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_add_crm&field_id=time_cost.crm_id&field_name=time_cost.crm_head','list')"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='244.Servis'><cf_get_lang_main no='1033.İş'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="work_id" id="work_id" value="<cfif isdefined("attributes.work_id")><cfoutput>#attributes.work_id#</cfoutput></cfif>">
												<input type="hidden" name="comp_id" id="comp_id" value="">
												<input type="text" name="work_head" id="work_head" value="<cfif isdefined("attributes.work_head")><cfoutput>#attributes.work_head#</cfoutput></cfif>"onfocus="AutoComplete_Create('work_head','WORK_HEAD','WORK_HEAD','get_work','','WORK_ID','work_id','','3','110')">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=time_cost.work_id&field_name=time_cost.work_head&comp_id=time_cost.comp_id','list')"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='7.Eğitim'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="class_id" id="class_id" value="<cfif isdefined("attributes.class_id")><cfoutput>#attributes.class_id#</cfoutput></cfif>">
												<input type="text" name="class_name" id="class_name" value="<cfif isdefined("attributes.class_name")><cfoutput>#attributes.class_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('class_name','CLASS_NAME','CLASS_NAME','get_training_class','','CLASS_ID','class_id','','3','200');">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_list_training_classes&field_id=time_cost.class_id&field_name=time_cost.class_name','list');"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='162.Şirket'></label>
										<div class="col col-12 col-xs-12">
											<select name="our_company_id" id="our_company_id">
											<cfoutput>
												<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<cfloop query="get_our_company">
													<option value="#comp_id#"<cfif isdefined("attributes.our_company_id") and attributes.our_company_id eq comp_id>selected</cfif>><cfoutput>#company_name#</cfoutput></option> 
												</cfloop>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no ='41.Şube'></label>
										<div class="col col-12 col-xs-12">
											<select name="branch_id" id="branch_id" onchange="showDepartment(this.value)">
												<option value=""><cf_get_lang_main no="322.Seçiniz"></option>
												<cfoutput query="get_branches" group="NICK_NAME">
													<optgroup label="#NICK_NAME#"></optgroup>
													<cfoutput>
														<option value="#BRANCH_ID#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq branch_id)> selected</cfif>>&nbsp;&nbsp;&nbsp;#BRANCH_NAME#</option>
													</cfoutput>
												</cfoutput>
											</select>
										</div>
									</div>
								</div>							
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1512.Sıralama'></label>
										<div class="col col-12 col-xs-12">
											<select name="order_type" id="order_type">
												<cfif get_module_user(48)>
													<option value="1" <cfif isdefined("attributes.order_type") and attributes.order_type eq 1>selected</cfif>><cf_get_lang no ='1326.Maliyete Göre'></option>
												</cfif>
												<option value="2" <cfif isdefined("attributes.order_type") and attributes.order_type eq 2>selected</cfif>><cf_get_lang no ='1327.Süreye Göre'></option>
												<option value="3" <cfif isdefined("attributes.order_type") and attributes.order_type eq 3>selected</cfif>><cf_get_lang no ='1328.Kayıt Sayısına Göre'></option>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1131.Mesai Türü'></label>
										<div class="col col-12 col-xs-12">
											<select name="overtime_type" id="overtime_type">
												<option value=""><cf_get_lang_main no="322.Seçiniz"></option>
												<option value="1" <cfif Len(attributes.overtime_type) and attributes.overtime_type eq 1>selected</cfif>><cf_get_lang_main no='2696.Normal'></option>
												<option value="2" <cfif Len(attributes.overtime_type) and attributes.overtime_type eq 2>selected</cfif>><cf_get_lang_main no='2697.Fazla Mesai'></option>
												<option value="3" <cfif Len(attributes.overtime_type) and attributes.overtime_type eq 3>selected</cfif>><cf_get_lang no='1427.Hafta Sonu'></option>
												<option value="4" <cfif Len(attributes.overtime_type) and attributes.overtime_type eq 4>selected</cfif>><cf_get_lang no='1429.Resmi Tatil'></option>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='160.Departman'></label>
										<div class="col col-12 col-xs-12" id="DEPARTMENT_PLACE">											
											<select name="department" id="department">
												<option value=""><cf_get_lang_main no="322.Seçiniz"></option>
												<cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
													<cfquery name="GET_DEPARTMANT" datasource="#DSN#">
														SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> ORDER BY DEPARTMENT_HEAD
													</cfquery>
													<cfoutput query="get_departmant">
														<option value="#department_id#"<cfif isdefined('attributes.department') and (attributes.department eq get_departmant.department_id)>selected</cfif>>#department_head#</option>
													</cfoutput>
												</cfif>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1548.Rapor Tipi'></label>
										<div class="col col-12 col-xs-12" id="DEPARTMENT_PLACE">											
											<select name="report_type" id="report_type" onchange="show_graph(this.value);">
												<option value="1" <cfif isdefined("attributes.report_type") and attributes.report_type eq 1>selected</cfif>><cf_get_lang no ='1453.Çalışanlara Göre'></option>
												<option value="2" <cfif isdefined("attributes.report_type") and attributes.report_type eq 2>selected</cfif>><cf_get_lang no ='1695.Projelere Göre'></option>
												<option value="10" <cfif isdefined("attributes.report_type") and attributes.report_type eq 10>selected</cfif>><cf_get_lang no ='1696.Proje Gruplarına Göre'></option>
												<option value="11" <cfif isdefined("attributes.report_type") and attributes.report_type eq 11>selected</cfif>><cf_get_lang no ='1697.Proje Gruplarına Göre Onaylanmış'></option>
												<option value="12" <cfif isdefined("attributes.report_type") and attributes.report_type eq 12>selected</cfif>><cf_get_lang no ='1698.Proje Grubu ve Açıklamalar'></option>
												<option value="3" <cfif isdefined("attributes.report_type") and attributes.report_type eq 3>selected</cfif>><cf_get_lang no ='1699.Masraf Merkezlerine Göre'></option>
												<option value="4" <cfif isdefined("attributes.report_type") and attributes.report_type eq 4>selected</cfif>><cf_get_lang no ='1700.Cari Hesaplara Göre'></option>
												<option value="5" <cfif isdefined("attributes.report_type") and attributes.report_type eq 5>selected</cfif>><cf_get_lang no ='1407.Abonelere Göre'></option>
												<option value="6" <cfif isdefined("attributes.report_type") and attributes.report_type eq 6>selected</cfif>><cf_get_lang no ='1702.İşlere Göre'></option>
												<option value="7" <cfif isdefined("attributes.report_type") and attributes.report_type eq 7>selected</cfif>><cf_get_lang no ='1703.Servislere Göre'></option>
												<option value="8" <cfif isdefined("attributes.report_type") and attributes.report_type eq 8>selected</cfif>><cf_get_lang no ='1704.Eğitimlere Göre'></option>
												<option value="13" <cfif isdefined("attributes.report_type") and attributes.report_type eq 13>selected</cfif>><cf_get_lang no ='1967.Aktivitelere Göre'></option>
												<option value="9" <cfif isdefined("attributes.report_type") and attributes.report_type eq 9>selected</cfif>><cf_get_lang no ='1705.Açıklamalara Göre'></option>
												<option value="14" <cfif isdefined("attributes.report_type") and attributes.report_type eq 14>selected</cfif>><cf_get_lang_main no ='2624.Departmanlara Göre'></option>
												<option value="15" <cfif isdefined("attributes.report_type") and attributes.report_type eq 15>selected</cfif>><cf_get_lang_main no ='2625.İş Kategorilerine Göre'></option>
												<option value="16" <cfif isdefined("attributes.report_type") and attributes.report_type eq 16>selected</cfif>><cf_get_lang_main no ='2626.Etkileşim Kategorisine Göre'></option>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='330.Tarih'>*</label>
											<div class="col col-6">
												<div class="input-group">
													<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='641.Başlangıç Tarihi'></cfsavecontent>
													<cfif isdefined("attributes.real_start_date_") and len(attributes.real_start_date_)>
														<cfinput type="text" name="start_date" id="start_date" maxlength="10" value="#attributes.real_start_date_#" validate="#validate_style#" message="#message#" required="yes">
													<cfelse>
														<cfinput type="text" name="start_date" id="start_date" maxlength="10" value="#dateformat(attributes.start_date,dateformat_style)#" alidate="#validate_style#" message="#message#" required="yes">
													</cfif>
													<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
												</div>
											</div>
											<div class="col col-6">
												<div class="input-group">
													<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='288.Bitiş Tarihi'></cfsavecontent>
													<cfinput type="text" name="finish_date" id="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" message="#message#" required="yes">
													<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
												</div>
											</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang no='452.Aktivite Tipi'></label>
										<div class="col col-12 col-xs-12">
											<select name="activity_type" id="activity_type" multiple>
												<cfoutput query="get_activity_types">
													<option value="#activity_id#" <cfif isdefined("attributes.activity_type") and listfind(attributes.activity_type,activity_id,',')>selected</cfif>>#activity_name#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang no ='1020.Grafik'></label>
										<div class="col col-12 col-xs-12">
											<select name="graph_type" id="graph_type">
												<option value="" selected><cf_get_lang_main no='538.Grafik Format'></option>
												<option value="radar" <cfif attributes.graph_type eq 'radar'> selected</cfif>>Radar</option>
												<option value="pie"<cfif attributes.graph_type eq 'pie'> selected</cfif>><cf_get_lang_main no='1316.Pasta'></option>
												<option value="bar"<cfif attributes.graph_type eq 'bar'> selected</cfif>><cf_get_lang_main no='251.Bar'></option>
											</select>
										</div>
									</div>
									<div class="form-group" id="item-form_ul_workgroup_id" style="<cfif not(attributes.report_type eq 10 or attributes.report_type eq 11 or attributes.report_type eq 12)>display:none;</cfif>">
										<label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58140.İş Grubu'></label>
										<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
											<select name="workgroup_ids" id="workgroup_ids" >
												<option value=""><cf_get_lang dictionary_id='58140.Is Grubu'></option>
												<cfoutput query="get_workgroups">
													<option value="#workgroup_id#" <cfif attributes.workgroup_ids eq workgroup_id>selected</cfif>>#workgroup_name#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group">
										<div class="col col-12 col-xs-12">
											<label id="shop_graph_" style="<cfif attributes.report_type neq 1 and attributes.report_type neq 9>display:none;</cfif>">
												<input type="checkbox"  name="is_graph_show" id="is_graph_show" <cfif isdefined('attributes.is_graph_show')>checked</cfif>><cf_get_lang dictionary_id ='57490.Gün'>- <cf_get_lang dictionary_id ='58696.Grafik Göster'>
											</label>
											<br/>
											<cfif isdefined('xml_show_cus_help') and xml_show_cus_help eq 1>
													<label><cf_get_lang dictionary_id='63811.Etkileşimle İlişkili Olanlar Gelsin'><input type="checkbox" name="is_cus_help" id="is_cus_help" onclick="show_help_filters();" <cfif isdefined('attributes.is_cus_help')>checked</cfif>></label>
											</cfif>
											<br/>
											<cfif isdefined('xml_show_service_relation') and xml_show_service_relation eq 1>
													<label><cf_get_lang_main no='2623.Servisle İlişkili Olanlar Gelsin'><input type="checkbox" name="is_service_relation" id="is_service_relation" onclick="show_service_filters();" <cfif isdefined('attributes.is_service_relation')>checked</cfif>></label>
											</cfif>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12" id="help_catagories_title" rowspan="2" valign="top" <cfif not isdefined('attributes.is_cus_help')>style="display:none;"</cfif>><cf_get_lang_main no='74.Kategori'></label>
											<div class="col col-12 col-xs-12" id="help_catagories_select" rowspan="2" valign="top" <cfif not isdefined('attributes.is_cus_help')>style="display:none;"</cfif>>
												<select name="interaction_cat" id="interaction_cat" multiple>
													<cfoutput query="get_interaction_cat">
														<option value="#interactioncat_id#"<cfif listfind(attributes.interaction_cat,interactioncat_id)>selected</cfif>>#interactioncat#</option>
													</cfoutput>			  
												</select>
											</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12" id="help_special_def_title" rowspan="2" valign="top" nowrap="nowrap" <cfif not isdefined('attributes.is_cus_help')>style="display:none;"</cfif>><cf_get_lang no='561.Özel Tanım'></label>
											<td </td>
										<div class="col col-12 col-xs-12" id="help_special_def_select" rowspan="2" valign="top" <cfif not isdefined('attributes.is_cus_help')>style="display:none;"</cfif>>
											<select name="special_definition" id="special_definition" multiple>
												<cfoutput query="get_special_definition">
													<option value="#special_definition_id#" <cfif listfind(attributes.special_definition,special_definition_id)>selected</cfif>>#special_definition#</option>
												</cfoutput>			  
											</select>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
						    <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>>&nbsp;<cf_get_lang_main no='446.Excel Getir'></label>
                            <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">&nbsp;
							<cfelse>
								<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">&nbsp;
							</cfif>
							<cfsavecontent variable="message"><cf_get_lang_main no ='499.Çalıştır'></cfsavecontent>
							<input type="hidden" name="is_submit" id="is_submit" value="1">
							<cf_wrk_report_search_button search_function='kontrol()'  insert_info='#message#' is_excel='1' button_type='1'>
						</div>
					</div>
				</div>
			</div>		
	</cf_report_list_search_area>
</cf_report_list_search>
</cfform>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset filename="time_cost_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="content-type" content="text/plain; charset=utf-16">
</cfif>
<cfif IsDefined("attributes.is_submit")>
<cf_report_list>
<cfif attributes.report_type neq 12>   
	 <cfif isdefined("attributes.report_type") and attributes.report_type eq 9>
		<!--- Genel Toplam Hesaplamalari --->
		<cfset last_total_time = 0>
		<cfset last_total_money = 0>
		<cfif time_cost_.recordcount and attributes.page neq 1>
			<cfoutput query="time_cost_" maxrows="#attributes.startrow-1#">
				<cfset last_total_time = last_total_time + expensed_minute>
				<cfset last_total_money = last_total_money + expensed_money>
			</cfoutput>
		</cfif>
		<!--- //Genel Toplam Hesaplamalari --->
            <thead>
                <tr> 
                    <th><cf_get_lang_main no='75.No'></th>
                    <th width="150"><cf_get_lang_main no='164.Çalışan'></th>
                    <th width="250"><cf_get_lang_main no='217.Açıklama'></th>
                    <th><cf_get_lang no='1543.Proje No'></th>
                    <th><cf_get_lang_main no='4.Proje'></th>
                    <th><cf_get_lang_main no='1033.İş'></th>
                    <th><cf_get_lang_main no='1131.Mesai Tipi'></th>
                    <cfif attributes.report_type eq 9><th><cf_get_lang no='452.Aktivite Tipi'></th></cfif>
                    <cfif attributes.report_type eq 9 and isdefined('attributes.is_graph_show')><!--- Grafik Göster Denilmiş ise ve açıklamalara göre seçilmiş ise --->	
                        <th align="center"><cf_get_lang no='1938.Günlük Çalışma'>
                             <table align="left">
                                <tr bgcolor="FF9966">
                                    <cfloop from="1" to="24" index="xx">
                                        <th width="20" class="txtbold"><cfoutput>#xx#</cfoutput></th>
                                    </cfloop>
                                </tr> 
                            </table>
                        </th>
                    <cfelse>
                        <th width="65"><cf_get_lang_main no='330.Tarih'></th>
                        <th align="right" style="text-align:right;"><cf_get_lang_main no='1716.Süre'></th>
                        <cfif get_module_user(48)>
                        	<th align="right" style="text-align:right;"><cf_get_lang_main no='846.Maliyet'></th>
	                        <th nowrap><cf_get_lang_main no ='77.Para Br'></th>
                       	</cfif>
                    </cfif>
                </tr>
            </thead>
            <cfif time_cost_.recordcount>
                <cfset employee_id_list = ''>
                <cfset project_id_list = ''>
                <cfset work_id_list = ''>
                <cfset activity_id_list=''>
                <cfoutput query="time_cost_">
                    <cfif len(employee_id) and not listFindnocase(employee_id_list,employee_id)>
                        <cfset employee_id_list = listappend(employee_id_list,employee_id)>
                    </cfif>
                    <cfif len(project_id) and not ListFindNoCase(project_id_list,project_id)>
                        <cfset project_id_list = ListAppend(project_id_list,project_id)>
                    </cfif>
                    <cfif len(work_id) and not listFindnocase(work_id_list,work_id)>
                        <cfset work_id_list = listappend(work_id_list,work_id)>
                    </cfif>
                    <cfif len(activity_id) and not listfindnocase(activity_id_list,activity_id)>
                        <cfset activity_id_list=listappend(activity_id_list,activity_id)>
                    </cfif>
                </cfoutput>
                <cfif len(employee_id_list)>
                    <cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
                    <cfquery name="GET_EMPLOYEE" datasource="#DSN#">
                        SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME EMPLOYEE,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
                    </cfquery>
                    <cfset employee_id_list = listsort(listdeleteduplicates(valuelist(get_employee.employee_id,',')),'numeric','ASC',',')>
                </cfif>
                <cfif len(project_id_list)>
                    <cfset project_id_list = ListSort(project_id_list,"numeric","ASC",",")>
                    <cfquery name="GET_PROJECT" datasource="#DSN#">
                        SELECT PROJECT_ID,PROJECT_HEAD,PROJECT_NUMBER FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
                    </cfquery>
                    <cfset project_id_list = ListSort(ListDeleteDuplicates(ValueList(get_project.project_id,',')),'numeric','ASC',',')>
                </cfif>
                <cfif len(work_id_list)>
                    <cfset work_id_list=listsort(work_id_list,"numeric","ASC",",")>
                    <cfquery name="GET_WORK" datasource="#DSN#">
                        SELECT WORK_HEAD,WORK_ID FROM PRO_WORKS WHERE WORK_ID IN (#work_id_list#) ORDER BY WORK_ID
                    </cfquery>
                    <cfset work_id_list = listsort(listdeleteduplicates(valuelist(get_work.work_id,',')),'numeric','ASC',',')>
                </cfif>
                <cfif len(activity_id_list)>
                    <cfset activity_id_list=listsort(activity_id_list,"numeric","ASC",",")>
                        <cfquery name="GET_ACTIVITY" datasource="#DSN#">
                            SELECT ACTIVITY_NAME,ACTIVITY_ID FROM SETUP_ACTIVITY WHERE ACTIVITY_ID IN (#activity_id_list#) ORDER BY ACTIVITY_ID
                        </cfquery>
                    <cfset activity_id_list = listsort(listdeleteduplicates(valuelist(get_activity.activity_id,',')),'numeric','ASC',',')>
                </cfif>
                <cfset toplam_time = 0>
                <cfset toplam_money = 0>
                <tbody>
                <cfoutput query="time_cost_" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td width="25">#currentrow#</td>
                    <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#get_employee.employee[listfind(employee_id_list,employee_id,',')]#</a></td>
                    <td>#comment#</td>
                    <td><cfif len(project_id_list)>#get_project.project_number[listfind(project_id_list,project_id,',')]#</cfif></td>
                    <td><cfif len(project_id_list)>#get_project.project_head[listfind(project_id_list,project_id,',')]#</cfif></td>
                    <td><cfif len(work_id_list)>#get_work.work_head[listfind(work_id_list,work_id,',')]#</cfif></td>
                    <td><cfif len(overtime_type)>
                            <cfset status = overtime_type>
                            <cfswitch expression="#status#">
                                <cfcase value="1">Normal</cfcase>
                                <cfcase value="2">Fazla Mesai</cfcase>
                                <cfcase value="3">Hafta Sonu</cfcase>
                                <cfcase value="4">Resmi Tatil</cfcase>
                            </cfswitch>
                        </cfif>
                    </td>
                    <td><cfif Len(activity_id_list)>#get_activity.activity_name[listfind(activity_id_list,activity_id,',')]#</cfif></td>
                    <cfif attributes.report_type eq 9 and isdefined('attributes.is_graph_show')><!--- Grafik Göster Denilmiş ise ve açıklamalara göre seçilmiş ise --->	
                        <td>
                            <div style="background:FF9966;width:#((expensed_minute/60)*24)#;">
                                <cfset totaltime = expensed_minute mod 60>
                                #((expensed_minute-totaltime)/60)#:#totaltime#
                            </div> 
                        </td>
                    <cfelse>
                        <td>#dateformat(event_date,dateformat_style)#</td>
                        <td align="right" style="text-align:right;">
                            <cfset totaltime = expensed_minute mod 60>
                            #((expensed_minute-totaltime)/60)#:#totaltime# <cf_get_lang_main no ='79.Saat'>
                        </td>
                        <cfif get_module_user(48)>
                            <td align="right" style="text-align:right;">#TLFORMAT(expensed_money)#</td>
                            <td>&nbsp;#session.ep.money#</td>
                        </cfif>
                    </cfif>
                </tr>
                <cfset toplam_time = toplam_time + expensed_minute>
                <cfset toplam_money = toplam_money + expensed_money>
                </cfoutput>
                </tbody>
                <tfoot>
                <cfif attributes.report_type eq 9 and isdefined('attributes.is_graph_show')>
                    <tr>
                        <td colspan="8"></td>
                        <td><cf_get_lang no ='462.Sayfa Toplam'> : 
                        <cfoutput>
                            <cfset total_time = toplam_time mod 60>
                            #((toplam_time-total_time)/60)#:#total_time#<cf_get_lang_main no ='79.Saat'>
                        </cfoutput>
                        </td>
                    </tr>
                <cfelse>
                <tr>
                    <td colspan="<cfif attributes.report_type eq 9>9<cfelse>8</cfif>"><cf_get_lang no ='462.Sayfa Toplam'></td>
                    <td style="text-align:right;">
                        <cfoutput>
                            <cfset total_time = toplam_time mod 60>
                            #((toplam_time-total_time)/60)#:#total_time#<cf_get_lang_main no ='79.Saat'>
                        </cfoutput>
                    </td>
                    <td style="text-align:right;"><cfoutput>#TLFormat(toplam_money)#</cfoutput></td>
                    <td>&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
                </tr>
                </cfif>
                </tfoot>
                <!--- Genel Toplam --->
                <cfif time_cost_.recordcount and attributes.page neq 1>
                <tfoot>
                    <tr>
                        <td colspan="<cfif attributes.report_type eq 9>9<cfelse>8</cfif>"><cf_get_lang_main no ='268.Genel Toplam'></td>
                        <td align="right" style="text-align:right;">
                            <cfset last_total_time = last_total_time + toplam_time>
                            <cfset last_total_money = last_total_money + toplam_money>
                            <cfoutput>
                                <cfset last_total_time_mod = last_total_time mod 60>
                                #((last_total_time-last_total_time_mod)/60)#:#last_total_time_mod#<cf_get_lang_main no ='79.Saat'>
                            </cfoutput>
                        </td>
                        <cfif get_module_user(48)>
                            <td align="right" style="text-align:right;"><cfoutput>#TLFormat(last_total_money)#</cfoutput></td>
                            <td>&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
                        </cfif>
                    </tr>
                </tfoot>
                </cfif>
            <cfelse>
            <tbody>
                <tr>
                    <td colspan="12"><cfif isdefined('attributes.is_submit')><cf_get_lang_main no='72.Kayıt yok'><cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif>!</td>
                </tr>
            </tbody>
            </cfif>
	 <cfelseif (isdefined("attributes.report_type") and attributes.report_type eq 10) or (attributes.report_type eq 11)>
        <thead>
		<tr> 
			<th><cf_get_lang_main no='75.No'></th>
			<th width="250"><cf_get_lang_main no ='4.Proje'></th>
			<th width="200"><cf_get_lang_main no ='246.Üye'></th>
			<th width="150"><cf_get_lang_main no='164.Çalışan'></th>
			<th><cf_get_lang no ='1329.Hizmet Kalemi'></th>
			<th align="right" style="text-align:right;"><cf_get_lang_main no ='226.Birim Fiyat'></th>
			<th nowrap><cf_get_lang_main no ='77.Para Br'></th>
			<th align="right" style="text-align:right;"><cf_get_lang_main no='1716.Süre'></th>
			<cfif get_module_user(48)>
                <th align="right" style="text-align:right;"><cf_get_lang_main no='846.Maliyet'></th>
                <th nowrap><cf_get_lang_main no ='77.Para Br'></th>
            </cfif>
		</tr>
        </thead>
		<cfif get_project_group_time.recordcount>
			<cfset employee_id_list=''>
			<cfoutput query="get_project_group_time">
				<cfif len(employee_id) and not listFindnocase(employee_id_list,employee_id)>
					<cfset employee_id_list=listappend(employee_id_list,employee_id)>
				</cfif>
			</cfoutput>
			<cfif len(employee_id_list)>
				<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
				<cfquery name="GET_EMPLOYEE" datasource="#DSN#">
					SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME EMPLOYEE,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
				</cfquery>
				<cfset employee_id_list = listsort(listdeleteduplicates(valuelist(get_employee.employee_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfset toplam_time = 0>
			<cfset toplam_money = 0>
            <tbody>
			<cfoutput query="get_project_group_time" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td width="25">#currentrow#</td>
					<td><cfif len(project_id)>
							<cfquery name="GET_PROJECT" datasource="#DSN#">
								SELECT PROJECT_HEAD,PARTNER_ID,CONSUMER_ID FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#project_id#">
							</cfquery>
							#get_project.project_head#
						</cfif>
					</td>
					<td width="200">
						<cfif IsDefined("attributes.is_excel") and attributes.is_excel eq 1>
							<cfif len(get_project.partner_id)>
							#get_par_info(get_project.partner_id,0,1,0)#
							<cfelseif len(get_project.consumer_id)>
								#get_cons_info(get_project.consumer_id,0,0)#
							</cfif>
						<cfelse>
							<cfif len(get_project.partner_id)>
								#get_par_info(get_project.partner_id,0,1,1)#
							<cfelseif len(get_project.consumer_id)>
								#get_cons_info(get_project.consumer_id,0,1)#
							</cfif>
						</cfif>
					</td>
					<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#get_employee.employee[listfind(employee_id_list,employee_id,',')]#</a></td>
					<td>#product_name#</td>
					<td align="right" style="text-align:right;">#TLFormat(product_unit_price)# </td>
					<td>&nbsp;#product_money#</td>
					<td align="right" style="text-align:right;">
						<cfset totaltime = expensed_minute mod 60>
						#((expensed_minute-totaltime)/60)#:#totaltime#<cf_get_lang_main no ='79.Saat'>
					</td>
					<cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
						SELECT 
							(RATE2/RATE1) RATE
						FROM 
							SETUP_MONEY
						WHERE
							MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#product_money#">
					</cfquery>
					<cfif get_module_user(48)>
	                    <td align="right" style="text-align:right;">
							<cfset workgroup_total = ((product_unit_price/60)*expensed_minute*get_money_info.rate)>
                            #TLFormat(workgroup_total)#
                        </td>
                        <td>&nbsp;#session.ep.money#</td>
                    </cfif>
				</tr>
				<cfset toplam_time = toplam_time + expensed_minute>
				<cfset toplam_money = toplam_money + workgroup_total>
			</cfoutput>
            </tbody>
            <tfoot>
			<tr>
				<td colspan="7"><cf_get_lang no ='462.Sayfa Toplam'></td>
				<td style="text-align:right;">
					<cfoutput>
						<cfset total_time = toplam_time mod 60>
						#((toplam_time-total_time)/60)#:#total_time# <cf_get_lang_main no ='79.Saat'>
					</cfoutput>
				</td>
				<cfif get_module_user(48)>
                    <td style="text-align:right;"><cfoutput>#TLFormat(toplam_money)# </cfoutput></td>
                    <td>&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
                </cfif>
			</tr>
            </tfoot>
		<cfelse>
        <tbody>
			<tr>
				<td colspan="60"><cfif isdefined('attributes.is_submit')><cf_get_lang_main no='72.Kayıt yok'><cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif>!</td>
			</tr>
        </tbody>
		</cfif>
	 <cfelseif isdefined("attributes.report_type") and attributes.report_type eq 16>
    	<thead>
            <tr> 
                <th><cf_get_lang_main no='75.No'></th>
                <th width="500"><cf_get_lang_main no='2627.Etkileşim Kategorisi'></th>
                <th align="right" style="text-align:right;"><cf_get_lang no='740.Toplam Süre'></th>
                <cfif get_module_user(48)>
                    <th align="right" style="text-align:right;"><cf_get_lang_main no='846.Maliyet'></th>
                    <th nowrap><cf_get_lang_main no ='77.Para Br'></th>
                </cfif>
                <th align="right" style="text-align:right;"><cf_get_lang_main no='1417.Kayıt Sayısı'></th>
            </tr>
        </thead>
		<cfif time_cost_.recordcount>
		 	<cfset interaction_cat_list=''>
			<cfoutput query="time_cost_" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(interaction_cat) and not listFindnocase(interaction_cat_list,interaction_cat)>
					<cfset interaction_cat_list = listappend(interaction_cat_list,interaction_cat)>
				</cfif>
			</cfoutput>
			<cfif len(interaction_cat_list)>
				<cfset interaction_cat_list=listsort(interaction_cat_list,"numeric","ASC",",")>
				<cfquery name="GET_INTERACT" datasource="#DSN#">
					SELECT INTERACTIONCAT_ID,INTERACTIONCAT FROM SETUP_INTERACTION_CAT WHERE INTERACTIONCAT_ID IN (#interaction_cat_list#) ORDER BY INTERACTIONCAT_ID
				</cfquery>
				<cfset interaction_cat_list = listsort(listdeleteduplicates(valuelist(get_interact.interactioncat_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfset toplam_time = 0>
			<cfset toplam_money = 0>
			<cfset toplam_count = 0>
            <tbody>
			<cfoutput query="time_cost_" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td width="25">#currentrow#</td>
                    <td>#get_interact.interactioncat[listfind(interaction_cat_list,interaction_cat,',')]#</td>
                    <td align="right" style="text-align:right;">
                        <cfset totaltime = expensed_minute mod 60>
                        #((expensed_minute-totaltime)/60)#:#totaltime# <cf_get_lang_main no ='79.Saat'>
                    </td>
                    <cfif get_module_user(48)>
                        <td align="right" style="text-align:right;">#TLFormat(expensed_money)# </td>
                        <td>&nbsp;#session.ep.money#</td> 
                    </cfif>
                    <td align="right" style="text-align:right;">#toplam#</td>
                </tr>
                <cfset toplam_time = toplam_time + expensed_minute>
                <cfset toplam_money = toplam_money + expensed_money>
               <cfset toplam_count = toplam_count + toplam>
			</cfoutput>
            </tbody>
            <tfoot>
			<tr>
				<td colspan="2"><cf_get_lang no ='462.Sayfa Toplam'></td>
				<td style="text-align:right;">
					<cfoutput>
						<cfset total_time = toplam_time mod 60>
						#((toplam_time-total_time)/60)#:#total_time#<cf_get_lang_main no ='79.Saat'>
					</cfoutput>
				</td>
				<cfif get_module_user(48)>
                    <td style="text-align:right;"><cfoutput>#TLFormat(toplam_money)#</cfoutput></td>
                    <td>&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
                </cfif>
				<td style="text-align:right;"><cfoutput>#toplam_count#</cfoutput></td>
			</tr>
            </tfoot>
		<cfelse>
        	<tbody>
			<tr>
				<td colspan="60"><cfif isdefined('attributes.is_submit')><cf_get_lang_main no='72.Kayıt yok'><cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif>!</td>
			</tr>
            </tbody>
		</cfif>
	 <cfelse>
    	<cfif attributes.report_type eq 1 and isdefined('attributes.is_graph_show')> <!---Grafik Göster Denilmiş ise ve çalışanlara göre seçilmiş ise --->	
        	<thead>
                <tr>
                    <th width="1%"><cf_get_lang_main no='75.No'></th>
                    <th width="200"><cf_get_lang_main no='164.Çalışan'></th>
                    <cfset diff_day = DateDiff('d',attributes.start_date,attributes.finish_date)>
                    <cfloop from="0" to="#diff_day#" index="day_ind">
                        <cfoutput><th width="10" title="#DateFormat(date_add('d',day_ind,attributes.start_date),dateformat_style)#">#DateFormat(date_add('d',day_ind,attributes.start_date),'DD')#</th></cfoutput>
                    </cfloop>
                </tr>
           </thead>
                <cfset sayac = 1>
				<cfset _emp_id_list_ = listdeleteduplicates(ValueList(get_time_cost.employee_id,','))>
				<cfif get_time_cost.recordcount>
                <cfoutput query="get_time_cost">
					<cfset 'is_full_#EMPLOYEE_ID#_#Replace(EVENT_DATE,'-','','all')#' = 'CCCCC'>
					<cfset 'is_full#EMPLOYEE_ID##Replace(EVENT_DATE,'-','','all')#' = '#expensed_minute#'>
				</cfoutput>
					<cfif len(_emp_id_list_)>
						<cfset _emp_id_list_=listsort(_emp_id_list_,"numeric","ASC",",")>
						<cfquery name="GET_EMPLOYEE" datasource="#DSN#">
							SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME EMPLOYEE,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#_emp_id_list_#) ORDER BY EMPLOYEE_ID
						</cfquery>
						<cfset _emp_id_list_ = listsort(listdeleteduplicates(valuelist(get_employee.employee_id,',')),'numeric','ASC',',')>
					</cfif>
                <tbody>
                	<cfloop list="#_emp_id_list_#" index="EMP_ID">
                    <cfoutput>
                        <tr bgcolor="FFFFF">
                            <td width="1%">#sayac#</td>
                            <td width="200"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#emp_id#','medium');" class="tableyazi">#get_employee.employee[listfind(_emp_id_list_,emp_id,',')]#</a></td>
                            <cfloop from="0" to="#diff_day#" index="day_ind">
								<cfset 'new_day#day_ind#' = DateFormat(date_add('d',day_ind,attributes.start_date),'DDMMYYYY')>
                                <td width="10" <cfif isdefined('is_full_#EMP_ID#_#Evaluate('new_day#day_ind#')#')>bgcolor="CCCCC"<cfelse>bgcolor="FFFFF"</cfif>>
                                    <cfif isdefined('is_full_#EMP_ID#_#Evaluate('new_day#day_ind#')#')>
                                        <cfset _time_graph_ = #Evaluate('is_full#EMP_ID##Evaluate('new_day#day_ind#')#')#>
                                        <cfset totaltime = _time_graph_ mod 60>
                                        #((_time_graph_-totaltime)/60)#:#totaltime#
                                    <cfelse>
                                        &nbsp;
                                    </cfif>
                                </td>
                            </cfloop>
                        </tr>    
                    </cfoutput>
                <cfset sayac = sayac+1>   
                </cfloop>
                </tbody>
				<cfelse>
					<tbody>
					<tr>
						<td colspan="60"><cfif isdefined('attributes.is_submit')><cf_get_lang_main no='72.Kayıt yok'><cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif>!</td>
					</tr>
					</tbody>
				</cfif>

		<cfelse>
        	<thead>
            <tr> 
                <th><cf_get_lang_main no='75.No'></th>
                <th width="500">
					<cfif attributes.report_type eq 1>
                    	<cf_get_lang_main no='164.Çalışan'>
					<cfelseif attributes.report_type eq 2>
                    	<cf_get_lang_main no='4.Proje'>
                    <cfelseif attributes.report_type eq 3>
                    	<cf_get_lang_main no='1518.Masraf'>
                    <cfelseif attributes.report_type eq 4>
                    	<cf_get_lang_main no='45.Müşteri'>
                    <cfelseif attributes.report_type eq 5>
                    	<cf_get_lang_main no='1420.Abone'>
                    <cfelseif attributes.report_type eq 6>
                    	<cf_get_lang_main no='1033.İş'>
                    <cfelseif attributes.report_type eq 15>
                    	<cf_get_lang_main no='2628.İş Kategorisi'>
                    <cfelseif attributes.report_type eq 7>
                    	<cf_get_lang_main no='244.Servis'>
                    <cfelseif attributes.report_type eq 8>
                    	<cf_get_lang_main no='7.Eğitim'>
                    <cfelseif attributes.report_type eq 13>
                        <cf_get_lang no='452.Aktivite Tipi'>
                    <cfelseif attributes.report_type eq 14>
                        <cf_get_lang_main no='160.Departman'>
					</cfif>
                </th>
				<cfif attributes.report_type eq 5><th><cf_get_lang_main no='45.Müşteri'></th></cfif>
				<cfif attributes.report_type eq 5><th><cf_get_lang_main no='70.Aşama'></th></cfif>
                <th align="right" style="text-align:right;"><cf_get_lang no='740.Toplam Süre'></th>
                <cfif get_module_user(48)>
                    <th align="right" style="text-align:right;"><cf_get_lang_main no='846.Maliyet'></th>
                    <th nowrap><cf_get_lang_main no ='77.Para Br'></th>
                </cfif>
                <th align="right" style="text-align:right;"><cf_get_lang_main no='1417.Kayıt Sayısı'></th>
            </tr>
            </thead>
            <cfif get_time_cost.recordcount>
			<cfset project_id_list=''>
			<cfset expense_id_list=''>
			<cfset subscription_id_list=''>
			<cfset subscription_stage_list=''>
			<cfset work_id_list=''>
			<cfset crm_id_list=''>
			<cfset class_id_list=''>
			<cfset activity_id_list=''>
			<cfset department_id_list=''>
			<cfset employee_id_list=''>
			<cfset work_cat_id_list = ''>
			<cfif listfind('1,2,3,4,5,6,7,8,9,13,14,15',attributes.report_type)>
				<cfoutput query="get_time_cost" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif attributes.report_type eq 1>
						<cfif len(employee_id) and not listFindnocase(employee_id_list,employee_id)>
							<cfset employee_id_list=listappend(employee_id_list,employee_id)>
						</cfif>
					<cfelseif attributes.report_type eq 2>
						<cfif len(project_id) and not listFindnocase(project_id_list,project_id)>
							<cfset project_id_list=listappend(project_id_list,project_id)>
						</cfif>
					<cfelseif attributes.report_type eq 3>
						<cfif len(expense_id) and not listfindnocase(expense_id_list,expense_id)>
							<cfset expense_id_list=listappend(expense_id_list,expense_id)>
						</cfif>
					<cfelseif attributes.report_type eq 5>
						<cfif len(subscription_id) and not listfindnocase(subscription_id_list,subscription_id)>
							<cfset subscription_id_list=listappend(subscription_id_list,subscription_id)>
						</cfif>
					<cfelseif attributes.report_type eq 6>
						<cfif len(work_id) and not listfindnocase(work_id_list,work_id)>
							<cfset work_id_list=listappend(work_id_list,work_id)>
						</cfif>
					<cfelseif attributes.report_type eq 15>
						<cfif len(work_cat_id) and not listfindnocase(work_cat_id_list,work_cat_id)>
							<cfset work_cat_id_list=listappend(work_cat_id_list,work_cat_id)>
						</cfif>
					<cfelseif attributes.report_type eq 7>
						<cfif len(service_id) and not listfindnocase(crm_id_list,service_id)>
							<cfset crm_id_list=listappend(crm_id_list,service_id)>
						</cfif>
					<cfelseif attributes.report_type eq 8>
						<cfif len(class_id) and not listfindnocase(class_id_list,class_id)>
							<cfset class_id_list=listappend(class_id_list,class_id)>
						</cfif>
					<cfelseif attributes.report_type eq 13>
						<cfif len(activity_id) and not listfindnocase(activity_id_list,activity_id)>
							<cfset activity_id_list=listappend(activity_id_list,activity_id)>
						</cfif>
					<cfelseif attributes.report_type eq 14>
						<cfif len(department_id) and not listfindnocase(department_id_list,department_id)>
							<cfset department_id_list=listappend(department_id_list,department_id)>
						</cfif>
					</cfif>					
				</cfoutput>
					<cfif attributes.report_type eq 1>
						<cfif len(employee_id_list)>
							<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
							<cfquery name="GET_EMPLOYEE" datasource="#DSN#">
								SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME EMPLOYEE,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
							</cfquery>
							<cfset employee_id_list = listsort(listdeleteduplicates(valuelist(get_employee.employee_id,',')),'numeric','ASC',',')>
						</cfif>
					<cfelseif attributes.report_type eq 2>
 						<cfif len(project_id_list)>
							<cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>
							<cfquery name="GET_PROJECT" datasource="#DSN#">
								SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
							</cfquery>
							<cfset project_id_list = listsort(listdeleteduplicates(valuelist(get_project.project_id,',')),'numeric','ASC',',')>
						</cfif>
					<cfelseif attributes.report_type eq 3>
						<cfif len(expense_id_list)>
							<cfset expense_id_list=listsort(expense_id_list,"numeric","ASC",",")>
							<cfquery name="GET_EXPENSE" datasource="#DSN2#">
								SELECT EXPENSE,EXPENSE_ID FROM EXPENSE_CENTER WHERE EXPENSE_ID IN(#expense_id_list#) ORDER BY EXPENSE_ID
							</cfquery>
							<cfset expense_id_list = listsort(listdeleteduplicates(valuelist(get_expense.expense_id,',')),'numeric','ASC',',')>
						</cfif>
					<cfelseif attributes.report_type eq 5>
						<cfif len(subscription_id_list)>
							<cfset subscription_id_list=listsort(subscription_id_list,"numeric","ASC",",")>
							<cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
									SELECT
										1 TYPE,
										SC.SUBSCRIPTION_NO,
										SC.SUBSCRIPTION_ID,
										SC.SUBSCRIPTION_STAGE,
										CP.PARTNER_ID PARTNER_ID,
										CP.COMPANY_PARTNER_NAME PARTNER_NAME,
										CP.COMPANY_PARTNER_SURNAME PARTNER_SURNAME,
										C.COMPANY_ID COMPANY_ID,
										C.NICKNAME
									FROM
										#dsn_alias#.COMPANY C,
										#dsn_alias#.COMPANY_PARTNER CP,
										SUBSCRIPTION_CONTRACT SC
									WHERE
										SC.PARTNER_ID IS NOT NULL AND
										SC.PARTNER_ID = CP.PARTNER_ID AND
										SC.COMPANY_ID = C.COMPANY_ID AND
										C.COMPANY_ID = CP.COMPANY_ID AND
										SC.SUBSCRIPTION_ID IN (#subscription_id_list#)										
								UNION ALL
									SELECT
										2 TYPE,
										SC.SUBSCRIPTION_NO,
										SC.SUBSCRIPTION_ID,
										SC.SUBSCRIPTION_STAGE,
										CS.CONSUMER_ID PARTNER_ID,
										CS.CONSUMER_NAME PARTNER_NAME,
										CS.CONSUMER_SURNAME PARTNER_SURNAME,
										NULL COMPANY_ID,
										NULL NICKNAME
									FROM
										#dsn_alias#.CONSUMER CS,
										SUBSCRIPTION_CONTRACT SC
									WHERE
										SC.CONSUMER_ID IS NOT NULL AND
										SC.CONSUMER_ID = CS.CONSUMER_ID AND
										SC.SUBSCRIPTION_ID IN (#subscription_id_list#)
									ORDER BY
										SC.SUBSCRIPTION_ID
							</cfquery>
							<cfset subscription_id_list = listsort(listdeleteduplicates(valuelist(get_subscription.subscription_id,',')),'numeric','ASC',',')>
						</cfif>
					<cfelseif attributes.report_type eq 6>
						<cfif len(work_id_list)>
							<cfset work_id_list=listsort(work_id_list,"numeric","ASC",",")>
							<cfquery name="GET_WORK" datasource="#DSN#">
								SELECT WORK_HEAD,WORK_ID FROM PRO_WORKS WHERE WORK_ID IN (#work_id_list#) ORDER BY WORK_ID
							</cfquery>
							<cfset work_id_list = listsort(listdeleteduplicates(valuelist(get_work.work_id,',')),'numeric','ASC',',')>
						</cfif>
					<cfelseif attributes.report_type eq 15>
						<cfif len(work_cat_id_list)>
							<cfset work_cat_id_list=listsort(work_cat_id_list,"numeric","ASC",",")>
							<cfquery name="GET_WORK_CAT" datasource="#DSN#">
								SELECT WORK_CAT,WORK_CAT_ID FROM PRO_WORK_CAT WHERE WORK_CAT_ID IN (#work_cat_id_list#) ORDER BY WORK_CAT_ID
							</cfquery>
							<cfset work_cat_id_list = listsort(listdeleteduplicates(valuelist(get_work_cat.WORK_CAT_ID,',')),'numeric','ASC',',')>
						</cfif>
					<cfelseif attributes.report_type eq 7>
						<cfif len(crm_id_list)>
							<cfset crm_id_list=listsort(crm_id_list,"numeric","ASC",",")>
							<cfquery name="GET_SERVICE" datasource="#DSN3#">
								SELECT SERVICE_HEAD,SERVICE_ID FROM SERVICE WHERE SERVICE_ID IN (#crm_id_list#) ORDER BY SERVICE_ID 
							</cfquery>
							<cfset crm_id_list = listsort(listdeleteduplicates(valuelist(get_service.service_id,',')),'numeric','ASC',',')>
						</cfif>
					<cfelseif attributes.report_type eq 8>
						<cfif len(class_id_list)>
							<cfset class_id_list=listsort(class_id_list,"numeric","ASC",",")>
							<cfquery name="GET_CLASS" datasource="#DSN#">
								SELECT CLASS_NAME,CLASS_ID FROM TRAINING_CLASS WHERE CLASS_ID IN (#class_id_list#) ORDER BY CLASS_ID
							</cfquery>
							<cfset class_id_list = listsort(listdeleteduplicates(valuelist(get_class.class_id,',')),'numeric','ASC',',')>
						</cfif>
					<cfelseif attributes.report_type eq 13>
						<cfif len(activity_id_list)>
							<cfset activity_id_list=listsort(activity_id_list,"numeric","ASC",",")>
								<cfquery name="GET_ACTIVITY" datasource="#DSN#">
									SELECT ACTIVITY_NAME,ACTIVITY_ID FROM SETUP_ACTIVITY WHERE ACTIVITY_ID IN (#activity_id_list#) ORDER BY ACTIVITY_ID
								</cfquery>
							<cfset activity_id_list = listsort(listdeleteduplicates(valuelist(get_activity.activity_id,',')),'numeric','ASC',',')>
						</cfif>
					<cfelseif attributes.report_type eq 14>
						<cfif len(department_id_list)>
							<cfset department_id_list=listsort(department_id_list,"numeric","ASC",",")>
								<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
									SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#department_id_list#) ORDER BY DEPARTMENT_ID
								</cfquery>
							<cfset department_id_list = listsort(listdeleteduplicates(valuelist(get_department.department_id,',')),'numeric','ASC',',')>
						</cfif>
					</cfif>
				</cfif>
                <cfset toplam_time = 0>
                <cfset toplam_money = 0>
                <cfset toplam_count = 0>
                <tbody>
                <cfoutput query="get_time_cost" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td width="25">#currentrow#</td>
                    <td>
						<cfif attributes.report_type eq 1>
							<cfif IsDefined("attributes.is_excel") and attributes.is_excel eq 1>
								#get_employee.employee[listfind(employee_id_list,employee_id,',')]#
							<cfelse>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#get_employee.employee[listfind(employee_id_list,employee_id,',')]#</a>
							</cfif>
						<cfelseif attributes.report_type eq 2>
							#get_project.project_head[listfind(project_id_list,project_id,',')]#
						<cfelseif attributes.report_type eq 3>
							#get_expense.expense[listfind(expense_id_list,expense_id,',')]#
						<cfelseif attributes.report_type eq 4>
							<cfif IsDefined("attributes.is_excel") and attributes.is_excel eq 1>
								<cfif len(get_time_cost.company_id)>
									#get_par_info(company_id,1,1,0)#
								<cfelse>
									#get_cons_info(consumer_id,0,1,0)#
								</cfif>
							<cfelse>
								<cfif len(get_time_cost.company_id)>
									#get_par_info(company_id,1,1,1)#
								<cfelse>
									#get_cons_info(consumer_id,0,1,0)#
								</cfif>
							</cfif>
						<cfelseif attributes.report_type eq 5>
							#get_subscription.subscription_no[listfind(subscription_id_list,subscription_id,',')]#
						<cfelseif attributes.report_type eq 6>
							#get_work.work_head[listfind(work_id_list,work_id,',')]# 
						<cfelseif attributes.report_type eq 15>
							<cfif len(work_cat_id_list)>
								#get_work_cat.work_cat[listfind(work_cat_id_list,work_cat_id,',')]#     
							</cfif>
						<cfelseif attributes.report_type eq 7>
							#get_service.service_head[listfind(crm_id_list,service_id,',')]# 		
						<cfelseif attributes.report_type eq 8>
							#get_class.class_name[listfind(class_id_list,class_id,',')]# 
						<cfelseif attributes.report_type eq 13 and isdefined('get_time_cost.activity_id') and len(get_time_cost.activity_id)>
							#get_activity.activity_name[listfind(activity_id_list,activity_id,',')]# 
						<cfelseif attributes.report_type eq 14>
							#get_department.department_head[listfind(department_id_list,department_id,',')]#
						</cfif>
                    </td>
					<cfif attributes.report_type eq 5>
						<td><cfif Len(get_subscription.nickname[listfind(subscription_id_list,subscription_id,',')])>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_subscription.company_id[listfind(subscription_id_list,subscription_id,',')]#','medium');" class="tableyazi">#get_subscription.nickname[listfind(subscription_id_list,subscription_id,',')]#</a> - </cfif>
								<cfif get_subscription.type[listfind(subscription_id_list,subscription_id,',')] eq 1>
									<cfset Link_ = "popup_par_det&par_id=">
								<cfelse>
									<cfset Link_ = "popup_con_det&con_id=">
								</cfif>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.#Link_##get_subscription.partner_id[listfind(subscription_id_list,subscription_id,',')]#','medium');" class="tableyazi">
									#get_subscription.partner_name[listfind(subscription_id_list,subscription_id,',')]# #get_subscription.partner_surname[listfind(subscription_id_list,subscription_id,',')]#
								</a>
						</td>
					</cfif>
					<cfif attributes.report_type eq 5>
						<td align="right">
							<cfquery name="GET_SUB_STAGE" dbtype="query">
								SELECT * FROM GET_SUBSCRIPTION_STAGES WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.subscription_stage[listfind(subscription_id_list,subscription_id,',')]#">
							</cfquery>
							#get_sub_stage.stage#
						</td>
					</cfif>
                    <td align="right" style="text-align:right;">
                        <cfset totaltime = expensed_minute mod 60>
                        #((expensed_minute-totaltime)/60)#:#totaltime# <cf_get_lang_main no ='79.Saat'>
                    </td>
                    <cfif get_module_user(48)>
                        <td align="right" style="text-align:right;">#TLFormat(expensed_money)# </td>
                        <td>&nbsp;#session.ep.money#</td> 
                    </cfif>
                    <td align="right" style="text-align:right;">
                    <cfif attributes.report_type neq 4>
                        #toplam#
                    <cfelse>
                        <cfif len(consumer_id)>
                            #toplam#
                        <cfelse>
                            #toplam2#
                        </cfif>
                    </cfif>
                    </td>
                </tr>
                <cfset toplam_time = toplam_time + expensed_minute>
                <cfset toplam_money = toplam_money + expensed_money>
                <cfif attributes.report_type neq 4>
                    <cfset toplam_count = toplam_count + toplam>
                <cfelse>
                    <cfset toplam_count = toplam_count + toplam2>
                </cfif>
                </cfoutput>
                </tbody>
                <tfoot>
                <tr>
                    <td colspan="<cfif attributes.report_type eq 5>4<cfelse>2</cfif>"><cf_get_lang no ='462.Sayfa Toplam'></td>
                    <td style="text-align:right;">
                        <cfoutput>
                        	<cfset total_time =toplam_time mod 60>
                             #((toplam_time-total_time)/60)#:#total_time#<cf_get_lang_main no ='79.Saat'>
                        </cfoutput>
                    </td>
                    <cfif get_module_user(48)>
                        <td style="text-align:right;"><cfoutput>#TLFormat(toplam_money)#</cfoutput></td>
                        <td>&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
                    </cfif>
                    <td style="text-align:right;"><cfoutput>#toplam_count#</cfoutput></td>
                </tr>
                </tfoot>
            <cfelse>
            	<tbody>
                <tr>
                    <td colspan="<cfif attributes.report_type eq 5>8<cfelse>6</cfif>"><cfif isdefined('attributes.is_submit')><cf_get_lang_main no='72.Kayıt yok'><cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif>!</td>
                </tr>
                </tbody>
            </cfif>
        </cfif>
	</cfif>	
</cfif>
 <cfif isdefined("attributes.report_type") and attributes.report_type eq 12>
    <table width="99%" class="color-border" cellpadding="2" cellspacing="1" style=" margin-bottom:10px;" id="transaction_type">
		<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
			<cfoutput>
			<tr class="color-row">
				<td class="txtbold" width="10%"><cf_get_lang_main no ='4.Proje'>:</td>
				<td align="left">
					<cfquery name="GET_PROJECT" datasource="#DSN#">
						SELECT PROJECT_HEAD,PARTNER_ID,CONSUMER_ID FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
					</cfquery>
					#get_project.project_head#
				</td>
				<td align="left">
					<table>
						<tr class="color-row">
							<td align="left" class="txtbold"><cf_get_lang_main no ='330.Tarih'> :</td>
							<td align="left">
								#dateformat(attributes.start_Date,dateformat_style)# - #dateformat(attributes.finish_date,dateformat_style)#
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr class="color-row">
				<td class="txtbold"><cf_get_lang_main no='45.Müşteri'> :</td>
				<td align="left">
					<cfif len(get_project.partner_id)>
						#get_par_info(get_project.partner_id,0,1,0)#
					<cfelseif len(get_project.consumer_id)>
						#get_cons_info(get_project.consumer_id,0,0)#
					</cfif>
				</td>
                <td>&nbsp;</td>
			</tr>
			<tr class="color-row">
				<td colspan="3"><hr style="height:01px; color:999999" /></td>
			</tr>
			</cfoutput>
		</cfif>
	</table>
    <cf_medium_list_search title="#getLang('report',1330)#">
    </cf_medium_list_search>
	<cf_medium_list> 
    	<thead>
		<tr> 
			<th><cf_get_lang_main no='75.No'></th>
			<cfif not len(attributes.project_id)>
				<th width="250"><cf_get_lang_main no ='4.Proje'></th>
				<th width="200"><cf_get_lang_main no ='246.Üye'></th>
			</cfif>
			<th width="150"><cf_get_lang_main no='164.Çalışan'></th>
			<th><cf_get_lang no ='1329.Hizmet Kalemi'></th>
			<th align="right" style="text-align:right;"><cf_get_lang_main no ='226.Birim Fiyat'></th>
			<th nowrap><cf_get_lang_main no ='77.Para Br'></th>
			<th align="right" style="text-align:right;"><cf_get_lang_main no='1417.Kayıt Sayısı'></th>
			<th align="right" style="text-align:right;"><cf_get_lang_main no='1716.Süre'></th>
			<th align="right" style="text-align:right;"><cf_get_lang_main no ='261.Tutar'></th>
			<th nowrap><cf_get_lang_main no ='77.Para Br'></th>
		</tr>
        </thead>
		<cfif get_project_group_time.recordcount>
			<cfset employee_id_list=''>
			<cfoutput query="get_project_group_time">
				<cfif len(employee_id) and not listFindnocase(employee_id_list,employee_id)>
					<cfset employee_id_list=listappend(employee_id_list,employee_id)>
				</cfif>
			</cfoutput>
			<cfif len(employee_id_list)>
				<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
				<cfquery name="GET_EMPLOYEE" datasource="#DSN#">
					SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME EMPLOYEE,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
				</cfquery>
				<cfset employee_id_list = listsort(listdeleteduplicates(valuelist(get_employee.employee_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfset toplam_time = 0>
			<cfset toplam_money = 0>
			<cfset toplam_record = 0>
            <tbody>
			<cfoutput query="get_project_group_time" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td width="25">#currentrow#</td>
					<cfif not len(attributes.project_id)>
						<td><cfif len(project_id)>
								<cfquery name="GET_PROJECT" datasource="#DSN#">
									SELECT PROJECT_HEAD,PARTNER_ID,CONSUMER_ID FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#project_id#">
								</cfquery>
								#get_project.project_head#
							</cfif>
						</td>
						<td width="200">
							<cfif IsDefined("attributes.is_excel") and attributes.is_excel eq 1>
								<cfif len(get_project.partner_id)>
									#get_par_info(get_project.partner_id,0,1,0)#
								<cfelseif len(get_project.consumer_id)>
									#get_cons_info(get_project.consumer_id,0,0)#
								</cfif>
							<cfelse>
								<cfif len(get_project.partner_id)>
									#get_par_info(get_project.partner_id,0,1,1)#
								<cfelseif len(get_project.consumer_id)>
									#get_cons_info(get_project.consumer_id,0,1)#
								</cfif>
							</cfif>
						</td>
					</cfif>
					<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#get_employee.employee[listfind(employee_id_list,employee_id,',')]#</a></td>
					<td>#product_name#</td>
					<td align="right" style="text-align:right;">#TLFormat(product_unit_price)# </td>
					<td>&nbsp;#product_money#</td>
					<td align="right" style="text-align:right;">#toplam#</td>
					<td align="right" style="text-align:right;">
						<cfset totaltime = expensed_minute mod 60>
						#((expensed_minute-totaltime)/60)#:#totaltime# <cf_get_lang_main no ='79.Saat'>
					</td>
					<cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
						SELECT 
							(RATE2/RATE1) RATE
						FROM 
							SETUP_MONEY
						WHERE
							MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#product_money#">
					</cfquery>
					<td align="right" style="text-align:right;">
						<cfif len(product_unit_price) and len(expensed_minute) and len(get_money_info.rate)><!--- fatih sorulcak,geçici çözüm if eklendi,birinin durumuna göre query kısmında ISNULL eklenebilir --->
							<cfset workgroup_total = ((product_unit_price/60)*expensed_minute*get_money_info.rate)>
						<cfelse>
                        	<cfset workgroup_total = 0>
						</cfif>
						#TLFormat(workgroup_total)# 
					</td>
					<td>&nbsp;#session.ep.money#</td>
				</tr>
				<cfset toplam_time = toplam_time + expensed_minute>
				<cfset toplam_money = toplam_money + workgroup_total>
				<cfset toplam_record = toplam_record + toplam>
			</cfoutput>
            </tbody>
            <tfoot>
			<tr>
				<td <cfif not len(attributes.project_id)>colspan="7"<cfelse>colspan="5"</cfif> class="txtbold"><cf_get_lang no ='462.Sayfa Toplam'></td>
				<td style="text-align:right;"><cfoutput>#toplam_record#</cfoutput></td>
				<td style="text-align:right;">
					<cfoutput>
						<cfset total_time = toplam_time mod 60>
						#((toplam_time-total_time)/60)#:#total_time#<cf_get_lang_main no ='79.Saat'>
					</cfoutput>
				</td>
				<td style="text-align:right;"><cfoutput>#TLFormat(toplam_money)# </cfoutput></td>
				<td>&nbsp;<cfoutput>#session.ep.money#</cfoutput></td>
			</tr>
            </tfoot>
		<cfelse>
        	<tbody>
			<tr>
				<td colspan="11"><cfif isdefined('attributes.is_submit')><cf_get_lang_main no='72.Kayıt yok'><cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif>!</td>
			</tr>
            </tbody>
		</cfif>
	</cf_medium_list>
    <cf_medium_list_search title="#getLang('main',608)#">
    </cf_medium_list_search>
	<cf_medium_list>
    	<thead>
		<tr> 
			<th><cf_get_lang_main no='75.No'></th>
			<th width="150"><cf_get_lang_main no='164.Çalışan'></th>
			<th><cf_get_lang_main no='217.Açıklama'></th>
			<th width="65"><cf_get_lang_main no='330.Tarih'></th>
			<th width="70" align="right" style="text-align:right;"><cf_get_lang_main no='1716.Süre'></th>
		</tr>
        </thead>
		<cfif time_cost_.recordcount>
			<cfset toplam_time = 0>
			<cfset toplam_money = 0>
			<cfset employee_id_list=''>
			<cfoutput query="time_cost_">
				<cfif len(employee_id) and not listFindnocase(employee_id_list,employee_id)>
					<cfset employee_id_list=listappend(employee_id_list,employee_id)>
				</cfif>
			</cfoutput>
			<cfif len(employee_id_list)>
				<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
				<cfquery name="GET_EMPLOYEE" datasource="#DSN#">
					SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME EMPLOYEE,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
				</cfquery>
				<cfset employee_id_list = listsort(listdeleteduplicates(valuelist(get_employee.employee_id,',')),'numeric','ASC',',')>
			</cfif>
            <tbody>
			<cfoutput query="time_cost_" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
				<td width="25">#currentrow#</td>
				<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">#get_employee.employee[listfind(employee_id_list,employee_id,',')]#</a></td>
				<td>#comment#</td>
				<td>#dateformat(event_date,dateformat_style)#</td>
				<td align="right" style="text-align:right;">
					<cfset totaltime = expensed_minute mod 60>
					#((expensed_minute-totaltime)/60)#:#totaltime#<cf_get_lang_main no ='79.Saat'>
				</td>
			</tr>
			<cfset toplam_time = toplam_time + expensed_minute>
			</cfoutput>
            </tbody>
            <tfoot>
			<tr>
				<td colspan="4"><cf_get_lang no ='462.Sayfa Toplam'></td>
				<td style="text-align:right;">
					<cfoutput>
						<cfset total_time = toplam_time mod 60>
						#((toplam_time-total_time)/60)#:#total_time#<cf_get_lang_main no ='79.Saat'>
					</cfoutput>
				</td>
			</tr>
            </tfoot>
		<cfelse>
        	<tbody>
			<tr>
				<td colspan="7"><cfif isdefined('attributes.is_submit')><cf_get_lang_main no='72.Kayıt yok'><cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif>!</td>
			</tr>
            </tbody>
		</cfif>
	</cf_medium_list>
</cfif>
</cf_report_list>
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
  <cfset url_str = "">
	<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>
		<cfset url_str = "#url_str#&subscription_id=#attributes.subscription_id#&subscription_no=#attributes.subscription_no#">
	</cfif>
	<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
		<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
	</cfif>
	<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
		<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
	</cfif>
	<cfif isdefined("attributes.is_submit")>
		<cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
	</cfif>
	<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined('attributes.employee') and len(attributes.employee)>
		<cfset url_str = "#url_str#&employee_id=#attributes.employee_id#&employee=#attributes.employee#">
	</cfif>
	<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined('attributes.company') and len(attributes.company)>
		<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
	</cfif>
	<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined('attributes.company') and len(attributes.company)>
		<cfset url_str = "#url_str#&company_id=#attributes.company_id#&company=#attributes.company#">
	</cfif>
	<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined('attributes.project_head') and len(attributes.project_head)>
		<cfset url_str = "#url_str#&project_id=#attributes.project_id#&project_head=#attributes.project_head#">
	</cfif>
	<cfif isdefined("attributes.work_id") and len(attributes.work_id) and isdefined('attributes.work_head') and len(attributes.work_head)>
		<cfset url_str = "#url_str#&work_id=#attributes.work_id#&work_head=#attributes.work_head#">
	</cfif>
	<cfif isdefined("attributes.expense_id") and len(attributes.expense_id) and isdefined('attributes.expense') and len(attributes.expense)>
		<cfset url_str = "#url_str#&expense_id=#attributes.expense_id#&expense=#attributes.expense#">
	</cfif>
	<cfif isdefined("attributes.crm_id") and len(attributes.crm_id) and isdefined('attributes.crm_head') and len(attributes.crm_head)>
		<cfset url_str = "#url_str#&crm_id=#attributes.crm_id#&crm_head=#attributes.crm_head#">
	</cfif>
	<cfif isdefined("attributes.class_id") and len(attributes.class_id) and isdefined('attributes.class_name') and len(attributes.class_name)>
		<cfset url_str = "#url_str#&class_id=#attributes.class_id#&class_name=#attributes.class_name#">
	</cfif>
	<cfif isdefined("attributes.our_company_id") and len(attributes.our_company_id)>
		<cfset url_str = "#url_str#&our_company_id=#attributes.our_company_id#">
	</cfif>
    <cfif isdefined("attributes.department") and len(attributes.department)>
    	<cfset url_str="#url_str#&department=#attributes.department#">	
    </cfif>
    <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
    	<cfset url_str="#url_str#&branch_id=#attributes.branch_id#">
	</cfif>
	<cfif len(attributes.report_type)>
		<cfset url_str = "#url_str#&report_type=#attributes.report_type#">
	</cfif>
	<cfif len(attributes.order_type)>
		<cfset url_str = "#url_str#&order_type=#attributes.order_type#">
	</cfif>
	<cfif len(attributes.graph_type)>
		<cfset url_str = "#url_str#&graph_type=#attributes.graph_type#">
	</cfif>
    <cfif len(attributes.activity_type)>
    	<cfset url_str = "#url_str#&activity_type=#attributes.activity_type#">
    </cfif>
	<cfif isdefined("attributes.overtime_type") and len(attributes.overtime_type)>
    	<cfset url_str = "#url_str#&overtime_type=#attributes.overtime_type#">
    </cfif>
	<cfif isdefined("attributes.is_cus_help") and len(attributes.is_cus_help)>
    	<cfset url_str = "#url_str#&is_cus_help=#attributes.is_cus_help#">
    </cfif>
	<cfif isdefined("attributes.is_service_relation") and len(attributes.is_service_relation)>
    	<cfset url_str = "#url_str#&is_service_relation=#attributes.is_service_relation#">
    </cfif>
	<cfif isdefined("attributes.special_definition") and len(attributes.special_definition)>
    	<cfset url_str = "#url_str#&special_definition=#attributes.special_definition#">
    </cfif>
	<cfif isdefined("attributes.interaction_cat") and len(attributes.interaction_cat)>
    	<cfset url_str = "#url_str#&interaction_cat=#attributes.interaction_cat#">
    </cfif>        
     <cf_paging
	 	page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#" 
		adres="report.time_cost_report#url_str#">
 <!---  </cfif> --->
</cfif>
<cfif isdefined("attributes.is_submit") and len(attributes.graph_type)>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getlang('','Grafik','56387')#">
	<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
		<tr class="nohover">
				<cfif isdefined("attributes.report_type") and (attributes.report_type eq 9 or attributes.report_type eq 16)>
					<cfset query_name=time_cost_>
				<cfelseif  isdefined("attributes.report_type") and listfind('10,11,12',attributes.report_type)>	
					<cfset query_name=get_project_group_time>
				<cfelse>
					<cfset query_name=get_time_cost>
				</cfif>
				<cfset deger_=0>
				<cfoutput query="query_name">
					<cfif  isdefined("attributes.report_type") and listfind('1,2,3,4,5,6,7,8,9,13,14,15,16',attributes.report_type)>
						<cfset deger_=EXPENSED_MONEY>
					<cfelse>
						<cfif isdefined('PRODUCT_UNIT_PRICE') and len(PRODUCT_UNIT_PRICE) and len(expensed_minute) and len(get_money_info.RATE)>
							<cfset deger_ = ((PRODUCT_UNIT_PRICE/60)*expensed_minute*get_money_info.RATE)>
						<cfelse>
							<cfset deger_ = 0>
						</cfif>
					</cfif>
					<cfset totaltime = expensed_minute mod 60>
					<cfif  isdefined("attributes.report_type") and listfind('10,11,12',attributes.report_type) and len(project_id)>
						<cfquery name="get_project" datasource="#dsn#">
							SELECT PROJECT_HEAD,PARTNER_ID,CONSUMER_ID FROM PRO_PROJECTS WHERE PROJECT_ID = #project_id#
						</cfquery>
					</cfif>
					<cfset item_value = ''>
					<cfif attributes.report_type eq 1 and isdefined("_emp_id_list_")>
						<cfset item_value = '#get_employee.EMPLOYEE[listfind(_emp_id_list_,employee_id,',')]# - #((expensed_minute-totaltime)/60)#:#totaltime#'>
					<cfelseif attributes.report_type eq 2>
						<cfset item_value = '#get_project.project_head[listfind(project_id_list,project_id,',')]# - #((expensed_minute-totaltime)/60)#:#totaltime#'>
					<cfelseif attributes.report_type eq 3>
						<cfset item_value = '#get_expense.expense[listfind(expense_id_list,expense_id,',')]#'>
					<cfelseif attributes.report_type eq 4>
						<cfif len(get_time_cost.company_id)>
							<cfset item_value = '#GET_PAR_INFO(company_id,1,0,0)# - #((expensed_minute-totaltime)/60)#:#totaltime#'>
						<cfelse>
							<cfset item_value = '#GET_CONS_INFO(consumer_id,0,1,0)# - #((expensed_minute-totaltime)/60)#:#totaltime#'>
					</cfif>							
					<cfelseif attributes.report_type eq 5>
						<cfset item_value = '#get_subscription.subscription_no[listfind(subscription_id_list,subscription_id,',')]# - #((expensed_minute-totaltime)/60)#:#totaltime#'>
					<cfelseif attributes.report_type eq 6>
						<cfset item_value = '#get_work.work_head[listfind(work_id_list,work_id,',')]# - #((expensed_minute-totaltime)/60)#:#totaltime#'>
					<cfelseif attributes.report_type eq 15>
						<cfif len(work_cat_id_list)>
							<cfset item_value = '#get_work_cat.work_cat[listfind(work_cat_id_list,work_cat_id,',')]# - #((expensed_minute-totaltime)/60)#:#totaltime#'>
						<cfelse>
							<cfset item_value = ''>
						</cfif>
					<cfelseif attributes.report_type eq 16>
						<cfif len(interaction_cat_list)>
							<cfset item_value = '#get_interact.interactioncat[listfind(interaction_cat_list,interaction_cat,',')]# - #((expensed_minute-totaltime)/60)#:#totaltime#'>
						<cfelse>
							<cfset item_value = ''>
						</cfif>
					<cfelseif attributes.report_type eq 7>
						<cfset item_value = '#get_service.service_head[listfind(crm_id_list,service_id,',')]#  - #((expensed_minute-totaltime)/60)#:#totaltime#'>
					<cfelseif attributes.report_type eq 8>
						<cfset item_value = '#get_class.class_name[listfind(class_id_list,class_id,',')]#  - #((expensed_minute-totaltime)/60)#:#totaltime#'><!--- burda kaldım --->
					<cfelseif attributes.report_type eq 9>
						<cfset item_value = '#get_employee.EMPLOYEE[listfind(employee_id_list,employee_id,',')]# - #((expensed_minute-totaltime)/60)#:#totaltime#'>
					<cfelseif attributes.report_type eq 10>
						<cfset item_value = '#get_project.project_head# - #((expensed_minute-totaltime)/60)#:#totaltime#'>
					<cfelseif attributes.report_type eq 11>
						<cfset item_value = '#get_project.project_head# - #((expensed_minute-totaltime)/60)#:#totaltime#'>
					<cfelseif attributes.report_type eq 12>
						<cfset item_value = '#get_project.project_head# - #((expensed_minute-totaltime)/60)#:#totaltime#'>
					<cfelseif attributes.report_type eq 13>
						<cfset item_value = '#get_activity.activity_name[listfind(activity_id_list,activity_id,',')]#  - #((expensed_minute-totaltime)/60)#:#totaltime#'>
					<cfelseif attributes.report_type eq 14>
						<cfset item_value = '#get_department.department_head[listfind(department_id_list,department_id,',')]#  - #((expensed_minute-totaltime)/60)#:#totaltime#'>
					</cfif>
					<cfset 'item_#currentrow#'="#item_value#">
					<cfset 'value_#currentrow#'="#deger_#"> 
				</cfoutput>
			<script src="JS/Chart.min.js" style="width:100%;"></script> 
			<canvas id="myChart"></canvas>
			<script>
				var ctx = document.getElementById('myChart');
					var myChart = new Chart(ctx, {
						type: '<cfoutput>#graph_type#</cfoutput>',
						data: {
							labels: [<cfloop from="1" to="#query_name.recordcount#" index="jj">
												<cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
							datasets: [{
								label: "<cfoutput>#getLang('main',223)#</cfoutput>",
								backgroundColor: [<cfloop from="1" to="#query_name.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
								data: [<cfloop from="1" to="#query_name.recordcount#" index="jj"><cfoutput>#evaluate("value_#jj#")#</cfoutput>,</cfloop>],
							}]
						},
						options: {}
				});
			</script>
		</tr>	
	</div> 
</cf_box>
</cfif>
</div> 
<script type="text/javascript">
	function kontrol()
	{
		if ((document.time_cost.start_date.value != '') && (document.time_cost.finish_date.value != '') &&
	    !date_check(time_cost.start_date,time_cost.finish_date,"<cf_get_lang no ='1093.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
		var report_t_id = document.getElementById('report_type').value;
		if((report_t_id==1 && document.getElementById('is_graph_show').checked == true && document.getElementById('shop_graph_').style.display=="") && datediff(document.getElementById('start_date').value,document.getElementById('finish_date').value) > 62){//eğer grafik göster seçili ise.
			alert("<cf_get_lang no ='1717.Grafik Gösterimi için tarih aralığı en fazla 2 ay olmalıdır'>!");
			return false;
		}
		else if((report_t_id==9 && document.getElementById('is_graph_show').checked == true && document.getElementById('shop_graph_').style.display=="") && datediff(document.getElementById('start_date').value,document.getElementById('finish_date').value) > 1){//eğer grafik göster seçili ise.
			alert("<cf_get_lang no ='1718.Açıklamalara Göre Rapor Almak İçin Tarih Aralığı 1 Gün Olmalıdır'>!");
			return false;
		}	
		if(document.time_cost.is_excel.checked==false)
		{
			document.time_cost.action="<cfoutput>#request.self#?fuseaction=report.time_cost_report</cfoutput>";
			return true;
		}
		else
			document.time_cost.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_time_cost_report</cfoutput>";
	}
	function show_graph(report_t_id){
		if(report_t_id == 1 || report_t_id == 9){
			goster(shop_graph_);
		}	
		else
			gizle(shop_graph_);	
		if(report_t_id == 10 || report_t_id == 11 || report_t_id == 12){
			document.getElementById('item-form_ul_workgroup_id').style.display="";
		}	
		else
			document.getElementById('item-form_ul_workgroup_id').style.display="none";
	}
	function showDepartment(branch_id)	
		{
			var branch_id = document.time_cost.branch_id.value;
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popupajax_list_departments&branch_id="+branch_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
			}
			else
			{
				var myList = document.time_cost.department;
				myList.options.length = 0;
				var txtFld = document.createElement("option");
				txtFld.value='';
				txtFld.appendChild(document.createTextNode('<cf_get_lang_main no="322.Seçiniz">'));
				myList.appendChild(txtFld);
			}
			
		}
	function show_help_filters()
	{
		if(document.getElementById('is_cus_help').checked == true) 
		{
			if(document.getElementById('is_service_relation') != undefined) document.getElementById('is_service_relation').checked = false;
			document.getElementById('help_catagories_title').style.display="";
			document.getElementById('help_catagories_select').style.display="";
			document.getElementById('help_special_def_title').style.display="";
			document.getElementById('help_special_def_select').style.display="";				
		}
		else
		{
			document.getElementById('help_catagories_title').style.display="none";
			document.getElementById('help_catagories_select').style.display="none";
			document.getElementById('help_special_def_title').style.display="none";
			document.getElementById('help_special_def_select').style.display="none";
		}
	}
	function show_service_filters()
	{
		if(document.getElementById('is_service_relation').checked == true)
		{
			if(document.getElementById('is_cus_help') != undefined) document.getElementById('is_cus_help').checked = false;
			document.getElementById('help_catagories_title').style.display="none";
			document.getElementById('help_catagories_select').style.display="none";
			document.getElementById('help_special_def_title').style.display="none";
			document.getElementById('help_special_def_select').style.display="none";
		}
	}
</script>
