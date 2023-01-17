<cfquery name="del_transport_orders" datasource="#DSN#">
    DELETE FROM REFINERY_WASTE_COLLECTION WHERE WASTE_COLLECTION_EXPEDITIONS_ID = #attributes.id#
</cfquery>
<cfquery name="del_transport_orders_row" datasource="#DSN#">
    DELETE FROM REFINERY_WASTE_COLLECTION_ROWS WHERE WASTE_COLLECTION_EXPEDITIONS_ID = #attributes.id#
</cfquery>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=recycle.waste_collection</cfoutput>';
</script>