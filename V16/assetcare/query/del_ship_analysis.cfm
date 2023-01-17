<cfquery name="DEL_SHIP_ANALYSIS" datasource="#DSN#">
	DELETE FROM ASSET_P_SHIP_ANALYSIS WHERE SHIP_ID = #attributes.ship_id#
</cfquery>
<cf_add_log  log_type="-1" action_id="#attributes.ship_id#" action_name="#attributes.head#">
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
