<cfquery name="DEL_CASH" datasource="#dsn2#">
	DELETE FROM	CASH WHERE CASH_ID=#attributes.ID#		
</cfquery>
<cf_add_log log_type="-1" action_id="#attributes.ID#" action_name="#attributes.pageHead#">
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=cash.list_cashes';
</script>