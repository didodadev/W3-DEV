<cfquery name="DEL_ALTERNATIVE_PRODUCTS" datasource="#dsn3#">
	DELETE ALTERNATIVE_PRODUCTS_EXCEPT WHERE ALTERNATIVE_ID = #attributes.anative_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
