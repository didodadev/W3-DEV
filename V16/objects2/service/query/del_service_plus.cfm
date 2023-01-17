<cfquery name="DEL_SERVICE_PLUS" datasource="#dsn3#">
	DELETE 
		SERVICE_PLUS
	WHERE 
		SERVICE_PLUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SERVICE_PLUS_ID#">
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
