<cfquery name="del_request_row" datasource="#dsn#">
	DELETE FROM TRAINING_REQUEST_ROWS WHERE TRAIN_REQUEST_ID = #attributes.request_id#
</cfquery>
<cfquery name="del_request" datasource="#dsn#">
	DELETE FROM TRAINING_REQUEST WHERE TRAIN_REQUEST_ID = #attributes.request_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
