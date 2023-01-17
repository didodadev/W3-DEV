<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.list_digital_asset_group';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/settings/display/dijital_asset_groups.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.list_digital_asset_group';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/settings/query/add_digital_asset_group.cfm';
		if(isdefined("attributes.id")){
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.list_digital_asset_group';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/settings/form/upd_digital_asset_group.cfm';		
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/settings/query/upd_digital_asset_group.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'upd_digital_asset_group';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'settings.list_digital_asset_group&event=upd&id=';}
		
		

	
	}
    else
    {
        fuseactController = caller.attributes.fuseaction;
        getLang = caller.getLang;
        
        tabMenuStruct = StructNew();
        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

        
    }						
</cfscript>

