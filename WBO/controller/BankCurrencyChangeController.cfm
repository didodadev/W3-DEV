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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.form_add_virman';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/bank/form/add_virman.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/bank/query/add_virman.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.form_add_virman&event=upd&id=';
		
		WOStruct['#attributes.fuseaction#']['addMulti'] = structNew();
		WOStruct['#attributes.fuseaction#']['addMulti']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['addMulti']['fuseaction'] ='bank.add_collacted_virman';
		WOStruct['#attributes.fuseaction#']['addMulti']['filePath'] = 'V16/bank/form/add_collacted_virman.cfm';
		WOStruct['#attributes.fuseaction#']['addMulti']['queryPath'] = 'V16/bank/query/add_collacted_virman.cfm';
		WOStruct['#attributes.fuseaction#']['addMulti']['nextEvent'] = 'bank.form_add_virman&event=updMulti&multi_id=';
		WOStruct['#attributes.fuseaction#']['addMulti']['js'] = "javascript:gizle_goster_ikili('collacted_virman','collacted_virman_sepet');";
		
		if(isdefined("attributes.id") or isdefined("attributes.ids"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'bank.form_upd_virman';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/bank/form/upd_virman.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/bank/query/upd_virman.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'bank.form_add_virman&event=upd&id=';
			
			if(listfind('upd,del',attributes.event))
			{
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
				if(isdefined("attributes.id"))
					WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_virman&ids=#attributes.id#,#attributes.id+1#&head=##caller.get_action_detail.paper_no##&old_process_type=##caller.get_action_detail.action_type_id####caller.url_link##';
				else
					WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_virman&ids=#attributes.ids#&head=##caller.get_action_detail.paper_no##&old_process_type=##caller.get_action_detail.action_type_id####caller.url_link##';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/bank/query/del_virman.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/bank/query/del_virman.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_bank_actions';
			}
		}
		if(isdefined("attributes.multi_id"))
		{
			WOStruct['#attributes.fuseaction#']['updMulti'] = structNew();
			WOStruct['#attributes.fuseaction#']['updMulti']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['updMulti']['fuseaction'] = 'bank.upd_collacted_virman';
			WOStruct['#attributes.fuseaction#']['updMulti']['filePath'] = '/V16/bank/form/upd_collacted_virman.cfm';
			WOStruct['#attributes.fuseaction#']['updMulti']['queryPath'] = '/V16/bank/query/upd_collacted_virman.cfm';
			WOStruct['#attributes.fuseaction#']['updMulti']['Identity'] = '#attributes.multi_id#';
			WOStruct['#attributes.fuseaction#']['updMulti']['nextEvent'] = 'bank.form_add_virman&event=updMulti&multi_id=';
			WOStruct['#attributes.fuseaction#']['updMulti']['js'] = "javascript:gizle_goster_ikili('collacted_virman','collacted_virman_sepet');";
			
			if(ListFind('updMulti,delMulti',attributes.event))
			{
				WOStruct['#attributes.fuseaction#']['delMulti'] = structNew();
				WOStruct['#attributes.fuseaction#']['delMulti']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['delMulti']['fuseaction'] = '#request.self#?fuseaction=bank.emptypopup_del_collacted_action&multi_id=#attributes.multi_id#&old_process_type=##caller.get_action_detail.action_type_id##&active_period=#session.ep.period_id#';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_bank_actions";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";

			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['text'] = '#getLang('main',2085)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=bank.form_add_virman&event=addMulti";
		}
		else if(caller.attributes.event is 'addMulti')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_bank_actions";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			get_action_detail = caller.get_action_detail;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getlang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_action_detail.action_type_id#','page','upd_virman');";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['text'] = '#getLang('main',1966)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['customTag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='19' action_section='BANK_ACTION_ID' action_id='#attributes.id#'>";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=bank.form_add_virman";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_bank_actions";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_virman&ID=#get_action_detail.action_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=155','page')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['target'] = "_blank";			
		}
		else if(caller.attributes.event is 'updMulti')
		{
			get_action_detail = caller.get_action_detail;
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_bank_actions";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['add']['href'] = "#request.self#?fuseaction=bank.form_add_virman&event=addMulti";
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['add']['target'] = "_blank";
							
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['menus'][0]['text'] = '#getLang('main',1966)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['menus'][0]['customTag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='19' action_section='BANK_MULTI_ACTION_ID' action_id='#attributes.multi_id#'>";			
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['menus'][1]['text'] = '#getLang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['menus'][1]['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.multi_id#&process_cat=230','page','add_process');";
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	if(not attributes.event contains 'Multi')
	{
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ACTIONS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACTION_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-from_account_id','item-to_account_id','item-ACTION_DATE','item-ACTION_VALUE']";
	}
	else
	{
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'addMulti,updMulti';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ACTIONS_MULTI';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'MULTI_ACTION_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-action_date']";
	}
</cfscript>