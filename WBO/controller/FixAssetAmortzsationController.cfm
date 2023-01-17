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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'invent.list_invent_amortization';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/inventory/display/list_invent_amortization.cfm';
		

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invent.popup_add_invent_amortization';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/inventory/form/add_invent_amortization.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/inventory/query/add_invent_amortization.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invent.list_invent_amortization&event=upd&inv_id=';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(invent_amortization);";
		
		if(isdefined("attributes.inv_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['xmlFuseaction'] = 'invent.popup_add_invent_amortization';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invent.popup_upd_invent_amortization';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/inventory/form/upd_invent_amortization.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/inventory/query/upd_invent_amortization.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.inv_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invent.list_invent_amortization&event=upd&inv_id=';

		}
		if(isdefined("attributes.event") and (attributes.event is "upd" or attributes.event is "del"))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=invent.emptypopup_del_invent_amortization&inv_main_id=#attributes.inv_id#&old_process_type=##caller.get_detail.process_type##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/inventory/query/del_invent_amortization.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/inventory/query/del_invent_amortization.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'invent.list_invent_amortization';
		}
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'INVENTORY_AMORTIZATION_MAIN';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'INV_AMORT_MAIN_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-purchase_date','item-process_date','item-last_amortization_year','item-process_cat_bottom','item-amort_debt_acc_name_bottom','item-amort_claim_acc_name_bottom','item-process_date_bottom']";
		
		
	}else{
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invent.list_invent_amortization";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(caller.attributes.event is 'upd')
		{
			get_detail = caller.get_detail;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=invent.list_invent_amortization&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invent.list_invent_amortization";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=invent.popup_print_invent_amortization&action_id=#attributes.inv_id#','longpage');";
		
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.inv_id#&process_cat=#get_detail.process_type#','page');";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>