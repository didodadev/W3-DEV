<cfquery name="DEL_PRODUCT_SEGMENT" datasource="#DSN1#">
	DELETE FROM PRODUCT_SEGMENT WHERE PRODUCT_SEGMENT_ID = #attributes.PRODUCT_SEGMENT_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
