<cf_date tarih='attributes.execute_start_date'>
<cf_date tarih='attributes.execute_finish_date'>
<cfquery name="ADD_EVENT_PLAN_ROW" datasource="#dsn#">
	INSERT
	INTO
		ACTIVITY_PLAN_ROW
		(
			PLAN_ROW_STATUS,
			COMPANY_ID,
			PARTNER_ID,
			WARNING_ID,
			VISIT_STAGE,
			EXPENSE,
			MONEY_CURRENCY,
			EXPENSE_ITEM,
			POSITION_ID,
			EXECUTE_STARTDATE,
			EXECUTE_FINISHDATE,
			RESULT_DETAIL,
			RESULT_RECORD_EMP,
			RESULT_RECORD_DATE,
			RESULT_RECORD_IP,
			START_DATE,
			FINISH_DATE
		)
		VALUES
		(
			1,
			#attributes.company_id#,
			#attributes.partner_id#,
			#attributes.visit_type#,
			#attributes.visit_stage#,
			<cfif len(attributes.visit_expense)>#attributes.visit_expense#,<cfelse>NULL,</cfif>
			<cfif len(attributes.money)>'#attributes.money#',<cfelse>NULL,</cfif>
			<cfif len(attributes.expense_item)>#attributes.expense_item#,<cfelse>NULL,</cfif>
			<cfif len(attributes.employee_id) and len(attributes.employee_name)>#attributes.employee_id#,<cfelse>NULL,</cfif>
			<cfif len(attributes.execute_start_date)>#attributes.execute_start_date#,<cfelse>NULL,</cfif>
			<cfif len(attributes.execute_finish_date)>#attributes.execute_finish_date#,<cfelse>NULL,</cfif>
			'#attributes.detail#',
			#session.ep.userid#,
			#now()#,
			'#cgi.REMOTE_ADDR#',
			<cfif len(attributes.execute_start_date)>#attributes.execute_start_date#,<cfelse>NULL,</cfif>
			<cfif len(attributes.execute_finish_date)>#attributes.execute_finish_date#<cfelse>NULL</cfif>
		)
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		location.href = document.referrer;
	</cfif>
	
</script>
