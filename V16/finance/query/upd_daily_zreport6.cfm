<cfscript>
	muhasebe_sil(action_id:form.invoice_id, process_type:form.old_process_type);
	butce_sil (action_id:form.invoice_id,muhasebe_db:dsn2,process_type:old_process_type);
</cfscript>
<cfquery name="GET_INVOICE_CASH_ACTIONS" datasource="#DSN2#">
	SELECT * FROM INVOICE_CASH_POS WHERE INVOICE_ID=#form.invoice_id# AND CASH_ID IS NOT NULL
</cfquery>
<cfset cash_action_list=listsort(valuelist(GET_INVOICE_CASH_ACTIONS.CASH_ID,','),'numeric','asc',',')>
<cfif len(cash_action_list)>
	<cfquery name="DEL_CASH_ACTION" datasource="#DSN2#">
		DELETE FROM CASH_ACTIONS WHERE ACTION_ID IN (#cash_action_list#)
	</cfquery>
	<cfquery name="DEL_INVOICE_CASH" datasource="#DSN2#">
		DELETE FROM INVOICE_CASH_POS WHERE CASH_ID IN (#cash_action_list#) AND INVOICE_ID=#form.invoice_id#
	</cfquery>
</cfif>
<cfquery name="GET_INVOICE_POS_ACTIONS" datasource="#DSN2#">
	SELECT * FROM INVOICE_CASH_POS WHERE INVOICE_ID=#form.invoice_id# AND POS_PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfset pos_action_list=listsort(valuelist(GET_INVOICE_POS_ACTIONS.POS_ACTION_ID,','),'numeric','asc',',')>
<cfif len(pos_action_list)>
	<cfquery name="DEL_CARD" datasource="#DSN2#">
		DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE CREDITCARD_PAYMENT_ID IN (#pos_action_list#)
	</cfquery>
	<cfquery name="DEL_CARD_ROWS" datasource="#DSN2#">
		DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS WHERE CREDITCARD_PAYMENT_ID IN (#pos_action_list#)
	</cfquery>
	<cfquery name="DEL_CASH_ACTIONS" datasource="#DSN2#">
		DELETE FROM INVOICE_CASH_POS WHERE INVOICE_ID=#form.invoice_id# AND POS_ACTION_ID IN (#pos_action_list#) AND POS_PERIOD_ID = #session.ep.period_id#
	</cfquery>
</cfif>
<cfquery name="DEL_STOCKS_ROW" datasource="#DSN2#">
	DELETE FROM STOCKS_ROW WHERE PROCESS_TYPE=69 AND UPD_ID=#form.invoice_id#
</cfquery>
<cfquery name="DEL_INVOICE_SHIPS" datasource="#DSN2#">
	DELETE FROM INVOICE_SHIPS WHERE INVOICE_ID = #form.invoice_id#
</cfquery>
<cfquery name="DEL_INVOICE_ROW_1" datasource="#DSN2#">
	DELETE FROM INVOICE_CONTRACT_COMPARISON WHERE MAIN_INVOICE_ID = #form.invoice_id#
</cfquery>
<cfquery name="DEL_INVOICE_ROW_12" datasource="#DSN2#">
	DELETE FROM INVOICE_CONTROL WHERE INVOICE_ID=#form.invoice_id#
</cfquery>
<cfquery name="DEL_INVOICE_ROW_123" datasource="#DSN2#">
	DELETE FROM INVOICE_CONTROL_CONTRACT_ACTIONS WHERE ACTION_ID = #form.invoice_id#
</cfquery>
<cfquery name="DEL_INVOICE_ROW" datasource="#DSN2#">
	DELETE FROM INVOICE_ROW WHERE INVOICE_ID=#form.invoice_id#
</cfquery>
<cfquery name="DEL_INVOICE_11" datasource="#DSN2#">
	DELETE FROM INVOICE_COST WHERE INVOICE_ID=#form.invoice_id#
</cfquery>
<cfquery name="DEL_INVOICE_111" datasource="#DSN2#">
	DELETE FROM INVOICE_MONEY WHERE ACTION_ID = #form.invoice_id#
</cfquery>
<cfquery name="DEL_INVOICE_1" datasource="#DSN2#">
	DELETE FROM INVOICE_GROUP_COMP_INVOICE WHERE INVOICE_ID = #form.invoice_id#
</cfquery>
<cfquery name="DEL_INVOICE" datasource="#DSN2#">
	DELETE FROM INVOICE WHERE INVOICE_ID = #form.invoice_id#
</cfquery>
<cfquery name="DEL_INVOICE_STATISTICAL" datasource="#DSN2#">
	DELETE FROM INVOICE_STATISTICAL WHERE INVOICE_ID = #form.invoice_id#
</cfquery>

