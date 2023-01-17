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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'budget.list_expense_center';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/budget/display/list_expense_center.cfm';	
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'budget.popup_add_expense_center';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/budget/form/add_expense_center.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/budget/query/add_expense_center.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '';	
		
		if(isdefined("attributes.expense_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'budget.popup_upd_expense_center';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/budget/form/upd_expense_center.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/budget/query/upd_expense_center.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.expense_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '';
		
			if(listFind('upd,del',attributes.event))
			{
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=budget.emptypopup_del_expense_center&expense_id=#attributes.expense_id#';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/budget/query/del_expense_center.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/budget/query/del_expense_center.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'budget.list_expense_center';
			}
		}
		
	}
	else{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(isdefined("attributes.event") and (attributes.event is 'add'))
		{
			getLang = caller.getLang;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang(97,"Liste",57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=budget.list_expense_center";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction();";
		}

		if(isdefined("attributes.event") and (attributes.event is 'upd'))
		{			
			getLang = caller.getLang;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=budget.list_expense_center&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=budget.list_expense_center";
			
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
<!---<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang no='50.Masraf Merkezi Kodu Girmelisiniz'> !</cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang no='49.Alt Masraf Merkezi Adı Girmelisiniz'> !</cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang_main no='1527.Ad Girmelisiniz'> !</cfsavecontent> upd masraf merkezi--->