<cfif FileExists("#upload_folder#member#dir_seperator##attributes.OLDSECUREFUND_FILE#")>
	<!--- <cffile action="delete" file="#upload_folder#member#dir_seperator##attributes.OLDSECUREFUND_FILE#"> --->
	<cf_del_server_file output_file="member/#attributes.OLDSECUREFUND_FILE#" output_server="#attributes.OLDSECUREFUND_FILE_SERVER_ID#">
</cfif>

<cfquery name="del_secure" datasource="#dsn#">
	DELETE 
	FROM  
		CONSUMER_SECUREFUND 
	WHERE 
		SECUREFUND_ID = #ATTRIBUTES.SECUREFUND_ID#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
