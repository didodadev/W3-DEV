<cfquery name="ADD_TRAINING_JOIN_REQUESTS" datasource="#dsn#">
	INSERT INTO
		TRAINING_JOIN_REQUESTS
    (
		EMPLOYEE_ID,
		TRAINING_ID,
		<cfif IsDefined("attributes.CLASS_ID")>
		CLASS_ID,
		</cfif>
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
    )
	VALUES
    (
		#session.ep.userid#,
		#attributes.TRAINING_ID#,
		<cfif IsDefined("attributes.CLASS_ID")>
		#attributes.CLASS_ID#,
		</cfif>
		#now()#,
		#session.ep.userid#,
		'#REMOTE_ADDR#'
    )
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
