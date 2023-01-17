<cfquery name="del_operation" datasource="#dsn3#">
	DELETE FROM 
		SERVICE_OPERATION 
	WHERE 
		SERVICE_ID = #ATTRIBUTES.SERVICE_ID# AND
		SERVICE_OPE_ID = #ATTRIBUTES.operation_id#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
