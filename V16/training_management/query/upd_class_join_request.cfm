<cfquery name="UPD_TRAINING_JOIN_REQUESTS" datasource="#dsn#">
	UPDATE
		TRAINING_JOIN_REQUESTS
	SET
		EMPLOYEE_ID = #attributes.EMP_ID#,
		CLASS_ID = #attributes.CLASS_ID#,
		UPDATE_DATE = #Now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#REMOTE_ADDR#'
	WHERE
		TRAINING_JOIN_REQUEST_ID = #attributes.REQUEST_ID#
</cfquery>

<script type="text/javascript">
wrk_opener_reload();
window.close();
</script>
