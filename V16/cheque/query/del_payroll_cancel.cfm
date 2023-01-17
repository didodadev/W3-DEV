<cfif get_payroll_actions.action_type_id eq 31>
	<!--- Kasa hareketleri silinyor --->
	<cfquery name="get_cash_old" datasource="#dsn2#">
		SELECT * FROM CASH_ACTIONS WHERE ACTION_ID = #get_payroll_actions.action_id#
	</cfquery>
	<cfif get_cash_old.recordcount>
		<cfscript>
			cari_sil(action_id:get_cash_old.action_id , process_type:31);
			muhasebe_sil(action_id:get_cash_old.action_id, process_type:31);
		</cfscript>
		<cfquery name="del_cash_actions" datasource="#dsn2#">
			DELETE FROM CASH_ACTIONS WHERE ACTION_ID = #get_cash_old.action_id#
		</cfquery>
	</cfif>	
<cfelseif get_payroll_actions.action_type_id eq 24>
	<!--- Banka hareketleri silinyor --->
	<cfquery name="get_bank_old" datasource="#dsn2#">
		SELECT * FROM BANK_ACTIONS WHERE ACTION_ID = #get_payroll_actions.action_id#
	</cfquery>
	<cfif get_bank_old.recordcount>
		<cfscript>
			cari_sil(action_id:get_bank_old.action_id , process_type:24);
			muhasebe_sil(action_id:get_bank_old.action_id, process_type:24);
		</cfscript>
		<cfquery name="del_bank_actions" datasource="#dsn2#">
			DELETE FROM BANK_ACTIONS WHERE ACTION_ID = #get_bank_old.action_id#
		</cfquery>
	</cfif>	
<cfelse>
	<!--- Pos hareketleri siliniyor --->
	<cfquery name="get_pos_old" datasource="#dsn2#">
		SELECT * FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE CREDITCARD_PAYMENT_ID = #get_payroll_actions.action_id#
	</cfquery>
	<cfif get_pos_old.recordcount>
		<cfscript>
			cari_sil(action_id:get_pos_old.CREDITCARD_PAYMENT_ID, process_type:241);
			muhasebe_sil(action_id:get_pos_old.CREDITCARD_PAYMENT_ID, process_type:241);
		</cfscript>
		<cfquery name="DEL_CARD" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE CREDITCARD_PAYMENT_ID = #get_pos_old.CREDITCARD_PAYMENT_ID#
		</cfquery>
		<cfquery name="DEL_CARD_ROWS" datasource="#dsn2#">
			DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS WHERE CREDITCARD_PAYMENT_ID = #get_pos_old.CREDITCARD_PAYMENT_ID#
		</cfquery>
	</cfif>	
</cfif>
<!--- Faiz gelirleri siliniyor --->
<cfquery name="del_expense_rows" datasource="#dsn2#">
	DELETE FROM EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #attributes.payroll_id# AND EXPENSE_COST_TYPE = 1057
</cfquery>

