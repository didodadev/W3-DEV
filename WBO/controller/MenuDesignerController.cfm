<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        
        WOStruct['#attributes.fuseaction#'] = structNew();
        
        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        
        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'dev.menudesigner';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'WDO/modalMenuDesigner.cfm';

    
        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'dev.menudesigner';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'WDO/modalMenuDesigner.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'dev.menudesigner';

        if(isdefined("attributes.menu"))
        {
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'dev.menudesigner';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'WDO/modalMenuDesigner.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.menu#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'dev.menudesigner';
        }
        WOStruct['#attributes.fuseaction#']['mm'] = structNew();
        WOStruct['#attributes.fuseaction#']['mm']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['mm']['fuseaction'] = 'dev.menudesigner';
        WOStruct['#attributes.fuseaction#']['mm']['filePath'] = 'WDO/modalModuleMenu.cfm';
        WOStruct['#attributes.fuseaction#']['mm']['nextEvent'] = 'dev.menudesigner';
        
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
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=dev.menudesigner";
            
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
 
	
        }
	    if(caller.attributes.event is 'upd')
		{
		    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=dev.menudesigner";
            
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=dev.menudesigner&event=add";
	
        }
        if(caller.attributes.event is 'mm')
		{
		    tabMenuStruct['#fuseactController#']['tabMenus']['mm']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['mm']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['mm']['icons']['list-ul']['href'] = "#request.self#?fuseaction=dev.menudesigner";
            
			tabMenuStruct['#fuseactController#']['tabMenus']['mm']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['mm']['icons']['check']['onClick'] = "buttonClickFunction()";

            tabMenuStruct['#fuseactController#']['tabMenus']['mm']['icons']['add']['text'] = '#getLang('main',170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['mm']['icons']['add']['href'] = "#request.self#?fuseaction=dev.menudesigner&event=add";
	
        }
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>