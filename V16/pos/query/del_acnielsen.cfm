<cfquery name="add_report" datasource="#dsn3#">
	DELETE FROM ACNIELSEN_REPORTS WHERE ACNR_ID = #attributes.ACNR_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
