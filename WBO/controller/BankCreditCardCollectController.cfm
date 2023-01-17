
<cfscript>
	// Switch //
	if(attributes.tabMenuController eq 0)
	{	
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.list_creditcard_revenue';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/bank/display/list_creditcard_revenue.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.popup_add_creditcard_revenue';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/bank/form/form_add_creditcard_revenue.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/bank/query/add_creditcard_revenue.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.list_creditcard_revenue&event=upd&id=';
		
		WOStruct['#attributes.fuseaction#']['addPos'] = structNew();
		WOStruct['#attributes.fuseaction#']['addPos']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['addPos']['fuseaction'] = 'bank.popup_add_online_pos';
		WOStruct['#attributes.fuseaction#']['addPos']['filePath'] = '/V16/bank/form/add_online_pos.cfm';
		WOStruct['#attributes.fuseaction#']['addPos']['queryPath'] = '/V16/bank/form/add_online_pos_kontrol.cfm';
		WOStruct['#attributes.fuseaction#']['addPos']['nextEvent'] = 'bank.list_creditcard_revenue';
		
		WOStruct['#attributes.fuseaction#']['addMulti'] = structNew();
		WOStruct['#attributes.fuseaction#']['addMulti']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['addMulti']['fuseaction'] ='bank.add_collacted_creditcard_revenue';
		WOStruct['#attributes.fuseaction#']['addMulti']['filePath'] = 'V16/bank/form/add_collacted_creditcard_revenue.cfm';
		WOStruct['#attributes.fuseaction#']['addMulti']['queryPath'] = 'V16/bank/query/add_collacted_creditcard_revenue.cfm';
		WOStruct['#attributes.fuseaction#']['addMulti']['nextEvent'] = 'bank.list_creditcard_revenue&event=updMulti&multi_id=';
		WOStruct['#attributes.fuseaction#']['addMulti']['js'] = "javascript:gizle_goster_ikili('collacted_creditcard','collacted_creditcard_sepet');";	
		
		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'bank.popup_form_upd_creditcard_revenue';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/bank/form/form_upd_creditcard_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/bank/query/upd_creditcard_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'bank.list_creditcard_revenue&event=upd&id=';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#'; 
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_creditcard_revenue&id=#attributes.id#&comp=##caller.attributes.comp_name##&old_process_type=##caller.get_payment.action_type_id##&action_date=##caller.get_payment.store_report_date##&active_period=##caller.get_payment.action_period_id##&cari_action_id=##caller.get_payment.cari_action_id##&relation_creditcard_payment_id=##caller.get_payment.relation_creditcard_payment_id##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/bank/query/del_creditcard_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/bank/query/del_creditcard_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_creditcard_revenue';
		}
		if(isdefined("attributes.multi_id"))
		{
			WOStruct['#attributes.fuseaction#']['updMulti'] = structNew();
			WOStruct['#attributes.fuseaction#']['updMulti']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['updMulti']['fuseaction'] = 'bank.upd_collacted_creditcard_revenue';
			WOStruct['#attributes.fuseaction#']['updMulti']['filePath'] = '/V16/bank/form/upd_collacted_creditcard_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['updMulti']['queryPath'] = '/V16/bank/query/upd_collacted_creditcard_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['updMulti']['Identity'] = '#attributes.multi_id#';
			WOStruct['#attributes.fuseaction#']['updMulti']['nextEvent'] = 'bank.list_creditcard_revenue&event=updMulti&multi_id=';
			WOStruct['#attributes.fuseaction#']['updMulti']['js'] = "javascript:gizle_goster_ikili('collacted_creditcard','collacted_creditcard_sepet');";
			
			if(ListFind('updMulti,delMulti',attributes.event))
			{
				WOStruct['#attributes.fuseaction#']['delMulti'] = structNew();
				WOStruct['#attributes.fuseaction#']['delMulti']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['delMulti']['fuseaction'] = '#request.self#?fuseaction=bank.emptypopup_del_collacted_creditcard_revenue&multi_id=#attributes.multi_id#&active_period=##caller.get_payment.action_period_id##&old_process_type=##caller.get_payment.action_type_id##';
				WOStruct['#attributes.fuseaction#']['delMulti']['filePath'] = 'V16/bank/query/del_collacted_creditcard_revenue.cfm';
				WOStruct['#attributes.fuseaction#']['delMulti']['queryPath'] = 'V16/bank/query/del_collacted_creditcard_revenue.cfm';
				WOStruct['#attributes.fuseaction#']['delMulti']['nextEvent'] = 'bank.list_creditcard_revenue';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_creditcard_revenue";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['text'] = '#getLang('main',2531)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=bank.list_creditcard_revenue&event=addMulti";
		}
		else if(caller.attributes.event is 'addPos')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['addPos']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['addPos']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addPos']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'addMulti')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_creditcard_revenue";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			GET_PAYMENT = caller.GET_PAYMENT;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=bank.list_creditcard_revenue&event=add";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&action_type=#GET_PAYMENT.action_type_id#&print_type=152','woc');"
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_creditcard_revenue";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#getlang('main',1966)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customtag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='19' action_section='CREDITCARD_PAYMENT_ID' action_id='#attributes.id#'>";	
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=id&action_id=#attributes.id#','Workflow')";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-table']['text'] = '#getlang('main',1040)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-table']['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#GET_PAYMENT.ACTION_TYPE_ID#&period_id=#GET_PAYMENT.ACTION_PERIOD_ID#','page','upd_cc_revenue')";	
		}
		else if(caller.attributes.event is 'updMulti')
		{
			get_payment = caller.get_payment;
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_creditcard_revenue";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['icons']['add']['href'] = "#request.self#?fuseaction=bank.list_creditcard_revenue&event=addMulti";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['menus'] = structNew();			
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['menus'][0]['text'] = '#getLang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updMulti']['menus'][0]['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.multi_id#&process_cat=#get_payment.ACTION_TYPE_ID#','wide','add_process');";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	if(isdefined("attributes.event") and attributes.event contains "Multi")
	{
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'addMulti,updMulti';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CREDIT_CARD_BANK_PAYMENTS_MULTI';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'MULTI_ACTION_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_date','item-process_cat']";	
	}
	else
	{
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,addPos';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CREDIT_CARD_BANK_PAYMENTS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CREDITCARD_PAYMENT_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-CreditCards','item-process','item-comp_name','item-due_start_date','item-sales_credit_comm','item-sales_credit']";
	}
</cfscript>
