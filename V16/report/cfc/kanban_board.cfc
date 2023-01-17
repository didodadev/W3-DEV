<!---
    File: kanban_board.cfc
    Author: Esma R. UYSAL<esmauysal@workcube.com>
    Description:
        Kanban Tahtası Fonsiyonlarını içerir.
--->
<cfcomponent displayname="Board"  hint="Kanban Board">
  <cfset dsn = application.systemParam.systemParam().dsn>
  <!--- Update Stage --->
  <cffunction name="query_Fonksiyon"  hint="" access="remote">
      <cfargument name="pro_work_ID" default="">
      <cfargument name="new_currency_ID"  default="">
      <cfargument name="milestone_work_id"  default="">
      <cfargument name="type"  default="0">
      <cfargument name="employee_type"  default="">
      <cfargument name="partner_cmp_id"  default="">
      <cfargument name="new_emp_id"  default="0">
      <cfquery name="board_column" datasource="#dsn#" result="aaa">
          UPDATE 
              PRO_WORKS
          SET 
            <cfif arguments.type eq 0> 
              WORK_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.new_currency_ID#">
            <cfelseif len(arguments.milestone_work_id) and arguments.type eq 1>
              MILESTONE_WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.milestone_work_id#">
            <cfelseif arguments.type eq 2 and employee_type eq 1>
              PROJECT_EMP_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.new_emp_id#">
            <cfelseif arguments.type eq 2 and employee_type eq 2>
              CONSUMER_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.new_emp_id#">
            <cfelseif arguments.type eq 2 and employee_type eq 3>
              OUTSRC_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.new_emp_id#">,
              OUTSRC_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_cmp_id#">
            <cfelse>
              MILESTONE_WORK_ID = NULL
            </cfif>
          WHERE   
              WORK_ID = #evaluate('arguments.pro_work_ID')# 
      </cfquery>
      <cfreturn arguments>
  </cffunction>
  <cffunction name="GET_PROCESS_TYPES" access="public" returntype="any">
      <cfquery name="GET_PROCESS_TYPES" datasource="#dsn#">
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
              PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.works%">
          ORDER BY
              PTR.PROCESS_ID DESC,
              PTR.LINE_NUMBER
      </cfquery>
      <cfreturn  GET_PROCESS_TYPES>
  </cffunction> 
  <cffunction name="GET_PROJECT_MILESTONE" access="public" returntype="any">
    <cfargument  name="project_id" default="">
    <cfquery name="GET_PROJECT_MILESTONE" datasource="#dsn#">
      SELECT 
        WORK_ID,
        WORK_HEAD
      FROM 
        PRO_WORKS
      WHERE
        PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
        AND IS_MILESTONE = 1
    </cfquery>
    <cfreturn  GET_PROJECT_MILESTONE>
  </cffunction> 
  <cffunction name="GET_EMPLOYEE_TASK" access="public" returntype="any">
    <cfargument  name="project_id" default="">
    <cfargument  name="roles_id" default="">
    <cfquery name="GET_EMPLOYEE_TASK" datasource="#dsn#">
      SELECT 
        DISTINCT 
        WEP.PARTNER_ID,
        WEP.EMPLOYEE_ID,
        WEP.CONSUMER_ID
      FROM 
        WORK_GROUP WG
          INNER JOIN WORKGROUP_EMP_PAR WEP ON WG.WORKGROUP_ID = WEP.WORKGROUP_ID 
      WHERE
        WG.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
        AND WEP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
        <cfif len(arguments.roles_id)>
          AND WEP.ROLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.roles_id#">
        </cfif>
    </cfquery>
    <cfreturn  GET_EMPLOYEE_TASK>
  </cffunction> 

  <cffunction name="GET_ROLES" access="public" returntype="any">
    <cfquery name="GET_ROLES" datasource="#dsn#">
      SELECT * FROM SETUP_PROJECT_ROLES ORDER BY PROJECT_ROLES
    </cfquery>
    <cfreturn  GET_ROLES>
  </cffunction> 
  <cffunction name="GET_PRO_WORKS" access="public" returntype="any">
      <cfargument  name="work_cat" default="">
      <cfargument  name="currency" default="">
      <cfargument  name="priority_cat" default="">
      <cfargument  name="activity_id" default="">
      <cfargument  name="workgroup_id" default="">
      <cfargument  name="work_status" default="">
      <cfargument  name="time_interval" default="">
      <cfargument  name="search_date1" default="">
      <cfargument  name="search_date2" default="">
      <cfargument  name="pro_employee" default="">
      <cfargument  name="pro_employee_id" default="">
      <cfargument  name="is_milestone" default="">
      <cfargument  name="process_row_id" default="">
      <cfargument  name="project_id" default="">
      <cfargument  name="project_head" default="">
      <cfargument  name="work_id" default="">
      <cfargument  name="is_free" default="0">
      <cfargument  name="employee_id" default="">
      <cfargument  name="partner_id" default="">
      <cfargument  name="consumer_id" default="">
      <cfargument  name="day_type" default="">
      <cfif arguments.time_interval eq 1>
        <cfset firstdayofmonth = CREATEODBCDATETIME(CREATEDATE(year(now()),month(now()),1))>
        <cfset lastdayofmonth = CREATEODBCDATETIME(CREATEDATE(year(now()),month(now()),daysinmonth(now())))>
      <cfelseif arguments.time_interval eq 0>
          <cfset firstDay= DateAdd("d", "-#DayOfWeek(Now()) -2#", Now())>
          <cfset seventhday = DateAdd('d',6,firstday)>
          <cfset seventhday = CreateDateTime(year(seventhday),month(seventhday),day(seventhday),23,59,0)>
      </cfif>
      <cfquery name="GET_PRO_WORKS" datasource="#dsn#">
          SELECT
              PRO_WORKS.WORK_ID,
              PRO_WORKS.WORK_HEAD,
              PWC.WORK_CAT,
              SA.ACTIVITY_NAME,
              PRO_WORKS.TERMINATE_DATE,
              EMP.EMPLOYEE_NAME,
              EMP.EMPLOYEE_SURNAME,
              PRO_WORKS.WORK_PRIORITY_ID,
              PRO_WORKS.TO_COMPLETE,
              SP.COLOR,
              PRO_WORKS.TARGET_START,
              SP.PRIORITY,
              PRO_WORKS.IS_MILESTONE,
              (SELECT SUM((ISNULL(TOTAL_TIME_HOUR,0)*60) + ISNULL(TOTAL_TIME_MINUTE,0)) FROM PRO_WORKS_HISTORY WHERE PRO_WORKS.WORK_ID = PRO_WORKS_HISTORY.WORK_ID GROUP BY WORK_ID)  HARCANAN_DAKIKA,
              (SELECT   
                  CASE 
                      WHEN E.PHOTO IS NOT NULL AND LEN(E.PHOTO) > 0 
                          THEN '/documents/hr/'+E.PHOTO 
                      WHEN E.PHOTO IS NULL AND ED.SEX = 0
                          THEN  '/images/female.jpg'
                  ELSE '/images/male.jpg' END AS AA
              FROM 
                  EMPLOYEES E,
                  EMPLOYEES_DETAIL ED
              WHERE  
                  E.EMPLOYEE_ID =   PRO_WORKS.PROJECT_EMP_ID
                  AND ED.EMPLOYEE_ID = E.EMPLOYEE_ID
              ) AS PHOTO
          FROM  
            PRO_WORKS 
            LEFT JOIN SETUP_PRIORITY SP ON SP.PRIORITY_ID = PRO_WORKS.WORK_PRIORITY_ID 
            LEFT JOIN SETUP_ACTIVITY SA ON SA.ACTIVITY_ID = PRO_WORKS.ACTIVITY_ID 
            LEFT JOIN EMPLOYEES EMP ON EMP.EMPLOYEE_ID = PRO_WORKS.PROJECT_EMP_ID
            LEFT JOIN PRO_WORK_CAT PWC ON PWC.WORK_CAT_ID = PRO_WORKS.WORK_CAT_ID
          WHERE 
            1 = 1
            <cfif isdefined("arguments.PROCESS_ROW_ID") and len(arguments.PROCESS_ROW_ID)>
              AND WORK_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PROCESS_ROW_ID#">
            <cfelseif len(arguments.work_id)>
              AND MILESTONE_WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#">
            <cfelseif len(arguments.is_free) and arguments.is_free eq 1>
              AND MILESTONE_WORK_ID IS NULL AND IS_MILESTONE <> 1
            </cfif>
            <cfif isdefined("arguments.work_cat") and len(arguments.work_cat)>
              AND PRO_WORKS.WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_cat#">
            </cfif>
            <cfif  isdefined("arguments.currency") and len(arguments.currency)>
              AND PRO_WORKS.WORK_CURRENCY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.currency#" list="yes">)
            </cfif>
            <cfif isdefined("arguments.priority_cat") and len(arguments.priority_cat)>
              AND PRO_WORKS.WORK_PRIORITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.priority_cat#">
            </cfif>
            <cfif isdefined("arguments.activity_id") and len(arguments.activity_id)>
              AND PRO_WORKS.ACTIVITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.activity_id#">
            </cfif>
            <cfif isdefined("arguments.workgroup_id") and len(arguments.workgroup_id)>
              AND PRO_WORKS.WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workgroup_id#">
            </cfif>
            <cfif arguments.work_status eq -1>
              AND PRO_WORKS.WORK_STATUS = 0 
            <cfelseif arguments.work_status eq 1>
              AND PRO_WORKS.WORK_STATUS = 1 
            </cfif>
            <cfif arguments.time_interval eq -1 and arguments.day_type eq 0>
              AND PRO_WORKS.TARGET_START > #dateadd('d',-1,now())# and PRO_WORKS.TARGET_FINISH < #dateadd('d',1,now())#
            <cfelseif arguments.time_interval eq 0 and arguments.day_type eq 0>
              AND  PRO_WORKS.TARGET_START > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#firstday#">  and PRO_WORKS.TARGET_FINISH <  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#firstday#"> 
            <cfelseif arguments.time_interval eq 1 and arguments.day_type eq 0>
              AND PRO_WORKS.TARGET_START > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#firstdayofmonth#"> and PRO_WORKS.TARGET_FINISH <  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lastdayofmonth#">
            <cfelseif arguments.time_interval eq -1 and arguments.day_type eq 1>
              AND PRO_WORKS.TERMINATE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',-1,now())#"> and PRO_WORKS.TERMINATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,now())#"> 
            <cfelseif arguments.time_interval eq 0 and arguments.day_type eq 1>
              AND  PRO_WORKS.TERMINATE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#firstday#">  and PRO_WORKS.TERMINATE_DATE <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#seventhday#"> 
            <cfelseif arguments.time_interval eq 1 and arguments.day_type eq 1>
              AND PRO_WORKS.TERMINATE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#firstdayofmonth#"> and PRO_WORKS.TERMINATE_DATE <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lastdayofmonth#">
            </cfif>
            <cfif len(arguments.search_date1)>
              AND  PRO_WORKS.TARGET_START >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.search_date1#">
            </cfif>
            <cfif len(arguments.search_date2) and arguments.day_type eq 0>
              AND  PRO_WORKS.TARGET_FINISH <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.search_date2#">
            <cfelseif len(arguments.search_date2) and arguments.day_type eq 1>
              AND PRO_WORKS.TERMINATE_DATE <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.search_date2#">
            </cfif>
            <cfif Len(arguments.pro_employee_id) and Len(arguments.pro_employee)>
              AND PRO_WORKS.PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pro_employee_id#">
            </cfif>
            <cfif Len(arguments.project_head) and Len(arguments.project_id)>
              AND PRO_WORKS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
            </cfif>
            <cfif arguments.is_milestone eq 1>
              AND PRO_WORKS.IS_MILESTONE <> 1	
            </cfif>
            <cfif len(arguments.employee_id)>
              AND PRO_WORKS.PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
            <cfelseif len(arguments.consumer_id)>
              AND PRO_WORKS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
            <cfelseif len(arguments.partner_id)>
              AND PRO_WORKS.OUTSRC_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
            </cfif>
            <cfif (isdefined('xml_is_all_authorization') and len(xml_is_all_authorization) and not listfind(xml_is_all_authorization,session.ep.position_code,','))>
              AND (
                    PRO_WORKS.PROJECT_EMP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                    OR PRO_WORKS.RECORD_AUTHOR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                    OR PRO_WORKS.WORK_ID IN (SELECT WORK_ID FROM PRO_WORKS_CC WHERE CC_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">)
                  )
          </cfif>
          ORDER BY 
          TARGET_START desc
        </cfquery>
      <cfreturn  GET_PRO_WORKS>
  </cffunction>
  <cffunction name="ADD_WORK" access="remote" returntype="any">
    <cfargument  name="work_head" default="">
    <cfargument  name="work_detail" default="">
    <cfargument  name="pro_employee_id" default="">
    <cfargument  name="terminate_date" default="">
    <cfargument  name="work_currency" default=""> 
    <cfargument  name="process_id" default="">
    <cfargument  name="process_stage" default="">
    <cfargument  name="milestone_id" default="">
    <cfargument  name="terminate_hour" default="">
    <cfargument  name="project_id" default="">
    <cfargument  name="work_cat" default="">
    <cfargument  name="total_time" default="">
    <cfargument  name="priority_cat" default="">
    <cfargument  name="workgroup_id" default="">
    <cfargument  name="about_company" default="">
    <cfargument  name="company_partner_id" default="">
    <cfargument  name="company_id" default="">
    <cfargument  name="activity_type" default="">
    <cfargument  name="startdate_plan" default="">
    <cfargument  name="finishdate_plan" default="">
    <cfargument  name="expected_budget" default="">
    <cfargument  name="expected_budget_money" default="">
    <cfargument  name="amount_unit" default="">
    <cfargument  name="average_amount" default="">
    <cfargument  name="special_definition" default="">
    <cfargument  name="work_no" default="">
    <cfargument  name="start_hour" default="">
    <cfargument  name="finish_hour_plan" default="">
    <cfargument  name="work_fuse" default="">
    <cf_date tarih="arguments.terminate_date">
    <cf_date tarih="arguments.startdate_plan">
    <cf_date tarih="arguments.finishdate_plan">
    <cfif len(arguments.process_id)>
      <cfset work_currency = arguments.process_id>
    <cfelse>
      <cfset work_currency = arguments.process_stage>
    </cfif>
    <cfset arguments.terminate_date=dateadd("h",arguments.terminate_hour - session.ep.time_zone, arguments.terminate_date)>
    <cfset arguments.startdate_plan=dateadd("h",arguments.start_hour - session.ep.time_zone, arguments.startdate_plan)>
    <cfset arguments.finishdate_plan=dateadd("h",arguments.finish_hour_plan - session.ep.time_zone, arguments.finishdate_plan)>
    <cfquery name="ADD_WORK" datasource="#DSN#" result="MAX_ID">
      INSERT INTO
        PRO_WORKS
        (
          WORK_HEAD,
          WORK_DETAIL,
          TERMINATE_DATE,
          WORK_CURRENCY_ID,
          MILESTONE_WORK_ID,
          PROJECT_EMP_ID,
          RECORD_DATE,
          RECORD_IP,
          PROJECT_ID,
          WORK_CAT_ID,
          ESTIMATED_TIME,
          WORK_PRIORITY_ID,
          WORKGROUP_ID,
          COMPANY_ID,
          COMPANY_PARTNER_ID,
          CONSUMER_ID,
          ACTIVITY_ID,
          TARGET_START,
          TARGET_FINISH,
          EXPECTED_BUDGET,
          EXPECTED_BUDGET_MONEY,
          AVERAGE_AMOUNT,
          AVERAGE_AMOUNT_UNIT,
          SPECIAL_DEFINITION_ID,
          WORK_NO,
          WORK_CIRCUIT,
          WORK_FUSEACTION
        )
        VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.work_head#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.work_detail#">, 
          <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.terminate_date#">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_currency#">,
          <cfif len(arguments.milestone_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.milestone_id#"><cfelse>NULL</cfif>,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pro_employee_id#">,
          <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
          <cfif len(arguments.project_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"><cfelse>NULL</cfif>,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_cat#">,
          <cfif isdefined("total_time") and len(total_time)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.total_time#"><cfelse>NULL</cfif>,
          <cfif isdefined("arguments.priority_cat") and len(arguments.priority_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.priority_cat#"><cfelse>NULL</cfif>,
          <cfif isdefined("arguments.workgroup_id") and len(arguments.workgroup_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workgroup_id#"><cfelse>NULL</cfif>,
          <cfif len(arguments.company_id) and len(arguments.company_partner_id)>
            #arguments.company_id#,
            #arguments.company_partner_id#,
            NULL,
          <cfelseif not len(arguments.company_id) and len(arguments.company_partner_id)>
            NULL,
            NULL,
            #arguments.company_partner_id#,
          <cfelse>
            NULL,
            NULL,
            NULL,
          </cfif>
          <cfif isdefined('arguments.activity_type') and len(arguments.activity_type)>#arguments.activity_type#<cfelse>NULL</cfif>,
          <cfif isdefined('arguments.startdate_plan')>#arguments.startdate_plan#<cfelse>NULL</cfif>,
          <cfif isdefined('arguments.finishdate_plan')>#arguments.finishdate_plan#<cfelse>NULL</cfif>,
          <cfif isdefined("arguments.expected_budget") and len(arguments.expected_budget)>#replace(expected_budget,",","","all")#<cfelse>NULL</cfif>,
          <cfif isdefined("arguments.expected_budget_money") and len(arguments.expected_budget_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#expected_budget_money#"><cfelse>NULL</cfif>,
          <cfif isdefined('arguments.average_amount') and len(arguments.average_amount)>#arguments.average_amount#<cfelse>NULL</cfif>,
          <cfif isdefined('arguments.amount_unit') and len(arguments.amount_unit)>#arguments.amount_unit#<cfelse>NULL</cfif>,
          <cfif isdefined("arguments.special_definition") and len(arguments.special_definition)>#arguments.special_definition#<cfelse>NULL</cfif>,
          <cfif isDefined("arguments.work_no") and len(arguments.work_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.work_no#"><cfelse>NULL</cfif>,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#listfirst(arguments.work_fuse,".")#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#listlast(arguments.work_fuse,".")#">
        )
    </cfquery>
          <cf_wrk_get_history  datasource='#dsn#' source_table='PRO_WORKS' target_table='PRO_WORKS_HISTORY' record_id='#MAX_ID.IDENTITYCOL#' record_name='WORK_ID' insert_column_name="UPDATE_AUTHOR,UPDATE_DATE" insert_column_value="#session.ep.userid#,#now()#">
    <cfreturn 1>
  </cffunction> 
</cfcomponent>