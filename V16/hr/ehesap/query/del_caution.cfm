<cfquery name="ADD_CAUTION" datasource="#DSN#">
	DELETE FROM	EMPLOYEES_CAUTION WHERE CAUTION_ID = #attributes.caution_id#
</cfquery>
<cf_add_log  log_type="-1" action_id="#attributes.caution_id#" action_name="Disiplin İşlemi Sil : (#attributes.CAUTION_ID#)">
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.list_caution</cfoutput>';
</script>

