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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'invoice.marketplace_commands';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/invoice/display/list_marketplace_commands.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath'] = '/V16/invoice/display/list_marketplace_commands.cfm';
		WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'invoice.marketplace_commands';
		
		if(isdefined("attributes.iid") and len(attributes.iid))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invoice.marketplace_commands';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/invoice/form/upd_marketplace_bill.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/invoice/query/upd_marketplace_bill.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.iid#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invoice.marketplace_commands&event=upd&iid=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(marketplace_bill);";
		}

				
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invoice.marketplace_commands';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/invoice/form/add_marketplace_bill.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/invoice/query/add_marketplace_bill.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invoice.marketplace_commands&event=upd&iid=';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(marketplace_bill)";
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'INVOICE';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'INVOICE_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-partner_name','item-invoice_no','item-deliver_get','item-invoice_date','item-department_ID']";
		
		if(isdefined("attributes.event") and (attributes.event is "upd" or attributes.event is "del"))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_marketplace_bill&active_period=#session.ep.period_id#&iid=#attributes.iid#&id=#attributes.iid#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/invoice/query/upd_marketplace_bill.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/invoice/query/upd_marketplace_bill.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_invoice';
	
		}
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		// Upd //
		getLang = caller.getLang;
	
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'add' )
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invoice.marketplace_commands";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		if(isdefined("attributes.event") and attributes.event is 'upd')
			{
				denied_pages = caller.denied_pages;
				get_module_user =caller.get_module_user;
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',170)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invoice.marketplace_commands";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		
				i = 0;
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();

				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = "#getLang('invoice',217)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_cost&id=#url.iid#&page_type=1&basket_id=#attributes.basket_id#','page_horizantal');";
				i = i + 1;
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-sitemap']['text'] = '#getLang('','Maliyet Merkezi Dağıtımı',57266)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-sitemap']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_upd_expensecenter_invoice&id=#url.iid#','project');";
				
				
				
				if( not listfindnocase(denied_pages,'#listgetat(attributes.fuseaction,1,'.')#.popup_list_invoice_orders')){

					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','İlişkili Siparişler',57260)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_invoice_orders&invoice_id=#url.iid#','list');";
					i = i + 1;
				}

				if(session.ep.isBranchAuthorization eq 0 and not listfindnocase(denied_pages,'invoice.popup_get_contract_comparison')){
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Anlaşmalara Uygunluk Kontrolü',58751)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=invoice.popup_get_contract_comparison&iid=#url.iid#','horizantal');";		
				}
				if(get_module_user(22)){

					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['icn-md fa fa-table']['text'] = '#getLang('','Mahsup Fişi',58452)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['icn-md fa fa-table']['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.iid#&process_cat='+form_basket.old_process_type.value,'page');";		
				} 


			
			}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
		
</cfscript>