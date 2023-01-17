<cfquery name="DEL_SERVICE_PLUS" datasource="#dsn#">
	DELETE 
		G_SERVICE_PLUS
	WHERE 
		SERVICE_PLUS_ID = #attributes.SERVICE_PLUS_ID#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
