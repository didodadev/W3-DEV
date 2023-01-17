<!---kişi ücret kartından kişiye toplu olarak fazla mesai ekleme sayfası --->
<cfquery name="get_hours" datasource="#dsn#">
	SELECT
		OUR_COMPANY_HOURS.OCH_ID,
		OUR_COMPANY_HOURS.OUR_COMPANY_ID,
		OUR_COMPANY_HOURS.DAILY_WORK_HOURS,
		OUR_COMPANY_HOURS.SATURDAY_WORK_HOURS,
		OUR_COMPANY_HOURS.SSK_MONTHLY_WORK_HOURS,
		OUR_COMPANY_HOURS.SSK_WORK_HOURS,
		OUR_COMPANY_HOURS.UPDATE_DATE,
		OUR_COMPANY.NICK_NAME
	FROM
		OUR_COMPANY_HOURS INNER JOIN OUR_COMPANY
        ON OUR_COMPANY.COMP_ID = OUR_COMPANY_HOURS.OUR_COMPANY_ID
		INNER JOIN BRANCH ON BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
        INNER JOIN EMPLOYEES_IN_OUT ON EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID 
	WHERE
		EMPLOYEES_IN_OUT.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
</cfquery>
<cfif not get_hours.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='64571.Şirket SGK Çalışma Saatlerini Girmelisiniz'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cftransaction>
<cfif attributes.rowCount gt 0>
    <cfloop from="1" to="#attributes.rowCount#" index="i">
        <cfif evaluate("attributes.row_kontrol_#i#") eq 1>
            <cfset tarihim = evaluate("attributes.startdate#i#")>
            <cfset work_date_ = evaluate("attributes.work_startdate#i#")>
            <cf_date tarih="tarihim">	
            <cf_date tarih="work_date_">						
            <cfscript>
                attributes.day_type = evaluate("attributes.day_type#i#");
                attributes.valid_detail = evaluate('attributes.valid_detail#i#');
                start_hour = evaluate("attributes.start_hour#i#");
                start_min = evaluate("attributes.start_min#i#");
                end_hour = evaluate("attributes.end_hour#i#");
                end_min = evaluate("attributes.end_min#i#");
                attributes.shift_status = evaluate("attributes.shift_status#i#");
                attributes.process_stage = evaluate("attributes.process_stage#i#");
                startdate_ = tarihim;
                startdate = date_add('h', start_hour, startdate_);
                startdate = date_add('n', start_min, startdate);
                finishdate = date_add('h', end_hour, startdate_);
                finishdate = date_add('n', end_min, finishdate);
                work_startdate_ = work_date_;
                work_startdate = date_add('h', start_hour, work_startdate_);
                work_startdate = date_add('n', start_min, work_startdate);
                work_finishdate = date_add('h', end_hour, work_startdate_);
                work_finishdate = date_add('n', end_min, work_startdate);
            </cfscript>
            
            <cfset attributes.sal_mon = month(startdate_)>
            <cfset attributes.sal_year = year(startdate_)>
            <cfquery name="get_employee_company" datasource="#dsn#">
                SELECT
                    BRANCH.COMPANY_ID,
                    PUANTAJ_GROUP_IDS,
                    BRANCH.BRANCH_ID
                FROM
                    BRANCH,
                    EMPLOYEES_IN_OUT
                WHERE
                    EMPLOYEES_IN_OUT.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
                    EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
            </cfquery>
            <cfif get_employee_company.recordcount>
                <cfset attributes.group_id = "">
                <cfif len(get_employee_company.puantaj_group_ids)>
                    <cfset attributes.group_id = "#get_employee_company.PUANTAJ_GROUP_IDS#,">
                </cfif>
                <cfset attributes.branch_id = get_employee_company.branch_id>
                <cfset not_kontrol_parameter = 1>
                <cfinclude template="get_program_parameter.cfm">
                <cfquery name="get_hours1" dbtype="query">
                    SELECT
                        OCH_ID,
                        OUR_COMPANY_ID,
                        DAILY_WORK_HOURS,
                        SATURDAY_WORK_HOURS,
                        SSK_MONTHLY_WORK_HOURS,
                        SSK_WORK_HOURS,
                        UPDATE_DATE,
                        NICK_NAME
                    FROM
                        get_hours
                    WHERE
                        OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_employee_company.COMPANY_ID#">
                </cfquery>
                <cfquery name="GET_DAILY_EXT_TIME" datasource="#dsn#">
                    SELECT
                        <cfif database_type is "MSSQL">
                            SUM(DATEDIFF(MINUTE, START_TIME, END_TIME)) AS TOTAL_MIN
                        <cfelseif database_type is "DB2">
                            SUM(SECONDSDIFF(END_TIME,START_TIME))/60 AS TOTAL_MIN
                        </cfif>
                    FROM
                        EMPLOYEES_EXT_WORKTIMES
                    WHERE
                        START_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate_#"> AND
                        END_TIME < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d", 1, startdate_)#"> AND
                        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
                </cfquery>
                <cfset total_mesai = (end_hour - start_hour)*60 + (end_min - start_min)>
                <cfset ext_time_limit = get_program_parameters.overtime_hours*60>
                <cfif attributes.day_type eq 1><!--- hafta sonu --->
                    <cfset ext_time_limit = ext_time_limit + (get_hours1.daily_work_hours*60)>
                </cfif>
            
                <cfif len(GET_DAILY_EXT_TIME.TOTAL_MIN)>
                    <cfset total_mesai = total_mesai + GET_DAILY_EXT_TIME.TOTAL_MIN>
                </cfif>
                <cfif total_mesai gt ext_time_limit>
                    <script type="text/javascript">
                        alert("<cf_get_lang dictionary_id='64572.Günlük Kanuni Mesai Limitini Aştınız'>! (<cfoutput>#get_program_parameters.overtime_hours#</cfoutput> <cf_get_lang dictionary_id='57491.Saat'>)");
                        window.location.reload();
                    </script>
                    <cfabort>
                </cfif>
                <cfquery name="GET_YEARLY_EXT_TIME" datasource="#dsn#">
                    SELECT
                        <cfif database_type is "MSSQL">
                            SUM(DATEDIFF(MINUTE, START_TIME, END_TIME)) AS TOTAL_MIN
                        <cfelseif database_type is "DB2">
                            SUM(SECONDSDIFF(END_TIME,START_TIME))/60 AS TOTAL_MIN
                        </cfif>
                    FROM
                        EMPLOYEES_EXT_WORKTIMES
                    WHERE
                        START_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdate(session.ep.period_year,1,1)#"> AND
                        END_TIME < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("y",1,createdate(session.ep.period_year,1,1))#"> AND
                        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
                </cfquery>
            
                <cfset ext_time_limit = get_program_parameters.OVERTIME_YEARLY_HOURS*60>
                <cfset total_mesai = (end_hour - start_hour)*60 + (end_min - start_min)>
                <cfif attributes.day_type eq 1><!--- hafta sonu --->
                    <cfset ext_time_limit = ext_time_limit + (get_hours1.daily_work_hours*60)>
                </cfif>
                <cfif len(GET_YEARLY_EXT_TIME.total_min)>
                    <cfset total_mesai = total_mesai + GET_YEARLY_EXT_TIME.total_min>
                </cfif>
                <cfif total_mesai gt ext_time_limit>
                    <script type="text/javascript">
                        alert("<cf_get_lang dictionary_id='64574.Yıllık Kanuni Mesai Limitini Aştınız'>(#get_program_parameters.OVERTIME_YEARLY_HOURS# <cf_get_lang dictionary_id='57491.Saat'>) !");
                        window.location.reload();
                    </script>
                    <cfabort>
                </cfif>
                <cfquery name="add_worktime" datasource="#dsn#" result="MAX_ID">
                    INSERT INTO
                        EMPLOYEES_EXT_WORKTIMES
                        (
                        EMPLOYEE_ID,
                        START_TIME,
                        END_TIME,
                        DAY_TYPE,
                        IN_OUT_ID,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP,
                        VALID_DETAIL,
                        WORKTIME_WAGE_STATU,
                        PROCESS_STAGE,
                        WORK_START_TIME,
                        WORK_END_TIME
                        )
                    VALUES
                        (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#finishdate#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.day_type#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
                        <cfif len(attributes.shift_status)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Shift_Status#"><cfelse>NULL</cfif>,
                        <cfif len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#work_startdate#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#work_finishdate#">
                        )
                </cfquery>
        <cfelse>
                <script type="text/javascript">
                    alert("<cf_get_lang dictionary_id='64575.Kayıt Yapılamadı'>!");
                    window.location.reload();
                </script>
                <cfabort>
        </cfif>
        <cfif isDefined("attributes.process_stage") and len(attributes.process_stage)>
                <cf_workcube_process 
                    is_upd='1' 
                    data_source='#dsn#' 
                    old_process_line='0'
                    process_stage='#attributes.process_stage#' 
                    record_member='#session.ep.userid#' 
                    record_date='#now()#'
                    action_table='EMPLOYEES_EXT_WORKTIMES'
                    action_column='EWT_ID'
                    action_id='#MAX_ID.IDENTITYCOL#'
                    action_page='#request.self#?fuseaction=ehesap.list_ext_worktimes&event=upd&EWT_ID=#MAX_ID.IDENTITYCOL#'
                    warning_description='Fazla Mesai Talebi'>
            </cfif>
        </cfif>
    </cfloop>
