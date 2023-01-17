<cfscript>
	// Switch //
	if(attributes.tabMenuController eq 0)
	{	
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'finance.list_bank_pos';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/finance/display/list_pos_bank.cfm';
	
	if(isdefined("attributes.pos_id"))
		{
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'finance.popup_form_upd_pos_bank';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/finance/form/upd_pos_bank.cfm';		
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/finance/query/upd_pos_bank.cfm';			
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.pos_id##';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'finance.list_bank_pos&event=upd';	
		}

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.popup_form_add_pos_bank';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/finance/form/add_pos_bank.cfm';		
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/finance/query/add_pos_bank.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'finance.list_bank_pos&event=upd';
	 	
	}	
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		// Upd //
		if(isdefined("attributes.event") and (attributes.event is 'upd'))
		{
			getLang = caller.getLang;

			tabMenuStruct = StructNew();
			tabMenuStruct['#fuseactController#'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
				
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=finance.list_bank_pos";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onClick'] = "window.location.href='#request.self#?fuseaction=finance.list_bank_pos&event=add'";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";


			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		else if(attributes.event is 'add')
		{
			getLang = caller.getLang;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=finance.list_bank_pos";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'POS_EQUIPMENT_BANK';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'POS_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-pos_code','item-equipment','item-seller_code','item-branch_id','item-account_id']";	
</cfscript>
