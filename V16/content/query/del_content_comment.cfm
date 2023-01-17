<cfquery name="get_process" datasource="#dsn#">
	SELECT STAGE_ID FROM CONTENT_COMMENT WHERE CONTENT_COMMENT_ID = #attributes.ID#
</cfquery>
<cfquery name="ADD_COMMENT" datasource="#dsn#">
	DELETE 
	FROM
		CONTENT_COMMENT 
	WHERE
		CONTENT_COMMENT_ID = #attributes.ID#
</cfquery>
<cf_add_log log_type="-1" action_id="#attributes.ID#" action_name="#attributes.head#"  process_type="#attributes.cat#" process_stage="#get_process.stage_id#">
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>





















