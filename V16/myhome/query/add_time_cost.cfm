<!--- SAAT ÜCRETİ HESAPLAMASI --->
<cf_xml_page_edit fuseact="myhome.emptypopup_form_add_timecost">
<cfquery name="get_hourly_salary" datasource="#dsn#">
	SELECT
		ISNULL(ON_MALIYET,0) ON_MALIYET,
		ISNULL(ON_HOUR,0) ON_HOUR,
		IS_MASTER,
		ISNULL(ON_HOUR_DAILY,0) ON_HOUR_DAILY
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		IS_MASTER = 1 AND
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
</cfquery>
<cfif session.ep.time_cost_control eq 1 and ListFind("1,2",session.ep.time_cost_control_type,",") and get_hourly_salary.ON_HOUR lte 0>
	<script type="text/javascript">
		alert("<cf_get_lang no='104.Lütfen SSK Aylık İş Saatlerini Düzenleyin!'>");
		history.back();
	</script>
	<cfabort>
</cfif>
	<cfset salary_minute = 0>
<cfif session.ep.time_cost_control eq 1 and ListFind("1,2",session.ep.time_cost_control_type,",") and (not get_hourly_salary.recordcount or get_hourly_salary.ON_MALIYET lte 0 or get_hourly_salary.ON_HOUR lte 0)>
	<script type="text/javascript">
		alert("<cf_get_lang no='105.İnsan Kaynakları Bölümü Pozisyon Çalışma Maliyetinizi Belirtilmemiş !'>");
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfquery name="get_style" datasource="#dsn#">
		SELECT IS_TIME_STYLE FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	</cfquery>
	<cfif (not len(get_style.IS_TIME_STYLE) or get_style.IS_TIME_STYLE eq 1) and get_hourly_salary.ON_HOUR neq 0><!--- haftalik kontrol --->
		<cfset salary_minute = get_hourly_salary.ON_MALIYET / get_hourly_salary.ON_HOUR / 60>
	<cfelseif get_style.IS_TIME_STYLE eq 2 and get_hourly_salary.ON_HOUR_DAILY neq 0><!--- gunluk kontrol --->
		<cfset salary_minute = get_hourly_salary.ON_MALIYET / get_hourly_salary.ON_HOUR_DAILY / 60>
	</cfif>
</cfif>
<CF_DATE TARIH="attributes.today">
<cfset degerim = 1> <!--- Mesai Türü için --->
<cfif isdefined('overtime_type') and overtime_type eq 1>
	<cfset degerim = 1>
