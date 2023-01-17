<cf_xml_page_edit fuseact="report.emp_daily_in_out">
<cfif not isDefined("xml_additional_minute") or not len (xml_additional_minute)>
    <cfset xml_additional_minute = 0>
</cfif>

<cfsetting showdebugoutput="no">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.employee_name" default="" />
<cfparam name="attributes.employee_id" default="" />
<cfparam name="attributes.report_type" default="" />
<cfparam name="attributes.days_type" default="1">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.start_date" default="#dateformat(now(),dateformat_style)#">
<cfif len(attributes.start_date) and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfparam name="attributes.finish_date" default="#dateformat(now(),dateformat_style)#">
<cfif len(attributes.finish_date) and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif>
<cfif len(attributes.employee_id) and find("_", attributes.employee_id) neq 0>
    <cfset attributes.employee_id = listfirst(attributes.employee_id,'_')>
</cfif>

<cfset cmp_branch = createObject("component","V16.hr.cfc.get_branch_comp")>
<cfset cmp_branch.dsn = dsn>
<cfset get_branches = cmp_branch.get_branch(branch_status:1,comp_id : session.ep.company_id, ehesap_control : 1)>
<cfset cmp_department = createObject("component","V16.hr.cfc.get_departments")>
<cfset cmp_department.dsn = dsn>
<cfset get_department = cmp_department.get_department(branch_id : attributes.branch_id)>
<cfset cmp_pos_cat = createObject("component","V16.hr.cfc.get_position_cat")>
<cfset cmp_pos_cat.dsn = dsn>
<cfset get_position_cats = cmp_pos_cat.get_position_cat()>
<cfset cmp_org_step = createObject("component","V16.hr.cfc.get_organization_steps")>
<cfset cmp_org_step.dsn = dsn>
<cfset days_name = "">
<cfquery name="GET_OFFTIME_CATS" datasource="#DSN#">
	SELECT OFFTIMECAT,OFFTIMECAT_ID,IS_PUANTAJ_OFF FROM SETUP_OFFTIME WHERE IS_ACTIVE = 1 AND UPPER_OFFTIMECAT_ID = 0 ORDER BY OFFTIMECAT_ID
</cfquery>
<cfif isdefined("attributes.paper_submit") and len(attributes.paper_submit) and attributes.paper_submit eq 1>
    <cfif isDefined("attributes.offtime_check") and Listlen(attributes.offtime_check) gt 0>
		<cfset totalValues = structNew()>
		<cfset totalValues = {
				total_offtime : 0
			}>
        <cfif IsDefined('attributes.comp_id') and len(attributes.comp_id)>
            <cfset url_str="#url_str#&comp_id=#attributes.comp_id#">
        </cfif>
		<cfset action_id_list="">
        <cfloop list = "#attributes.offtime_check#" item = "employee_ids" delimiters=",">
            <cfset employee_id = listFirst(employee_ids,"&")>
            <cfset in_out_id = listGetAt(employee_ids,2,"&")>
            <cfset startdate = listGetAt(employee_ids,3,"&")>
            <cfset startdate = date_add("h",-session.ep.time_zone, startdate)>
            <cfset finishdate = listLast(employee_ids,"&")>
            <cfset finishdate = date_add("h",-session.ep.time_zone, finishdate)>
            <cfset work_startdate = dateAdd("n",1,finishdate)>
            <cfset work_startdate = date_add("h",-session.ep.time_zone, work_startdate)>
            <cfset action_id_list = ListAppend(action_id_list,employee_id)>
            <cfquery name="add_offtime" datasource="#dsn#" result="MAX_ID">
                INSERT INTO
                OFFTIME
                (
                    IN_OUT_ID,
                    RECORD_IP,
                    RECORD_EMP,
                    RECORD_DATE,
                    IS_PUANTAJ_OFF,
                    EMPLOYEE_ID,
                    OFFTIMECAT_ID,
                    SUB_OFFTIMECAT_ID,
                    STARTDATE,
                    FINISHDATE,
                    WORK_STARTDATE,
                    TOTAL_HOURS,
                    DETAIL,
                    OFFTIME_STAGE
                )
                VALUES
                (
                    <cfif len(in_out_id)> <!---GET_OFFTIME_CAT.EBILDIRGE_TYPE_ID is '06' and --->
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#in_out_id#">,
                    <cfelse>
                        NULL,
                    </cfif>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfif isdefined("attributes.is_puantaj_off")>1,<cfelse>0,</cfif>
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offtimecat_id#">,
                    <cfif isdefined("attributes.SUB_OFFTIMECAT_ID") and len(attributes.SUB_OFFTIMECAT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sub_offtimecat_id#"><cfelse>0</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#finishdate#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#work_startdate#">,
                    0,
                    <cfif len(attributes.general_paper_notice)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.general_paper_notice#"><cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.process_stage') and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>
                )
            </cfquery> 
        </cfloop>
        
		<cf_workcube_general_process
			mode = "query"
			general_paper_parent_id = "#(isDefined("attributes.general_paper_parent_id") and len(attributes.general_paper_parent_id)) ? attributes.general_paper_parent_id : 0#"
			general_paper_no = "#attributes.general_paper_no#"
			general_paper_date = "#attributes.general_paper_date#"
			action_list_id = "#action_id_list#"
			process_stage = "#attributes.process_stage#"
			general_paper_notice = "#attributes.general_paper_notice#"
			responsible_employee_id = "#(isDefined("attributes.responsible_employee_id") and len(attributes.responsible_employee_id) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_id : 0#"
			responsible_employee_pos = "#(isDefined("attributes.responsible_employee_pos") and len(attributes.responsible_employee_pos) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_pos : 0#"
			action_table = 'OFFTIME'
			action_column = 'OFFTIME_ID'
			action_page = '#request.self#?fuseaction=report.emp_daily_in_out'
			total_values = '#totalValues#'
		>
        <cfset attributes.paper_submit = 0>
	</cfif>
</cfif>
<cfloop from="1" to="7" index="c">
    <cfif c eq 1><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57610.Pazar"></cfsavecontent>
	<cfelseif c eq 2><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57604.Pazartesi"></cfsavecontent>
	<cfelseif c eq 3><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57605.Salı"></cfsavecontent>
	<cfelseif c eq 4><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57606.Çarşamba"></cfsavecontent>
	<cfelseif c eq 5><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57607.Perşembe"></cfsavecontent>
	<cfelseif c eq 6><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57608.Cuma"></cfsavecontent>
	<cfelseif c eq 7><cfsavecontent variable="day_name"><cf_get_lang dictionary_id = "57609.Cumartesi"></cfsavecontent>
	</cfif>
	<cfset days_name = listappend(days_name,'#day_name#')>
</cfloop>

<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset get_finish_am_hour_info = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_add_offtime_popup',
    property_name : 'finish_am_hour_info'
)>
<cfif get_finish_am_hour_info.recordcount>
    <cfset finish_am_hour_info = get_finish_am_hour_info.property_value>
