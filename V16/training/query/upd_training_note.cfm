<cfquery name="ADD_COMMENT" datasource="#dsn#">
	UPDATE 
		TRAINING_NOTES
	SET
		NOTE_HEAD = '#attributes.NOTE_HEAD#',
		NOTE_DETAIL = '#attributes.NOTE_DETAIL#',
		UPDATE_DATE = #now()#,
		UPDATE_IP='#CGI.REMOTE_ADDR#'		
	WHERE
		NOTE_ID = #attributes.NOTE_ID#
	</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>





















