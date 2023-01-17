
<cfset get_component = createObject("component", "V16.myhome.cfc.time_cost")>
<!--- SAAT ÜCRETİ HESAPLAMASI --->
<cfset get_hourly_salary = get_component.get_hourly_salary()>
<cfset salary_minute = 0>
<cfif session.ep.time_cost_control eq 1 and ListFind("1,2",session.ep.time_cost_control_type,",") and (get_hourly_salary.recordcount and not len(get_hourly_salary.ON_MALIYET) or not len(get_hourly_salary.ON_HOUR))>
	<script type="text/javascript">
		alert("<cf_get_lang no='105.İnsan Kaynakları Bölümü Pozisyon Çalışma Maliyetinizi Belirtilmemiş !'>");
		history.back();
	</script>
	<cfabort>
<cfelseif get_hourly_salary.ON_HOUR neq 0>
	<cfset salary_minute = get_hourly_salary.ON_MALIYET/get_hourly_salary.ON_HOUR/60>
</cfif>
<cfif session.ep.time_cost_control eq 1 and ListFind("1,2",session.ep.time_cost_control_type,",") and not len(get_hourly_salary.ON_HOUR)>
	<script type="text/javascript">
		alert("<cf_get_lang no='104.Lütfen SSK Aylık İş Saatlerini Düzenleyin!'>");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfif isdefined('attributes.record_num') and len(attributes.record_num) and attributes.record_num neq "">
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif isdefined("attributes.work_id#i#") and Len(evaluate("attributes.work_id#i#"))>
			<cfquery name="get_related_work_help" datasource="#dsn#">
				SELECT CUS_HELP_ID FROM PRO_WORKS WHERE WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.work_id#i#')#">
			</cfquery>
		</cfif>
		<cfscript>
			if(isdefined("attributes.work_id#i#") && Len(evaluate('attributes.work_id#i#')))
				form_cus_help_id = get_related_work_help.cus_help_id;
			else
				form_cus_help_id = "";
			form_comment = evaluate("attributes.comment#i#");
			form_is_rd_ssk = evaluate("attributes.is_rd_ssk#i#");
			form_total_time_hour = evaluate("attributes.total_time_hour#i#");
			form_total_time_minute = evaluate("attributes.total_time_minute#i#");
			if(isdefined("attributes.project_id#i#"))
			{
				form_project_id = evaluate("attributes.project_id#i#");
				form_project = evaluate("attributes.project#i#");
			}
			else
			{
				form_project_id = "";
				form_project = "";
			}
			if(isdefined("attributes.service_id#i#"))
			{
				form_service_id = evaluate("attributes.service_id#i#");
				form_service_head = evaluate("attributes.service_head#i#");
			}
			else
			{
				form_service_id = "";
				form_service_head = "";
			}
			if(isdefined("attributes.event_id#i#"))
			{
				form_event_id = evaluate("attributes.event_id#i#");
				form_event_head = evaluate("attributes.event_head#i#");
			}
			else
			{
				form_event_id = "";
				form_event_head = "";
			}
			if(isdefined("attributes.expense_id#i#"))
			{
				form_expense_id = evaluate("attributes.expense_id#i#");
				form_expense = evaluate("attributes.expense#i#");
			}
			else
			{
				form_expense_id = "";
				form_expense = "";
			}
			if(isdefined("attributes.company_id#i#"))
			{
				form_consumer_id = evaluate("attributes.consumer_id#i#");
				form_partner_id = evaluate("attributes.partner_id#i#");
				form_company_id = evaluate("attributes.company_id#i#");
				form_member_name = evaluate("attributes.member_name#i#");
			}
			else
			{
				form_consumer_id = "";
				form_partner_id = "";
				form_company_id = "";
				form_member_name = "";
			}
			if(isdefined("attributes.work_id#i#"))
			{
				form_work_id = evaluate("attributes.work_id#i#");
				form_work_head = evaluate("attributes.work_head#i#");
			}
			else
			{
				form_work_id = "";
				form_work_head = "";
			}
			if(isdefined("attributes.subscription_id#i#"))
			{
				form_subscription_id = evaluate("attributes.subscription_id#i#");
				form_subscription_no = evaluate("attributes.subscription_no#i#");
			}
			else
			{
				form_subscription_id = "";
				form_subscription_no = "";
			}
			if(isdefined("attributes.subscription_id#i#"))
			{
				form_class_id = evaluate("attributes.class_id#i#");
				form_class_name = evaluate("attributes.class_name#i#");
			}
			else
			{
				form_class_id = "";
				form_class_name = "";
			}
			form_today = evaluate("attributes.today#i#"); 
			form_time_cost_id = evaluate("attributes.time_cost_id#i#");
			form_row_kontrol = evaluate("attributes.row_kontrol#i#");
			form_overtime_type = evaluate("attributes.overtime_type#i#");
			form_time_cost_stage = evaluate("attributes.process_stage#i#");
			form_time_cost_cat = evaluate("attributes.time_cost_cat#i#");
			if(isdefined("attributes.activity#i#"))
				form_activity_id = evaluate("attributes.activity#i#");
			else
				form_activity_id = "";
		</cfscript>
		<cfif form_row_kontrol eq 1>
			<cfset degerim = 1> 
			<cfif form_overtime_type eq 1>
				<cfset degerim = 1>
			<cfelseif form_overtime_type eq 2>
				<cfset degerim = 1.5>
			<cfelse>
				<cfset get_in_out_id = get_component.get_in_out_id()>
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
			<cfset attributes.today=evaluate("attributes.today#i#")>
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
				<cfset totalminute=60 - totalminute>*
				<cfset totalhour=totalhour-1>
			</cfif>
			<cfset total_min=(totalhour*60)+totalminute>
			<cfset topson=total_min/60>
			<cfset para=wrk_round(salary_minute*total_min*degerim)>
			<cfif not len(evaluate("attributes.comment#i#"))>
				<cfset form_comment = '#session.ep.name# #session.ep.surname#'>
			</cfif>
			<cfif len(form_time_cost_id)>
				<cfif (len(form_total_time_hour) and form_total_time_hour gt 0) or (len(form_total_time_minute) and form_total_time_minute gt 0)>
					<cfset upd_time_cost = get_component.upd_time_cost(
						topson : wrk_round(topson),
						para : para,
						total_min : total_min,
						form_work_id : form_work_id,
						form_cus_help_id : form_cus_help_id,
						form_service_id : form_service_id,
						form_event_id : form_event_id,
						form_partner_id : form_partner_id,
						form_company_id : form_company_id,
						form_consumer_id : form_consumer_id,
						form_expense_id : form_expense_id,
						form_project_id : (isdefined("form_project_id") and len(form_project_id) and isdefined("form_project") and len(form_project)) ? form_project_id : '',
						form_project : (isdefined("form_project_id") and len(form_project_id) and isdefined("form_project") and len(form_project)) ? form_project : '',
						form_subscription_id : form_subscription_id,
						form_class_id : form_class_id,
						form_comment : form_comment,
						form_is_rd_ssk : (isDefined("form_is_rd_ssk") and len(form_is_rd_ssk)) ? form_is_rd_ssk : 0,
						today : attributes.today,
						form_overtime_type : form_overtime_type,
						form_time_cost_stage : form_time_cost_stage,
						form_time_cost_cat : form_time_cost_cat,
						form_activity_id : form_activity_id,
						form_time_cost_id : form_time_cost_id,
						form_member_name : form_member_name,
						form_expense : form_expense,
						form_work_head : form_work_head,
						form_service_head : form_service_head,
						form_event_head : form_event_head,
						form_subscription_no : form_subscription_no,
						form_class_name : form_class_name
					)>
				</cfif>
			<cfelse>
				<cfif (len(form_total_time_hour) and form_total_time_hour gt 0) or (len(form_total_time_minute) and form_total_time_minute gt 0)>
					<cfif isdefined("attributes.work_id#i#") and Len(evaluate("attributes.work_id#i#"))>
						<cfquery name="time_add_new" datasource="#dsn#">	
							INSERT INTO
								PRO_WORKS_HISTORY
								(
									WORK_ID,
									WORK_HEAD,
									WORK_DETAIL,
									UPDATE_AUTHOR,
									TOTAL_TIME_HOUR,
									TOTAL_TIME_MINUTE,
									UPDATE_DATE
								)
								VALUES
								(
								<cfqueryparam cfsqltype="cf_sql_integer" value="#form_work_id#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_work_head#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#form_comment#">,
									<cfif isdefined('session.ep.userid') and len(session.ep.userid)><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"></cfif>,
									<cfif isDefined("form_total_time_hour") and len(form_total_time_hour)>#form_total_time_hour#<cfelse>NULL</cfif>,
									<cfif isDefined("form_total_time_minute") and len(form_total_time_minute)>#form_total_time_minute#<cfelse>NULL</cfif>,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
								)
						</cfquery>
					</cfif>
					<cfset ADD_TIME_COST = get_component.ADD_TIME_COST(
						topson : wrk_round(topson),
						para : para,
						total_min : total_min,
						form_work_id : form_work_id,
						form_cus_help_id : form_cus_help_id,
						form_service_id : form_service_id,
						form_event_id : form_event_id,
						form_partner_id : form_partner_id,
						form_company_id : form_company_id,
						form_consumer_id : form_consumer_id,
						form_expense_id : form_expense_id,
						form_project_id : (isdefined("form_project_id") and len(form_project_id) and isdefined("form_project") and len(form_project)) ? form_project_id : "",
						form_project : (isdefined("form_project_id") and len(form_project_id) and isdefined("form_project") and len(form_project)) ? form_project : '',
						form_subscription_id : form_subscription_id,
						form_class_id : form_class_id,
						form_comment : form_comment,
						form_is_rd_ssk : (isDefined("form_is_rd_ssk") and len(form_is_rd_ssk)) ? form_is_rd_ssk : 0,
						today : attributes.today,
						form_overtime_type : form_overtime_type,
						form_time_cost_stage : form_time_cost_stage,
						form_time_cost_cat : form_time_cost_cat,
						form_activity_id : form_activity_id,
						form_time_cost_id : form_time_cost_id,
						form_member_name : form_member_name,
						form_expense : form_expense,
						form_work_head : form_work_head,
						form_service_head : form_service_head,
						form_event_head : form_event_head,
						form_subscription_no : form_subscription_no,
						form_class_name : form_class_name
					)>
					<cfquery name="get_last_id" datasource="#dsn#">
						SELECT MAX(TIME_COST_ID) AS LAST_ID FROM TIME_COST
					</cfquery>
					<cfset form_time_cost_id = get_last_id.last_id>
				</cfif>
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
				action_id='#form_time_cost_id#'
				warning_description='Zaman Harcamaları'>
		<cfelseif len(form_time_cost_id)>
			<cfquery name="del_time_cost" datasource="#dsn#">
				DELETE FROM TIME_COST WHERE TIME_COST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form_time_cost_id#">
			</cfquery>
		</cfif>
	</cfloop>
</cfif>
<script>    
	window.location.href='<cfoutput>#request.self#?fuseaction=myhome.upd_myweek</cfoutput>';
</script>
