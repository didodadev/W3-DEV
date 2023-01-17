<cfquery name="add_rival" datasource="#dsn#">
	DELETE SETUP_RIVALS	WHERE R_ID = #R_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
