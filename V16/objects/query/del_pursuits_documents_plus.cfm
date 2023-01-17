<cfif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_sale_order">
	<cfquery name="del_action_plus" datasource="#dsn3#">
		DELETE ORDER_PLUS WHERE ORDER_PLUS_ID = #action_plus_id#
	</cfquery>
<cfelseif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_sale_invoice">
	<cfquery name="del_action_plus" datasource="#dsn2#">
		DELETE INVOICE_PURSUIT_PLUS WHERE INVOICE_PLUS_ID = #action_plus_id#
	</cfquery>
<cfelseif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_service_application">
	<cfquery name="del_action_plus" datasource="#dsn3#">
		DELETE SERVICE_PLUS WHERE SERVICE_PLUS_ID = #action_plus_id#
	</cfquery>
</cfif>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