<cfelseif isdefined('overtime_type') and overtime_type eq 2>
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
				(EIO.FINISH_DATE IS NULL AND EIO.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
				OR
				EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
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
	<cfif isdefined('overtime_type') and overtime_type eq 3>
		<cfif isdefined("get_program_parameters.WEEKEND_MULTIPLIER") and len(get_program_parameters.WEEKEND_MULTIPLIER)>
			<cfset degerim = get_program_parameters.WEEKEND_MULTIPLIER>
		<cfelse>
			<cfset degerim = 1.5>
		</cfif>
	<cfelseif isdefined('overtime_type') and overtime_type eq 4>
		<cfif isdefined("get_program_parameters.OFFICIAL_MULTIPLIER") and len(get_program_parameters.OFFICIAL_MULTIPLIER)>
			<cfset degerim = get_program_parameters.OFFICIAL_MULTIPLIER>
		<cfelse>
			<cfset degerim = 2>
		</cfif>
	</cfif>
</cfif>
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
<cfelseif len(finish) and len(start) and not len(total_time_minute)>
	<cfset totalhour=finish-start>
<cfelse>
	<cfset totalhour=0>
</cfif>
<cfif len(total_time_minute)>
	<cfset totalminute=total_time_minute>
<cfelseif isdefined('finish_min') and len(finish_min) and isdefined('start_min') and len(start_min) and not len(total_time_hour)>
	<cfset totalminute=finish_min-start_min>
<cfelse>
	<cfset totalminute=0>
</cfif>
<cfif totalminute lt 0>
	<cfset totalminute=abs(totalminute)>
	<cfset totalminute=60-totalminute>*
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
 <cfquery name="ADD_TIME_COST" datasource="#dsn#"> 
	INSERT INTO
		TIME_COST
	(
		OUR_COMPANY_ID,
		TOTAL_TIME,
		EXPENSED_MONEY,
		EXPENSED_MINUTE,
		EMPLOYEE_ID,
		WORK_ID,
		SERVICE_ID,
		CRM_ID,
		CUS_HELP_ID,
		P_ORDER_RESULT_ID,
		EVENT_ID,
		PROJECT_ID,
		SUBSCRIPTION_ID,
		CLASS_ID,
		PARTNER_ID,
		COMPANY_ID,
		CONSUMER_ID,
		EXPENSE_ID,
		COMMENT,
		EVENT_DATE,
		OVERTIME_TYPE,
		START,
		FINISH,
		START_MIN,
		FINISH_MIN,
		STATE,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP,
		ACTIVITY_ID,
		TIME_COST_CAT_ID,
		TIME_COST_STAGE,
		IS_RD_SSK
	)
	VALUES
	(
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
		<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(topson)#">,
		<cfqueryparam cfsqltype="cf_sql_float" value="#para#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#total_min#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">,
		<cfif len(work_id) and len(work_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#work_id#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.is_service") and attributes.is_service eq 1 and len(service_id) and len(service_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#service_id#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.is_call_service") and attributes.is_call_service eq 1 and len(service_id) and len(service_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#service_id#"><cfelse>NULL</cfif>, 
		<cfif len(attributes.cus_help_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#"><cfelse>NULL</cfif>,
		<cfif len(attributes.p_order_result_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_result_id#"><cfelse>NULL</cfif>,
		<cfif len(event_id) and len(event_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#event_id#"><cfelse>NULL</cfif>,
		<cfif len(project_id) and len(project_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#project_id#"><cfelse>NULL</cfif>,
		<cfif len(subscription_id) and len(subscription_no)><cfqueryparam cfsqltype="cf_sql_integer" value="#subscription_id#"><cfelse>NULL</cfif>,
		<cfif len(class_id) and len(class_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#"><cfelse>NULL</cfif>,
		<cfif len(attributes.member_name) and len(attributes.partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#"><cfelse>NULL</cfif>,
		<cfif len(attributes.member_name) and len(attributes.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"><cfelse>NULL</cfif>,
		<cfif len(attributes.member_name) and len(attributes.consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"><cfelse>NULL</cfif>,
		<cfif len(expense_id) and len(expense)><cfqueryparam cfsqltype="cf_sql_integer" value="#expense_id#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.comment") and len(attributes.comment)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.comment#"><cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.today#">,
		<cfif isdefined('overtime_type') and len(overtime_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#overtime_type#"><cfelse>NULL</cfif>,
		<cfif len(start) and not len(total_time_hour) and not len(total_time_minute)><cfqueryparam cfsqltype="cf_sql_integer" value="#start#"><cfelse>NULL</cfif>,
		<cfif len(finish) and not len(total_time_hour) and not len(total_time_minute)><cfqueryparam cfsqltype="cf_sql_integer" value="#finish#"><cfelse>NULL</cfif>,
		<cfif isdefined('start_min') and len(start_min) and not len(total_time_hour) and not len(total_time_minute)><cfqueryparam cfsqltype="cf_sql_integer" value="#start_min#"><cfelse>NULL</cfif>,
		<cfif isdefined('finish_min') and len(finish_min) and not len(total_time_hour) and not len(total_time_minute)><cfqueryparam cfsqltype="cf_sql_integer" value="#finish_min#"><cfelse>NULL</cfif>,
		1,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		<cfif len(activity)><cfqueryparam cfsqltype="cf_sql_integer" value="#activity#"><cfelse>NULL</cfif>,
		<cfif len(attributes.time_cost_cat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.time_cost_cat_id#"><cfelse>NULL</cfif>,
		<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
		<cfif isdefined('attributes.is_rd_ssk') and len(attributes.is_rd_ssk)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_rd_ssk#"><cfelse>NULL</cfif>
	)
 </cfquery>

<cfquery name="get_last_id" datasource="#dsn#">
	SELECT MAX(TIME_COST_ID) AS LAST_ID FROM TIME_COST
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
	action_id='#get_last_id.last_id#'
	warning_description='Zaman Harcamaları'>
<script type="text/javascript">
	<cfif (attributes.is_service eq 1) or (attributes.is_call_service eq 1) or (attributes.is_subscription eq 1) or (attributes.is_bug eq 1) or (attributes.is_cus_help eq 1)>	
		location.href = document.referrer;
	<cfelseif attributes.is_p_order_result eq 1>
		location.href ="<cfoutput>#request.self#?fuseaction=myhome.mytime_management&event=add&p_order_result_id=#attributes.p_order_result_id#&is_p_order_result=1</cfoutput>";
	<cfelse>
		location.href='<cfoutput>#request.self#?fuseaction=myhome.mytime_management</cfoutput>';		
	</cfif>
</script>


<cfset attributes.actionId = get_last_id.last_id>