<cfquery name="del_page_type" datasource="#dsn3#">
	DELETE FROM CATALOG_PAGE_TYPES WHERE PAGE_TYPE_ID = #attributes.type_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
