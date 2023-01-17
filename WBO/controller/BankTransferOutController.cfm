<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
			
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.list_bank_actions';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/bank/display/list_bank_actions.cfm';
		
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.form_add_gidenh';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/bank/form/add_gidenh.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/bank/query/add_gidenh.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.form_add_gidenh&event=upd&id=';
		
		WOStruct['#attributes.fuseaction#']['addMulti'] = structNew();
		WOStruct['#attributes.fuseaction#']['addMulti']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['addMulti']['fuseaction'] ='bank.add_collacted_gidenh';
		WOStruct['#attributes.fuseaction#']['addMulti']['filePath'] = 'V16/bank/form/add_collacted_gidenh.cfm';
		WOStruct['#attributes.fuseaction#']['addMulti']['queryPath'] = 'V16/bank/query/add_collacted_gidenh.cfm';
		WOStruct['#attributes.fuseaction#']['addMulti']['nextEvent'] = 'bank.form_add_gidenh&event=updMulti&multi_id=';
		WOStruct['#attributes.fuseaction#']['addMulti']['js'] = "javascript:gizle_goster_ikili('collacted_gidenh','collacted_payment_bask');";
		
		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'bank.popup_upd_gidenh';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/bank/form/upd_gidenh.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/bank/query/upd_gidenh.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'bank.form_add_gidenh&event=upd&id=';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';	
			
			if(listFind('upd,del',attributes.event))
			{
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.del_gidenh&id=#attributes.id#&head=##caller.get_action_detail.paper_no##&old_process_type=##caller.get_action_detail.action_type_id##';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/bank/query/del_gidenh.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/bank/query/del_gidenh.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_bank_actions';
			}
		}
		if(isdefined("attributes.multi_id"))
		{
			WOStruct['#attributes.fuseaction#']['updMulti'] = structNew();
			WOStruct['#attributes.fuseaction#']['updMulti']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['updMulti']['fuseaction'] = 'bank.upd_collacted_gidenh';
			WOStruct['#attributes.fuseaction#']['updMulti']['filePath'] = '/V16/bank/form/upd_collacted_gidenh.cfm';
			WOStruct['#attributes.fuseaction#']['updMulti']['queryPath'] = '/V16/bank/query/upd_collacted_gidenh.cfm';
			WOStruct['#attributes.fuseaction#']['updMulti']['Identity'] = '#attributes.multi_id#';
			WOStruct['#attributes.fuseaction#']['updMulti']['nextEvent'] = 'bank.form_add_gidenh&event=updMulti&multi_id=';
			WOStruct['#attributes.fuseaction#']['updMulti']['js'] = "javascript:gizle_goster_ikili('collacted_gidenh','collacted_payment_bask');";
			
			if(ListFind('updMulti,delMulti',attributes.event) and not(session.ep.our_company_info.is_paper_closer eq 1 and isdefined("get_closed") and get_closed.recordcount neq 0))
			{
				if(not isdefined("caller.attributes.new_dsn2"))
					new_dsn2 = dsn2;
				else
					new_dsn2 = '##caller.attributes.new_dsn2##';
				WOStruct['#attributes.fuseaction#']['delMulti'] = structNew();
				WOStruct['#attributes.fuseaction#']['delMulti']['window'] = 'emptypopup';
				if(isdefined("attributes.puantaj_id") and len(attributes.puantaj_id) and dsn2 eq new_dsn2)
					WOStruct['#attributes.fuseaction#']['delMulti']['fuseaction'] = '#request.self#?fuseaction=bank.del_collacted_action&is_virtual=##caller.attributes.is_virtual_puantaj##&puantaj_id=##caller.attributes.puantaj_id##&multi_id=##caller.attributes.multi_id##&old_process_type=##caller.get_action_detail.action_type_id##&active_period=#session.ep.period_id#';
				else if(not (isdefined("attributes.puantaj_id") and len(attributes.puantaj_id)))
					WOStruct['#attributes.fuseaction#']['delMulti']['fuseaction'] = '#request.self#?fuseaction=bank.del_collacted_action&multi_id=##caller.attributes.multi_id##&old_process_type=##caller.get_action_detail.action_type_id##&active_period=#session.ep.period_id#';
				WOStruct['#attributes.fuseaction#']['delMulti']['filePath'] = 'V16/bank/query/del_collacted_action.cfm';
				WOStruct['#attributes.fuseaction#']['delMulti']['queryPath'] = 'V16/bank/query/del_collacted_action.cfm';
				WOStruct['#attributes.fuseaction#']['delMulti']['nextEvent'] = 'bank.list_bank_actions';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_bank_actions";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['text'] = '#getLang('main',1758)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=bank.form_add_gidenh&event=addMulti";
		}
		else if(caller.attributes.event is 'addMulti')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_bank_actions";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['fa fa-download']['text'] = '#getLang('main',2576)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['fa fa-download']['onClick'] = "cfmodal('#request.self#?fuseaction=objects.popup_add_collacted_from_file&type=3','warning_modal')";			
		}
		else if(caller.attributes.event is 'upd')
		{
			get_action_detail = caller.get_action_detail;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_action_detail.action_type_id#','page','upd_gidenh');";// Belgeler
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['text'] = '#getLang('main',1966)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['customTag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='19' action_section='BANK_ACTION_ID' action_id='#attributes.id#'>";
			
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=bank.form_add_gidenh";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=bank.form_add_gidenh&id=#attributes.id#";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_bank_actions";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&action_type=#get_action_detail.action_type_id#','page');";
			
		}
		else if(caller.attributes.event is 'updMulti')
		{
			get_action_detail = caller.get_action_detail;
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_bank_actions";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			if(not (isdefined("attributes.puantaj_id") and len(attributes.puantaj_id)))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['add']['text'] = '#getLang('main',170)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['add']['href'] = "#request.self#?fuseaction=bank.form_add_gidenh&event=addMulti";
					
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['print']['text'] = '#getLang('main',62)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.multi_id#&action_type=#get_action_detail.action_type_id#&keyword=multi','page');";
				
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['copy']['text'] = '#getLang('main',64)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['copy']['href'] = "#request.self#?fuseaction=#listGetAt(attributes.fuseaction,1,'.')#.form_add_gidenh&event=addMulti&multi_id=#attributes.multi_id#";
	
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['menus'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['archive']['text'] = '#getLang('main',1966)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['archive']['customTag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='19' action_section='BANK_MULTI_ACTION_ID' action_id='#attributes.multi_id#'>";			
				
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['fa fa-table']['text'] = '#getLang('main',1040)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['fa fa-table']['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.multi_id#&process_cat=250','page','add_process');";
			}
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	if(attributes.event contains "Multi")
	{
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'addMulti,updMulti';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ACTIONS_MULTI';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'MULTI_ACTION_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-to_account_id','item-action_date']";
	}
	else
	{
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ACTIONS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACTION_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-from_account_id','item-ACTION_TO_COMPANY_ID','item-ACTION_DATE','item-ACTION_VALUE','item-paper_number']";
	}
</cfscript>