<cfquery name="upd_query" datasource="#dsn#">
	DELETE 
	FROM
		INSURANCE_RATIO
	WHERE
		INS_RAT_ID = #attributes.INS_RAT_ID#
</cfquery>
	
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
