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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'worknet.list_social_media';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/worknet/display/list_social_media.cfm';
	
		if(isdefined("attributes.sid"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'worknet.upd_social_media';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/worknet/form/upd_social_media.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/worknet/form/upd_social_media.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.sid#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'worknet.list_social_media&event=upd&sid=';
		}
		
	}
	
</cfscript>
