<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];

		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'health.expenses';
		WOStruct['#attributes.fuseaction#']['list']['xmlfuseaction'] = 'cost.list_expense_income';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/cost/display/list_expense_income.cfm';	
		WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/cost/display/list_expense_income.cfm';	
		WOStruct['#attributes.fuseaction#']['list']['js'] = "javascript:gizle_goster_ikili('add_cost','list_plan_rows_cost_div');basket_set_height_list_plan_rows_cost_div();";		
	
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'objects.form_add_expense_cost';
		WOStruct['#attributes.fuseaction#']['add']['xmlfuseaction'] = 'health.expenses';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/objects/form/form_add_expense_cost.cfm';	
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/objects/query/add_collacted_expense_cost.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'health.expenses&event=upd&expense_id=';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('add_cost','list_plan_rows_cost_div');basket_set_height_list_plan_rows_cost_div();";		
		
		if(isdefined("attributes.expense_id") and listFind('upd,del',attributes.event))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'objects.form_upd_expense_cost';
			WOStruct['#attributes.fuseaction#']['upd']['xmlfuseaction'] = 'health.expenses';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/objects/form/form_upd_expense_cost.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/objects/query/upd_collacted_expense_cost.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.expense_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'health.expenses&event=upd&expense_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('upd_cost','upd_cost_bask');basket_set_height_upd_cost_bask();";
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=cost.emptypopup_del_collacted_expense_cost&expense_id=#attributes.expense_id#&process_cat=##caller.get_expense.process_cat##&head=##caller.get_expense.paper_no##&active_period=#session.ep.period_id#&is_from_credit=##caller.is_from_credit##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/objects/query/del_collacted_expense_cost.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/objects/query/del_collacted_expense_cost.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'health.expenses';
		}
		
	}else{
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=health.expenses";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			/* tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['text'] = '#getLang('main',2758)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['onClick'] = "open_file();"; */
			
		}
		else if(caller.attributes.event is 'upd')
		{
			get_efatura_det = caller.get_efatura_det;
			get_expense = caller.get_expense;
			denied_pages = caller.denied_pages;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=health.expenses&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=health.expenses&event=add&expense_id=#attributes.expense_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['href'] = "#request.self#?fuseaction=objects.workflowpages&tab=3&action=cost.form_upd_expense_cost&action_name=expense_id&action_id=#attributes.expense_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=health.expenses";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#expense_id#&print_type=230','page','workcube_print');";
			
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			
			i=0;
			if(get_efatura_det.recordcount)
			{	
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',2075)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_dsp_efatura_detail&receiving_detail_id=#get_efatura_det.receiving_detail_id#&type=1','wwide');";
				i = i + 1;
			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('objects',1744)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['customtag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='49' action_section='EXPENSE_ID' action_id='#attributes.expense_id#'>";
			i = i + 1;
			
			if(listfindnocase(denied_pages, 'invoice.popup_form_add_info-plus')){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',398)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.expense_id#&type_id=-17','list');";
				i = i + 1;
			}
			
			if(len(get_expense.ch_company_id)){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',397)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=ch.list_company_extre&popup_page=1&member_type=partner&member_id=#get_expense.ch_company_id#','wwide1','popup_list_comp_extre')";
				i = i + 1;
			}
			
			else if(len(get_expense.ch_consumer_id)){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',397)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=consumer&member_id=#get_expense.ch_consumer_id#','wwide1','popup_list_comp_extre');";
				i = i + 1;
			}
			
			else if(len(get_expense.ch_employee_id)){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',397)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=employee&member_id=#get_expense.ch_employee_id#','wwide1','popup_list_comp_extre');";
				i = i + 1;
			}
			
			if(len(get_expense.paymethod_id) and not listfindnocase(denied_pages, 'objects.popup_payment_with_voucher')){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('objects',109)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "send_popup_voucher();";
				i = i + 1;
			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('objects',509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&expense_id=#attributes.expense_id#&is_health=1','page','upd_bill');";
			i = i + 1;
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EXPENSE_ITEM_PLANS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'EXPENSE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-serial_number','item-expense_date']";
</cfscript>