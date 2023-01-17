<cfscript>
	cari_sil(action_id:attributes.bank_order_id,process_type:attributes.old_process_type);
	muhasebe_sil(action_id:attributes.bank_order_id,process_type:attributes.old_process_type);
</cfscript>
<cfquery name="GET_BANK_ORDERS" datasource="#DSN2#">
	SELECT CLOSED_ID FROM BANK_ORDERS WHERE BANK_ORDER_ID = #attributes.bank_order_id#
</cfquery>
<cfif len(GET_BANK_ORDERS.CLOSED_ID)>
	<cfquery name="UPD_CLOSED" datasource="#DSN2#">
		UPDATE CARI_CLOSED SET IS_BANK_ORDER = 0 WHERE CLOSED_ID = #GET_BANK_ORDERS.CLOSED_ID#
	</cfquery>
</cfif>
<cfquery name="DEL_BANK_ORDER_MONEY" datasource="#dsn2#">
	DELETE FROM BANK_ORDER_MONEY WHERE ACTION_ID = #attributes.bank_order_id#
</cfquery>
<cfquery name="DEL_FROM_CARI" datasource="#dsn2#">
	DELETE FROM BANK_ORDERS WHERE BANK_ORDER_ID=#attributes.bank_order_id#
</cfquery>

