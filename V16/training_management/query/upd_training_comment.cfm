<cfquery name="ADD_COMMENT" datasource="#dsn#">
	UPDATE 
		TRAINING_COMMENT 
	SET
		TRAINING_COMMENT = '#attributes.TRAINING_COMMENT#',
		TRAINING_COMMENT_POINT = #attributes.TRAINING_COMMENT_POINT#,
		NAME = '#attributes.NAME#',
		SURNAME = '#attributes.SURNAME#',
		STAGE_ID = #attributes.STAGE_ID#,	
		MAIL_ADDRESS = '#attributes.MAIL_ADDRESS#'
	WHERE
		TRAINING_COMMENT_ID = #attributes.TRAINING_COMMENT_ID#
	</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>





















