<cfquery name="ADD_COMMENT" datasource="#dsn3#">
DELETE PRODUCT_COMMENT WHERE PRODUCT_COMMENT_ID = #attributes.PRODUCT_COMMENT_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
