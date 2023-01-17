<cfquery name="DEL_ASSET_PROD_RESULT" datasource="#dsn#">
	DELETE FROM
		ASSET_P_RESERVE 
	WHERE 
		PROD_RESULT_ID = #URL.ID# AND 
		ASSETP_ID = #ASSETP_ID# AND
        OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
