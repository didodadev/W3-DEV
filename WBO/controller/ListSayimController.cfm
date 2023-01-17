<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'pos.list_sayim';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/pos/display/list_sayim.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'pos.form_add_sayim';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/pos/form/form_add_sayim.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/pos/query/form_add_sayim.cfm';

		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'pos.form_upd_sayim';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/pos/form/form_upd_sayim.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/pos/query/write_document.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'pos.list_sayim&event=upd&file_id=';
		if(isdefined("attributes.file_id"))
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.file_id#';
        
    }else
    {
        fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		// Tab Menus //
		tabMenuStruct = StructNew();
		tabMenuStruct['#attributes.fuseaction#'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
		
		if(isdefined("attributes.event") and attributes.event is 'add')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=pos.list_sayim";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
    }
      
</cfscript>