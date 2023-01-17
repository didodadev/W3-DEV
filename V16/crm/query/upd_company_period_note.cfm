<cfif isdefined("attributes.is_delete")>	
	<cfquery name="DEL_NOTE" datasource="#dsn#">
		DELETE FROM COMPANY_BRANCH_NOTES WHERE NOTE_ID = #attributes.note_id#
	</cfquery>
<cfelse>
	<cfquery name="UPD_COMPANY_NOTE" datasource="#dsn#">
		UPDATE
			COMPANY_BRANCH_NOTES
		SET
			NOTE_DETAIL = '#attributes.detail#',
			NOTE_YEAR = #attributes.period_year#,
			NOTE_MONTH = #attributes.period_month#,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#cgi.remote_addr#'
		WHERE
			NOTE_ID = #attributes.note_id#
	</cfquery>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
