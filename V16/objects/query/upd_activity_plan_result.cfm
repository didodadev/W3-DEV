<cf_date tarih='attributes.execute_start_date'>
<cf_date tarih='attributes.execute_finish_date'>
<cfquery name="UPDATE_EVENT_PLAN_ROW" datasource="#dsn#">
	UPDATE
		ACTIVITY_PLAN_ROW
	SET
		IS_POS = <cfif isdefined("attributes.is_pos")>1,<cfelse>0,</cfif>
		IS_INF = <cfif isdefined("attributes.is_inf")>1,<cfelse>0,</cfif>
		VISIT_STAGE = #attributes.visit_stage#,
		EXPENSE = <cfif len(attributes.visit_expense)>#attributes.visit_expense#,<cfelse>null,</cfif>
		MONEY_CURRENCY = '#attributes.money#',
		EXPENSE_ITEM = <cfif len(attributes.expense_item)>#attributes.expense_item#,<cfelse>null,</cfif>
		EXECUTE_STARTDATE = <cfif len(attributes.execute_start_date)>#attributes.execute_start_date#,<cfelse>null,</cfif>
		EXECUTE_FINISHDATE = <cfif len(attributes.execute_finish_date)>#attributes.execute_finish_date#,<cfelse>null,</cfif>
		RESULT_DETAIL = '#attributes.result#',
		RESULT_UPDATE_EMP = #session.ep.userid#,
		RESULT_UPDATE_DATE = #now()#,
		RESULT_UPDATE_IP = '#cgi.REMOTE_ADDR#'
	WHERE
		EVENT_PLAN_ROW_ID = #attributes.event_plan_row_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
