<cfquery name="get_process" datasource="#dsn#">
	SELECT PER_ASSIGN_STAGE FROM PERSONEL_ASSIGN_FORM WHERE PERSONEL_ASSIGN_ID = #attributes.per_assign_id#
</cfquery>
<cflock timeout="100">
<cftransaction>
	<cfquery name="del_form" datasource="#dsn#">
		DELETE FROM PERSONEL_ASSIGN_FORM WHERE PERSONEL_ASSIGN_ID = #attributes.per_assign_id#
	</cfquery>
	<cfquery name="del_notes" datasource="#dsn#">
		DELETE FROM NOTES WHERE ACTION_SECTION = 'PER_ASSIGN_ID' AND ACTION_ID = #attributes.per_assign_id#
	</cfquery>
	<cfquery name="del_warnings" datasource="#dsn#">
		DELETE FROM PAGE_WARNINGS WHERE WARNING_DESCRIPTION LIKE '%Atama%' AND SETUP_WARNING_ID = #attributes.per_assign_id#
	</cfquery>
	<cf_add_log log_type="-1" action_id="#attributes.per_assign_id#" action_name="#attributes.head#"  process_stage="#get_process.per_assign_stage#">
</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=hr.list_personel_assign_form</cfoutput>";
</script>
