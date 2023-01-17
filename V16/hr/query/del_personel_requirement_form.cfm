<cfquery name="get_process" datasource="#dsn#">
	SELECT PER_REQ_STAGE FROM PERSONEL_REQUIREMENT_FORM WHERE PERSONEL_REQUIREMENT_ID = #attributes.per_req_id#
</cfquery>
<cflock timeout="60">
	<cftransaction>
		<cfquery name="del_form" datasource="#dsn#">
			DELETE FROM PERSONEL_REQUIREMENT_FORM WHERE PERSONEL_REQUIREMENT_ID = #attributes.per_req_id#
		</cfquery>
		<cfquery name="del_notes" datasource="#dsn#">
			DELETE FROM NOTES WHERE ACTION_SECTION = 'PER_REQ_ID' AND ACTION_ID = #attributes.per_req_id#
		</cfquery>
		<cfquery name="del_warnings" datasource="#dsn#">
			DELETE FROM PAGE_WARNINGS WHERE WARNING_DESCRIPTION LIKE '%Personel%' AND SETUP_WARNING_ID = #attributes.per_req_id#
		</cfquery>
		<cf_add_log  log_type="-1" action_id="#attributes.per_req_id#" action_name="#attributes.head#"  process_stage="#get_process.PER_REQ_STAGE#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.list_personel_requirement_form</cfoutput>";
</script>
