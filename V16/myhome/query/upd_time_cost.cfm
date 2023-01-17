<cf_xml_page_edit fuseact="myhome.emptypopup_form_add_timecost">
<cfquery name="get_hourly_salary" datasource="#dsn#">
	SELECT
		ISNULL(ON_MALIYET,0) ON_MALIYET,
		ISNULL(ON_HOUR,0) ON_HOUR,
		IS_MASTER
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		IS_MASTER = 1 AND
		EMPLOYEE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>
<cfset salary_minute = 0>
<cfif session.ep.time_cost_control eq 1 and ListFind("1,2",session.ep.time_cost_control_type,",") and (get_hourly_salary.recordcount) and (get_hourly_salary.ON_MALIYET eq "") and (get_hourly_salary.ON_HOUR eq  "")>
	<script type="text/javascript">
		alert("<cf_get_lang no='17.İnsan Kaynakları Bölümü Pozisyon Başlama Maliyetinizi Belirtilmemiş !'>");
		history.back();
	</script>
	<cfabort>
<cfelseif get_hourly_salary.ON_HOUR neq 0>
	<cfset salary_minute = get_hourly_salary.ON_MALIYET / get_hourly_salary.ON_HOUR / 60>
</cfif>
<cfif session.ep.time_cost_control eq 1 and ListFind("1,2",session.ep.time_cost_control_type,",") and not len(get_hourly_salary.ON_HOUR)>
	<script type="text/javascript">
		alert("<cf_get_lang no='104.Lütfen SSK Aylık İş Saatlerini Düzenleyin !'>");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfset degerim = 1> <!--- Mesai Türü için --->
	<cfif isdefined('overtime_type')>
		<cfif overtime_type eq 1>
			<cfset degerim = 1>
		<cfelseif overtime_type eq 2>
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
					EIO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND 
					(
						(EIO.FINISH_DATE IS NULL AND EIO.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
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
			<cfif overtime_type eq 3>
				<cfif isdefined("get_program_parameters.WEEKEND_MULTIPLIER") and len(get_program_parameters.WEEKEND_MULTIPLIER)>
					<cfset degerim = get_program_parameters.WEEKEND_MULTIPLIER>
				<cfelse>
					<cfset degerim = 1.5>
				</cfif>
			<cfelseif overtime_type eq 4>
				<cfif isdefined("get_program_parameters.OFFICIAL_MULTIPLIER") and len(get_program_parameters.OFFICIAL_MULTIPLIER)>
					<cfset degerim = get_program_parameters.OFFICIAL_MULTIPLIER>
				<cfelse>
					<cfset degerim = 2>
				</cfif>
			</cfif>
		</cfif>
	</cfif>
<cf_date tarih="attributes.today">
<cfset start=event_start_clock>
<cfset finish=event_finish_clock>
<cfif isdefined('event_finish_minute')>
	<cfset finish_min=event_finish_minute>
</cfif>
<cfif isdefined('event_start_minute')>
	<cfset start_min=event_start_minute>
</cfif>

<cfif len(total_time_hour)>
	<cfset totalhour=total_time_hour>
<cfelseif len(finish) and len(start)>
	<cfset totalhour=finish-start>
<cfelse>
	<cfset totalhour=0>
</cfif>
<cfif len(total_time_minute)>
	<cfset totalminute=total_time_minute>
<cfelseif isdefined('finish_min') and len(finish_min) and len(start_min)>
	<cfset totalminute=finish_min-start_min>
<cfelse>
	<cfset totalminute=0>
</cfif>

<cfif totalminute lt 0>
	<cfset totalminute=abs(totalminute)>
	<cfset totalminute=60-totalminute>
	<cfset totalhour=totalhour-1>
</cfif>
<cfset topson=(totalhour*60)+totalminute>
<cfif  topson gt 1440 and isdefined('x_timecost_limited') and x_timecost_limited eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1144.Zaman Harcaması Bir Gün İçin 24 Saatten Fazla Girilemez'>!");
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfset topson=topson/60>
</cfif>
<cfset total_min=(totalhour*60)+totalminute>
<cfset para=wrk_round(salary_minute*total_min*degerim)>
<cfquery name="upd_time_cost" datasource="#dsn#">
	UPDATE TIME_COST
	SET
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
		TOTAL_TIME = <cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(topson)#">,
		EXPENSED_MONEY = <cfqueryparam cfsqltype="cf_sql_float" value="#para#">,
		EXPENSED_MINUTE = <cfqueryparam cfsqltype="cf_sql_integer" value="#total_min#">,
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">,
		WORK_ID = <cfif len(work_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#work_id#"><cfelse>NULL</cfif>,
		SERVICE_ID =<cfif len(service_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#service_id#"><cfelse>NULL</cfif>,
		EVENT_ID = <cfif len(event_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#event_id#"><cfelse>NULL</cfif>,
		PARTNER_ID = <cfif len(attributes.partner_id) and len(attributes.member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#"><cfelse>NULL</cfif>,
		COMPANY_ID = <cfif len(attributes.company_id) and len(attributes.member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"><cfelse>NULL</cfif>,
		CONSUMER_ID = <cfif len(attributes.consumer_id) and len(attributes.member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"><cfelse>NULL</cfif>,
		EXPENSE_ID = <cfif len(expense_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#expense_id#"><cfelse>NULL</cfif>,
		PROJECT_ID = <cfif len(attributes.project_id) and len(attributes.project_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#project_id#"><cfelse>NULL</cfif>,
		SUBSCRIPTION_ID = <cfif len(subscription_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#subscription_id#"><cfelse>NULL</cfif>,
		CLASS_ID = <cfif len(class_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#"><cfelse>NULL</cfif>,
		COMMENT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#comment#">,
		EVENT_DATE =  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.today#">,
		OVERTIME_TYPE = <cfif isdefined('attributes.overtime_type') and len(attributes.overtime_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.overtime_type#"><cfelse>NULL</cfif>,
		START = <cfif len(start) and not len(total_time_hour) and not len(total_time_minute)><cfqueryparam cfsqltype="cf_sql_integer" value="#start#"><cfelse>NULL</cfif>,
		FINISH = <cfif len(finish) and not len(total_time_hour) and not len(total_time_minute)><cfqueryparam cfsqltype="cf_sql_integer" value="#finish#"><cfelse>NULL</cfif>,
		START_MIN = <cfif isdefined('start_min') and len(start_min) and not len(total_time_hour) and not len(total_time_minute)><cfqueryparam cfsqltype="cf_sql_integer" value="#start_min#"><cfelse>NULL</cfif>,
		FINISH_MIN = <cfif isdefined('finish_min') and len(finish_min) and not len(total_time_hour) and not len(total_time_minute)><cfqueryparam cfsqltype="cf_sql_integer" value="#finish_min#"><cfelse>NULL</cfif>,
		UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
        ACTIVITY_ID = <cfif isdefined('activity') and len(activity)><cfqueryparam cfsqltype="cf_sql_integer" value="#activity#"><cfelse>NULL</cfif>,
        TIME_COST_CAT_ID = <cfif isdefined('attributes.time_cost_cat_id') and len(attributes.time_cost_cat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.time_cost_cat_id#"><cfelse>NULL</cfif>,
        TIME_COST_STAGE =<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
		IS_RD_SSK =	<cfif isdefined('attributes.is_rd_ssk') and len(attributes.is_rd_ssk)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_rd_ssk#"><cfelse>NULL</cfif>

	WHERE
		TIME_COST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#time_cost_id#">
</cfquery>
<cf_workcube_process 
	is_upd='1'
	data_source='#dsn#'
	old_process_line='0'
	process_stage='#attributes.process_stage#'
	record_member='#session.ep.userid#'
	record_date='#now()#'
	action_table='TIME_COST'
	action_column='TIME_COST_ID'
	action_id='#attributes.time_cost_id#'
	warning_description='Zaman Harcamaları'>
<cfif isdefined("attributes.is_popup")>
    <script>    
		window.location.href='<cfoutput>#request.self#?fuseaction=myhome.popup_form_upd_timecost&time_cost_id=#time_cost_id#</cfoutput>';
	</script>
<cfelseif isdefined("attributes.draggable") and attributes.draggable eq 1>
	<script>
		location.href=document.referrer;
	</script>
<cfelse>
    <script>    
		window.location.href='<cfoutput>#request.self#?fuseaction=myhome.mytime_management</cfoutput>';
	</script>
</cfif>
<cfset attributes.actionId = time_cost_id>