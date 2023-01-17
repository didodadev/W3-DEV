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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'health.assurance_types';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/hr/display/assurance_types.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'health.assurance_types';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/hr/form/add_assurance_types.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/hr/form/add_assurance_types.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '';

        WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'health.assurance_types';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/hr/form/upd_assurance_types.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/hr/form/upd_assurance_types.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '';
    }
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

		
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>

