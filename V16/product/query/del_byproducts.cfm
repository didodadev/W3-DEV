<cfquery name="del_page_type" datasource="#dsn3#">
	DELETE FROM PRODUCT_TREE_BY_PRODUCT WHERE BY_PRODUCT_ID = #attributes.id#
</cfquery>
<script type="text/javascript">
	location.href = document.referrer;
</script>
