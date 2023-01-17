<cfquery name="upd_saved_report" datasource="#dsn#">
	UPDATE
		SAVED_REPORTS
	SET
		REPORT_NAME = '#attributes.REPORT_NAME#',
		REPORT_DETAIL = '#attributes.REPORT_DETAIL#',
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_DATE = #NOW()#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE
		SR_ID = #attributes.SR_ID#
</cfquery>

<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.reload();
	</cfif>
</script>
