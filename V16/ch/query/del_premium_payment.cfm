<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="GET_PREMIUM_ACTIONS" datasource="#dsn2#">
			SELECT DISTINCT CARI_ACTION_ID,BANK_ORDER_ID FROM INVOICE_MULTILEVEL_PAYMENT_ROWS WHERE INV_PAYMENT_ID = #url.payment_id#
		</cfquery>
		<cfoutput query="GET_PREMIUM_ACTIONS">
			<cfif len(GET_PREMIUM_ACTIONS.BANK_ORDER_ID)>
				<cfscript>
					is_transaction = 1;
					is_from_makeage = 1;
					url.bank_order_id = GET_PREMIUM_ACTIONS.BANK_ORDER_ID;
					attributes.old_process_type = 250;
				</cfscript>
				<cfinclude template="../../bank/query/del_assign_order.cfm">
			</cfif>
			<cfif len(GET_PREMIUM_ACTIONS.CARI_ACTION_ID)>
				<cfscript>
					is_transaction = 1;
					is_from_premium = 1;
					url.action_id = GET_PREMIUM_ACTIONS.CARI_ACTION_ID;
					attributes.process_type = 42;
				</cfscript>
				<cfinclude template="del_debit_claim.cfm">
			</cfif>
		</cfoutput>
		<cfscript>
			attributes.process_type = 44;
			muhasebe_sil(action_id:url.payment_id,process_type:attributes.process_type);
		</cfscript>	
		<cfquery name="DEL_PREMIUM" datasource="#dsn2#">
			DELETE FROM INVOICE_MULTILEVEL_PAYMENT WHERE INV_PAYMENT_ID = #url.payment_id#
		</cfquery>
		<cfquery name="DEL_PREMIUM_ROWS" datasource="#dsn2#">
			DELETE FROM INVOICE_MULTILEVEL_PAYMENT_ROWS WHERE INV_PAYMENT_ID = #url.payment_id#
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=ch.list_premium_payment" addtoken="no">
