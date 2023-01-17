<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'dev.wex';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'WDO/modalWex.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'dev.wex&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'WDO/modalWexAdd.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'WDO/development/query/add_wex.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'dev.wex&event=upd&wxid=';


       
		if(isdefined("attributes.event") and listFind('upd',attributes.event))
			{	
				WOStruct['#attributes.fuseaction#']['upd'] = structNew();
				WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
				WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'dev.wex&event=upd&wxid=';
				WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'WDO/modalWexAdd.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'WDO/development/query/upd_wex.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'dev.wex&event=upd&wxid=';
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.wxid#';
			} 
    }
    else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		if((isdefined("attributes.event") and attributes.event is 'add'))
        {
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=dev.wex";
			  
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";

		}
		if((isdefined("attributes.event") and attributes.event is 'upd'))
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170,'ekle')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=dev.wex&event=add";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=dev.wex";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=wxid&action_id=#attributes.wxid#','Workflow')";
	
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>