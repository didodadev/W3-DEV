	<cfquery name="GET_SCHEDULES" datasource="#DSN#">
		DELETE
			SCHEDULED_REPORTS
		WHERE
			REPORT_ID = #attributes.report_id#	
	</cfquery>
<script type="text/javascript">
	location.href = document.referrer;
</script>
