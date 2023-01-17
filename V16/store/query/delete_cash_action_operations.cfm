<!--- 
	Kasa işlemi yapilmissa silinir.
		1) cash_actions
		2) cari_rows
		3) expense_item_rows
		4)account_card & account_card_rows
		workcube_old_process_type : 36,
--->
<cfquery name="GET_STORE_EXPENSE_CASH_IDS" datasource="#DSN2#">
	SELECT CASH_ACTION_ID FROM STORE_EXPENSE WHERE STORE_REPORT_ID = #attributes.store_report_id#
</cfquery>
<cfset liste_cash_action =  valuelist(GET_STORE_EXPENSE_CASH_IDS.CASH_ACTION_ID) >
<cfif listlen(liste_cash_action,",") and GET_STORE_EXPENSE_CASH_IDS.recordcount >
	<cfloop from="1" to="#listlen(liste_cash_action,",")#" index="index_cash">
		<cfset main_c_a_id = listgetat(liste_cash_action,index_cash,",")>
		<cfquery name="DEL_CASH_RECORDS" datasource="#DSN2#">
			DELETE FROM CASH_ACTIONS WHERE ACTION_ID = #main_c_a_id#
		</cfquery>
		<cfquery name="DEL_EXPENSE_ITEM_ROW" datasource="#dsn2#">
			DELETE FROM EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #main_c_a_id# AND EXPENSE_COST_TYPE = 1
		</cfquery>
		<cfscript>
			cari_sil(action_id:main_c_a_id, process_type:36);		
			muhasebe_sil(action_id:main_c_a_id, process_type:36);
		</cfscript>
	</cfloop>
</cfif>
