<cfsavecontent  variable="copy"><cf_get_lang dictionary_id='39010.Kopya'></cfsavecontent>
<cfsavecontent  variable="design"><cf_get_lang dictionary_id='43439.Sayfa Tasarımı'></cfsavecontent>
<cfsavecontent  variable="menu"><cf_get_lang dictionary_id='31002.Menu'></cfsavecontent>
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
            WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'settings.list_main_menu';
            WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/settings/display/list_main_menu.cfm';
    
	
		    WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.list_main_menu';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/settings/form/add_main_menu.cfm';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/settings/query/add_main_menu.cfm';
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.list_main_menu';
	
            if(isdefined("attributes.menu_id"))
            {
		    WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.list_main_menu';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/settings/form/upd_main_menu.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/settings/query/upd_main_menu.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.menu_id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'settings.list_main_menu&event=upd&menu_id=';
            WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'user_group';}

	
		
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
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=settings.list_main_menu";
            
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
 
	
        }
		if(caller.attributes.event is 'upd')
		{
		    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=settings.list_main_menu&event=add";
            
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=settings.list_main_menu";

            
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=menu_id&action_id=#attributes.menu_id#','Workflow')";
    
            

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#copy#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=settings.emptypopup_copy_main_menu&menu_id=#attributes.menu_id#";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-pencil']['text'] = '#design#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=settings.list_site_layouts&menu_id=#attributes.menu_id#";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-sitemap']['text'] = '#menu#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-sitemap']['onclick'] = "windowopen('#request.self#?fuseaction=settings.popup_dsp_main_menu&menu_id=#attributes.menu_id#','page');";

        }
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	
</cfscript>

