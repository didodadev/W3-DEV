<cfscript>
	if(attributes.tabMenuController eq 0)
	{
			
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'assetcare.form_search_accident';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/assetcare/form/form_search_accident.cfm';
        
        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'assetcare.form_add_accident';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/assetcare/form/form_add_accident.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/assetcare/form/add_accident.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '';

        if(isdefined("attributes.accident_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'assetcare.popup_upd_accident';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/assetcare/form/upd_accident.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/assetcare/query/upd_accident.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '';
		}
		
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
        
		
		 if(caller.attributes.event is 'upd')
		{
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=assetcare.form_search_accident";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	
	}
</cfscript>