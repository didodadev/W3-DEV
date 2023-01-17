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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invent.add_invent_sale';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/inventory/form/add_invent_sale.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/inventory/query/add_invent_sale.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invent.upd_invent_sale&invoice_id=';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('invent_sale','invent_sale_bask');";
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'INVOICE';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'INVOICE_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-comp_name','item-partner_name','item-invoice_date','item-serial_no','item-ship_number','item-acc_department','item-department_location','item-ship_address']";
		
		if(isdefined("attributes.invoice_id") or isdefined("attributes.ship_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invent.upd_invent_sale';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/inventory/form/upd_invent_sale.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/inventory/query/upd_invent_sale.cfm';
			if(isdefined("attributes.invoice_id"))
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.invoice_id#';
			else
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.ship_id#';
			if(isdefined("attributes.invoice_id"))
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invent.add_invent_sale&event=upd&invoice_id=';
			else
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invent.add_invent_sale&event=upd&ship_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] ="javascript:gizle_goster_ikili('invent_sale','invent_sale_bask');";
		}
		
		if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			if(isdefined("attributes.ship_id"))
				url_str = 'ship_id=#attributes.ship_id#&head=##caller.get_ship.ship_number##';
			else if(isdefined("attributes.invoice_id"))
				url_str = 'invoice_id=#attributes.invoice_id#&head=##caller.get_invoice.invoice_number##';
				
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=invent.emptypopup_del_purchase_sale_invent&#url_str#&old_process_type=##caller.get_invoice.invoice_cat##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/inventory/query/del_purchase_sale_invent.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/inventory/query/del_purchase_sale_invent.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'invent.list_actions';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invent.list_actions";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			get_invoice = caller.get_invoice;
			control_earchive = caller.control_earchive;
			control_einvoice = caller.control_einvoice;
			denied_pages = caller.denied_pages;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=invent.add_invent_sale";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-sitemap']['text'] = '#getLang(dictionary_id : 53382)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-sitemap']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_budget_transactions&action_id=#attributes.invoice_id#&is_income=1&action_type=#GET_INVOICE.invoice_cat#','medium');";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invent.list_actions";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_type=#GET_INVOICE.invoice_cat#&iid=#attributes.invoice_id#&print_type=350','page','workcube_print');";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			
			i = 0;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = "#getLang('main',1966)#";	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['customtag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-22' module_id='20' action_section='INVOICE_ID' action_id='#attributes.invoice_id#'>";	
			i = i + 1;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = "#getLang('main',345)#";	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=invent.upd_invent_sale&action_name=invoice_id&action_id=#attributes.invoice_id#','list');";	
			i = i + 1;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = "#getLang('main',2577)#";	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&invoice_id=#attributes.invoice_id#','page','upd_bill');";	
			i = i + 1;

			if(session.ep.our_company_info.is_earchive eq 1)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',1338)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=invent.popup_cancel_invent&invoice_id=#attributes.invoice_id#');";
				
				i = i + 1;
			} 
			
			if(len(get_invoice.pay_method) and not listfindnocase(denied_pages,'objects.popup_payment_with_voucher')){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = "#getLang('invent',14)#";	
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_payment_with_voucher&is_purchase_=0&payment_process_id=#attributes.invoice_id#&str_table=INVOICE&branch_id='+document.upd_invent.branch_id.value,'page','upd_invent_sale');";	
				i = i + 1;
			}
			
			if(GET_INVOICE.use_efatura eq 1){
				transformations['#fuseactController#']['upd']['icons']['customTag'] = structNew();
				if(control_earchive.recordcount){
					transformations['#fuseactController#']['upd']['icons']['customtag'] = "<cf_wrk_earchive_display action_id='#attributes.invoice_id#' action_type='INVOICE' action_date='#get_invoice.invoice_date#'>";	
				}
				else{
					transformations['#fuseactController#']['upd']['icons']['customtag'] = "<cf_wrk_efatura_display action_id='#attributes.invoice_id#' action_type='INVOICE' action_date='#get_invoice.invoice_date#'>";	
				}
			}else if(session.ep.our_company_info.is_earchive eq 1){
				transformations['#fuseactController#']['upd']['icons']['customTag'] = structNew();
				if(control_einvoice.recordcount){
					transformations['#fuseactController#']['upd']['icons']['customtag'] = "<cf_wrk_efatura_display action_id='#attributes.invoice_id#' action_type='INVOICE' action_date='#get_invoice.invoice_date#'>";	
				}
				else{
					
					transformations['#fuseactController#']['upd']['icons']['customtag'] = "<cf_wrk_earchive_display action_id='#attributes.invoice_id#' action_type='INVOICE' action_date='#get_invoice.invoice_date#'>";	
				}	
			}
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

</cfscript>