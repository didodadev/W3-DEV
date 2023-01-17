<cfquery name="DEL_USER_GROUP" datasource="#DSN#">
	DELETE FROM ORGANIZATION_SIMULATION_ROWS WHERE ROW_ID = #attributes.row_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
