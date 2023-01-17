<cflock timeout="70">
	<cftransaction>
		<cfquery name="GET_STORE_REPORT" datasource="#DSN2#">
			SELECT BRANCH_ID,STORE_REPORT_DATE FROM STORE_REPORT WHERE STORE_REPORT_ID = #url.id#
		</cfquery>
		<cfquery name="DEL_STORE_REPORT" datasource="#DSN2#">
			DELETE FROM STORE_REPORT WHERE STORE_REPORT_ID = #url.id#
		</cfquery>
		<cfquery name="DEL_STORE_EXPENSE" datasource="#DSN2#">
			DELETE FROM STORE_EXPENSE WHERE STORE_REPORT_ID = #url.id#
		</cfquery>
		<cfquery name="DEL_STORE_POS_BANK" datasource="#DSN2#">
			DELETE FROM STORE_POS_BANK WHERE STORE_REPORT_ID = #url.id#
		</cfquery>
		<cfquery name="DEL_STORE_POS_CASH" datasource="#DSN2#">
			DELETE FROM STORE_POS_CASH WHERE STORE_REPORT_ID = #url.id#
		</cfquery>
		<cfquery name="DEL_STORE_INCOME" datasource="#DSN2#">
			DELETE FROM STORE_INCOME WHERE STORE_REPORT_ID = #url.id#
		</cfquery>
		<cfquery name="DEL_STORE_POS_BANK_DETAIL" datasource="#DSN2#">
			DELETE FROM STORE_POS_BANK_DETAIL WHERE STORE_REPORT_ID = #url.id#
		</cfquery>
		<cfquery name="DEL_CREDIT_CARD_PAYMENTS" datasource="#DSN2#">
			DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE STORE_REPORT_ID = #url.id# AND ACTION_PERIOD_ID = #session.ep.period_id#
		</cfquery>
		<cfquery name="DEL_CREDIT_CARD_PAYMENTS_ROWS" datasource="#DSN2#">
			DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS WHERE STORE_REPORT_ID = (SELECT STORE_REPORT_ID FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE STORE_REPORT_ID = #url.id# AND ACTION_PERIOD_ID = #session.ep.period_id#)
		</cfquery>
		<cf_add_log log_type="-1" action_id="#url.id#" action_name="#get_store_report.store_report_date#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_stores_daily_reports" addtoken="no">
