<cf_xml_page_edit fuseact="myhome.popup_add_timecost_project_all">
<cfset list_employee_id="">
<cfset list_employee="">
<cfset _employee_name_ = "">
<cfloop from="1" to="#attributes.record_num#" index="m">
	<cfif isdefined("attributes.employee_id#m#") and len(evaluate("attributes.employee_id#m#")) and evaluate("attributes.row_kontrol_#m#") neq 0>
		<cfset list_employee_id = listappend(list_employee_id,#evaluate("attributes.employee_id#m#")#,',')>
	</cfif>
</cfloop>

<cfloop from="1" to="#attributes.record_num#" index="m">
	<cfif isdefined("attributes.employee#m#") and len(evaluate("attributes.employee#m#")) and evaluate("attributes.row_kontrol_#m#") neq 0>
		<cfset list_employee = listappend(list_employee,#evaluate("attributes.employee#m#")#,',')>
	</cfif>
</cfloop>

<cfif not listlen(list_employee_id) and not listlen(list_employee)>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1225.Zaman Harcaması Eklenecek Kişi Girmelisiniz'>!");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfset list_employee_id=listsort(ListDeleteDuplicates(list_employee_id),'numeric')>
<cfif listlen(list_employee_id)>
	<cfquery name="get_hourly_salary" datasource="#dsn#">
		SELECT
			EMPLOYEE_ID,
			ISNULL(ON_MALIYET,0) ON_MALIYET,
			ISNULL(ON_HOUR,0) ON_HOUR
		FROM
			EMPLOYEE_POSITIONS
		WHERE
			IS_MASTER = 1 AND <!--- Birden Fazla Pozisyon varsa sorun olur --->
			EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#list_employee_id#">)
		ORDER BY
			EMPLOYEE_ID
	</cfquery>
</cfif>

<cfloop from="1" to="#attributes.record_num#" index="i">
	<cfif isdefined("attributes.row_kontrol_#i#") and evaluate("attributes.row_kontrol_#i#") neq 0>
        <cfscript>
			form_employee_id = evaluate("attributes.employee_id#i#");
			form_today = evaluate("attributes.today#i#");
            form_total_time_hour = evaluate("attributes.total_time_hour#i#");
            form_total_time_minute = evaluate("attributes.total_time_minute#i#");
        </cfscript>
        <cfset attributes.today = evaluate("attributes.today#i#")>
        <cf_date tarih="attributes.today">
        <cfif isdefined("form_total_time_hour") and len(form_total_time_hour)>
            <cfset totalhour = form_total_time_hour>
        <cfelse>
            <cfset totalhour=0>
        </cfif>
        <cfif isdefined("form_total_time_minute") and len(form_total_time_minute)>
            <cfset totalminute = form_total_time_minute>
        <cfelse>
            <cfset totalminute = 0>
        </cfif>
        <cfif totalminute lt 0>
            <cfset totalminute = abs(totalminute)>
            <cfset totalminute = 60 - totalminute>*
            <cfset totalhour = totalhour-1>
        </cfif>
        <cfset topson = (totalhour*60) + totalminute>
        <cfif x_timecost_limited eq 0 and len(attributes.today)>
            <cfquery name="getTimeCost" datasource="#dsn#">
                SELECT SUM(EXPENSED_MINUTE) EXPENSED_MINUTE FROM TIME_COST WHERE EVENT_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.today#"> AND EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form_employee_id#">
            </cfquery>
            <cfif len(getTimeCost.EXPENSED_MINUTE)>
                <cfset topson = topson + getTimeCost.EXPENSED_MINUTE>
            </cfif>
        </cfif>
        <cfif topson gt 1440 and x_timecost_limited eq 0>
            <script type="text/javascript">
                alert("<cf_get_lang no ='1144.Zaman Harcaması Bir Gün İçin 24 Saatten Fazla Girilemez'>!");
                history.back();
            </script>
            <cfabort>
        </cfif>
    </cfif>
</cfloop>
<!--- saat kontrolleri bitti--->

<cfif len(attributes.record_num) and attributes.record_num neq "">
    <cfif isdefined("attributes.project_id") and len(attributes.project_id)>
        <cfquery name="WorkGroup_Control" datasource="#dsn#">
            SELECT EMPLOYEE_ID FROM WORKGROUP_EMP_PAR WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
        </cfquery>
        <cfif WorkGroup_Control.RecordCount>
            <cfquery name="Del_Time_Cost" datasource="#dsn#">
                DELETE FROM TIME_COST WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> AND EMPLOYEE_ID IN (#valuelist(WorkGroup_Control.Employee_Id)#)
            </cfquery>
        </cfif>
    </cfif>
    <cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif isdefined("attributes.row_kontrol_#i#") and evaluate("attributes.row_kontrol_#i#") neq 0>
            <cfscript>
                form_employee_id = evaluate("attributes.employee_id#i#");
                form_employee = evaluate("attributes.employee#i#");
                if(isdefined('attributes.comment#i#'))
                    form_comment = evaluate("attributes.comment#i#");
                else
                    form_comment = '';
                form_total_time_hour = evaluate("attributes.total_time_hour#i#");
                form_total_time_minute = evaluate("attributes.total_time_minute#i#");
                if(isdefined('attributes.project_id#i#') || isdefined('attributes.project#i#'))
                {
                    form_project_id = evaluate("attributes.project_id#i#");
                    form_project = evaluate("attributes.project#i#");
                }
                else
                {
                    form_project_id = '';
                    form_project = '';
                }
                if(isdefined('attributes.expense_id#i#') || isdefined('attributes.expense#i#'))
                {
                    form_expense_id = evaluate("attributes.expense_id#i#");
                    form_expense = evaluate("attributes.expense#i#");
                }
                else
                {
                    form_expense_id = '';
                    form_expense = '';
                }
                if(isdefined('attributes.consumer_id#i#') || isdefined('attributes.partner_id#i#') || isdefined('attributes.company_id#i#') || isdefined('attributes.member_name#i#'))
                {
                    form_consumer_id = evaluate("attributes.consumer_id#i#");
                    form_partner_id = evaluate("attributes.partner_id#i#");
                    form_company_id = evaluate("attributes.company_id#i#");
                    form_member_name = evaluate("attributes.member_name#i#");
                }
                else
                {
                    form_consumer_id = '';
                    form_partner_id = '';
                    form_company_id = '';
                    form_member_name = '';
                }
                if(isdefined('attributes.work_id#i#') || isdefined('attributes.work_head#i#'))
                {
                    form_work_id = evaluate("attributes.work_id#i#");
                    form_work_head = evaluate("attributes.work_head#i#");
                }
                else
                {
                    form_work_id = '';
                    form_work_head = '';
                }
                form_today = evaluate("attributes.today#i#");
                if(isdefined('attributes.product_id#i#'))
                    form_product_id = evaluate("attributes.product_id#i#");
                else
                    form_product_id = '';
                if(isdefined('attributes.overtime_type#i#'))
                    form_overtime_type = evaluate("attributes.overtime_type#i#");
                else
                    form_overtime_type = '';
                if(isdefined('attributes.activity_type#i#'))
                    form_activity_type = evaluate("attributes.activity_type#i#");
                else
                    form_activity_type = '';
                if(isdefined('attributes.state#i#'))
                    form_state = evaluate("attributes.state#i#");
                else
                    form_state = '';
                if(isdefined('attributes.time_cost_cat#i#'))
                    form_time_cost_cat = evaluate("attributes.time_cost_cat#i#");
                else
                    form_time_cost_cat = '';
                if(isdefined('attributes.time_cost_stage#i#'))
                    form_time_cost_stage = evaluate("attributes.time_cost_stage#i#");
                else
                    form_time_cost_stage = '';

                if(isdefined('attributes.is_rd_ssk#i#'))
                    form_is_rd_ssk = evaluate("attributes.is_rd_ssk#i#");
                else
                    form_is_rd_ssk = '';
            </cfscript>
            <cfset degerim = 1> 
			<cfif form_overtime_type eq 1>
				<cfset degerim = 1>
            <cfelseif form_overtime_type eq 2>
                <cfset degerim = 1.5>
            <cfelse>
                <cfquery name="get_in_out_id" datasource="#dsn#">
                    SELECT 
                        EIO.IN_OUT_ID,
                        PUANTAJ_GROUP_IDS,
                        BRANCH_ID
                    FROM
                        EMPLOYEES_IN_OUT EIO
                    WHERE
                        EIO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form_employee_id#"> AND 
                        (
                            (EIO.FINISH_DATE IS NULL AND EIO.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
                            OR
                            (
                            EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                            )
                        )
                </cfquery>
                <cfset attributes.sal_mon = MONTH(now())>
                <cfset attributes.sal_year = YEAR(now())>
                <cfset attributes.group_id = "">
                <cfif len(get_in_out_id.puantaj_group_ids)>
                    <cfset attributes.group_id = "#get_in_out_id.PUANTAJ_GROUP_IDS#,">
                </cfif>
                <cfset attributes.branch_id = get_in_out_id.branch_id>
                <cfset not_kontrol_parameter = 1>
                <cfinclude template="../../hr/ehesap/query/get_program_parameter.cfm">
                <cfif form_overtime_type eq 3>
                    <cfif isdefined("get_program_parameters.WEEKEND_MULTIPLIER") and len(get_program_parameters.WEEKEND_MULTIPLIER)>
                        <cfset degerim = get_program_parameters.WEEKEND_MULTIPLIER>
                    <cfelse>
                        <cfset degerim = 1.5>
                    </cfif>
                <cfelseif form_overtime_type eq 4>
                    <cfif isdefined("get_program_parameters.OFFICIAL_MULTIPLIER") and len(get_program_parameters.OFFICIAL_MULTIPLIER)>
                        <cfset degerim = get_program_parameters.OFFICIAL_MULTIPLIER>
                    <cfelse>
                        <cfset degerim = 2>
                    </cfif>
                </cfif>
            </cfif>
			<cfif isdefined('form_employee_id') and len(form_employee_id) and (get_hourly_salary.ON_MALIYET[listfind(list_employee_id,form_employee_id,',')] neq 0 or get_hourly_salary.ON_HOUR[listfind(list_employee_id,form_employee_id,',')] neq 0) and get_hourly_salary.ON_HOUR[listfind(list_employee_id, form_employee_id,',')] neq 0>
                <cfset salary_minute = get_hourly_salary.ON_MALIYET[listfind(list_employee_id,form_employee_id,',')] / get_hourly_salary.ON_HOUR[listfind(list_employee_id,form_employee_id,',')] / 60>
            <cfelse>
                <cfset salary_minute = 0>
            </cfif>
            <cfset attributes.today = evaluate("attributes.today#i#")>
            <cf_date tarih="attributes.today">
            <cfif isdefined("form_total_time_hour") and len(form_total_time_hour)>
                <cfset totalhour = form_total_time_hour>
            <cfelse>
                <cfset totalhour=0>
            </cfif>
            <cfif isdefined("form_total_time_minute") and len(form_total_time_minute)>
                <cfset totalminute = form_total_time_minute>
            <cfelse>
                <cfset totalminute = 0>
            </cfif>
            <cfif totalminute lt 0>
                <cfset totalminute = abs(totalminute)>
                <cfset totalminute = 60 - totalminute>*
                <cfset totalhour = totalhour-1>
            </cfif>
            <cfset topson = (totalhour*60) + totalminute>
            <cfif x_timecost_limited eq 0 and len(attributes.today)>
                <cfquery name="getTimeCost" datasource="#dsn#">
                    SELECT SUM(EXPENSED_MINUTE) EXPENSED_MINUTE FROM TIME_COST WHERE EVENT_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.today#"> AND EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form_employee_id#">
                </cfquery>
                <cfif len(getTimeCost.EXPENSED_MINUTE)>
                    <cfset topson = topson + getTimeCost.EXPENSED_MINUTE>
                </cfif>
            </cfif>
			<cfset topson = topson/60>
            <cfset total_min = ((totalhour*60)+totalminute)>
            <cfset para = wrk_round(salary_minute*total_min*degerim)>
            <cfif form_state eq 1>
                <cfquery name="ADD_TIME_COST" datasource="#dsn#">
                    INSERT INTO
                        TIME_COST
                    (
                        OUR_COMPANY_ID,
                        TOTAL_TIME,
                        EXPENSED_MONEY,
                        EXPENSED_MINUTE,
                        EMPLOYEE_ID,
                        EMPLOYEE_NAME, 
                        WORK_ID,
                        PROJECT_ID,
                        PARTNER_ID,
                        COMPANY_ID,
                        CONSUMER_ID,
                        EXPENSE_ID,
                        COMMENT,
                        EVENT_DATE,
                        PRODUCT_ID,	
                        OVERTIME_TYPE,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP,
                        ACTIVITY_ID,
                        STATE,
                        TIME_COST_CAT_ID,
                        TIME_COST_STAGE,
                        IS_RD_SSK
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(TOPSON)#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#PARA#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#TOTAL_MIN#">,
                        <cfif len(form_employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_employee_id#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form_employee#">,
                        <cfif len(form_work_id) and len(form_work_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_work_id#">,<cfelse>NULL,</cfif>
                        <cfif len(form_project_id) and len(form_project)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_project_id#">,<cfelse>NULL,</cfif>
                        <cfif len(form_partner_id) and len(form_member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_partner_id#">,<cfelse>NULL,</cfif>
                        <cfif len(form_company_id) and len(form_member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_company_id#">,<cfelse>NULL,</cfif>
                        <cfif len(form_consumer_id) and len(form_member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_consumer_id#">,<cfelse>NULL,</cfif>
                        <cfif len(form_expense_id) and len(form_expense)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_expense_id#">,<cfelse>NULL,</cfif>
                        <cfif len(form_comment)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form_comment#">,<cfelse>NULL,</cfif>
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.today#">,
                        <cfif len(form_product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_product_id#">,<cfelse>NULL,</cfif>
                        <cfif len(form_overtime_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_overtime_type#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                        <cfif isdefined('form_activity_type') and len(form_activity_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_activity_type#">,<cfelse>NULL,</cfif>
                        <cfif isdefined('form_state') and len(form_state)><cfqueryparam cfsqltype="cf_sql_bit" value="#form_state#"><cfelse>1</cfif>,
                        <cfif isdefined('form_time_cost_cat') and len(form_time_cost_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_time_cost_cat#"><cfelse>NULL</cfif>,
                        <cfif isdefined('form_time_cost_stage') and len(form_time_cost_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_time_cost_stage#"><cfelse>NULL</cfif>,
                        <cfif isdefined('form_is_rd_ssk') and len(form_is_rd_ssk)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_is_rd_ssk#"><cfelse>NULL</cfif>
                    )
                </cfquery>
            </cfif>
            <cfquery name="get_last_id" datasource="#dsn#">
                SELECT MAX(TIME_COST_ID) AS LAST_ID FROM TIME_COST
            </cfquery>
            <cfif form_state eq 0>
                <!--- İş Detayında planlanan zaman harcamaları giriliyor. Toplu zaman harcamalarının kayıtlarınında oraya yansıtılması için ekleme yapıldı. MT - 03/06/2015 --->
                <cfquery name="Get_Hıstory_Id" datasource="#dsn#">
                    SELECT HISTORY_ID FROM TIME_COST_PLANNED WHERE WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form_work_id#">
                </cfquery>
                <cfquery name="ADD_TIME_COST" datasource="#dsn#">
                    INSERT INTO
                        TIME_COST_PLANNED
                    (
                        OUR_COMPANY_ID,
                        TOTAL_TIME_MINUTE1,
                        TOTAL_TIME_HOUR1,
                        EMPLOYEE_ID,
                        EMPLOYEE_NAME, 
                        WORK_ID,
                        HISTORY_ID,
                        PARTNER_ID,
                        COMMENT,
                        PRODUCT_ID,	
                        OVERTIME_TYPE,
                        FINISH_DATE,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
                        <cfif len(totalminute)><cfqueryparam cfsqltype="cf_sql_integer" value="#totalminute#"><cfelse>0</cfif>,
                        <cfif len(totalhour)><cfqueryparam cfsqltype="cf_sql_integer" value="#totalhour#"><cfelse>0</cfif>,
                        <cfif len(form_employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_employee_id#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form_employee#">,
                        <cfif len(form_work_id) and len(form_work_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_work_id#">,<cfelse>NULL,</cfif>
                        <cfif len(Get_Hıstory_Id.History_Id)><cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Hıstory_Id.History_Id#">,<cfelse>NULL,</cfif>
                        <cfif len(form_partner_id) and len(form_member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_partner_id#">,<cfelse>NULL,</cfif>
                        <cfif len(form_comment)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form_comment#">,<cfelse>NULL,</cfif>
                        <cfif len(form_product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_product_id#">,<cfelse>NULL,</cfif>
                        <cfif len(form_overtime_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_overtime_type#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.today#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    )
                </cfquery>
            </cfif>
            <cf_workcube_process 
                is_upd='1'
                data_source='#dsn#'
                old_process_line='0'
                fusepath="time_cost"
                process_stage='#form_time_cost_stage#'
                record_member='#session.ep.userid#'
                record_date='#now()#'
                action_table='TIME_COST'
                action_column='TIME_COST_ID'
                action_id='#get_last_id.last_id#'
                warning_description='Zaman Harcamaları'>
          </cfif>
	</cfloop>
</cfif>
<script type="text/javascript">
    <cfif isdefined("attributes.fusebox_circuit") and len(attributes.fusebox_circuit) and attributes.fusebox_circuit eq 'hr'>
        alert("<cfoutput>#getLang('product',990)#</cfoutput>");
        window.location.href  = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.add_timecost_all";
    <cfelse>
        window.close();
    </cfif>
</script>
