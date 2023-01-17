<cfquery name="DEL_KESINTI" datasource="#DSN#">
	DELETE FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = #attributes.bes_id#
</cfquery>
<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#?fuseaction=ehesap.list_bes</cfoutput>';
</script>