<cfquery name="del_rival_prices" datasource="#dsn3#">
	DELETE 
	FROM	
		PRICE_RIVAL	
	WHERE 
		PR_ID = #PR_ID#
</cfquery>
<script type="text/javascript">
location.href = document.referrer;
	wrk_opener_reload();
	window.close();
</script>
