<cflock timeout="20">
	<cftransaction>
		<cfquery name="GET_PAYMENT_ORDER" datasource="#dsn#">
			SELECT	* FROM PAYMENT_ORDERS WHERE RESULT_ID=#attributes.id#
		</cfquery>
		<cfif GET_PAYMENT_ORDER.recordcount>
			<cfif len(GET_PAYMENT_ORDER.PAY_REQUEST_ID)>
				<cfquery name="GET_PAYMENT" datasource="#dsn#">
					SELECT * FROM CORRESPONDENCE_PAYMENT WHERE ID= #GET_PAYMENT_ORDER.PAY_REQUEST_ID#
				</cfquery>
				<cfif GET_PAYMENT.recordcount>
					<cfquery name="upd_order_request" datasource="#dsn#">
						UPDATE CORRESPONDENCE_PAYMENT SET STATUS = NULL WHERE ID=#GET_PAYMENT.ID#	
					</cfquery>
				</cfif>
			</cfif>
			<cfquery name="get_all_row" datasource="#dsn#">
				SELECT * FROM #dsn3_alias#.PAYMENT_ORDERS_ROW WHERE RESULT_ID = #GET_PAYMENT_ORDER.RESULT_ID#
			</cfquery>
			<cfoutput query="get_all_row">
				<cfif len(get_all_row.invoice_id)>
					<cfquery name="upd_invoice_control" datasource="#dsn#">
						UPDATE #dsn2_alias#.INVOICE SET IS_ORDERED = 0 WHERE INVOICE_ID = #get_all_row.invoice_id#
					</cfquery>
				</cfif>
			</cfoutput>
			<cfquery name="DEL_PAYMENT_ORDER_ROWS" datasource="#dsn#">
				DELETE FROM #dsn3_alias#.PAYMENT_ORDERS_ROW WHERE RESULT_ID = #GET_PAYMENT_ORDER.RESULT_ID#
			</cfquery>
			<cfquery name="DEL_PAYMENT_ORDER" datasource="#dsn#">
				DELETE FROM PAYMENT_ORDERS WHERE RESULT_ID=#attributes.id#
			</cfquery>
		</cfif>
		<cf_add_log  log_type="-1" action_id="#GET_PAYMENT_ORDER.RESULT_ID#" action_name="#attributes.name#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	alert('Silme İşlemi Başarı İle Tamamlandı!');
	wrk_opener_reload();
	window.close();
</script> 
<cfabort> 
