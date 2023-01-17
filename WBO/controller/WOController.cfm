<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        
        WOStruct['#attributes.fuseaction#'] = structNew();
        
        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        
        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'dev.wo';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'WDO/modalWo.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'dev.wo&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'WDO/modalWoAdd.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'WDO/development/query/add_fuseaction.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'dev.wo';

        

        if(isdefined("attributes.fuseact"))
        {
        WOStruct['#attributes.fuseaction#']['upd'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'dev.wo';
        WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'WDO/modalWoAdd.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'WDO/development/query/upd_fuseaction.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.fuseact#';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'dev.wo';}
        
        
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
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=dev.wo";
            
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";

            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-folder']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-folder']['href'] = "#request.self#?fuseaction=dev.tools";
 
	
        }
		if(caller.attributes.event is 'upd')
		{
		    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			if(isdefined("url.fuseact") and  url.fuseact DOES NOT CONTAIN 'popup' and url.fuseact DOES NOT CONTAIN 'emptypopup' )
            {
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa icon-link']['text'] = '#getLang('','',42371)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa icon-link']['href'] = "#request.self#?fuseaction=#url.fuseact#";
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa icon-link']['target'] = "_blank";
            }

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=dev.wo&event=add";
            
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=dev.wo";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=woid&action_id=#attributes.woid#','Workflow')";
    
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-folder']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-folder']['href'] = "#request.self#?fuseaction=dev.tools";
    
        }
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>