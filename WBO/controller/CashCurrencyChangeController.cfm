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
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cash.form_add_cash_to_cash';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/cash/form/add_cash_to_cash.cfm';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/cash/query/add_cash_to_cash.cfm';
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cash.form_add_cash_to_cash&event=upd&id=';
			
			if(isdefined("attributes.id") or isdefined("attributes.ids"))
			{
				WOStruct['#attributes.fuseaction#']['upd'] = structNew();
				WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
				WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cash.form_upd_cash_to_cash';
				WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/cash/form/upd_cash_to_cash.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/cash/query/upd_cash_to_cash.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cash.form_add_cash_to_cash&event=upd&id=';
				if(listfind('upd,del',attributes.event))
				{
					WOStruct['#attributes.fuseaction#']['del'] = structNew();
					WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
					if(isdefined("attributes.id"))
						WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_cash_to_cash&ids=#attributes.id#,#attributes.id+1#&paper_number=##caller.get_action_detail.paper_no##&old_process_type=##caller.get_action_detail.action_type_id##';
					else
						WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_cash_to_cash&ids=#attributes.ids#&paper_number=##caller.get_action_detail.paper_no##&old_process_type=##caller.get_action_detail.action_type_id##';
					WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/cash/query/del_cash_to_cash.cfm';
					WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/cash/query/del_cash_to_cash.cfm';
					WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cash.list_cash_actions';
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
			}
			else if(caller.attributes.event is 'upd')
			{
				get_action_detail=caller.GET_ACTION_DETAIL;
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=cash.form_add_cash_to_cash&event=add";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=cash.list_cash_actions";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=130','page')";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['target'] = "_blank";		
				
				
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
		
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('main',1040)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_action_detail.action_type_id#','page','upd_cash_to_cash');";// Uyarılar
				
				
			}
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);	
		}
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CASH_ACTIONS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACTION_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-from_cash_id','item-to_cash_id','item-action_date','item-cash_action_value']";
</cfscript>