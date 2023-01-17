<cfquery name="DEL_UNIT" datasource="#dsn#">
	DELETE FROM SETUP_UNIT WHERE UNIT_ID=#attributes.id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
