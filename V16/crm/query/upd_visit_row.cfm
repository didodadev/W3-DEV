<cf_date tarih='attributes.execute_startdate'>
<cfscript>
		form_execute_start_date = date_add("h", attributes.execute_start_clock, attributes.execute_startdate);
		form_execute_start_date = date_add('n', attributes.execute_start_minute, form_execute_start_date);
		form_execute_finish_date = date_add('h', attributes.execute_finish_clock, attributes.execute_startdate);
		form_execute_finish_date = date_add('n', attributes.execute_finish_minute, form_execute_finish_date);
</cfscript>
<cfquery name="ADD_EVENT_PLAN_ROW" datasource="#dsn#">
	UPDATE
		EVENT_PLAN_ROW
	SET
		BRANCH_ID = <cfif len(attributes.sales_zones)>#attributes.sales_zones#,<cfelse>NULL,</cfif>
		IS_ACTIVE = 1,
		COMPANY_ID = #attributes.company_id#,
		PARTNER_ID = #attributes.partner_id#,
		WARNING_ID = #attributes.visit_type#,
		START_DATE = #form_execute_start_date#,
		FINISH_DATE = #form_execute_finish_date#,
		VISIT_STAGE = #attributes.visit_stage#,
		EXPENSE = <cfif len(attributes.visit_expense)>#attributes.visit_expense#,<cfelse>NULL,</cfif>
		MONEY_CURRENCY = <cfif len(attributes.money)>'#attributes.money#',<cfelse>NULL,</cfif>
		EXECUTE_STARTDATE = #form_execute_start_date#,
		EXECUTE_FINISHDATE = #form_execute_finish_date#,
		EXPENSE_ITEM = <cfif len(attributes.expense_item)>#attributes.expense_item#,<cfelse>NULL,</cfif>
		PLAN_ROW_STATUS = 1,
		RESULT_DETAIL = '#attributes.detail#',
		RESULT_UPDATE_IP = '#cgi.REMOTE_ADDR#',
		RESULT_UPDATE_DATE = #now()#,
		RESULT_UPDATE_EMP = #session.ep.userid#,
		RECORD_DATE = #now()#,
		RECORD_EMP = #session.ep.userid#,
		RECORD_IP = '#cgi.remote_addr#'
	WHERE
		EVENT_PLAN_ROW_ID = #attributes.event_plan_row_id#
</cfquery>
<cfquery name="UPD_ROW_POS" datasource="#dsn#">
	DELETE FROM EVENT_PLAN_ROW_PARTICIPATION_POS WHERE EVENT_ROW_ID = #attributes.event_plan_row_id#
</cfquery>
<cfif len(attributes.employee_id) and len(attributes.employee_name)>
	<cfloop from="1" to="#listlen(attributes.employee_id,',')#" index="i">
		<cfquery name="ADD_ROW_POS" datasource="#dsn#">
			INSERT
			INTO
				EVENT_PLAN_ROW_PARTICIPATION_POS
				(
					EVENT_ROW_ID,
					EVENT_POS_ID
				)
				VALUES
				(
					#attributes.event_plan_row_id#,
					#listgetat(attributes.employee_id, i, ',')#
				)
		</cfquery>
	</cfloop> 
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
