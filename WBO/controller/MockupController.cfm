<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        
        WOStruct['#attributes.fuseaction#'] = structNew();
        
        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        
        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'dev.mockup';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'WDO/modalMockup.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'dev.mockup&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'WDO/modalMockup.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'WDO/modalMockup.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'dev.mockup';

        if(isdefined("attributes.id"))
        {
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'dev.mockup';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'WDO/modalMockup.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'WDO/modalMockup.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'dev.mockup';

            WOStruct['#attributes.fuseaction#']['det'] = structNew();
            WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'dev.mockup';
            WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'WDO/modalMockup.cfm';
            WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'WDO/modalMockup.cfm';
            WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.id#';
            WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'dev.mockup';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=dev.mockup";
            if( IsDefined("attributes.work_id") and len( attributes.work_id ) ){
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['link']['target'] = "_blank";
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['link']['text'] = '#getLang('','',49733)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['link']['href'] = "#request.self#?fuseaction=project.works&event=det&id=#attributes.work_id#";
            }
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
        }
        if(caller.attributes.event is 'upd')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
            
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-eye']['text'] = '#getlang('','',59807)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-eye']['href'] = "#request.self#?fuseaction=dev.mockup&event=det&id=#attributes.id#";

            if( IsDefined("attributes.work_id") and len( attributes.work_id ) ){
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['link']['target'] = "_blank";
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['link']['text'] = '#getLang('','',49733)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['link']['href'] = "#request.self#?fuseaction=project.works&event=det&id=#attributes.work_id#";
            }

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=dev.mockup";

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=dev.mockup&event=add";
            
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['text'] = '#getLang('main',359)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=dev.mockup&event=det&id=#attributes.id#";
            
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

        }
        if(caller.attributes.event is 'det')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
            
            if( IsDefined("attributes.work_id") and len( attributes.work_id ) ){
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['link']['target'] = "_blank";
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['link']['text'] = '#getLang('','',49733)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['link']['href'] = "#request.self#?fuseaction=project.works&event=det&id=#attributes.work_id#";
            }

            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=dev.mockup";

            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=dev.mockup&event=add";

            tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getlang('','',57464)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=dev.mockup&event=upd&id=#attributes.id#";

        }

        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
    }
</cfscript>