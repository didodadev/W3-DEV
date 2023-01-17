<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cheque.form_add_payroll_entry';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/cheque/form/add_payroll_entry.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/cheque/query/add_payroll_entry.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cheque.form_add_payroll_entry&event=upd&id=';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('payroll_entry','payroll_entry_bask');";
		WOStruct['#attributes.fuseaction#']['add']['formName'] = "form_payroll_basket";
		
		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cheque.form_upd_payroll_entry';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/cheque/form/upd_payroll_entry.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/cheque/query/upd_payroll_entry.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cheque.form_add_payroll_entry&event=upd&id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('payroll_entry','payroll_entry_bask');";
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.del_payroll&id=#attributes.id#&head=##caller.get_action_detail.PAYROLL_NO##&cheque_base_acc=##caller.get_action_detail.CHEQUE_BASED_ACC_CARI##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/cheque/query/del_payroll.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/cheque/query/del_payroll.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cheque.list_cheque_actions';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=cheque.list_cheque_actions";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['text'] = '#getLang('','CSV Import',59030)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['onClick'] = "open_file();";
		}
		else if(caller.attributes.event is 'upd')
		{
			get_action_detail = caller.GET_ACTION_DETAIL;
			
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=cheque.form_add_payroll_entry";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=cheque.list_cheque_actions";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['href'] = '#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=111';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=id&action_id=#attributes.id#','Workflow')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['icn-md wrk-uF0134']['text'] = '#getLang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['icn-md wrk-uF0134']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&payroll_id=#url.id#&action_id=#attributes.id#&process_cat=#get_action_detail.PAYROLL_TYPE#','wide');";
		
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['archive']['text'] = '#getLang('main',1966)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['archive']['customTag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='21' action_section='PAYROLL' action_id='#url.id#'>";
			
			

			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PAYROLL';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACTION_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-company_name','item-REVENUE_COLLECTOR','item-payroll_revenue_date']";
</cfscript>

