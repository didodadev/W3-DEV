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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.form_add_prod_pause_cat';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/settings/form/add_prod_pause_cat.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/settings/query/add_prod_pause_cat.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.form_add_prod_pause_cat';	
		
		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.form_upd_prod_pause_cat';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/settings/form/upd_prod_pause_cat.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/settings/query/upd_prod_pause_cat.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'settings.form_add_prod_pause_cat';
		}
	}
	
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'add')
		{
						
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onClick'] = "window.location.href='#request.self#?fuseaction=settings.form_add_prod_pause_cat';";
			
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SETUP_PROD_PAUSE_CAT';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PROD_PAUSE_CAT_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-pauseCat']";
</cfscript>
