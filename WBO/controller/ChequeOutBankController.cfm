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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'cheque.list_cheque_actions';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/cheque/display/list_cheque_actions.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cheque.form_add_payroll_bank_guaranty';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/cheque/form/add_payroll_bank_guaranty.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/cheque/query/add_payroll_bank_guaranty.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cheque.form_add_payroll_bank_guaranty&event=upd&ID=';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('payroll_bank_quaranty','payroll_bank_quaranty_bask');";
				
		if(isdefined("attributes.id"))				
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cheque.form_upd_payroll_bank_guaranty';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/cheque/form/upd_payroll_bank_guaranty.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/cheque/query/upd_payroll_bank_guaranty.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cheque.form_add_payroll_bank_guaranty&event=upd&ID=';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';	
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('payroll_bank_quaranty','payroll_bank_quaranty_bask');";
		
			if(listFind('upd,del',attributes.event))
				{
					WOStruct['#attributes.fuseaction#']['del'] = structNew();
					WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
					WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.del_payroll&id=#attributes.id#&head=##caller.get_action_detail.PAYROLL_NO##';
					WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/cheque/query/del_payroll.cfm';
					WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/cheque/query/del_payroll.cfm';
					WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cheque.list_cheque_actions';
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
		
		if(attributes.event is 'add')
		{	
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['text'] = 'CSV İmport';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['onClick'] = "open_file();";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = "#getLang('main',97)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=cheque.list_cheque_actions";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = "#getLang('main',49)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		if(attributes.event is 'upd')
		{
			get_action_detail=caller.get_action_detail;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = "#getLang('main',170)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onclick'] = "windowopen('#request.self#?fuseaction=cheque.form_add_payroll_bank_guaranty','project');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = "#getLang('main',97)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=cheque.list_cheque_actions";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = "#getLang('main',49)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = "#getLang('main',62)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=112','page');";
			
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['icn-md wrk-uF0134']['text']= "#getLang('main',1040)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['icn-md wrk-uF0134']['onClick']  = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&payroll_id=#url.id#&action_id=#attributes.id#&process_cat=#get_action_detail.PAYROLL_TYPE#','wide');";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['archive']['archieve'] = "#getLang('main',1966)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['archive']['customTag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='21' action_section='PAYROLL' action_id='#url.id#'>";
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,del';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CHEQUE_HISTORY';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CHEQUE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-payroll_account_id','item-EMPLOYEE_ID','item-payroll_revenue_date','item-expense_center','item-exp_item_id']";

</cfscript>

