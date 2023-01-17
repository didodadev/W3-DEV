<cfquery name="ADD_SERVICE_CONTRACT" datasource="#DSN#">
	UPDATE
		G_SERVICE_HISTORY
	SET
		SERVICE_DETAIL = '#attributes.service_detail#'
	WHERE
		SERVICE_HISTORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_history_id#">
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
