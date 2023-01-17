<cfquery name="DEL_PRODUCT_RELATION" datasource="#dsn3#">
	DELETE RELATED_PRODUCT WHERE RELATED_ID = #attributes.related_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
