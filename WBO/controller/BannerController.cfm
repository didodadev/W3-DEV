<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];
            WOStruct['#attributes.fuseaction#']['list'] = structNew();
            WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'content.list_banners';
            WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/content/display/list_banners.cfm';
    
	
		    WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'content.list_banners';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/content/form/add_banner.cfm';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/content/query/add_banner.cfm';
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'content.list_banners&event=upd&banner_id=';
			WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_banner'; 
	
            if(isdefined("attributes.banner_id"))
            {
		    WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'content.list_banners';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/content/form/upd_banner.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/content/query/upd_banner.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.banner_id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'content.list_banners&event=upd&banner_id=';
            WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'upd_banner';}

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] ='#request.self#?fuseaction=content.emptypopup_del_banner&banner_id=';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/content/query/del_banner.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/content/query/del_banner.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'content.list_banners';
		
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
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=content.list_banners";
            
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
 
	
        }
		if(caller.attributes.event is 'upd')
		{
		    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=content.list_banners&event=add";
            
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=content.list_banners";

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onclick'] = "printSa()";
            
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=banner_id&action_id=#attributes.banner_id#','Workflow')";
    
            
        }
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	
</cfscript>

