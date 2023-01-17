
<cfquery name="DEL_TEST" datasource="#DSN3#">
	DELETE FROM SERVICE_TEST WHERE SERVICE_TEST_ID = #ATTRIBUTES.SERVICE_TEST_ID#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
