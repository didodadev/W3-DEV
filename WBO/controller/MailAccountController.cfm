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
                WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/settings/display/list_mail_accounts.cfm';
                WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'settings.list_mail_accounts';
                WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = '';

                WOStruct['#attributes.fuseaction#']['add'] = structNew();
                WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.list_mail_accounts';
                WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/settings/form/add_mail_account.cfm';
                WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/settings/query/add_mail_account.cfm';
                WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.list_mail_accounts&event=upd&maid=';

            if(isDefined("attributes.event") and listFind('del,upd', attributes.event)){
                WOStruct['#attributes.fuseaction#']['upd'] = structNew();
                WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.list_mail_accounts';
                WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/settings/form/upd_mail_account.cfm';
                WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/settings/query/upd_mail_account.cfm';
                WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'settings.list_mail_accounts&event=upd&maid=';
                WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.maid#';

                WOStruct['#attributes.fuseaction#']['del'] = structNew();
                WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
                WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'settings.list_mail_accounts&maid=#attributes.maid#';
                WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/settings/query/del_mail_account.cfm';
                WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/settings/query/del_mail_account.cfm';
                WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'settings.list_mail_accounts';
            }
    }
    else
	{
		getLang = caller.getLang;
		
		if(isdefined("attributes.event") and attributes.event is 'add')
		{

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=settings.list_mail_accounts";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
	
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
        }
        if(isdefined("attributes.event") and attributes.event is 'upd')
		{
            tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getlang('main',170)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=settings.list_mail_accounts&event=add";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] =  '#getlang('main',62)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] ="window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#url.maid#&print_type=73','WOC');";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=settings.list_mail_accounts";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=maid&action_id=#attributes.maid#&wrkflow=1','Workflow')";
        }
    }
</cfscript>