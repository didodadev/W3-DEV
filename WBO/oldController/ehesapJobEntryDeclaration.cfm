<script type="text/javascript">
	function send_page()
	{
		window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_ssk_start_work&employee_id='+$('#employee_id').val()+'&in_out_id='+$('#in_out_id').val()+'&employee_name='+$('#employee_name').val();
		return true;
	}
</script>
<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'det';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'ehesap.popup_job_entry_declaration';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'hr/ehesap/display/job_entry_declaration.cfm';
</cfscript>