<cfelse>
    <cfset finish_am_hour_info = 0>
</cfif>
<cfset get_finish_am_min_info = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_add_offtime_popup',
    property_name : 'finish_am_min_info'
)>
<cfif get_finish_am_min_info.recordcount>
    <cfset finish_am_min_info = get_finish_am_min_info.property_value>
<cfelse>
    <cfset finish_am_min_info = 0>
</cfif>
<cfset get_start_pm_hour_info = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_add_offtime_popup',
    property_name : 'start_pm_hour_info'
)>
<cfif get_start_pm_hour_info.recordcount>
    <cfset start_pm_hour_info = get_start_pm_hour_info.property_value>
<cfelse>
    <cfset start_pm_hour_info = 0>
</cfif>
<cfset get_start_pm_min_info = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_add_offtime_popup',
    property_name : 'start_pm_min_info'
)>
<cfif get_start_pm_min_info.recordcount>
    <cfset start_pm_min_info = get_start_pm_min_info.property_value>
<cfelse>
    <cfset start_pm_min_info = 0>
</cfif>
<cfset sabah_bitis = timeformat('#finish_am_hour_info#:#finish_am_min_info#','HH:mm')><!--- sabah mesaisi bitiş ---> 
<cfset oglen_baslangic = timeformat('#start_pm_hour_info#:#start_pm_min_info#','HH:mm')><!--- Öğle mesaisi Başlangıç --->
<cfset ogle_arasi_dk = datediff("n",sabah_bitis,oglen_baslangic)><!--- öğle arası dk --->

