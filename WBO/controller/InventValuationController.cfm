<cfscript>
        if(attributes.tabMenuController eq 0)
		{
			WOStruct = StructNew();
			
			WOStruct['#attributes.fuseaction#'] = structNew();
			
			WOStruct['#attributes.fuseaction#']['default'] = 'list';
			
			WOStruct['#attributes.fuseaction#']['list'] = structNew();
			WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'invent.valuation&event=list';
			WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/inventory/display/list_valuation.cfm';
			
			
			WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invent.valuation&event=add';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/inventory/form/add_valuation.cfm';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/inventory/cfc/inventory.cfc';
			
		}
		else
	{			
			
			getLang = caller.getLang;
			denied_pages = caller.denied_pages;
			fuseactController = caller.attributes.fuseaction;
			dsn = caller.dsn;
			
			tabMenuStruct = StructNew();
			tabMenuStruct['#attributes.fuseaction#'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
			if(isdefined("attributes.event") and attributes.event is 'add')
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invent.valuation&event=list";

				
				tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

			}
	}
</cfscript>