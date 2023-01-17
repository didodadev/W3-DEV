<cfquery name="DEL_INVENT" datasource="#dsn3#">
	DELETE FROM INVENTORY WHERE INVENTORY_ID=#attributes.inventory_id#
</cfquery>
<cfquery name="DEL_INVENT_ROW" datasource="#dsn3#">
	DELETE FROM INVENTORY_ROW WHERE INVENTORY_ID=#attributes.inventory_id#
</cfquery>
<cfquery name="DEL_INVENT_HISTORY" datasource="#dsn3#">
	DELETE FROM INVENTORY_HISTORY WHERE INVENTORY_ID=#attributes.inventory_id#
</cfquery>
<cfset attributes.actionId=attributes.inventory_id>
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=invent.list_inventory</cfoutput>";
</script>