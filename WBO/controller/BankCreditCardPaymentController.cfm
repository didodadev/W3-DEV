
<cfscript>
	// Switch //
	if(attributes.tabMenuController eq 0)
	{	
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.list_credit_card_expense';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/bank/display/list_credit_card_expense.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.popup_add_creditcard_bank_expense';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/bank/form/add_creditcard_bank_expense.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/bank/query/add_creditcard_bank_expense.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.list_credit_card_expense&event=upd';
		
		WOStruct['#attributes.fuseaction#']['addDebit'] = structNew();
		WOStruct['#attributes.fuseaction#']['addDebit']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['addDebit']['fuseaction'] = 'bank.popup_add_cc_debit_payment';
		WOStruct['#attributes.fuseaction#']['addDebit']['filePath'] = '/V16/bank/form/add_cc_debit_payment.cfm';
		WOStruct['#attributes.fuseaction#']['addDebit']['queryPath'] = '/V16/bank/query/add_cc_debit_payment.cfm';
		WOStruct['#attributes.fuseaction#']['addDebit']['nextEvent'] = 'bank.list_credit_card_expense&event=upd';
		
	

		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'bank.popup_upd_creditcard_bank_expense';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/bank/form/upd_creditcard_bank_expense.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/bank/query/upd_creditcard_bank_expense.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'bank.list_credit_card_expense&event=upd';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
			
			WOStruct['#attributes.fuseaction#']['updDebit'] = structNew();
			WOStruct['#attributes.fuseaction#']['updDebit']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['updDebit']['fuseaction'] = 'bank.list_credit_card_expense';
			WOStruct['#attributes.fuseaction#']['updDebit']['filePath'] = '/V16/bank/form/upd_cc_debit_payment.cfm';
			WOStruct['#attributes.fuseaction#']['updDebit']['queryPath'] = '/V16/bank/form/upd_cc_debit_payment.cfm';
			WOStruct['#attributes.fuseaction#']['updDebit']['Identity'] = '##attributes.id##';
			WOStruct['#attributes.fuseaction#']['updDebit']['nextEvent'] = 'bank.list_credit_card_expense&event=upd';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=bank.emptypopup_del_creditcard_bank_expense&id=#attributes.id#&comp=##caller.attributes.comp_name##&old_process_type=##caller.get_expense.process_type##&active_period=##caller.GET_EXPENSE.ACTION_PERIOD_ID##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/bank/query/del_creditcard_bank_expense.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/V16/bank/query/del_creditcard_bank_expense.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_credit_card_expense';
		}
	}	
	else
	{
		
		getLang = caller.getLang;
		tabMenuStruct = StructNew();
		tabMenuStruct['#attributes.fuseaction#'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'add')
		{			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_credit_card_expense";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'addDebit')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addDebit'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addDebit']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addDebit']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addDebit']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addDebit']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_bank_actions";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addDebit']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addDebit']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			GET_EXPENSE = caller.GET_EXPENSE;
			CONTROL_RETURN = CALLER.CONTROL_RETURN;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['onClick'] ="window.location.href='#request.self#?fuseaction=bank.list_credit_card_expense&event=add';";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=153&action_type=#GET_EXPENSE.PROCESS_TYPE#','woc')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_credit_card_expense";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['href'] = '#request.self#?fuseaction=objects.workflowpages&tab=3&action=myhome.my_extre&action_name=id&action_id=#attributes.id#';

														


			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#getlang('main',1966)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customtag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='19' action_section='CREDITCARD_EXPENSE_ID' action_id='#attributes.id#'>";
		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#getlang('main',1040)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#GET_EXPENSE.CREDITCARD_EXPENSE_ID#&process_cat=#GET_EXPENSE.PROCESS_TYPE#&period_id=#GET_EXPENSE.ACTION_PERIOD_ID#','page','upd_cc_revenue')";	
		
			if(len(CONTROL_RETURN.CC_BANK_EXPENSE_ROWS_ID) and CONTROL_RETURN.CC_BANK_EXPENSE_ROWS_ID neq 0){
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#getlang('main',1621,'iade')# #getlang('main',1040,'mahsup fişi')#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#CONTROL_RETURN.CC_BANK_EXPENSE_ROWS_ID#&process_cat=249&period_id=#GET_EXPENSE.ACTION_PERIOD_ID#','page','upd_cc_revenue')";	
				}
											
		}
		else if(isdefined("attributes.event") and attributes.event is 'updDebit')
		{
			get_action_detail = caller.get_action_detail;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updDebit'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updDebit']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updDebit']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updDebit']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=156&action_type=#get_action_detail.action_type_id#','page');";
						
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updDebit']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updDebit']['menus'][0]['text'] = '#getlang('main',1040)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updDebit']['menus'][0]['id'] = 'open_page_1';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['updDebit']['menus'][0]['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_action_detail.action_type_id#','page','upd_gelenh');";	
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,addDebit,updDebit';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CREDIT_CARD_BANK_EXPENSE';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CREDITCARD_EXPENSE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-our_credit_cards','item-process_cat','item-comp_name','item-action_date','item-credit_card','item-start_date','item-action_value']";		
</cfscript>