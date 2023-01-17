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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invent.add_invent_purchase';
		WOStruct['#attributes.fuseaction#']['add']['xmlFuseaction'] = 'invent.add_invent_purchase';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/inventory/form/add_invent_purchase.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/inventory/query/add_invent_purchase.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invent.add_invent_purchase&event=upd&invoice_id=';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('invent_purchase','invent_purchase_bask');";

		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'INVENTORY';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'INVENTORY_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-comp_name','item-partner_name','item-invoice_date','item-serial_no','item-ship_number','item-depo','item-project','item-partner_name',]";

		if(isdefined("attributes.invoice_id") or isdefined("attributes.ship_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invent.upd_purchase_invent';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/inventory/form/upd_invent_purchase.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/inventory/query/upd_invent_purchase.cfm';
			if(isdefined("attributes.invoice_id"))
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.invoice_id#';
			else
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.ship_id#';
			if(isdefined("attributes.invoice_id"))
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invent.add_invent_purchase&event=upd&invoice_id=';
			else
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invent.add_invent_purchase&event=upd&ship_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] ="javascript:gizle_goster_ikili('upd_cost','upd_cost_bask');";
		}
		
		if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
		{
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invent.list_actions";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{	
			denied_pages = caller.denied_pages;
			get_efatura_det = caller.get_efatura_det;
			get_invoice = caller.get_invoice;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invent.list_actions";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=invent.upd_purchase_invent&action_name=invoice_id&action_id=#attributes.invoice_id#&wrkflow=1','Workflow')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=invent.add_invent_purchase";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onclick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_type=#GET_INVOICE.invoice_cat#&iid=#attributes.invoice_id#','page');";
		
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			i = 0;
			if(isdefined("get_efatura_det") and get_efatura_det.recordcount){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',345)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_dsp_efatura_detail&receiving_detail_id=#get_efatura_det.receiving_detail_id#&type=1','wwide');";	
				i = i + 1;
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',1966)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['customtag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-22' module_id='20' action_section='INVOICE_ID' action_id='#attributes.invoice_id#'>";	
			i = i + 1;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',2577)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&invoice_id=#attributes.invoice_id#','page','upd_bill');";	
			i = i + 1;
			
			if(len(get_invoice.pay_method) and not listfindnocase(denied_pages,'objects.popup_payment_with_voucher')){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('invent',14)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_payment_with_voucher&is_purchase_=1&payment_process_id=#attributes.invoice_id#&str_table=INVOICE&branch_id='+document.upd_invent.branch_id.value);";	
				i = i + 1;
			}
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>