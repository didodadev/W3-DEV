<cfquery name="DEL_ASSET_P_CONTRACT" datasource="#DSN#">
	DELETE
	FROM
		ASSET_CARE_CONTRACT
	WHERE
		ASSET_CARE_CONTRACT_ID = #URL.CONTRACT_ID#
	AND
		ASSET_ID = #URL.ASSETP_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
