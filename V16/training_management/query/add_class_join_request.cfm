<cfquery name="ADD_TRAINING_JOIN_REQUESTS" datasource="#dsn#">
	INSERT INTO
		TRAINING_JOIN_REQUESTS
		(
		EMPLOYEE_ID,
		CLASS_ID,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
		)
		VALUES
		(
		#attributes.EMP_ID#,
		#attributes.CLASS_ID#,
		#Now()#,
		#session.ep.userid#,
		'#REMOTE_ADDR#'
		)
</cfquery>

<script type="text/javascript">
wrk_opener_reload();
window.close();
</script>
