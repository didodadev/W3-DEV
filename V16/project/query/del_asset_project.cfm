<cfquery name="DEL_ASSET_PROJECT" datasource="#dsn#">
	DELETE FROM
		ASSET_P_RESERVE 
	WHERE 
		PROJECT_ID = #URL.ID# AND 
		ASSETP_ID = #ASSETP_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
