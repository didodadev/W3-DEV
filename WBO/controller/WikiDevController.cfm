<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        
        WOStruct['#attributes.fuseaction#'] = structNew();
        
        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        
        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal'; 
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'dev.wiki_progress';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'WDO/wiki_development.cfm';
    
    }
    else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
        if(caller.attributes.event is 'list')
		{
		    tabMenuStruct['#fuseactController#']['tabMenus']['list']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['list']['icons']['fa fa-folder']['text'] = 'Dev Tools';
            tabMenuStruct['#fuseactController#']['tabMenus']['list']['icons']['fa fa-folder']['href'] = "#request.self#?fuseaction=dev.tools";
            
        }
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>