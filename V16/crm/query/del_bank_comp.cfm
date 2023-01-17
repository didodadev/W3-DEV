<cfquery name="DEL_BANK_COMPANY" datasource="#dsn#">
	DELETE 
		FROM 
		COMPANY_BANK
	WHERE 
		COMPANY_BANK_ID = #URL.BID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
