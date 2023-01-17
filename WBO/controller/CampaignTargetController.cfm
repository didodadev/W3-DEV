<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';		
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'campaign.targets';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/campaign/form/targets.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/campaign/query/add_multiple_targets.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'campaign.targets';
		
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		getLang = caller.getLang;		
		
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}

</cfscript>
