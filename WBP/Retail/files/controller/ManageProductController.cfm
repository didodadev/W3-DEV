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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'retail.list_manage_products';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/WBP/Retail/files/display/list_manage_products.cfm';	
		WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/WBP/Retail/files/display/list_manage_products.cfm';	
	
		WOStruct['#attributes.fuseaction#']['add']					= structNew();
		WOStruct['#attributes.fuseaction#']['add']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'retail.list_manage_products';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= '/WBP/Retail/files/form/speed_manage_product_new.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath']		= '/WBP/Retail/files/query/speed_manage_product_new.cfm';
		WOStruct['#attributes.fuseaction#']['add']['Xmlfuseaction']	= 'product.list_product';

		WOStruct['#attributes.fuseaction#']['addTable']					= structNew();
		WOStruct['#attributes.fuseaction#']['addTable']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['addTable']['fuseaction']	= 'retail.list_manage_products';
		WOStruct['#attributes.fuseaction#']['addTable']['filePath']		= '/WBP/Retail/files/query/combine_table_codes.cfm';	
		WOStruct['#attributes.fuseaction#']['addTable']['queryPath']	= '/WBP/Retail/files/query/combine_table_codes.cfm';	

		WOStruct['#attributes.fuseaction#']['upd']					= structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction']	= 'retail.list_manage_products';
		WOStruct['#attributes.fuseaction#']['upd']['filePath']		= '/WBP/Retail/files/form/speed_manage_product_new.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath']		= '/WBP/Retail/files/form/speed_manage_product_new.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['Xmlfuseaction']	= 'product.list_product';
		WOStruct['#attributes.fuseaction#']['upd']['parameters'] = '&is_form_submitted=1&table_code=##attributes.table_code##';
		if(isdefined("attributes.table_code"))
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.table_code#';

	
	}
	else {
		/*
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
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.health_expense_approve&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.health_expense_approve";

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
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-calculator']['text'] = '#getlang('main',4202)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-calculator']['href'] = "#request.self#?fuseaction=ch.list_company_extre&member_type=employee&member_id=#get_expense.emp_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-calculator']['target'] ="_blank";

		}
	
		

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);		
		*/
	}
	/*
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm']				= true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList']	= 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName']			= 'EXPENSE_ITEM_PLAN_REQUESTS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn']		= 'EXPENSE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings']				= "['item-expense_stage','item-expense_date']";
	*/
</cfscript>