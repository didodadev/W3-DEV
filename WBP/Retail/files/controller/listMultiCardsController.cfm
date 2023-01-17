<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	

		WOStruct['#attributes.fuseaction#']['list']					= structNew();
		WOStruct['#attributes.fuseaction#']['list']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'retail.card_multi_list';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/WBP/Retail/files/display/card_multi_list.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/WBP/Retail/files/display/card_multi_list.cfm';

		WOStruct['#attributes.fuseaction#']['add']					= structNew();
		WOStruct['#attributes.fuseaction#']['add']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'retail.card_multi_list';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= '/WBP/Retail/files/form/card_multi_add.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath']		= '/WBP/Retail/files/form/card_multi_add.cfm';
		
		WOStruct['#attributes.fuseaction#']['upd']					= structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction']	= 'retail.card_multi_list';
		WOStruct['#attributes.fuseaction#']['upd']['filePath']		= '/WBP/Retail/files/display/card_multi_list_inner.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath']		= '/WBP/Retail/files/display/card_multi_list_inner.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent']     = 'retail.card_multi_list&event=upd&row_id=';
		WOStruct['#attributes.fuseaction#']['upd']['parameters']    = 'row_id=##attributes.row_id##';
		if(isdefined("attributes.row_id"))
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.row_id#';
		
	
	}
	else {
		
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=retail.card_multi_list";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}
</cfscript>