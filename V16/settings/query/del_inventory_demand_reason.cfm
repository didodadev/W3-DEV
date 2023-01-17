<cfquery name="del_reason" datasource="#dsn#">
	DELETE FROM SETUP_INVENTORY_DEMAND_REASON WHERE REASON_ID = #attributes.reason_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_inventory_demand_reason" addtoken="no">
