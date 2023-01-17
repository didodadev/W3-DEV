<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.add_stock_in_from_customs';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/stock/form/add_stock_in_from_customs.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/stock/query/add_stock_in_from_customs.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.add_stock_in_from_customs&event=upd&ship_id=';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(add_stock_in);";
		
		if(isdefined("attributes.ship_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.upd_stock_in_from_customs';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/stock/form/upd_stock_in_from_customs.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/stock/query/upd_stock_in_from_customs.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.ship_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.add_stock_in_from_customs&event=upd&ship_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';		
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=stock.emptypopup_upd_stock_in&del_ship=1&ship_id=#attributes.ship_id#&upd_id=#attributes.ship_id#&ship_number=##caller.get_upd_purchase.ship_number##&cat=##caller.get_upd_purchase.ship_type##';				
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/stock/query/del_stock_in_from_customs.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/stock/query/del_stock_in_from_customs.cfm';
			WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'old_process_type';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'stock.list_purchase';
			
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_purchase";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getlang('stock',358)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_cost&id=#url.ship_id#&page_type=4&basket_id=#attributes.basket_id#','page_horizantal');";
			i = 1;
			if(session.ep.our_company_info.guaranty_followup)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','',32706)#';	
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_add_serial_operations&is_filtre=1&belge_no=#caller.get_upd_purchase.ship_number#&process_cat_id=#caller.get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#')";
				i++;
			}
			
			if(session.ep.our_company_info.GUARANTY_FOLLOWUP){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',305)# - #getlang('main',306)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#caller.get_upd_purchase.ship_number#&process_cat_id=#caller.get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#";
				i++;	
			}

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=stock.add_stock_in_from_customs";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_purchase";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.ship_id#&print_type=30#fuseaction contains 'service' ? '&keyword=service' : ''#','WOC');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['target'] = "_blank";
			
			if (caller.get_module_user(22)){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['text'] = '#getlang('main',2577)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.ship_id#&process_cat='+form_basket.old_process_type.value,'page','upd_bill');";				
			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=ship_id&action_id=#attributes.ship_id#&wrkflow=1','Workflow')";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ACTIONS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACTION_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-from_account_id','item-to_account_id','item-ACTION_DATE','item-ACTION_VALUE']";
	
</cfscript>