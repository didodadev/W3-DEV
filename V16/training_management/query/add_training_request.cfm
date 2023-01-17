<cfquery name="ADD_TRAINING_JOIN_REQUESTS" datasource="#dsn#">
	UPDATE
		TRAINING_JOIN_REQUESTS
	SET
		VALID = 1,
		VALID_EMP = #session.ep.userid#,
		VALID_DATE = #Now()#
	WHERE
		EMPLOYEE_ID=#attributes.EMP_ID#
		AND
		CLASS_ID=#attributes.CLASS_ID#
</cfquery>
<cfquery name="GET_CLASS_POTENTIAL_ATTENDER" datasource="#dsn#">
	SELECT
		EMP_ID
	FROM
		TRAINING_CLASS_ATTENDER
	WHERE
		CLASS_ID=#attributes.CLASS_ID#
		AND EMP_ID=#attributes.EMP_ID#
</cfquery>
<cfif NOT GET_CLASS_POTENTIAL_ATTENDER.RECORDCOUNT>
	<cfquery name="ADD_TRAINING_JOIN_REQUESTS" datasource="#dsn#">
		INSERT INTO
			TRAINING_CLASS_ATTENDER
			(
			CLASS_ID,
			EMP_ID		
			)
		VALUES
			(
			#attributes.CLASS_ID#,
			#attributes.EMP_ID#
			)
	</cfquery>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