<cfif isdefined('attributes.is_form_submit')>
    <cfset date_diff = dateDiff('d',attributes.start_date,attributes.finish_date)>
    <cfquery name="get_data" datasource="#dsn#">
        SELECT
            PT.*,
            WFR.FLEXIBLE_DATE,
            WFR.FLEXIBLE_YEAR,
            WFR.FLEXIBLE_MONTH,
            WFR.FLEXIBLE_DAY,
            WFR.FLEXIBLE_START_HOUR,
            WFR.FLEXIBLE_START_MINUTE,
            WFR.FLEXIBLE_FINISH_HOUR,
            WFR.FLEXIBLE_FINISH_MINUTE,
            DATEADD(hour, #session.ep.time_zone#, O.STARTDATE) AS OFFTIME_STARTDATE,
            DATEADD(hour, #session.ep.time_zone#, O.FINISHDATE) AS OFFTIME_FINISHDATE,
            DATEADD(hour, #session.ep.time_zone#, O.WORK_STARTDATE) AS OFFTIME_WORK_STARTDATE,
            CASE 
                WHEN ISNULL(O.SUB_OFFTIMECAT_ID,0) <> 0 THEN (SELECT top 1 OFFTIMECAT FROM SETUP_OFFTIME A WHERE A.OFFTIMECAT_ID = O.SUB_OFFTIMECAT_ID)
                WHEN ISNULL(O.SUB_OFFTIMECAT_ID,0) = 0 THEN (SELECT top 1  OFFTIMECAT FROM SETUP_OFFTIME B WHERE B.OFFTIMECAT_ID = O.OFFTIMECAT_ID)
            END AS OFFTIME_CAT_NAME
        FROM
        (
            SELECT
                E.EMPLOYEE_ID,
                E.EMPLOYEE_NAME,
                E.EMPLOYEE_SURNAME,
                E.EMPLOYEE_NO,
                EIO.IN_OUT_ID,
                D.DEPARTMENT_ID,
                D.DEPARTMENT_HEAD,
                D.BRANCH_ID,
                B.BRANCH_NAME,
                DATEADD(MINUTE, #-xml_additional_minute#, EDIO.START_DATE) AS ADD_START_DATE,
                DATEADD(MINUTE, #xml_additional_minute#, EDIO.FINISH_DATE) AS ADD_FINISH_DATE,
                EDIO.START_DATE,
                EDIO.FINISH_DATE,
                ST.TITLE,
                B2.BRANCH_NAME AS IN_OUT_BRANCH_NAME,
                OCH.START_HOUR,
                OCH.START_MIN,
                OCH.END_HOUR,
                OCH.END_MIN,
                XT.XTARIH,
                SPC.POSITION_CAT,
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
                EMPLOYEES E
                LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
                LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
                LEFT JOIN BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
                LEFT JOIN SETUP_TITLE ST ON ST.TITLE_ID = EP.TITLE_ID
                LEFT JOIN SETUP_POSITION_CAT SPC ON SPC.POSITION_CAT_ID = EP.POSITION_CAT_ID
                CROSS JOIN (
                    <cfloop from="0" to="#date_diff#" index="i">
                        SELECT CAST(#DateAdd('d',i,attributes.start_date)# AS DATE) XTARIH
                        <cfif i lt date_diff>UNION ALL</cfif>
                    </cfloop>
                ) AS XT
                LEFT JOIN EMPLOYEE_DAILY_IN_OUT EDIO ON EDIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND ISNULL(EDIO.FROM_HOURLY_ADDFARE,0) = 0
                    AND YEAR(EDIO.START_DATE) = YEAR(XT.XTARIH)
                    AND MONTH(EDIO.START_DATE) = MONTH(XT.XTARIH)
                    AND DAY(EDIO.START_DATE) = DAY(XT.XTARIH)
                LEFT JOIN EMPLOYEES_IN_OUT EIO ON EIO.EMPLOYEE_ID = EDIO.EMPLOYEE_ID
                LEFT JOIN BRANCH B2 ON B2.BRANCH_ID = EDIO.BRANCH_ID
                LEFT JOIN OUR_COMPANY_HOURS OCH ON OCH.OUR_COMPANY_ID = B.COMPANY_ID
            WHERE
                EP.IS_MASTER = 1 AND EP.POSITION_STATUS = 1
                AND E.EMPLOYEE_STATUS = 1
                AND EIO.FINISH_DATE IS NULL
                <cfif len(attributes.branch_id)>
                    AND D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
                <cfelseif not session.ep.ehesap>
                    AND D.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
                </cfif>
                <cfif len(attributes.department_id)>
                    AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                </cfif>
                <cfif len(attributes.employee_name) and len(attributes.employee_id)>
                    AND E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
                </cfif>
                <cfif len(attributes.days_type) and attributes.days_type eq 2>
                    AND DATEPART(WEEKDAY, XT.XTARIH) NOT IN (1,7)
                </cfif>
                <cfif len(attributes.position_cat_id)>
                    AND EP.POSITION_CAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_cat_id#" list="true">)
                </cfif>
        ) PT
        LEFT OUTER JOIN WORKTIME_FLEXIBLE_ROW WFR ON (WFR.IS_APPROVE != -1 OR WFR.IS_APPROVE IS NULL) AND
            (
                (
                    YEAR(WFR.FLEXIBLE_DATE) = YEAR(PT.XTARIH) AND
                    MONTH(WFR.FLEXIBLE_DATE) = MONTH(PT.XTARIH) AND
                    DAY(WFR.FLEXIBLE_DATE) = DAY(PT.XTARIH)
                )
                OR
                (
                    WFR.FLEXIBLE_YEAR = YEAR(PT.XTARIH) AND
                    WFR.FLEXIBLE_MONTH = MONTH(PT.XTARIH) AND
                    WFR.FLEXIBLE_DAY = DATEPART(dw,PT.XTARIH)
                )
            ) AND PT.EMPLOYEE_ID = (SELECT WF.EMPLOYEE_ID FROM WORKTIME_FLEXIBLE WF WHERE WF.WORKTIME_FLEXIBLE_ID = WFR.WORKTIME_FLEXIBLE_ID)
        LEFT OUTER JOIN OFFTIME O ON O.EMPLOYEE_ID = PT.EMPLOYEE_ID AND (O.VALID IS NOT NULL AND O.VALID = 1) AND
            (
                CAST(O.STARTDATE AS DATE) <= CAST(PT.XTARIH AS DATE) AND
                CAST(O.FINISHDATE AS DATE) >= CAST(PT.XTARIH AS DATE) AND
                CAST(O.WORK_STARTDATE AS DATE) >= CAST(PT.XTARIH AS DATE)
            )
        WHERE
                1 = 1
            <cfif len(attributes.report_type) and attributes.report_type eq 1>
                AND PT.START_DATE IS NULL AND
                PT.FINISH_DATE IS NULL AND
                O.STARTDATE IS NULL AND
                O.FINISHDATE IS NULL
            <cfelseif len(attributes.report_type) and attributes.report_type eq 2>
                AND PT.START_DATE IS NOT NULL AND
                PT.FINISH_DATE IS NOT NULL AND
                (
                    (
                        WFR.FLEXIBLE_START_HOUR IS NOT NULL AND WFR.FLEXIBLE_START_MINUTE IS NOT NULL AND
                        (
                            (
                                DATEPART(HOUR, DATEADD(MINUTE, #-xml_additional_minute#, PT.START_DATE)) > WFR.FLEXIBLE_START_HOUR
                            )
                            OR
                            (
                                DATEPART(HOUR, DATEADD(MINUTE, #-xml_additional_minute#, PT.START_DATE)) = WFR.FLEXIBLE_START_HOUR AND DATEPART(MINUTE, DATEADD(MINUTE, #-xml_additional_minute#, PT.START_DATE)) > WFR.FLEXIBLE_START_MINUTE
                            )
                        )
                        AND
                        (
                            (
                                O.STARTDATE IS NULL AND O.FINISHDATE IS NULL
                            )
                            OR
                            (
                                O.STARTDATE IS NOT NULL AND O.FINISHDATE IS NOT NULL
                                AND
                                NOT (
                                    (CAST(DATEADD(hour, #session.ep.time_zone#, O.STARTDATE) AS DATETIME) <= CAST(PT.START_DATE AS DATETIME) AND
                                    CAST(DATEADD(hour, #session.ep.time_zone#, O.FINISHDATE) AS DATETIME) >= CAST(PT.START_DATE AS DATETIME)) OR
                                    CAST(DATEADD(hour, #session.ep.time_zone#, O.WORK_STARTDATE) AS DATETIME) >= CAST(PT.START_DATE AS DATETIME)
                                )
                            )
                        )
                    )
                    OR
                    (
                        (
                            DATEPART(HOUR, DATEADD(MINUTE, #-xml_additional_minute#, PT.START_DATE)) > PT.START_HOUR 
                            OR 
                            (DATEPART(HOUR, DATEADD(MINUTE, #-xml_additional_minute#, PT.START_DATE)) = PT.START_HOUR and DATEPART(MINUTE, DATEADD(MINUTE, #-xml_additional_minute#, PT.START_DATE)) > PT.START_MIN)
                        )
                        AND
                        (
                            (
                                O.STARTDATE IS NULL AND O.FINISHDATE IS NULL AND WFR.FLEXIBLE_START_HOUR IS NULL AND WFR.FLEXIBLE_START_MINUTE IS NULL
                            )
                            OR
                            (
                                O.STARTDATE IS NOT NULL AND O.FINISHDATE IS NOT NULL
                                AND
                                NOT (
                                    (CAST(DATEADD(hour, #session.ep.time_zone#, O.STARTDATE) AS DATETIME) <= CAST(PT.START_DATE AS DATETIME) AND
                                    CAST(DATEADD(hour, #session.ep.time_zone#, O.FINISHDATE) AS DATETIME) >= CAST(PT.START_DATE AS DATETIME)) OR
                                    CAST(DATEADD(hour, #session.ep.time_zone#, O.WORK_STARTDATE) AS DATETIME) >= CAST(PT.START_DATE AS DATETIME)
                                )
                            )
                        )
                    )
                )
            <cfelseif len(attributes.report_type) and attributes.report_type eq 3>
                AND PT.START_DATE IS NOT NULL AND
                PT.FINISH_DATE IS NOT NULL AND
                (
                    (
                        WFR.FLEXIBLE_FINISH_HOUR IS NOT NULL AND WFR.FLEXIBLE_FINISH_MINUTE IS NOT NULL AND
                        (
                            (
                                DATEPART(HOUR, DATEADD(MINUTE, #xml_additional_minute#, PT.FINISH_DATE)) < WFR.FLEXIBLE_FINISH_HOUR
                            )
                            OR
                            (
                                DATEPART(HOUR, DATEADD(MINUTE, #xml_additional_minute#, PT.FINISH_DATE)) = WFR.FLEXIBLE_FINISH_HOUR AND DATEPART(MINUTE, DATEADD(MINUTE, #xml_additional_minute#, PT.FINISH_DATE)) < WFR.FLEXIBLE_FINISH_MINUTE
                            )
                        )
                        AND
                        (
                            (
                                O.STARTDATE IS NULL AND O.FINISHDATE IS NULL
                            )
                            OR
                            (
                                O.STARTDATE IS NOT NULL AND O.FINISHDATE IS NOT NULL
                                AND
                                NOT (
                                    CAST(DATEADD(hour, #session.ep.time_zone#, O.STARTDATE) AS DATETIME) <= CAST(PT.FINISH_DATE AS DATETIME) AND
                                    CAST(DATEADD(hour, #session.ep.time_zone#, O.FINISHDATE) AS DATETIME) > CAST(PT.FINISH_DATE AS DATETIME) AND
                                    CAST(DATEADD(hour, #session.ep.time_zone#, O.WORK_STARTDATE) AS DATETIME) > CAST(PT.FINISH_DATE AS DATETIME)
                                )
                            )
                        )
                    )
                    OR
                    (
                        (
                            DATEPART(HOUR, DATEADD(MINUTE, #xml_additional_minute#, PT.FINISH_DATE)) < PT.END_HOUR
                            OR
                            (DATEPART(HOUR, DATEADD(MINUTE, #xml_additional_minute#, PT.FINISH_DATE)) = PT.END_HOUR and DATEPART(MINUTE, DATEADD(MINUTE, #xml_additional_minute#, PT.FINISH_DATE)) < PT.END_MIN)
                        )
                        AND
                        (
                            (
                                O.STARTDATE IS NULL AND O.FINISHDATE IS NULL AND WFR.FLEXIBLE_FINISH_HOUR IS NULL AND WFR.FLEXIBLE_FINISH_MINUTE IS NULL
                            )
                            OR
                            (
                                O.STARTDATE IS NOT NULL AND O.FINISHDATE IS NOT NULL
                                AND
                                NOT (
                                    CAST(DATEADD(hour, #session.ep.time_zone#, O.STARTDATE) AS DATETIME) <= CAST(PT.FINISH_DATE AS DATETIME) AND
                                    CAST(DATEADD(hour, #session.ep.time_zone#, O.FINISHDATE) AS DATETIME) > CAST(PT.FINISH_DATE AS DATETIME) AND
                                    CAST(DATEADD(hour, #session.ep.time_zone#, O.WORK_STARTDATE) AS DATETIME) > CAST(PT.FINISH_DATE AS DATETIME)
                                )
                            )
                        )
                    )
                )
            </cfif>
        ORDER BY
            PT.XTARIH DESC,
            PT.EMPLOYEE_ID
    </cfquery>
<cfelse>
	<cfset get_data.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_data.recordcount#">
<cfsavecontent variable="head"><cf_get_lang dictionary_id='61006.Çalışan Devam Raporu'></cfsavecontent>
<div class="col col-12">
    <cfform name="search_form" method="post" action="#request.self#?fuseaction=report.emp_daily_in_out">
        <cf_report_list_search title="#head#">
            <cf_report_list_search_area>
                <div class="row">
                    <div class="col col-12 col-xs-12">
                        <div class="row formContent">
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group" id="item-employee">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57576.Çalışan"></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>" />
                                            <input type="text" name="employee_name" id="employee_name" placeholder="<cf_get_lang dictionary_id="57576.Çalışan">" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3,9\',\'0\',\'0\',\'0\',\'\',\'\',\'\',\'1\'','EMPLOYEE_ID,MEMBER_TYPE','employee_id','','3','135');" style="width:120px;" value="<cfif isDefined('attributes.employee_name') And Len(attributes.employee_name)><cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput></cfif>" />
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&is_display_self=1&field_emp_id=search_form.employee_id&field_name=search_form.employee_name&field_type=search_form.employee_id&select_list=1,9','list');"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-report_type">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="58960.Rapor tipi"></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="report_type" id="report_type">
                                            <option value=""><cf_get_lang dictionary_id="57708.Tümü"></option>
                                            <option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id="61184.Gelmeyenler"></option>
                                            <option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id="61185.Geç Gelenler"></option>
                                            <option value="3" <cfif attributes.report_type eq 3>selected</cfif>><cf_get_lang dictionary_id="61186.Erken Çıkanlar"></option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group" id="item-organizational_units">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="branch_id" id="branch_id" onChange="showDepartment(this.value)">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_branches" group="NICK_NAME">
                                                <optgroup label="#NICK_NAME#"></optgroup>
                                                <cfoutput>
                                                    <option value="#BRANCH_ID#"<cfif attributes.branch_id eq branch_id>selected</cfif>>#BRANCH_NAME#</option>
                                                </cfoutput>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-weekend">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="31472.Hafta Sonu"></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="days_type" id="days_type">
                                            <option value="1" <cfif attributes.days_type eq 1>selected</cfif>><cf_get_lang dictionary_id="52302.Getir"></option>
                                            <option value="2" <cfif attributes.days_type eq 2>selected</cfif>><cf_get_lang dictionary_id="61347.Getirme"></option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group" id="item-organizational_units">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                                    <div class="col col-12 col-xs-12" id="department_div">
                                        <select name="DEPARTMENT_ID" id="DEPARTMENT_ID"> 
                                            <option value=""><cf_get_lang dictionary_id='57572.Departman'></option>
                                            <cfoutput query="get_department">
                                                <option value="#department_id#" <cfif attributes.department_id eq department_id>selected</cfif>>#department_head#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" id="item-position_cat_id">
                                    <label class="col col-12 col-xs-12"><cf_get_lang_main no='367.Pozisyon Tipleri'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cf_multiselect_check
                                            name="position_cat_id"
                                            option_name="position_cat"
                                            option_value="position_cat_id"
                                            width="130"
                                            value="#attributes.position_cat_id#"
                                            query_name="get_position_cats">
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57742.Tarih'></cfsavecontent>
                                            <cfif len(attributes.start_date) and isdate(attributes.start_date)>
                                                <cfinput type="text" name="start_date" id="start_date" maxlength="10" validate="#validate_style#" message="#message#"  value="#dateformat(attributes.start_date,dateformat_style)#">
                                            <cfelse>
                                                <cfinput type="text" name="start_date" id="start_date" maxlength="10" validate="#validate_style#" message="#message#" >
                                            </cfif>
                                            <span class="input-group-addon">
                                                <cf_wrk_date_image date_field="start_date">
                                            </span>
                                        </div>
                                    </div>
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57742.Tarih'></cfsavecontent>
                                            <cfif len(attributes.finish_date) and isdate(attributes.finish_date)>
                                                <cfinput type="text" name="finish_date" id="finish_date" maxlength="10" validate="#validate_style#" message="#message#"  value="#dateformat(attributes.finish_date,dateformat_style)#">
                                            <cfelse>
                                                <cfinput type="text" name="finish_date" id="finish_date" maxlength="10" validate="#validate_style#" message="#message#" >
                                            </cfif>
                                            <span class="input-group-addon">
                                                <cf_wrk_date_image date_field="finish_date">
                                            </span>
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
                                <input type="hidden" name="is_form_submit" id="is_form_submit" value="1">
                                <cf_wrk_report_search_button button_type='1' is_excel='1' search_function="control()">
                            </div>
                        </div>
                    </div>
                </div>
            </cf_report_list_search_area>
        </cf_report_list_search>
    </cfform>
</div>
<cfif attributes.is_excel eq 1>
	<cfset type_ = 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">
<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.is_form_submit")>
<cfform name="add_offtime_form" method="post" action="#request.self#?fuseaction=report.emp_daily_in_out">
    <div class="col col-12">
        <cf_report_list>
            <cfif attributes.is_excel eq 1>
                <cfset type_ = 1>
                <cfset attributes.startrow = 1>
                <cfset attributes.maxrows = get_data.recordcount>
            <cfelse>
                <cfset type_ = 0>
            </cfif>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='51231.Sicil No'></th>
                    <th><cf_get_lang dictionary_id='55757.Adı Soyadı'></th>
                    <th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id='57572.Departman'></th>
                    <th><cf_get_lang dictionary_id='61009.Giriş Yapılan Şube'></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <th><cf_get_lang dictionary_id='57490.Gün'></th>
                    <th><cf_get_lang dictionary_id='61007.Giriş Saati'></th>
                    <th><cf_get_lang dictionary_id='61008.Çıkış Saati'></th>
                    <th><cf_get_lang dictionary_id='55877.Çalışma Süresi'></th>
                    <th><cf_get_lang dictionary_id='41800.Esnek Çalışma'></th>
                    <th><cf_get_lang dictionary_id='54109.İzin Kategorisi'></th>
                    <th><cf_get_lang dictionary_id='58575.İzin'></th>
                    <th><cf_get_lang dictionary_id='57756.Durum'>( <cf_get_lang dictionary_id='57554.Giriş'>)</th>
                    <th><cf_get_lang dictionary_id='57756.Durum'>( <cf_get_lang dictionary_id='57431.Çıkış'>)</th>
                    <cfif isDefined("x_show_level") and x_show_level eq 1><th><cf_get_lang dictionary_id='62040.Kademeli Departman'></th></cfif>
                    <cfif len(attributes.report_type) and attributes.report_type eq 2><th><input type="checkbox" name="select_all" id="select_all" value="1" onClick="wrk_select_all('select_all','offtime_check');" ></th></cfif>
                <tr>
            </thead>
            <tbody class="text-center">
                <cfif get_data.recordcount>
                    <cfoutput query="get_data" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#" group="EMPLOYEE_ID">
                        <cfset day_start = createDateTime(year(XTARIH),month(XTARIH),day(XTARIH),START_HOUR,START_MIN)>
                        <cfset day_end = createDateTime(year(XTARIH),month(XTARIH),day(XTARIH),END_HOUR,END_MIN)>
                        <tr>
                            <td>#EMPLOYEE_NO#</td>
                            <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                            <td>#POSITION_CAT#</td>
                            <td>#BRANCH_NAME#</td>
                            <td>#DEPARTMENT_HEAD#</td>
                            <td>#IN_OUT_BRANCH_NAME#</td>
                            <td>#dateformat(XTARIH,dateformat_style)#</td>
                            <td>#listGetAt(days_name,dayOfWeek(XTARIH))#</td>
                            <td>
                                <cfif len(START_DATE)>
                                    #timeformat(START_DATE,timeformat_style)#
                                </cfif>
                            </td>
                            <td>
                                <cfif len(FINISH_DATE)>
                                    #timeformat(FINISH_DATE,timeformat_style)#
                                </cfif>
                            </td>
                            <td>
                                <cfif len(START_DATE) and len(FINISH_DATE)>
                                    <cfset giris_saat = timeformat(START_DATE,timeformat_style)>
                                    <cfset cikis_saat = timeformat(FINISH_DATE,timeformat_style)>
                                    <cfif (giris_saat lte sabah_bitis and cikis_saat gte oglen_baslangic) or (giris_saat gt sabah_bitis and cikis_saat lt oglen_baslangic)>
                                        <cfset time_diff = datediff('n',START_DATE,FINISH_DATE)>
                                        <cfset calisma_toplam = time_diff - ogle_arasi_dk>
                                    <cfelse>
                                        <cfif giris_saat gt sabah_bitis and giris_saat lt oglen_baslangic>
                                            <cfset giris_saat = oglen_baslangic>
                                        </cfif>
                                        <cfif cikis_saat lt oglen_baslangic and cikis_saat gt sabah_bitis>
                                            <cfset cikis_saat = sabah_bitis>
                                        </cfif>
                                        <cfset time_diff = datediff('n',giris_saat,cikis_saat)>
                                        <cfset calisma_toplam = time_diff>
                                    </cfif>
                                    <cfset saat_ = int(calisma_toplam / 60)>
                                    <cfset dakika_ = calisma_toplam - (saat_ * 60)>
                                    <cfif saat_ gt 0>#saat_# <cf_get_lang dictionary_id='57491.Saat'></cfif>
                                    <cfif dakika_ gt 0>#dakika_# <cf_get_lang dictionary_id='58127.Dakika'></cfif>
                                </cfif>
                            </td>
                            <td>
                                <cfif len(FLEXIBLE_START_HOUR) and len(FLEXIBLE_START_MINUTE) and len(FLEXIBLE_FINISH_HOUR) and len(FLEXIBLE_FINISH_MINUTE)>
                                    #FLEXIBLE_START_HOUR#:<cfif FLEXIBLE_START_MINUTE lt 10>0</cfif>#FLEXIBLE_START_MINUTE# - #FLEXIBLE_FINISH_HOUR#:<cfif FLEXIBLE_FINISH_MINUTE lt 10>0</cfif>#FLEXIBLE_FINISH_MINUTE#
                                </cfif>
                            </td>
                            <td>
                                <cfif len(OFFTIME_CAT_NAME)>
                                    #OFFTIME_CAT_NAME#
                                </cfif>
                            </td>
                            <td>
                                <cfif len(OFFTIME_STARTDATE) and len(OFFTIME_FINISHDATE)>
                                    #dateformat(OFFTIME_STARTDATE,dateformat_style)# 
                                    #timeformat(OFFTIME_STARTDATE,timeformat_style)# - 
                                    #dateformat(OFFTIME_FINISHDATE,dateformat_style)# 
                                    #timeformat(OFFTIME_FINISHDATE,timeformat_style)#
                                </cfif>
                            </td>
                            <!--- Giriş Kontrol --->
                            <td class="text-center">
                                <cfif len(attributes.report_type) and attributes.report_type eq 1>
                                    Y
                                <cfelseif len(attributes.report_type) and attributes.report_type eq 2>
                                    G
                                <cfelse>
                                    <cfif len(OFFTIME_STARTDATE) and len(OFFTIME_FINISHDATE) and OFFTIME_STARTDATE lte day_start and OFFTIME_FINISHDATE gte day_end>
                                        İ
                                    <cfelse>
                                        <cfif len(START_DATE)><!--- Giriş varsa --->
                                            <cfif len(FLEXIBLE_START_HOUR) and len(FLEXIBLE_START_MINUTE) and len(FLEXIBLE_FINISH_HOUR) and len(FLEXIBLE_FINISH_MINUTE)><!--- Esnek çalışma kontrolü --->
                                                <cfif (hour(ADD_START_DATE) gt FLEXIBLE_START_HOUR) or (hour(ADD_START_DATE) eq FLEXIBLE_START_HOUR and minute(ADD_START_DATE) gt FLEXIBLE_START_MINUTE)>
                                                    <cfif len(OFFTIME_STARTDATE) and ((ADD_START_DATE gte OFFTIME_STARTDATE and ADD_START_DATE lte OFFTIME_FINISHDATE) or ADD_START_DATE lte OFFTIME_WORK_STARTDATE)>
                                                        N
                                                    <cfelse>
                                                        G
                                                    </cfif>
                                                <cfelse>
                                                    N
                                                </cfif>
                                            <cfelse>
                                                <cfif hour(ADD_START_DATE) gt START_HOUR or (hour(ADD_START_DATE) eq START_HOUR and minute(ADD_START_DATE) gt START_MIN)>
                                                    <cfif len(OFFTIME_STARTDATE) and ((ADD_START_DATE gte OFFTIME_STARTDATE and ADD_START_DATE lte OFFTIME_FINISHDATE) or ADD_START_DATE lte OFFTIME_WORK_STARTDATE)>
                                                        N
                                                    <cfelse>
                                                        G
                                                    </cfif>
                                                <cfelse>
                                                    N
                                                </cfif>
                                            </cfif>
                                        <cfelse><!--- Giriş yoksa --->
                                            <cfif len(OFFTIME_STARTDATE)><!--- İzin kontrolü --->
                                                İ
                                            <cfelse>
                                                Y
                                            </cfif>
                                        </cfif>
                                    </cfif>
                                </cfif>
                            </td>
                            <!--- Çıkış Kontrol --->
                            <td class="text-center">
                                <cfif len(attributes.report_type) and attributes.report_type eq 1>
                                    Y
                                <cfelseif len(attributes.report_type) and attributes.report_type eq 3>
                                    E
                                <cfelse>
                                    <cfif len(OFFTIME_STARTDATE) and len(OFFTIME_FINISHDATE) and OFFTIME_STARTDATE lte day_start and OFFTIME_FINISHDATE gte day_end>
                                        İ
                                    <cfelse>
                                        <cfif len(FINISH_DATE)><!--- Çıkış varsa --->
                                            <cfif len(FLEXIBLE_START_HOUR) and len(FLEXIBLE_START_MINUTE) and len(FLEXIBLE_FINISH_HOUR) and len(FLEXIBLE_FINISH_MINUTE)><!--- Esnek çalışma kontrolü --->
                                                <cfif (hour(ADD_FINISH_DATE) lt FLEXIBLE_FINISH_HOUR) or (hour(ADD_FINISH_DATE) eq FLEXIBLE_FINISH_HOUR and minute(ADD_FINISH_DATE) lt FLEXIBLE_FINISH_MINUTE)>
                                                    <cfif len(OFFTIME_STARTDATE) and ADD_FINISH_DATE gte OFFTIME_STARTDATE and ADD_FINISH_DATE lt OFFTIME_FINISHDATE and ADD_FINISH_DATE lt OFFTIME_WORK_STARTDATE>
                                                        N
                                                    <cfelse>
                                                        E
                                                    </cfif>
                                                <cfelse>
                                                    N
                                                </cfif>
                                            <cfelse>
                                                <cfif hour(ADD_FINISH_DATE) lt END_HOUR or (hour(ADD_FINISH_DATE) eq END_HOUR and minute(ADD_FINISH_DATE) lt END_MIN)>
                                                    <cfif len(OFFTIME_STARTDATE) and ADD_FINISH_DATE gte OFFTIME_STARTDATE and ADD_FINISH_DATE lt OFFTIME_FINISHDATE and ADD_FINISH_DATE lt OFFTIME_WORK_STARTDATE>
                                                        N
                                                    <cfelse>
                                                        E
                                                    </cfif>
                                                <cfelse>
                                                    N
                                                </cfif>
                                            </cfif>
                                        <cfelse><!--- Çıkış yoksa --->
                                            <cfif len(OFFTIME_STARTDATE)><!--- İzin kontrolü --->
                                                İ
                                            <cfelse>
                                                Y
                                            </cfif>
                                        </cfif>
                                    </cfif>
                                </cfif>
                            </td>
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
                            <cfif len(attributes.report_type) and attributes.report_type eq 2>
                                <cfquery name="get_other_offtimes" datasource="#dsn#">
                                    SELECT
                                        *
                                    FROM
                                        OFFTIME
                                        INNER JOIN SETUP_OFFTIME ON SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID
                                    WHERE
                                        OFFTIME.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#"> AND
                                        (
                                            ( OFFTIME.STARTDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('h',-session.ep.time_zone, day_start)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('h',-session.ep.time_zone, START_DATE)#">) OR
                                            ( OFFTIME.FINISHDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('h',-session.ep.time_zone, day_start)#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('h',-session.ep.time_zone, START_DATE)#">) OR
                                            ( OFFTIME.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('h',-session.ep.time_zone, day_start)#"> AND  OFFTIME.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('h',-session.ep.time_zone, START_DATE)#">)
                                        )
                                </cfquery>
                                <td>
                                    <cfif get_other_offtimes.recordcount eq 0>
                                        <input class="checkControl" type="checkbox" name="offtime_check" id="offtime_check" value="#employee_id#&#in_out_id#&#day_start#&#START_DATE#">
                                    </cfif>
                                </td>
                            </cfif>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="16"><cf_get_lang dictionary_id='57484.kayıt yok'>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_report_list>
        
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cfset url_str = "report.emp_daily_in_out">
            <cfif isdefined('attributes.is_form_submit')>
                <cfset url_str = '#url_str#&is_form_submit=1'>
            </cfif>
            <cfif len(attributes.start_date) and isdate(attributes.start_date)>
                <cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
            </cfif>
            <cfif len(attributes.finish_date) and isdate(attributes.finish_date)>
                <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
            </cfif>
            <cfif len(attributes.branch_id)>
                <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
            </cfif>
            <cfif len(attributes.department_id)>
                <cfset url_str = "#url_str#&department_id=#attributes.department_id#">
            </cfif>
            <cfif len(attributes.report_type)>
                <cfset url_str = "#url_str#&report_type=#attributes.report_type#">
            </cfif>
            <cfif len(attributes.days_type)>
                <cfset url_str = "#url_str#&days_type=#attributes.days_type#">
            </cfif>
            <cfif len(attributes.position_cat_id)>
                <cfset url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#">
            </cfif>
            <cfif len(attributes.employee_id)>
                <cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
            </cfif>
            <cfif len(attributes.employee_name)>
                <cfset url_str = "#url_str#&employee_name=#attributes.employee_name#">
            </cfif>
            <cf_paging 
                page="#attributes.page#" 
                maxrows="#attributes.maxrows#" 
                totalrecords="#attributes.totalrecords#" 
                startrow="#attributes.startrow#" 
                adres="#url_str#">
        </cfif>
    </div>
    <div class="col col-12">
        <div class="col col-12">
            <cfif len(attributes.report_type) and attributes.report_type eq 2>
                <cf_box closable="0" title="#getLang('','izin ekle',30915)#">
                    <cf_box_elements vertical="1">
                        <div class="col col-4 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-offtimecat_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
                                <div class="col col-8 col-xs-12"> 
                                    <select name="offtimecat_id" id="offtimecat_id" onchange="sub_category();">
                                        <option value="" onclick="change_puantaj(0);"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfoutput query="get_offtime_cats">
                                        <option value="#offtimecat_id#" onclick="change_puantaj(#is_puantaj_off#);">#offtimecat#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-sub_offtimecat_id" style="display:none">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49193.Alt Kategori'></label>
                                <div class="col col-8 col-xs-12"> 
                                    <select name="sub_offtimecat_id" id="sub_offtimecat_id">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    </select>
                                </div>
                            </div>
                            <cf_workcube_general_process print_type="175" >						
                        </div>
                    </cf_box_elements>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <div class="ui-form-list-btn">
                            <input type="hidden" id="paper_submit" name="paper_submit" value="1">
                            <div>
                                <input type="submit" name="setOfftimeProcess" id="setOfftimeProcess" onclick="if(confirm('<cf_get_lang dictionary_id='57535.Kaydetmek istediğinize emin misiniz'>')) return setofftimesProcess(); else return false;" value="<cf_get_lang dictionary_id='57461.Kaydet'>">
                            </div>
                        </div>
                    </div>
                </cf_box>
            </cfif>
        </div>
    </div>
</cfform>
</cfif>
<script type="text/javascript">
    function control(){
        if(document.search_form.is_excel.checked==false){
            document.search_form.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
            return true;
        }
        else
            document.search_form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_emp_daily_in_out</cfoutput>";
    }

    function showDepartment(branch_id){
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&show_div=0&branch_id="+branch_id;
			AjaxPageLoad(send_address,'department_div',1,'İlişkili Departmanlar');
		}
    }
    function setofftimesProcess(){
		var controlChc = 0;
		$('.checkControl').each(function(){
			if(this.checked){
				controlChc += 1;
			}
		});
		if(controlChc == 0){
			alert("İzin Seçiniz");
			return false;
		}
		if( $.trim($('#general_paper_no').val()) == '' ){
			alert("<cf_get_lang dictionary_id='33367.Lütfen Belge No Giriniz'>");
			return false;
		}else{
			paper_no_control = wrk_safe_query('general_paper_control','dsn',0,$('#general_paper_no').val());
			if(paper_no_control.recordcount > 0)
			{
            	alert("<cf_get_lang dictionary_id='49009.Girdiğiniz Belge Numarası Kullanılmaktadır'>.<cf_get_lang dictionary_id='59367.Otomatik olarak değişecektir'>.");
				paper_no_val = $('#general_paper_no').val();
				paper_no_split = paper_no_val.split("-");
				if(paper_no_split.length == 1)
					paper_no = paper_no_split[0];
				else
					paper_no = paper_no_split[1];
				paper_no = parseInt(paper_no);
				paper_no++;
				if(paper_no_split.length == 1)
					$('#general_paper_no').val(paper_no);
				else
					$('#general_paper_no').val(paper_no_split[0]+"-"+paper_no);
				return false;
			}
		}
		if( $.trim($('#general_paper_date').val()) == '' ){
			alert("Lütfen Belge Tarihi Giriniz!");
			return false;
		}
		if( $.trim($('#general_paper_notice').val()) == '' ){
			alert("Lütfen Ek Açıklama Giriniz!");
			return false;
		}
		document.getElementById("paper_submit").value = 1;
		$('#setProcessForm').submit();
		
	}
    function sub_category(){//Alt Kategori 20191009ERU
		up_catid = $('#offtimecat_id').val();
		$('#sub_offtimecat_id').empty();
		$.ajax({ 
            type:'POST',  
            url:'V16/settings/cfc/setup_offtime.cfc?method=get_sub_setupofftime',  
            data: { 
            upper_offtimecat_id: up_catid,
            is_myhome:1
            },
            success: function (returnData) {  // alt kategori varsa burası çalışacak
                    var jData = JSON.parse(returnData);  
                    if(jData['DATA'].length != 0){
                        document.getElementById("item-sub_offtimecat_id").style.display='';
                        $("#doc_req").val(0);
                    }else{ // alt kategori yoksa burası çalışacak
                        document.getElementById("item-sub_offtimecat_id").style.display='none';

                        $.ajax({ 
                            type:'POST',  
                            url:'V16/settings/cfc/setup_offtime.cfc?method=get_sub_setupofftime',  
                            data: { 
                            upper_offtimecat_id: 0
                        },
                        success: function (returnData) {  // üst kategori için belge zorunluluğunu kontrol ediyor
                                var jData = JSON.parse(returnData);  
                                for(var i = 0; i < jData['DATA'].length; i++){
                                    if(jData['DATA'][i][0] == up_catid){ 
                                        /*
                                            üst satır, V16\settings\cfc\setup_offtime.cfc dosyasından gelen veriye göre işlem yapıyor. 
                                            Değişiklik durumunda diğer dosyada da güncelleme yapınız.
                                        */
                                        if(jData['DATA'][i][2] == true){
                                            $("#doc_req").val(1); // belge zorunluluğu varsa input'a 1 değeri atıyor
                                        }else{
                                            $("#doc_req").val(0);
                                        }
                                    }
                                }
                        },
                            error: function () 
                            {
                                console.log('CODE:8 please, try again..');
                                return false; 
                            }
                        }); 

                    }
                    $('<option>').attr({value:0})
                            .append('<cfoutput>#getLang("main",322)#</cfoutput>').appendTo('#sub_offtimecat_id');  
                    $.each( jData['DATA'], function( index ) {                       
                            $('<option>').attr({value:this[0]})
                            .append(this[1]).appendTo('#sub_offtimecat_id');       		                           
                    });
            },
            error: function () 
            {
                console.log('CODE:8 please, try again..');
                return false; 
            }
		}); 
	}
</script>