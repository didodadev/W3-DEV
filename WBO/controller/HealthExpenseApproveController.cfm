<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['list']					= structNew();
		WOStruct['#attributes.fuseaction#']['list']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'hr.health_expense_approve';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/V16/myhome/display/list_health_expense.cfm';	
		WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/V16/myhome/display/list_health_expense.cfm';	
	
		WOStruct['#attributes.fuseaction#']['add']					= structNew();
		WOStruct['#attributes.fuseaction#']['add']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'hr.health_expense_approve';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= '/V16/myhome/form/add_health_expense_form.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath']		= '/V16/myhome/query/add_health_expense_form.cfm';
		WOStruct['#attributes.fuseaction#']['add']['Xmlfuseaction']	= 'hr.health_expense_form';

		WOStruct['#attributes.fuseaction#']['approve'] = structNew();
		WOStruct['#attributes.fuseaction#']['approve']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['approve']['fuseaction'] = 'hr.health_expense_approve';
		WOStruct['#attributes.fuseaction#']['approve']['filePath'] = '/V16/myhome/query/health_expense_approve.cfm';
        WOStruct['#attributes.fuseaction#']['approve']['nextEvent'] = '';
		
		if(isdefined("attributes.health_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd']					= structNew();
	  		WOStruct['#attributes.fuseaction#']['upd']['window']		= 'normal';
	  		WOStruct['#attributes.fuseaction#']['upd']['fuseaction']	= 'hr.health_expense_approve';
	  		WOStruct['#attributes.fuseaction#']['upd']['filePath']		= '/V16/myhome/form/upd_health_expense_form.cfm';
	  		WOStruct['#attributes.fuseaction#']['upd']['queryPath']		= '/V16/myhome/query/upd_health_expense_form.cfm';
	  		WOStruct['#attributes.fuseaction#']['upd']['nextEvent']		= 'hr.upd_health_expense_form&event=upd';			
			WOStruct['#attributes.fuseaction#']['upd']['Identity']		= '#attributes.health_id#'; 

			WOStruct['#attributes.fuseaction#']['del']					= structNew();
	  		WOStruct['#attributes.fuseaction#']['del']['window']		= 'emptypopup';
	  		WOStruct['#attributes.fuseaction#']['del']['fuseaction']	= 'hr.health_expense_approve';
	  		WOStruct['#attributes.fuseaction#']['del']['filePath']		= '/V16/myhome/query/upd_health_expense_form.cfm';
	  		WOStruct['#attributes.fuseaction#']['del']['queryPath']		= '/V16/myhome/query/upd_health_expense_form.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent']		= 'hr.upd_health_expense_form&event=upd';
		}
	
	}
	else {
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
        tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();

		if(caller.attributes.event is 'add')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.health_expense_approve";	
        }
        
		if(caller.attributes.event is 'upd')
		{
			get_expense = caller.get_expense;
			get_expense_invoice = caller.get_expense_invoice;
			health_invoice_control = caller.health_invoice_control;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.health_expense_approve&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.health_expense_approve";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-sitemap']['text'] = '#getLang(dictionary_id : 53382)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-sitemap']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_budget_transactions&action_id=#attributes.health_id#&action_table=EXPENSE_ITEM_PLAN_REQUESTS&is_income=0','medium');";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['text'] = '#getLang('main',803)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&health_id=#attributes.health_id#','page')";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main', 62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.health_id#&print_type=489','page','workcube_print')";
			
			if(len(get_expense.company_id) and get_expense_invoice.recordcount){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['file-text-o']['text'] = '#getLang('main', 2075)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['file-text-o']['href'] = "#request.self#?fuseaction=objects.popup_dsp_efatura_detail&type=1&receiving_detail_id=#get_expense_invoice.RECEIVING_DETAIL_ID#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['file-text-o']['target'] = "_blank";
			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=offer_id&action_id=#attributes.health_id#','WorkFlow')";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-calculator']['text'] = '#getlang('','Cari Extre',47101)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-calculator']['href'] = "#request.self#?fuseaction=ch.list_company_extre&member_type=employee&member_id=#get_expense.emp_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-calculator']['target'] ="_blank";

			if( len(get_expense.invoice_no) and len( get_expense.EXPENSE_ITEM_PLANS_ID ) ) {
				if( health_invoice_control.recordcount ) {
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-tags']['text'] = '#getLang('','', 34758)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-tags']['href'] = "#request.self#?fuseaction=invoice.list_conract_comparison&is_submitted=1&keyword=#get_expense.invoice_no#";
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-tags']['target'] ="_blank";
				}
				else {
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-tags']['text'] = '#getLang('','', 34758)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-tags']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.health_invoice_control&health_id=#attributes.health_id#')";
				}
			}
		}
	
		/*tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['MLM']['text'] = '#getLang('main',147)#';
		tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['MLM']['href'] = "#request.self#?fuseaction=hr.health_expense_approve";*/

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);		
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm']				= true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList']	= 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName']			= 'EXPENSE_ITEM_PLAN_REQUESTS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn']		= 'EXPENSE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings']				= "['item-expense_stage','item-expense_date']";
</cfscript>