</cfif>
<cfloop from="1" to="#attributes.rowCount_sabit#" index="i">
	<cfif evaluate("attributes.sabit_row_kontrol_#i#") eq 1>
		<cfset tarihim = evaluate("attributes.sabit_startdate#i#")>
        <cfset work_date_ = evaluate("attributes.sabit_work_startdate#i#")>
        <cf_date tarih="tarihim">	
        <cf_date tarih="work_date_">						
        <cfscript>
            attributes.day_type = evaluate("attributes.sabit_my_row_day_type#i#");
			attributes.valid_detail = evaluate('attributes.sabit_my_row_valid_detail#i#');
            start_hour = evaluate("attributes.sabit_my_row_start_hour#i#");
            start_min = evaluate("attributes.sabit_my_row_start_min#i#");
            end_hour = evaluate("attributes.sabit_my_row_end_hour#i#");
            end_min = evaluate("attributes.sabit_my_row_end_min#i#");
            attributes.shift_status = evaluate("attributes.sabit_shift_status#i#");
			attributes.process_stage = evaluate("attributes.sabit_process_stage#i#");
            startdate_ = tarihim;
            startdate = date_add('h', start_hour, startdate_);
            startdate = date_add('n', start_min, startdate);
            finishdate = date_add('h', end_hour, startdate_);
            finishdate = date_add('n', end_min, finishdate);
            work_startdate_ = work_date_;
            work_startdate = date_add('h', start_hour, work_startdate_);
            work_startdate = date_add('n', start_min, work_startdate);
            work_finishdate = date_add('h', end_hour, work_startdate_);
            work_finishdate = date_add('n', end_min, work_startdate);
        </cfscript>
        
        <cfset attributes.sal_mon = month(startdate_)>
        <cfset attributes.sal_year = year(startdate_)>
        <cfquery name="get_employee_company" datasource="#dsn#">
            SELECT
                BRANCH.COMPANY_ID,
                PUANTAJ_GROUP_IDS,
                BRANCH.BRANCH_ID
            FROM
                BRANCH,
                EMPLOYEES_IN_OUT
            WHERE
                EMPLOYEES_IN_OUT.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
                EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID
        </cfquery>
        <cfif get_employee_company.recordcount>
            <cfset attributes.group_id = "">
            <cfif len(get_employee_company.puantaj_group_ids)>
                <cfset attributes.group_id = "#get_employee_company.PUANTAJ_GROUP_IDS#,">
            </cfif>
            <cfset attributes.branch_id = get_employee_company.branch_id>
            <cfset not_kontrol_parameter = 1>
            <cfinclude template="get_program_parameter.cfm">
            <cfquery name="get_hours1" dbtype="query">
                SELECT
                    OCH_ID,
                    OUR_COMPANY_ID,
                    DAILY_WORK_HOURS,
                    SATURDAY_WORK_HOURS,
                    SSK_MONTHLY_WORK_HOURS,
                    SSK_WORK_HOURS,
                    UPDATE_DATE,
                    NICK_NAME
                FROM
                    get_hours
                WHERE
                    OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_employee_company.COMPANY_ID#">
            </cfquery>
            <cfquery name="GET_DAILY_EXT_TIME" datasource="#dsn#">
                SELECT
                    <cfif database_type is "MSSQL">
                        SUM(DATEDIFF(MINUTE, START_TIME, END_TIME)) AS TOTAL_MIN
                    <cfelseif database_type is "DB2">
                        SUM(SECONDSDIFF(END_TIME,START_TIME))/60 AS TOTAL_MIN
                    </cfif>
                FROM
                    EMPLOYEES_EXT_WORKTIMES
                WHERE
                    START_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate_#"> AND
                    END_TIME < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d", 1, startdate_)#"> AND
                    EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND 
                    EWT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('sabit_worktimes_id#i#')#">
            </cfquery>
            <cfset total_mesai = (end_hour - start_hour)*60 + (end_min - start_min)>
            <cfset ext_time_limit = get_program_parameters.overtime_hours*60>
            <cfif attributes.day_type eq 1><!--- hafta sonu --->
                <cfset ext_time_limit = ext_time_limit + (get_hours1.daily_work_hours*60)>
            </cfif>
        
            <cfif len(GET_DAILY_EXT_TIME.TOTAL_MIN)>
                <cfset total_mesai = total_mesai + GET_DAILY_EXT_TIME.TOTAL_MIN>
            </cfif>
            <cfif total_mesai gt ext_time_limit>
                <script type="text/javascript">
                    alert("<cf_get_lang dictionary_id='64572.Günlük Kanuni Mesai Limitini Aştınız'>! (<cfoutput>#get_program_parameters.overtime_hours#</cfoutput> <cf_get_lang dictionary_id='57491.Saat'>)");
                    window.location.reload();
                </script>
                <cfabort>
            </cfif>
            <cfquery name="GET_YEARLY_EXT_TIME" datasource="#dsn#">
                SELECT
                    <cfif database_type is "MSSQL">
                        SUM(DATEDIFF(MINUTE, START_TIME, END_TIME)) AS TOTAL_MIN
                    <cfelseif database_type is "DB2">
                        SUM(SECONDSDIFF(END_TIME,START_TIME))/60 AS TOTAL_MIN
                    </cfif>
                FROM
                    EMPLOYEES_EXT_WORKTIMES
                WHERE
                    START_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createdate(session.ep.period_year,1,1)#"> AND
                    END_TIME < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("y",1,createdate(session.ep.period_year,1,1))#"> AND
                    EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
            </cfquery>
        
            <cfset ext_time_limit = get_program_parameters.OVERTIME_YEARLY_HOURS*60>
            <cfset total_mesai = (end_hour - start_hour)*60 + (end_min - start_min)>
            <cfif attributes.day_type eq 1><!--- hafta sonu --->
                <cfset ext_time_limit = ext_time_limit + (get_hours1.daily_work_hours*60)>
            </cfif>
            <cfif len(GET_YEARLY_EXT_TIME.total_min)>
                <cfset total_mesai = total_mesai + GET_YEARLY_EXT_TIME.total_min>
            </cfif>
            <cfif total_mesai gt ext_time_limit>
                <script type="text/javascript">
                    alert("<cf_get_lang dictionary_id='64574.Yıllık Kanuni Mesai Limitini Aştınız'>(#get_program_parameters.OVERTIME_YEARLY_HOURS# <cf_get_lang dictionary_id='57491.Saat'>) !");
                    window.location.reload();
                </script>
                <cfabort>
            </cfif>
            <cfquery name="upd_worktime" datasource="#dsn#">
                UPDATE
                    EMPLOYEES_EXT_WORKTIMES
                SET
                    START_TIME = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#startdate#">,
                    END_TIME = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#finishdate#">,
                    DAY_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.day_type#">,
                    UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
                    VALID_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.valid_detail#">,
                    WORKTIME_WAGE_STATU = <cfif len(attributes.shift_status)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.Shift_Status#"><cfelse>NULL</cfif>,
					PROCESS_STAGE =  <cfif len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
                    WORK_START_TIME= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#work_startdate#">,
		            WORK_END_TIME = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#work_finishdate#">
				WHERE
                	EWT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('sabit_worktimes_id#i#')#">
            </cfquery>
      <cfelse>
			<script type="text/javascript">
                alert("<cf_get_lang dictionary_id='64575.Kayıt Yapılamadı'>!");
                window.location.reload();
            </script>
            <cfabort>
      </cfif>
      <cfif isDefined("attributes.process_stage") and len(attributes.process_stage)>
        <cf_workcube_process 
            is_upd='1' 
            data_source='#dsn#' 
            old_process_line='0'
            process_stage='#attributes.process_stage#' 
            record_member='#session.ep.userid#' 
            record_date='#now()#'
            action_table='EMPLOYEES_EXT_WORKTIMES'
            action_column='EWT_ID'
            action_id='#evaluate('sabit_worktimes_id#i#')#'
            action_page='#request.self#?fuseaction=ehesap.list_ext_worktimes&event=upd&EWT_ID=#evaluate('sabit_worktimes_id#i#')#'
            warning_description='Fazla Mesai Talebi'>
    </cfif>
	<cfelse>
		<cfquery name="del_" datasource="#dsn#">
			DELETE FROM EMPLOYEES_EXT_WORKTIMES WHERE EWT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_worktimes_id#i#')#">
		</cfquery>
	</cfif>
</cfloop>
</cftransaction>
<cfif isdefined("attributes.from_upd_salary") and len(attributes.from_upd_salary)>
	<cflocation url="#request.self#?fuseaction=ehesap.list_salary&event=upd&in_out_id=#attributes.in_out_id#&employee_id=#attributes.employee_id#&type=9" addtoken="No">
<cfelseif not isdefined("attributes.modal_id")>
	<script type="text/javascript">
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</script>
</cfif>