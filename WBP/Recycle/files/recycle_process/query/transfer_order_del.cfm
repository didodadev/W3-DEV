<cfquery name="del_transport_orders" datasource="#DSN#">
    DELETE FROM REFINERY_TRANSPORT_ORDERS WHERE REFINERY_TRANSPORT_ID = #attributes.id#
</cfquery>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=recycle.transfer_order</cfoutput>';
</script>