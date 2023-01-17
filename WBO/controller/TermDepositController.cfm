<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();	
		WOStruct['#attributes.fuseaction#']['default'] = 'add';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.form_add_term_deposit';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/bank/form/add_term_deposit.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/bank/query/add_term_deposit.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.form_add_term_deposit&event=upd&id=';
		
		if(isdefined("attributes.event") and listFind('upd,yieldPayment',attributes.event))
		{
			
			WOStruct['#attributes.fuseaction#']['yieldPayment'] = structNew();
			WOStruct['#attributes.fuseaction#']['yieldPayment']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['yieldPayment']['fuseaction'] = 'bank.form_add_term_deposit';
			WOStruct['#attributes.fuseaction#']['yieldPayment']['filePath'] = '/V16/bank/form/popup_yieldPayment_interest_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['yieldPayment']['queryPath'] = '/V16/bank/query/popup_yieldPayment_interest_revenue.cfm';

			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'bank.form_add_term_deposit';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/bank/form/upd_term_deposit.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/bank/query/upd_term_deposit.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'bank.form_add_term_deposit&event=upd&id=';
		}
		
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'bank.form_add_term_deposit';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/bank/query/del_term_deposit.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/bank/query/del_term_deposit.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_bank_actions';
			
		
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.interest_revenue";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";

		}
		else if(caller.attributes.event is 'yieldPayment'){

			tabMenuStruct['#fuseactController#']['tabMenus']['yieldPayment']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['yieldPayment']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['yieldPayment']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.interest_revenue";

		}
		else if(caller.attributes.event is 'upd')
		{
			get_action_detail = caller.get_action_detail;
			i = 0;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			

			if( len(get_action_detail.BUDGET_PLAN_ID) ) {
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('budget',5)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=budget.list_plan_rows&event=upd&budget_plan_id=#get_action_detail.BUDGET_PLAN_ID#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank"; 

				i++;
			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',1966)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['customTag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='19' action_section='BANK_ACTION_ID' action_id='#attributes.id#'>";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=bank.form_add_term_deposit&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['text'] = '#getlang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_action_detail.action_type_id#','page','upd_term_deposit');";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_bank_actions";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_term_deposit&event=add&ID=#get_action_detail.action_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=155','page')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['target'] = "_blank";			
		}
	
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ACTIONS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACTION_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-from_account_id','item-to_account_id','item-ACTION_DATE','item-ACTION_VALUE']";
	
</cfscript>