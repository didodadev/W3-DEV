<cf_date tarih='attributes.execute_start_date'>
<cf_date tarih='attributes.execute_finish_date'>
<cfquery name="ADD_EVENT_PLAN_ROW" datasource="#dsn#">
	UPDATE
		ACTIVITY_PLAN_ROW
	SET
		PLAN_ROW_STATUS = 1,
		COMPANY_ID = #attributes.company_id#,
		PARTNER_ID = #attributes.partner_id#,
		WARNING_ID = #attributes.visit_type#,
		START_DATE = #attributes.execute_start_date#,
		FINISH_DATE = #attributes.execute_finish_date#,
		VISIT_STAGE = #attributes.visit_stage#,
		EXPENSE = <cfif len(attributes.visit_expense)>#attributes.visit_expense#,<cfelse>NULL,</cfif>
		MONEY_CURRENCY = <cfif len(attributes.money)>'#attributes.money#',<cfelse>NULL,</cfif>
		EXPENSE_ITEM = <cfif len(attributes.expense_item)>#attributes.expense_item#,<cfelse>NULL,</cfif>
		POSITION_ID = <cfif len(attributes.employee_id) and len(attributes.employee_name)>#attributes.employee_id#,<cfelse>NULL,</cfif>
		EXECUTE_STARTDATE = <cfif len(attributes.execute_start_date)>#attributes.execute_start_date#,<cfelse>NULL,</cfif>
		EXECUTE_FINISHDATE = <cfif len(attributes.execute_finish_date)>#attributes.execute_finish_date#,<cfelse>NULL,</cfif>
		RESULT_DETAIL = '#attributes.detail#',
		RESULT_UPDATE_EMP = #session.ep.userid#,
		RESULT_UPDATE_DATE =  #now()#,
		RESULT_UPDATE_IP = '#cgi.remote_addr#'
	WHERE
		EVENT_PLAN_ROW_ID = #attributes.event_plan_row_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
