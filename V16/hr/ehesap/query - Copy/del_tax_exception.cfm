<cfquery name="DEL_TAX_EXC" datasource="#DSN#">
	DELETE FROM TAX_EXCEPTION WHERE TAX_EXCEPTION_ID = #attributes.TAX_EXCEPTION_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
