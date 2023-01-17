<cfif FileExists("#upload_folder#member#dir_seperator##attributes.OLDSECUREFUND_FILE#")>
	<cf_del_server_file output_file="member/#attributes.OLDSECUREFUND_FILE#" output_server="#attributes.OLDSECUREFUND_FILE_SERVER_ID#">
</cfif>
<cfquery name="get_process" datasource="#dsn#">
	SELECT ACTION_CAT_ID FROM COMPANY_SECUREFUND WHERE SECUREFUND_ID = #ATTRIBUTES.SECUREFUND_ID#
</cfquery>
<cfquery name="del_secure" datasource="#dsn#">
	DELETE 
	FROM  
		COMPANY_SECUREFUND 
	WHERE 
		SECUREFUND_ID = #ATTRIBUTES.SECUREFUND_ID#
</cfquery>
<cf_add_log log_type="-1" action_id="#attributes.securefund_id#" action_name="#attributes.detail# " process_type="#attributes.process#" process_stage="#get_process.action_cat_id#">
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
