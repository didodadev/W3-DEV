<cfscript>
    if(attributes.tabMenuController eq 0)
	{
        WOStruct = StructNew();

        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/settings/display/list_emp_denied_pages.cfm';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'settings.emp_denied_pages';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.emp_denied_pages';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/settings/display/user_denied_emp.cfm';
 
		if(isDefined("attributes.event") and listFind('del,upd', attributes.event)){
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.emp_denied_pages';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/settings/display/user_upd_denied_emp.cfm';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=settings.emptypopup_del_user_denied_emp&faction_id=#faction_id#&module_id=#module_id#&pos_code=#pos_code#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/query/del_emp_denied_pages.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/query/del_emp_denied_pages.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'settings.emp_denied_pages';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=settings.emp_denied_pages";
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
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=settings.emp_denied_pages";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('','Güncelle','57464')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['href'] = '#request.self#?fuseaction=objects.popup_print_files&print_type=181&action_type=#attributes.faction_id#&action_id=#attributes.faction_id#';

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['href'] = '#request.self#?fuseaction=objects.workflowpages&tab=3&action=myhome.my_extre&action_name=faction_id&action_id=#attributes.faction_id#';			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

    }
</cfscript>
