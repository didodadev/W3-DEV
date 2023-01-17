<cfquery name="DEL_TARGET" datasource="#dsn#">
	DELETE FROM TARGET WHERE TARGET_ID=#attributes.TARGET_ID#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
