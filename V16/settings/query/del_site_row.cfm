<cfquery name="del_row_" datasource="#dsn#">
	DELETE FROM MAIN_SITE_LAYOUTS_SELECTS WHERE ROW_ID = #attributes.row_id#
</cfquery>

<cfquery name="del_row_pro_" datasource="#dsn#">
	DELETE FROM MAIN_SITE_LAYOUTS_SELECTS_PROPERTIES WHERE ROW_ID = #attributes.row_id#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
