<cfquery name="DEL_REQUEST" datasource="#DSN#">
	DELETE FROM CORRESPONDENCE_PAYMENT WHERE ID = #attributes.id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();	
</script>
