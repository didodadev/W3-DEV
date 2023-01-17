<script type="text/javascript">
	function kontrol()
	{
		if(document.form_work_transfer.startdate.value != '' && document.form_work_transfer.finishdate.value != '' )
			{
				return date_check(form_work_transfer.startdate,form_work_transfer.finishdate,"<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'> !");
			}
		return true;
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.popup_transfer_work';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/transfer_work.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/transfer_work.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.popup_transfer_work';
</cfscript>
