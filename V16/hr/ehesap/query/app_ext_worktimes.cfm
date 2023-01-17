<cfset url_str = "">
<cfif isdefined('attributes.keyword')>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined('attributes.day_type')>
	<cfset url_str = "#url_str#&day_type=#attributes.day_type#">
</cfif>
<cfif isdefined('attributes.related_company')>
	<cfset url_str = "#url_str#&related_company=#attributes.related_company#">
</cfif>
<cfif isdefined('attributes.pdks_status')>
	<cfset url_str = "#url_str#&pdks_status=#attributes.pdks_status#">
</cfif>
<cfif isdefined('attributes.form_submit')>
	<cfset url_str = "#url_str#&form_submit=#attributes.form_submit#">
</cfif>	
<cfif isdefined('attributes.branch_id')>
	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
</cfif>	

<cfif isdefined('attributes.department')>
	<cfset url_str = "#url_str#&department=#attributes.department#">
</cfif>
<cfset action_id_list = "">
<cfloop from="1" to="#listlen(attributes.id_list)#" index="i">
	<cfset emp_id = listfirst(listgetat(attributes.id_list,i,','),';')>
    <cfset ewt_id = listlast(listgetat(attributes.id_list,i,','),';')>

	<!--- Fazla Mesai Taleplerinin sadece ID listesini almak için eklendi. ÜOK - Ağustos 2021--->
	<cfif i eq 1><cfset action_id_list = ewt_id>
	<cfelse><cfset action_id_list = action_id_list & "," & ewt_id>
	</cfif>

	<cfif isdefined("attributes.puantaj_date") and len(attributes.puantaj_date)>
		<cf_date tarih="attributes.puantaj_date">
		<cfquery name="upd_" datasource="#dsn#">
			UPDATE
				EMPLOYEES_EXT_WORKTIMES
			SET
				START_TIME = DATEADD(day,DATEDIFF(day,START_TIME,#attributes.puantaj_date#),START_TIME),
				END_TIME = DATEADD(day,DATEDIFF(day,END_TIME,#attributes.puantaj_date#),END_TIME)
			WHERE
				EWT_ID = #EWT_ID#
		</cfquery>
    </cfif>
	
    <cfquery name="cont_worktime_valid" datasource="#dsn#">
        SELECT
        	VALID
        FROM
            EMPLOYEES_EXT_WORKTIMES
        WHERE
            EWT_ID = #EWT_ID#
    </cfquery>
    <cfif not len(cont_worktime_valid.valid)>
        <cfquery name="get_ext_worktime" datasource="#dsn#">
            SELECT
                EWT.WORK_START_TIME,
                EWT.WORK_END_TIME,
                EWT.IN_OUT_ID,
                EWT.DAY_TYPE
            FROM
                EMPLOYEES_EXT_WORKTIMES EWT
            WHERE
                EWT.EMPLOYEE_ID = #emp_id#
                AND EWT.EWT_ID = #ewt_id#
        </cfquery>
        <cfset startdate = dateformat(get_ext_worktime.WORK_START_TIME,dateformat_style)>
        <cfif len(get_ext_worktime.WORK_START_TIME)>
            <cfset start_hour = timeformat(get_ext_worktime.WORK_START_TIME,'HH')>
        <cfelse>
            <cfset start_hour = timeformat(0,'HH')>
        </cfif>
        <cfif len(get_ext_worktime.WORK_START_TIME)>
            <cfset start_min = timeformat(get_ext_worktime.WORK_START_TIME,'MM')>
        <cfelse>
            <cfset start_min = timeformat(0,'MM')>
        </cfif>
        <cfif len(get_ext_worktime.WORK_END_TIME)>
            <cfset end_hour = timeformat(get_ext_worktime.WORK_END_TIME,'HH')>
        <cfelse>
            <cfset end_hour = timeformat(0,'HH')>
        </cfif>
        <cfif len(get_ext_worktime.WORK_END_TIME)>
            <cfset end_min = timeformat(get_ext_worktime.WORK_END_TIME,'MM')>
        <cfelse>
            <cfset end_min = timeformat(0,'MM')>
        </cfif>
        <cf_date tarih="startdate">
        <cfscript>
            startdate_ = startdate;
            startdate = date_add('h',start_hour, startdate);
            startdate = date_add('n',start_min, startdate);
            finishdate = date_add('h',end_hour, startdate_);
            finishdate = date_add('n',end_min, finishdate);
        </cfscript>
        <!---  --->
        <cfquery name="IS_EXTRA_WORK_TIME_EQUAL" datasource="#DSN#">	<!--- CH --->
            SELECT 
                * 
            FROM
                 EMPLOYEES_EXT_WORKTIMES
            WHERE
                EMPLOYEE_ID = #emp_id# AND
                EWT_ID != EWT_ID AND
                IN_OUT_ID = #get_ext_worktime.in_out_id# AND
                (
                    (WORK_START_TIME <= #startdate# AND 
                    WORK_END_TIME >= #startdate#)
                    OR
                    (WORK_START_TIME <= #finishdate# AND 
                    WORK_END_TIME >= #finishdate#)
                    OR
                    (WORK_START_TIME <= #startdate# AND WORK_END_TIME >= #finishdate#)
                    OR
                    (WORK_START_TIME >= #startdate# AND WORK_START_TIME <= #finishdate#)
                )
        </cfquery>
        <cfif IS_EXTRA_WORK_TIME_EQUAL.recordcount>
            <script type="text/javascript">
                alert('Aynı Zaman Dilimleri İçersinde Birden çok Fazla Mesai Tanımlanamaz!');
                history.back();
            </script>
            <cfabort>
        </cfif>
        <!---  --->
        <cfquery name="get_employee_company" datasource="#dsn#">
            SELECT
                BRANCH.COMPANY_ID,
                PUANTAJ_GROUP_IDS,
                BRANCH.BRANCH_ID
            FROM
                BRANCH,
                EMPLOYEES_IN_OUT
            WHERE
                EMPLOYEES_IN_OUT.IN_OUT_ID = #get_ext_worktime.in_out_id# AND
                EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
        </cfquery>
        <cfset attributes.our_company_id = get_employee_company.COMPANY_ID>
        <cfinclude template="get_hours.cfm">
        <cfif not(get_hours.recordcount)>
            <script type="text/javascript">
                alert("Şirket SSK Çalışma Saatlerini Girmelisiniz !");
                window.close();
            </script>
            <cfabort>
        </cfif>
        
        <cfset attributes.sal_mon = month(startdate)>
        <cfset attributes.sal_year = year(startdate)>
        <cfset attributes.group_id = "">
        <cfif len(get_employee_company.puantaj_group_ids)>
            <cfset attributes.group_id = "#get_employee_company.PUANTAJ_GROUP_IDS#,">
        </cfif>
        <cfset attributes.branch_id = get_employee_company.branch_id>
        <cfset not_kontrol_parameter = 1>
        <cfinclude template="../query/get_program_parameter.cfm">
        
        <cfquery name="GET_DAILY_EXT_TIME" datasource="#dsn#">
            SELECT
            <cfif database_type is "MSSQL">
                SUM(DATEDIFF(minute, WORK_START_TIME, WORK_END_TIME)) AS TOTAL_MIN
            <cfelseif database_type is "DB2">
                SUM(SECONDSDIFF(WORK_END_TIME,WORK_START_TIME))/60 AS TOTAL_MIN
            </cfif>
            FROM
                EMPLOYEES_EXT_WORKTIMES
            WHERE
                WORK_START_TIME >= #STARTDATE_#
                AND
                WORK_END_TIME < #DATEADD("d", 1, STARTDATE_)#
                AND
                EWT_ID <> #EWT_ID#
                AND
                EMPLOYEE_ID = #emp_id#
        </cfquery>
        
        <cfset total_mesai = (end_hour - start_hour)*60 + (end_min - start_min)>
        <cfset ext_time_limit = get_program_parameters.overtime_hours*60>
        
        <cfif get_ext_worktime.day_type eq 1><!--- hafta sonu --->
            <cfset ext_time_limit = ext_time_limit + (get_hours.daily_work_hours*60)>
        <cfelseif get_ext_worktime.day_type eq 3><!--- Gece Çalışması --->
            <cfset ext_time_limit = ext_time_limit + (get_hours.daily_work_hours*60)>
        </cfif>
        
        <cfif len(GET_DAILY_EXT_TIME.TOTAL_MIN)>
            <cfset total_mesai = total_mesai + GET_DAILY_EXT_TIME.TOTAL_MIN>
        </cfif>
        <cfif get_ext_worktime.day_type eq 0> <!--- resmi tatil, hafta sonunda fazla mesai sınırı yoktur.CH_26012009 --->
            <cfif total_mesai gt ext_time_limit>
                <script type="text/javascript">
                    alert("Günlük Kanuni Mesai Limitini (<cfoutput>#get_program_parameters.overtime_hours#</cfoutput> saat) Aşamazsınız !");
                </script>
            </cfif>
        </cfif>
        
        <cfquery name="GET_YEARLY_EXT_TIME" datasource="#dsn#">
            SELECT
            <cfif database_type is "MSSQL">
                SUM(DATEDIFF(minute, WORK_START_TIME, WORK_END_TIME)) AS TOTAL_MIN2
            <cfelseif database_type is "DB2">
                SUM(SECONDSDIFF(WORK_END_TIME,WORK_START_TIME))/60 AS TOTAL_MIN2
            </cfif>
            FROM
                EMPLOYEES_EXT_WORKTIMES
            WHERE
                EWT_ID <> #EWT_ID#
                AND
                WORK_START_TIME > #createodbcdatetime(createdate(session.ep.period_year,1,1))#
                AND
                WORK_END_TIME < #createodbcdatetime(createdate(session.ep.period_year+1,1,1))#
                AND
                EMPLOYEE_ID = #emp_id#
        </cfquery>
        
        <cfset ext_time_limit = get_program_parameters.OVERTIME_YEARLY_HOURS*60>
        <cfset total_mesai = (end_hour - start_hour) * 60 + (end_min - start_min)>
        
        <cfif get_ext_worktime.day_type eq 1><!--- hafta sonu --->
            <cfset ext_time_limit = ext_time_limit + (get_hours.daily_work_hours*60)>
        <cfelseif get_ext_worktime.day_type eq 3><!--- Gece Çalışması --->
            <cfset ext_time_limit = ext_time_limit + (get_hours.daily_work_hours*60)>
        </cfif>
        
        <cfif len(GET_YEARLY_EXT_TIME.TOTAL_MIN2)>
            <cfset total_mesai = total_mesai + GET_YEARLY_EXT_TIME.total_min2>
        </cfif>
        
        <cfif total_mesai gt ext_time_limit>
            <script type="text/javascript">
                alert("Yıllık Kanuni Mesai Limitini (<cfoutput>#get_program_parameters.OVERTIME_YEARLY_HOURS#</cfoutput> saat) Aşamazsınız !");
            </script>
        </cfif>
        
        <cfquery name="upd_worktime" datasource="#dsn#">
            UPDATE
                EMPLOYEES_EXT_WORKTIMES
            SET
                VALID = 1,
                VALIDDATE = #NOW()#,
                VALID_EMPLOYEE_ID = #session.ep.userid#
            WHERE
                EWT_ID = #EWT_ID#
        </cfquery>
        <!---<cfquery name="GET_EMP_ID" datasource="#dsn#">
            SELECT 
                EMPLOYEE_ID,
                PROCESS_STAGE
            FROM
                EMPLOYEES_EXT_WORKTIMES
            WHERE
                EWT_ID = #EWT_ID#
        </cfquery>
        <cf_workcube_process 
            is_upd='1' 
            data_source='#dsn#' 
            old_process_line='0'
            process_stage='#GET_EMP_ID.process_stage#' 
            record_member='#session.ep.userid#' 
            record_date='#now()#' 
            action_table='EMPLOYEES_EXT_WORKTIMES'
            action_column='EWT_ID'
            action_id='#EWT_ID#'
            multi = '1'
            action_page='#request.self#?fuseaction=ehesap.list_ext_worktimes' 
            warning_description='Fazla Mesai: #get_emp_info(GET_EMP_ID.EMPLOYEE_ID,0,0,0)#'>--->
    </cfif>
</cfloop>
<cfset totalValues = structNew()>
<cfset totalValues = {
        total_offtime : 0
    }>
<!--- <cfset action_list_id = replace(attributes.id_list,";",",","all")>
<cfdump var = "#action_list_id#" abort> --->
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
    action_table = 'EMPLOYEES_EXT_WORKTIMES'
    action_column = 'EWT_ID'
    action_page = '#request.self#?fuseaction=ehesap.list_ext_worktimes'
    total_values = '#totalValues#'
>
<cflocation url="#request.self#?fuseaction=#attributes.fsactn##url_str#" addtoken="No">
