<cfscript>
    if(attributes.tabMenuController eq 0)
	{
        WOStruct = StructNew();

        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/settings/display/list_denied_pages.cfm';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'settings.denied_pages';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.denied_pages';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/settings/display/user_denied.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/settings/query/add_perm_faction1.cfm';
	    WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.denied_pages&event=upd&faction=';

		if(isDefined("attributes.event") and listFind('del,upd', attributes.event)){
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.denied_pages';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/settings/display/user_upd_denied.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/settings/query/upd_denied_page_cat.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'settings.denied_pages&event=upd&faction=';

			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=settings.emptypopup_del_denied_page&deny_page=#attributes.faction#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/settings/query/del_denied_page.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/settings/query/del_denied_page.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'settings.denied_pages';
        }
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=settings.denied_pages";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('','Kaydet','57461')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('','Ekle','57582')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=settings.denied_pages&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=settings.denied_pages";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('','Güncelle','57464')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";				
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

    }
</cfscript>
