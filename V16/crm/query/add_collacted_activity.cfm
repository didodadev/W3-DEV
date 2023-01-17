<cfif len(attributes.execute_start_date)>
	<cf_date tarih='attributes.execute_start_date'>
</cfif>
<cfif len(attributes.execute_finish_date)>
	<cf_date tarih='attributes.execute_finish_date'>
</cfif>
<cfquery name="GET_ROWS" datasource="#dsn#">
	SELECT 
		ACTIVITY_PLAN_ROW.EVENT_PLAN_ROW_ID
	FROM
		ACTIVITY_PLAN,
		ACTIVITY_PLAN_ROW
	WHERE
		ACTIVITY_PLAN.EVENT_PLAN_ID = #attributes.event_plan_id# AND
		ACTIVITY_PLAN.EVENT_PLAN_ID = ACTIVITY_PLAN_ROW.EVENT_PLAN_ID
</cfquery>
<cfoutput query="GET_ROWS">
	<cfquery name="UPDATE_EVENT_PLAN_ROW" datasource="#dsn#">
		UPDATE
			ACTIVITY_PLAN_ROW
		SET
			IS_POS = <cfif isdefined("attributes.is_pos")>1,<cfelse>0,</cfif>
			IS_INF = <cfif isdefined("attributes.is_inf")>1,<cfelse>0,</cfif>
			VISIT_STAGE = #attributes.visit_stage#,
			EXPENSE = <cfif len(attributes.visit_expense)>#attributes.visit_expense#,<cfelse>NULL,</cfif>
			MONEY_CURRENCY = '#attributes.money#',
			EXPENSE_ITEM = <cfif len(attributes.expense_item)>#attributes.expense_item#,<cfelse>NULL,</cfif>
			EXECUTE_STARTDATE = <cfif len(attributes.execute_start_date)>#attributes.execute_start_date#,<cfelse>NULL,</cfif>
			EXECUTE_FINISHDATE = <cfif len(attributes.execute_finish_date)>#attributes.execute_finish_date#,<cfelse>NULL,</cfif>
			RESULT_DETAIL = '#attributes.result#',
			RESULT_RECORD_DATE = #now()#,
			RESULT_RECORD_EMP = #session.ep.userid#,
			RESULT_RECORD_IP = '#cgi.REMOTE_ADDR#'
		WHERE
			EVENT_PLAN_ROW_ID = #get_rows.event_plan_row_id#
	</cfquery>
</cfoutput>
<script type="text/javascript">
	location.href = document.referrer;
</script>
