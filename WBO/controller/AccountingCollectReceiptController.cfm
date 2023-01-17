<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.form_add_bill_collecting';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/account/form/add_bill_collecting.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/account/query/add_bill_collecting.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.form_add_bill_collecting&event=upd&card_id=';
		
/*		WOStruct['#attributes.fuseaction#']['copy'] = structNew();
		WOStruct['#attributes.fuseaction#']['copy']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['copy']['fuseaction'] = 'account.popup_add_bill_collecting_copy';
		WOStruct['#attributes.fuseaction#']['copy']['filePath'] = '/V16/account/form/add_bill_collecting_copy.cfm';
		WOStruct['#attributes.fuseaction#']['copy']['queryPath'] = 'V16/account/query/add_bill_collecting.cfm';
		WOStruct['#attributes.fuseaction#']['copy']['nextEvent'] = 'account.form_add_bill_collecting&event=upd&card_id=';
		*/
		if(isdefined("attributes.card_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'account.popup_upd_bill_collecting';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/account/form/upd_bill_collecting.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/account/query/upd_bill_collecting.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.card_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'account.form_add_bill_collecting&event=upd&card_id=';
		}
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,copy';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'ACCOUNT_CARD';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CARD_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_date','item-process_cat','item-get_cash_plan']";
	}else
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=account.list_cards";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			link_str = caller.link_str;
			get_account_card = caller.get_account_card;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=account.form_add_bill_collecting";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=account.form_add_bill_collecting&card_id=#attributes.card_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=account.list_cards";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.card_id#&print_type=290','woc');";
		
			i = 0;
			if(isdefined('caller.link_str') and len(caller.link_str) and len(get_account_card.action_cat_id))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('account',199)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#link_str##GET_ACCOUNT_CARD.ACTION_ID#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = '_blank';
				
				i = i + 1;
			} 
			
			else if(listfind('31',get_account_card.action_type,','))
			{
				get_order_id = caller.get_order_id;
				if(get_order_id.recordcount){
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',35)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=sales.upd_fast_sale&order_id=#get_order_id.order_id#";
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = 'invoice_window';
					
					i = i + 1;
				}
			} 
			
			else if(listfind('241',get_account_card.action_type,','))
			{
				get_order_id = caller.get_order_id;
				if(get_order_id.recordcount){
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',35)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=sales.upd_fast_sale&order_id=#get_order_id.order_id#";
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = 'invoice_window';
					
					i = i + 1;
				}
				
			} 
			
			else if(listfind('97',get_account_card.action_type,','))
			{
				get_order_id = caller.get_order_id;
				if(get_order_id.recordcount){
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',35)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=sales.upd_fast_sale&order_id=#get_order_id.order_id#";
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = 'invoice_window';
					
					i = i + 1;
				}
			} 
			
			else if(listfind('90',get_account_card.action_type,','))
			{
				get_order_id = caller.get_order_id;
				if(get_order_id.recordcount){
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',35)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=sales.upd_fast_sale&order_id=#get_order_id.order_id#";
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = 'invoice_window';
					
					i = i + 1;
				}
			}
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
