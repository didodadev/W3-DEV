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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.form_add_stock_exchange';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/stock/form/form_add_stock_exchange.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/stock/query/add_stock_exchange.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.form_add_stock_exchange&event=upd&exchange_id=';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('detail_stock_exchange','detail_stock_exchange_bask');";
		
		if(isdefined("attributes.exchange_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.form_upd_stock_exchange';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/stock/form/form_upd_stock_exchange.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/stock/query/upd_stock_exchange.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.exchange_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.form_add_stock_exchange&event=upd&exchange_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('stock_exchange','stock_exchange_bask');";
		}
		
		if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#fusebox.circuit#.emptypopup_del_stock_exchange&exchange_id=#attributes.exchange_id#&process_type=##caller.GET_STOCK_EXCHANGE.PROCESS_CAT##&is_stock=1';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/stock/query/del_stock_exchange.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/stock/query/del_stock_exchange.cfm';
			WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'process_cat&acc_id&old_process_type';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'stock.list_purchase';
		}
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'STOCK_EXCHANGE';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'STOCK_EXCHANGE_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-exchange_no','item-giris_depo','item-cikis_depo','item-process_date']";
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
		getLang = caller.getLang;
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		if(isdefined("attributes.event") and attributes.event is 'add')
		{	
				
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_purchase";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['print']['onClick'] = "windowopen('index.cfm?fuseaction=objects.popup_send_print&module=stock&trail=1&is_logo=0&show_datetime=0&iframe=1','small','popup_send_print')";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'] = structNew();		
			
			tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
		}
		// Upd //
		else if(isdefined("attributes.event") and (attributes.event is 'upd'))
		{
			GET_STOCK_EXCHANGE = caller.GET_STOCK_EXCHANGE;
			get_module_user = caller.get_module_user;
			get_acc_id = caller.get_acc_id;
			get_acc_id_save = caller.get_acc_id_save;
			if(get_acc_id.recordcount)
			{
				acc_id_ = get_acc_id.ACTION_ID;
			}
			else if(get_acc_id_save.recordcount)
			{
				acc_id_ = get_acc_id_save.action_id;
			}
			else{
				 acc_id_ = -1;
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_purchase";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=stock.form_add_stock_exchange";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.exchange_id#&print_type=31','page','workcube_print');";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			i = 0;
			if(get_module_user(22) and listfind("116",GET_STOCK_EXCHANGE.PROCESS_TYPE)){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',397)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#acc_id_#&process_cat='+add_virman.old_process_type.value,'page','form_upd_fis');";
				
				i  = i + 1;
			}
			if(session.ep.our_company_info.guaranty_followup){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',305)#-#getLang('main',306)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations&is_filtre=1&belge_no=#GET_STOCK_EXCHANGE.EXCHANGE_NUMBER#&process_cat_id=#GET_STOCK_EXCHANGE.PROCESS_TYPE#&process_id=#attributes.exchange_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				
				i  = i + 1;
			}

			tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
		}
	}
</cfscript>