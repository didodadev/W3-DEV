<cfif len(attributes.module_id) and len(attributes.item_id) and len(attributes.lang_name)>
	<cfquery name="del_item" datasource="#dsn#">
		DELETE FROM SETUP_LANG_SPECIAL WHERE MODULE_ID = '#attributes.module_id#' AND ITEM_ID = #attributes.item_id#
	</cfquery>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
