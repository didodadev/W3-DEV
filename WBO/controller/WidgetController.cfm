<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        
        WOStruct['#attributes.fuseaction#'] = structNew();
        
        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        
        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'dev.widget';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'WDO/modalWidget.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'dev.widget&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'WDO/modalWidget.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'dev.widget';
        if(isdefined("attributes.id"))
            WOStruct['#attributes.fuseaction#']['add']['Identity'] = '#attributes.id#';
        
        

        if(isdefined("attributes.id"))
        {
        WOStruct['#attributes.fuseaction#']['upd'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'dev.widget&event=upd&id=';
        WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'WDO/modalWidget.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'dev.widget&event=upd&id=';}
        
        
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
	
            if( isdefined("attributes.id") and len(attributes.id) ){
                if( isdefined("attributes.woid") and len(attributes.woid) ){
                    tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['detail']['target'] = "_blank";
                    tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['detail']['text'] = '#getLang('main',359)#';
                    tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['detail']['href'] = "#request.self#?fuseaction=dev.wo&event=upd&fuseact=#attributes.fuseact#&woid=#attributes.woid#";
                }

                tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['add']['text'] = '#getLang('main',170)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['add']['href'] = "#request.self#?fuseaction=dev.widget&event=add";

            }

			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=dev.widget";
            
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
	
        }
		if(caller.attributes.event is 'upd')
		{
		    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=dev.widget&event=add";
            if( isdefined("attributes.woid") and len(attributes.woid) ){
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['target'] = "_blank";
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['text'] = '#getLang('main',359)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=dev.wo&event=upd&fuseact=#attributes.fuseact#&woid=#attributes.woid#";
            }
            
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=dev.widget";

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-pencil']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-pencil']['text'] = '#getLang('','',58494)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=dev.widget&event=add&fuseact=#attributes.fuseact#&id=#attributes.id#&woid=#attributes.woid#";
            
        }
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>