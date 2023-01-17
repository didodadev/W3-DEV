
<cf_date tarih='attributes.execute_startdate'>
<cfscript>
	if(isdefined("attributes.execute_startdate") and len(attributes.execute_startdate))
	{
		form_execute_start_date = date_add("h", attributes.execute_start_clock, attributes.execute_startdate);
		form_execute_start_date = date_add('n', attributes.execute_start_minute, form_execute_start_date);
		form_execute_finish_date = date_add('h', attributes.execute_finish_clock, attributes.execute_startdate);
		form_execute_finish_date = date_add('n', attributes.execute_finish_minute, form_execute_finish_date);
	}
	else
	{
		form_execute_start_date = now();
		form_execute_finish_date = now();
	}
</cfscript>
	<cfquery name="UPDATE_EVENT_PLAN_ROW" datasource="#DSN#">
		UPDATE
			EVENT_PLAN_ROW
		SET
		IS_INF = <cfif isdefined("attributes.is_inf")>1<cfelse>0</cfif>,
		VISIT_STAGE =<cfif isdefined("attributes.visit_stage") and len(attributes.visit_stage)>#attributes.visit_stage#<cfelse>NULL</cfif>,  
		VISIT_RESULT_ID = <cfif isdefined("attributes.visit_result_category") and len(attributes.visit_result_category)>'#attributes.visit_result_category#'<cfelse>NULL</cfif>,
		EXPENSE = <cfif  isdefined("attributes.visit_expense") and len(attributes.visit_expense)>#attributes.visit_expense#<cfelse>NULL</cfif>,
		MONEY_CURRENCY =<cfif isdefined("attributes.money_name") and len(attributes.money_name)>'#attributes.money_name#'<cfelse>NULL</cfif>,
		EXECUTE_STARTDATE = <cfif isdefined("attributes.execute_startdate") and len(attributes.execute_startdate)>#form_execute_start_date#<cfelse>NULL</cfif>,
		EXECUTE_FINISHDATE = <cfif isdefined("attributes.execute_startdate") and len(attributes.execute_startdate)>#form_execute_finish_date#<cfelse>NULL</cfif>,
		EXPENSE_ITEM = <cfif isdefined("attributes.expense_item") and len(attributes.expense_item) >#attributes.expense_item#<cfelse>NULL</cfif>,
		RESULT_DETAIL =<cfif isdefined("attributes.result") and len(attributes.result)>'#attributes.result#'<cfelse>NULL</cfif>,
		RESULT_PROCESS_STAGE =<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
		RESULT_UPDATE_EMP = #session.ep.userid#,
		RESULT_UPDATE_IP = '#cgi.remote_addr#',
		RESULT_UPDATE_DATE = #now()#
		WHERE
			EVENT_PLAN_ROW_ID = #attributes.event_plan_row_id#
	</cfquery>
	<cfquery name="get_event_plan" datasource="#dsn#">
		SELECT EVENT_PLAN_ID FROM EVENT_PLAN_ROW WHERE EVENT_PLAN_ROW_ID = #attributes.event_plan_row_id#
	</cfquery>
	<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
	<cf_workcube_process 
		is_upd='1' 
		old_process_line='0'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_table='EVENT_PLAN_ROW'
		action_column='EVENT_PLAN_ROW_ID'
		action_id='#attributes.event_plan_row_id#'
		action_page='#request.self#?fuseaction=objects.popup_upd_event_plan_result&eventid=#get_event_plan.event_plan_id#&event_plan_row_id=#attributes.event_plan_row_id#' 
		warning_description='Ziyaret Sonucu : #attributes.event_plan_row_id#'>
	</cfif>
<script type="text/javascript">
	location.href = document.referrer;
</script>

