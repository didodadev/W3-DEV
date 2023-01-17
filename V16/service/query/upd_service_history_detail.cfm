<cfquery NAME="ADD_SERVICE_CONTRACT" DATASOURCE="#DSN3#">
	UPDATE
		SERVICE_HISTORY
	SET
		SERVICE_DETAIL = '#attributes.service_detail#'
	WHERE
		SERVICE_HISTORY_ID=#attributes.SERVICE_HISTORY_ID#
</cfquery>
<script type="text/javascript">
 wrk_opener_reload();
 window.close();
</script>
