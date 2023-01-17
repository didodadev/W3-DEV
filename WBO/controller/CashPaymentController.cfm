<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
			
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'cash.list_cash_actions';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/cash/display/list_cash_actions.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] ='cash.form_add_cash_payment';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/cash/form/add_cash_payment.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/cash/query/add_cash_payment.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cash.form_add_cash_payment&event=upd&id=';

		WOStruct['#attributes.fuseaction#']['popupAdd'] = structNew();
		WOStruct['#attributes.fuseaction#']['popupAdd']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['popupAdd']['fuseaction'] ='cash.popup_add_cash_payment';
		WOStruct['#attributes.fuseaction#']['popupAdd']['filePath'] = 'V16/cash/form/add_cash_payment.cfm';
		WOStruct['#attributes.fuseaction#']['popupAdd']['queryPath'] = 'V16/cash/query/add_cash_payment.cfm';
		WOStruct['#attributes.fuseaction#']['popupAdd']['nextEvent'] = 'cash.form_add_cash_payment&event=upd&id=';
		
		WOStruct['#attributes.fuseaction#']['addMulti'] = structNew();
		WOStruct['#attributes.fuseaction#']['addMulti']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['addMulti']['fuseaction'] ='cash.add_collacted_payment';
		WOStruct['#attributes.fuseaction#']['addMulti']['filePath'] = 'V16/cash/form/add_collacted_payment.cfm';
		WOStruct['#attributes.fuseaction#']['addMulti']['queryPath'] = 'V16/cash/query/add_collacted_payment.cfm';
		WOStruct['#attributes.fuseaction#']['addMulti']['nextEvent'] = 'cash.form_add_cash_payment&event=updMulti&multi_id=';
		WOStruct['#attributes.fuseaction#']['addMulti']['js'] = "javascript:gizle_goster_ikili('collacted_payment','collacted_payment_bask');";
		
		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cash.popup_upd_cash_payment';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/cash/form/upd_cash_payment.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/cash/query/upd_cash_payment.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cash.form_add_cash_payment&event=upd&id=';
			
			if(attributes.event is 'upd')
			{
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.del_cash_payment&id=#attributes.id#&old_process_type=##caller.get_action_detail.action_type_id##';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/cash/query/del_cash_payment.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/cash/query/del_cash_payment.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cash.list_cash_actions';
			}
		}
		if(isdefined("attributes.multi_id"))
		{
			WOStruct['#attributes.fuseaction#']['updMulti'] = structNew();
			WOStruct['#attributes.fuseaction#']['updMulti']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['updMulti']['fuseaction'] = 'cash.upd_collacted_payment';
			WOStruct['#attributes.fuseaction#']['updMulti']['filePath'] = '/V16/cash/form/upd_collacted_payment.cfm';
			WOStruct['#attributes.fuseaction#']['updMulti']['queryPath'] = '/V16/cash/query/upd_collacted_payment.cfm';
			WOStruct['#attributes.fuseaction#']['updMulti']['Identity'] = '#attributes.multi_id#';
			WOStruct['#attributes.fuseaction#']['updMulti']['nextEvent'] = 'cash.form_add_cash_payment&event=updMulti&multi_id=';
			WOStruct['#attributes.fuseaction#']['updMulti']['js'] = "javascript:gizle_goster_ikili('collacted_payment','collacted_payment_bask');";
			
			if(ListFind('updMulti,delMulti',attributes.event))
			{
				WOStruct['#attributes.fuseaction#']['delMulti'] = structNew();
				WOStruct['#attributes.fuseaction#']['delMulti']['window'] = 'emptypopup';
				if(isdefined("attributes.puantaj_id") and len(attributes.puantaj_id) and dsn2 eq new_dsn2)
					WOStruct['#attributes.fuseaction#']['delMulti']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_collacted_action&is_virtual=#attributes.is_virtual_puantaj#&puantaj_id=#attributes.puantaj_id#&multi_id=#attributes.multi_id#&old_process_type=320';
				else if(not (isdefined("attributes.puantaj_id") and len(attributes.puantaj_id)))
					WOStruct['#attributes.fuseaction#']['delMulti']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_collacted_action&multi_id=#attributes.multi_id#&old_process_type=320';
				WOStruct['#attributes.fuseaction#']['delMulti']['filePath'] = 'V16/cash/query/del_collacted_action.cfm';
				WOStruct['#attributes.fuseaction#']['delMulti']['queryPath'] = 'V16/cash/query/del_collacted_action.cfm';
				WOStruct['#attributes.fuseaction#']['delMulti']['nextEvent'] = 'cash.list_cash_actions';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=cash.list_cash_actions";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['text'] = '#getLang('main',2532)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=cash.form_add_cash_payment&event=addMulti";
		}
		else if(caller.attributes.event is 'upd')
		{
			get_action_detail=caller.get_action_detail;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=cash.form_add_cash_payment&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=cash.list_cash_actions";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#url.id#&print_type=132','woc');";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=#listGetAt(attributes.fuseaction,1,'.')#.form_add_cash_payment&event=add&id=#attributes.id#";
		
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('main',1542)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_action_detail.action_type_id#','list','upd_cash_payment');";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['text'] = '#getLang('main',1966)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['customTag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='18' action_section='ACTION_ID' action_id='#attributes.id#'>";			

		}
		else if(caller.attributes.event is 'addMulti')
		{	
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['file-text']['text'] = '#getLang('main',2576)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['file-text']['onClick'] = "open_file();";	
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['list-ul']['href'] = "#request.self#?fuseaction=cash.list_cash_actions";			
		}
		else if(caller.attributes.event is 'updMulti')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['list-ul']['href'] = "#request.self#?fuseaction=cash.list_cash_actions";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			if(not (isdefined("attributes.puantaj_id") and len(attributes.puantaj_id)))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['add']['text'] = '#getLang('main',170)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['add']['href'] = "#request.self#?fuseaction=cash.form_add_cash_payment&event=addMulti";
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['add']['target'] = "_blank";
					
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['print']['text'] = '#getLang('main',62)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.multi_id#&keyword=multi_payment&print_type=132','woc');";
				
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['copy']['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['copy']['text'] = '#getLang('main',64)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['copy']['href'] = "#request.self#?fuseaction=#listGetAt(attributes.fuseaction,1,'.')#.form_add_cash_payment&event=addMulti&multi_id=#attributes.multi_id#";
	
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['menus'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['menus'][0]['text'] = '#getLang('main',1966)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['menus'][0]['customTag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='18' action_section='ACTION_ID' action_id='#attributes.multi_id#'>";			
				
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['menus'][1]['text'] = '#getLang('main',1542)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['menus'][1]['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.multi_id#&process_cat=320','page','add_process');";
			}
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CASH_ACTIONS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACTION_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-CASH_ACTION_FROM_CASH_ID','item-CASH_ACTION_TO_COMPANY_ID','item-action_date','item-paper_number','item-cash_action_value','item-other_cash_act_value','item-PAYER_ID']";

	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'addMulti,updMulti';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CASH_ACTIONS_MULTI';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'MULTI_ACTION_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-cash_action_to_cash_id','item-action_date']";
	
</cfscript>