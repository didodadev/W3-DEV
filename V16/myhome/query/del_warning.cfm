<cfquery name="del_warning" datasource="#dsn#">
	DELETE FROM PAGE_WARNINGS WHERE W_ID = #attributes.W_ID#
</cfquery>
<script type="text/javascript">
	window.close();
</script>
