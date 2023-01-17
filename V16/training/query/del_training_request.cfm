<cfquery name="DEL_TRAINING_JOIN_REQUESTS" datasource="#dsn#">
	DELETE FROM
		TRAINING_JOIN_REQUESTS
	WHERE
		EMPLOYEE_ID = #session.ep.userid# AND
		TRAINING_ID = #attributes.TRAINING_ID#
		<cfif IsDefined("attributes.CLASS_ID") AND Len(attributes.CLASS_ID)>
		AND CLASS_ID = #attributes.CLASS_ID#
		<cfelse>
		AND CLASS_ID IS NULL
		</cfif>
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
