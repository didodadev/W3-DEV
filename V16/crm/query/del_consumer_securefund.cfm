<cfif FileExists("#upload_folder#member#dir_seperator##attributes.OLDSECUREFUND_FILE#")>
	<cffile action="delete" file="#upload_folder#member#dir_seperator##attributes.OLDSECUREFUND_FILE#">
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
