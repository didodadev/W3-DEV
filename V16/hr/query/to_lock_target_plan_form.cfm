<cfsetting showdebugoutput="no">
<cfif attributes.lock eq 1>
	<cfquery name="upd_perf" datasource="#dsn#">
		UPDATE
			EMPLOYEE_PERFORMANCE
		SET
			IS_CLOSED = 0
		WHERE
			PER_ID=#attributes.per_id#
	</cfquery>
<cfelseif attributes.lock eq 0>
	<cfquery name="upd_perf" datasource="#dsn#">
		UPDATE
			EMPLOYEE_PERFORMANCE
		SET
			IS_CLOSED = 1
		WHERE
			PER_ID=#attributes.per_id#
	</cfquery>
</cfif>
<script type="text/javascript">
	location.reload(); 
</script>
