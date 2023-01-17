<cfquery name="DEL_ASSETP_RESERVE" datasource="#dsn#">
	DELETE FROM 
		ASSET_P_RESERVE
	WHERE
		ASSETP_RESID = #attributes.ASSETP_RESID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
