<cfquery name="DEL_KESINTI" datasource="#DSN#">
	DELETE FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = #URL.ODKES_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
