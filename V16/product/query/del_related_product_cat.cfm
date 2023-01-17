<cfquery name="DEL_PRODUCT_RELATION" datasource="#dsn1#">
	DELETE RELATED_PRODUCT_CAT WHERE RELATED_PRODUCT_CAT_ID = #attributes.related_cat_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
