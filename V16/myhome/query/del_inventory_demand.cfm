<cfquery name="del_inventory_demand" datasource="#DSN#">
	DELETE FROM EMPLOYEES_INVENTORY_DEMAND WHERE INVENTORY_DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.INVENTORY_DEMAND_ID#">
</cfquery>
<cfquery name="del_inventory_demand_rows" datasource="#DSN#">
	DELETE FROM EMPLOYEES_INVENTORY_DEMAND_ROWS WHERE INVENTORY_DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.INVENTORY_DEMAND_ID#">
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
