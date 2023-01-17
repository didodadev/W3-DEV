<!--- del_cons_bank.cfm --->
<cfquery name="DEL_CONS_BANK" datasource="#dsn#">
	DELETE 
		CONSUMER_BANK 
	WHERE 
		CONSUMER_BANK_ID = #URL.BID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
