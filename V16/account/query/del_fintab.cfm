<cfquery name="GET_FIN_TABLES" datasource="#DSN3#">
	DELETE FROM SAVE_ACCOUNT_TABLES WHERE SAVE_ID = #ATTRIBUTES.SAVE_ID#		
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
