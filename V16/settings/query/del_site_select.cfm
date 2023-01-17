<cfquery name="del_" datasource="#dsn#">
	DELETE FROM MAIN_SITE_LAYOUTS_SELECTS WHERE ROW_ID = #attributes.row_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
