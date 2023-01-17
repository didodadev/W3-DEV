<cf_date tarih='attributes.execute_startdate'>
<cfscript>
	if(len(attributes.execute_startdate))
	{
		form_execute_start_date = date_add("h", attributes.execute_start_clock, attributes.execute_startdate);
		form_execute_start_date = date_add('n', attributes.execute_start_minute, form_execute_start_date);
		form_execute_finish_date = date_add('h', attributes.execute_finish_clock, attributes.execute_startdate);
		form_execute_finish_date = date_add('n', attributes.execute_finish_minute, form_execute_finish_date);
	}
</cfscript>
<cfquery name="UPDATE_EVENT_PLAN_ROW" datasource="#DSN#">
	UPDATE
		EVENT_PLAN_ROW
	SET
		IS_INF = <cfif isdefined("attributes.is_inf")>1,<cfelse>0,</cfif>
		VISIT_STAGE = #attributes.visit_stage#,
		EXPENSE = <cfif len(attributes.visit_expense)>#attributes.visit_expense#,<cfelse>NULL,</cfif>
		MONEY_CURRENCY = '#attributes.money_name#',
		EXECUTE_STARTDATE = <cfif isdefined("form_execute_start_date")>#form_execute_start_date#,<cfelse>NULL,</cfif>
		EXECUTE_FINISHDATE = <cfif isdefined("form_execute_finish_date")>#form_execute_finish_date#,<cfelse>NULL,</cfif>
		EXPENSE_ITEM = <cfif len(attributes.expense_item)>#attributes.expense_item#,<cfelse>NULL,</cfif>
		RESULT_DETAIL = '#attributes.result#',
		RESULT_UPDATE_EMP = #session.pda.userid#,
		RESULT_UPDATE_IP = '#cgi.REMOTE_ADDR#',
		RESULT_UPDATE_DATE = #now()#
	WHERE
		EVENT_PLAN_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_plan_row_id#">
</cfquery>
<cflocation addtoken="no" url="#cgi.HTTP_REFERER#">
