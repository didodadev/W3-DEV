<cfquery name="DEL_RELATED_CONT" datasource="#dsn#">
	DELETE 
	FROM
		TRAINING_RELATED 
	WHERE 
		RELATED_ID = #URL.RELATED_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
