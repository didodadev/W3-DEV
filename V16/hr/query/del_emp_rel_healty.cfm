<cfquery name="UPD_HEALTY" datasource="#DSN#">
	DELETE FROM EMPLOYEES_RELATIVE_HEALTY WHERE DOC_ID = #URL.DOC_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();  
</script>
