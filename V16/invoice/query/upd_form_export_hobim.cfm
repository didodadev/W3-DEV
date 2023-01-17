<cfquery name="updHobim" datasource="#dsn2#">
	UPDATE FILE_EXPORTS SET FILE_STAGE = #attributes.process_stage# WHERE E_ID = #attributes.hobim_id#
</cfquery>

<cf_workcube_process 
	is_upd="1" 
	old_process_line="#attributes.old_process_line#"
	process_stage="#attributes.process_stage#" 
	record_member="#session.ep.userid#"
	record_date="#now()#" 
	action_table='FILE_EXPORTS'
	action_column='E_ID'
	action_id="#attributes.hobim_id#"
    action_page="#request.self#?fuseaction=invoice.popup_form_export_hobim&hobim_id=#attributes.hobim_id#"
    warning_description='Hobim Id : #attributes.hobim_id#'>
<script type="text/javascript">
	opener.location.reload();
	window.close();
</script>
