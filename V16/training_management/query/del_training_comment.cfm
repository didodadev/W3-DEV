<cfquery name="ADD_COMMENT" datasource="#dsn#">
	DELETE 
	FROM
		TRAINING_COMMENT 
	WHERE
		TRAINING_COMMENT_ID = #attributes.TRAINING_COMMENT_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>





















