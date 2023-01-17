<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'quality.list_guaranty';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/service/display/list_guaranty.cfm';	
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'objects.popup_add_serialno_guaranty';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/objects/form/add_serial_no_guaranty.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/objects/query/add_serialno_guaranty.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'quality.list_guaranty&event=upd&id=';	
		
		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'objects.popup_upd_serialno_guaranty';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/objects/form/upd_serial_no_guaranty.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/objects/query/upd_serialno_guaranty.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'quality.list_guaranty&event=upd&id=';
		}
		
	}
</cfscript>
