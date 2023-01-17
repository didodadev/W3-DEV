<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.list_account_plan';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/account/display/list_account_plan.cfm';

		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.popup_form_add_account';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/account/form/form_add_account.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/account/query/add_account.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.list_account_plan&event=upd&account_id=';
		
		if(isdefined("attributes.account_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'account.popup_form_upd_account';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/account/form/form_upd_account.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/account/query/upd_account.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.account_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'account.list_account_plan&event=upd&account_id=';
			
			if(isdefined("attributes.account_id") or listfind('sub',attributes.event))
			{
				WOStruct['#attributes.fuseaction#']['sub'] = structNew();
				WOStruct['#attributes.fuseaction#']['sub']['window'] = 'popup';
				WOStruct['#attributes.fuseaction#']['sub']['fuseaction'] = 'objects.popup_form_add_sub_account';
				WOStruct['#attributes.fuseaction#']['sub']['filePath'] = 'V16/objects/form/form_add_sub_account.cfm';
				WOStruct['#attributes.fuseaction#']['sub']['queryPath'] = 'V16/objects/query/add_sub_account.cfm';
				WOStruct['#attributes.fuseaction#']['sub']['Identity'] = '#attributes.account_id#';
				WOStruct['#attributes.fuseaction#']['sub']['nextEvent'] = 'account.list_account_plan&event=upd&account_id=';
			}
			if(listFind('upd,del',attributes.event))
			{
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=account.del_account&old_account=##caller.account.account_code##&account_id=#attributes.account_id#';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/account/query/del_account.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/account/query/del_account.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'account.list_account_plan';
			}
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=account.list_account_plan";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=account.list_account_plan&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=account.list_account_plan";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'ACCOUNTS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACCOUNT_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-account_code','item-account_name']";

</cfscript>