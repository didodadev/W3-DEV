<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.list_assign_order';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/bank/display/list_assign_order.cfm';
		
		
		if(isdefined("attributes.bank_order_id")) 
		{
			WOStruct['#attributes.fuseaction#']['upd_incoming'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd_incoming']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd_incoming']['fuseaction'] = 'bank.popup_upd_bank_order';
			WOStruct['#attributes.fuseaction#']['upd_incoming']['filePath'] = 'V16/bank/form/upd_incoming_bank_order.cfm';
			WOStruct['#attributes.fuseaction#']['upd_incoming']['queryPath'] = 'V16/bank/query/upd_incoming_bank_order.cfm';
			WOStruct['#attributes.fuseaction#']['upd_incoming']['Identity'] = '#attributes.bank_order_id#';
			WOStruct['#attributes.fuseaction#']['upd_incoming']['nextEvent'] = 'bank.list_assign_order&event=upd_incoming&bank_order_id=';
			
			WOStruct['#attributes.fuseaction#']['upd_assign'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd_assign']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd_assign']['fuseaction'] = 'bank.popup_upd_assign_order';
			WOStruct['#attributes.fuseaction#']['upd_assign']['filePath'] = 'V16/bank/form/upd_assign_order.cfm';
			WOStruct['#attributes.fuseaction#']['upd_assign']['queryPath'] = 'V16/bank/query/upd_assign_order.cfm';
			WOStruct['#attributes.fuseaction#']['upd_assign']['Identity'] = '#attributes.bank_order_id#';
			WOStruct['#attributes.fuseaction#']['upd_assign']['nextEvent'] = 'bank.list_assign_order&event=upd_assign&bank_order_id=';
		}
		
		WOStruct['#attributes.fuseaction#']['add_incoming'] = structNew(); 
		WOStruct['#attributes.fuseaction#']['add_incoming']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add_incoming']['fuseaction'] = 'bank.popup_incoming_bank_order';
		WOStruct['#attributes.fuseaction#']['add_incoming']['filePath'] = 'V16/bank/form/add_incoming_bank_order.cfm';
		WOStruct['#attributes.fuseaction#']['add_incoming']['queryPath'] = 'V16/bank/query/add_incoming_bank_order.cfm';
		WOStruct['#attributes.fuseaction#']['add_incoming']['nextEvent'] = 'bank.list_assign_order&event=upd_incoming&bank_order_id=';
		
		WOStruct['#attributes.fuseaction#']['add_assign'] = structNew(); 
		WOStruct['#attributes.fuseaction#']['add_assign']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add_assign']['fuseaction'] = 'bank.popup_assign_order';
		WOStruct['#attributes.fuseaction#']['add_assign']['filePath'] = 'V16/bank/form/add_assign_order.cfm';
		WOStruct['#attributes.fuseaction#']['add_assign']['queryPath'] = 'V16/bank/query/add_assign_order.cfm';
		WOStruct['#attributes.fuseaction#']['add_assign']['nextEvent'] = 'bank.list_assign_order&event=upd_assign&bank_order_id=';
		
			
		if(IsDefined("attributes.event") && (attributes.event is 'del' || attributes.event is 'upd_assign' || attributes.event is 'upd_incoming'))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=bank.emptypopup_del_assign_order&bank_order_id=##caller.get_order.bank_order_id##&old_process_type=##caller.get_order.bank_order_type##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/bank/query/del_assign_order.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/bank/query/del_assign_order.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_assign_order';
		}
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ORDERS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'BANK_ORDER_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-wrkBankAccounts','item-company_name','item-list_bank','item-special_definition_id','item-project_name','item-payment_date','item-action_date','item-order_amount']";
	
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'add_incoming')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add_incoming']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add_incoming']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add_incoming']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_assign_order";
			tabMenuStruct['#fuseactController#']['tabMenus']['add_incoming']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add_incoming']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'add_assign'){
			tabMenuStruct['#fuseactController#']['tabMenus']['add_assign']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add_assign']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add_assign']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_assign_order";
			tabMenuStruct['#fuseactController#']['tabMenus']['add_assign']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add_assign']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd_incoming')
		{
			get_order = caller.get_order;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_incoming']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_incoming']['icons']['add']['text'] = '#getLang('bank',266)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_incoming']['icons']['add']['href'] = "#request.self#?fuseaction=bank.list_assign_order&event=add_incoming";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_incoming']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_incoming']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_assign_order";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_incoming']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_incoming']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_incoming']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_incoming']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#get_order.bank_order_id#&print_type=157','woc');";
			
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_incoming']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_incoming']['menus'][0]['text'] = '#getLang('main',1966)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_incoming']['menus'][0]['customtag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='19' action_section='BANK_ORDER_ID' action_id='#get_order.bank_order_id#'>";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_incoming']['icons']['fa fa-table']['text'] = '#getLang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_incoming']['icons']['fa fa-table']['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#get_order.bank_order_id#&process_cat=#get_order.bank_order_type#','page','popup_list_card_rows');";
			
		}
		else if( caller.attributes.event is 'upd_assign' ){
			get_order = caller.get_order;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_assign']['icons'] = structNew();

			tabMenuStruct['#fuseactController#']['tabMenus']['upd_assign']['icons']['add']['text'] = '#getLang('bank',265)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_assign']['icons']['add']['href'] = "#request.self#?fuseaction=bank.list_assign_order&event=add_assign";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_assign']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_assign']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_assign_order";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_assign']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_assign']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_assign']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_assign']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#get_order.bank_order_id#&print_type=157','woc');";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_assign']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_assign']['menus'][0]['text'] = '#getLang('main',1966)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_assign']['menus'][0]['customtag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='19' action_section='BANK_ORDER_ID' action_id='#get_order.bank_order_id#'>";
	
		tabMenuStruct['#fuseactController#']['tabMenus']['upd_assign']['icons']['bell']['target'] = "_blank";
		tabMenuStruct['#fuseactController#']['tabMenus']['upd_assign']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
		tabMenuStruct['#fuseactController#']['tabMenus']['upd_assign']['icons']['bell']['href'] = '#request.self#?fuseaction=objects.workflowpages&tab=3&action=myhome.my_extre&action_name=bank_order_id&action_id=#get_order.bank_order_id#';
	
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_assign']['icons']['fa fa-table']['text'] = '#getLang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_assign']['icons']['fa fa-table']['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#get_order.bank_order_id#&process_cat=#get_order.bank_order_type#','page','popup_list_card_rows');";
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
