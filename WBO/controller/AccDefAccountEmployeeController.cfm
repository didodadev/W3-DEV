<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		if(listgetat(attributes.fuseaction,1,'.') is 'account')
		{
			WOStruct['#attributes.fuseaction#']['list'] = structNew();
			WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.list_employee_accounts';
			WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/account/display/list_employee_accounts.cfm';	
		}
		else
		{
			WOStruct['#attributes.fuseaction#']['list'] = structNew();
			WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.popup_list_period';
			WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/ehesap/display/list_periods.cfm';		
		}
		
		if(isdefined("attributes.in_out_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
			if(listgetat(attributes.fuseaction,1,'.') is 'account')
				WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'account.popup_list_period';
			else
				WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_list_period';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/ehesap/display/list_periods.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/ehesap/query/add_periods_to_in_out.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.in_out_id#';
			if(listgetat(attributes.fuseaction,1,'.') is 'account')
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'account.list_employee_accounts&event=upd&in_out_id=';
			else
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.popup_list_period&event=upd&in_out_id=';
		}
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'upd')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			if(listgetat(attributes.fuseaction,1,'.') is 'account')
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=account.list_employee_accounts";
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

</cfscript>

