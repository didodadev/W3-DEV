<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        
        WOStruct['#attributes.fuseaction#'] = structNew();
        
        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        
        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'dev.events';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'WDO/modalEvent.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'dev.events&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'WDO/modalEvent.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'WDO/modalEvent.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'dev.events';

        if(isdefined("attributes.id"))
        {
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'dev.events';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'WDO/modalEvent.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'WDO/modalEvent.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'dev.events';
        }
        
    }else{
        
        fuseactController = caller.attributes.fuseaction;
        getLang = caller.getLang;
        
        tabMenuStruct = StructNew();
        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
        if(caller.attributes.event is 'add')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();

            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=dev.events";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
        }
        if(caller.attributes.event is 'upd')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
            
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=dev.events";

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['text'] = '#getLang('main',359)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=dev.wo&event=upd&fuseact=#attributes.fuseact#&woid=#attributes.woid#";

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-pencil']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-pencil']['text'] = '#getLang('','',58494)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=dev.events&event=add&fuseact=#attributes.fuseact#&id=#attributes.id#&woid=#attributes.woid#";

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

        }

        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
    }
</cfscript>