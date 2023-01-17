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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.form_add_bill_cash2cash';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/account/form/add_bill_cash2cash.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/account/query/add_bill_cash2cash.cfm';
		if(isdefined("attributes.is_rate_diff"))
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.list_cards';
		else
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.form_add_bill_cash2cash&event=upd&card_id=';
		
		WOStruct['#attributes.fuseaction#']['copy'] = structNew();
		WOStruct['#attributes.fuseaction#']['copy']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['copy']['fuseaction'] = 'account.popup_add_bill_cash2cash_copy';
		WOStruct['#attributes.fuseaction#']['copy']['filePath'] = 'V16/account/form/add_bill_cash2cash.cfm';
		WOStruct['#attributes.fuseaction#']['copy']['queryPath'] = 'V16/account/query/add_bill_cash2cash.cfm';
		WOStruct['#attributes.fuseaction#']['copy']['nextEvent'] = 'account.form_add_bill_cash2cash&event=upd&card_id=';

		if(isdefined("attributes.card_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'account.popup_upd_bill_cash2cash';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/account/form/upd_bill_cash2cash.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/account/query/upd_bill_cash2cash.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.card_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'account.form_add_bill_cash2cash&event=upd&card_id=';

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'account.del_card&card_id=#attributes.card_id#&from_controller=1';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/account/query/del_card.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/account/query/del_card.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'account.list_cards';
		}
	}
	else{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		if(caller.attributes.event is 'add' or caller.attributes.event is 'copy' )
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=account.list_cards";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
		}
		if(caller.attributes.event is 'upd')
		{			
			get_account_card = caller.get_account_card;
			link_str = caller.link_str;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();

			if(not (len(caller.GET_ACCOUNT_CARD.ACTION_ID) and caller.CONTROL_ACC_UPDATE.IS_ACCOUNT_CARD_UPDATE eq 0))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=account.list_cards";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=account.form_add_bill_cash2cash";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.card_id#&print_type=290','woc')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['target'] = "_blank";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=account.form_add_bill_cash2cash&event=copy&card_id=#attributes.card_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";

			
			i = 0;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			if(isdefined('link_str') and len(link_str) and len(get_account_card.action_cat_id) and get_account_card.action_id neq 0){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text']="#getLang('account',199)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href']="#link_str##GET_ACCOUNT_CARD.ACTION_ID#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target']="_blank";
				i = i + 1;
			}else if(listfind('31',get_account_card.action_type,',')){
				get_order_id = caller.get_order_id;
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text']="#getLang('main',35)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href']="#request.self#?fuseaction=sales.upd_fast_sale&order_id=#get_order_id.order_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target']="_invoice_window";
				i = i + 1;
			}else if(listfind('241',get_account_card.action_type,',')){
				get_order_id = caller.get_order_id;
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text']="#getLang('main',35)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href']="#request.self#?fuseaction=sales.upd_fast_sale&order_id=#get_order_id.order_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target']="_invoice_window";
				i = i + 1;
			}else if(listfind('97',get_account_card.action_type,',')){
				get_order_id = caller.get_order_id;
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text']="#getLang('main',35)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href']="#request.self#?fuseaction=sales.upd_fast_sale&order_id=#get_order_id.order_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target']="_invoice_window";
				i = i + 1;
			}else if(listfind('90',get_account_card.action_type,',')){
				get_order_id = caller.get_order_id;
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text']="#getLang('main',35)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href']="#request.self#?fuseaction=sales.upd_fast_sale&order_id=#get_order_id.order_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target']="_invoice_window";
				i = i + 1;
			}else if(listfind('1043,1044',get_account_card.action_type,',')){
				get_cheque_id = caller.get_cheque_id;
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text']="#getLang('account',199)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick']="windowopen('#request.self#?fuseaction=cheque.popup_view_cheque_detail&id=#get_cheque_id.cheque_id#','horizantal')";
				
				i = i + 1;
			}else if(get_account_card.action_type eq 1046){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text']="#getLang('account',199)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick']="windowopen('#request.self#?fuseaction=cheque.popup_view_cheque_detail&id=#get_account_card.action_id#','horizantal')";
				
				i = i + 1;
			}else if(listfind('1053,1054',get_account_card.action_type,',')){
				get_voucher_id = caller.get_voucher_id;
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text']="#getLang('account',199)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick']="windowopen('#request.self#?fuseaction=cheque.popup_view_voucher_detail&id=#get_voucher_id.voucher_id#','horizantal')";
				
				i = i + 1;
			}else if(listfind('8110',get_account_card.action_type,',')){
				get_ship_id = caller.get_ship_id;
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text']="#getLang('main',35)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target']="_invoice_window";
				
				i = i + 1;
			}else if(get_account_card.action_type eq 1056){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text']="#getLang('account',199)#";
				
				i = i + 1;
			}
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'ACCOUNT_CARD';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CARD_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-process_date']";

</cfscript>
