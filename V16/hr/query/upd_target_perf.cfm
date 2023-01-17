<cfquery name="UPD_TARGET_PERF" datasource="#dsn#">
	UPDATE
		TARGET
	SET
		PERFORM_COMMENT = '#attributes.PERFORM_COMMENT#',
		<cfif IsDefined("attributes.PERFORM_POINT_ID")>
		PERFORM_POINT_ID = #attributes.PERFORM_POINT_ID#,
		</cfif>
		PERFORM_REC_EMP = #Session.ep.userid#,
		PERFORM_REC_DATE = #now()#
	WHERE
		TARGET_ID = #attributes.TARGET_ID#
</cfquery>

<script type="text/javascript">
wrk_opener_reload();
window.close();
</script>
