<cfquery name="DEL_PLUS" datasource="#dsn3#">
	DELETE 
		OFFER_PLUS
	WHERE 
		OFFER_PLUS_ID = #URL.OID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
