<cfquery name="DEL_TRAINING_JOIN_REQUESTS" datasource="#dsn#">
	DELETE FROM
		TRAINING_JOIN_REQUESTS
	WHERE
		TRAINING_JOIN_REQUEST_ID=#attributes.REQUEST_ID#
</cfquery>

<script type="text/javascript">
wrk_opener_reload();
window.close();
</script>
