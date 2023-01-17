<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		// Switch //
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		
		if(not isdefined("attributes.event"))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invoice.add_bill_retail';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/invoice/form/add_bill_retail.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/invoice/query/add_invoice_retail.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invoice.add_bill_retail&event=upd';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(add_bill_retail)";
		
		if(IsDefined("attributes.event") && (attributes.event is 'upd' or attributes.event is 'del') and isdefined("attributes.iid"))
		{	
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invoice.detail_invoice_retail';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/invoice/form/upd_bill_retail.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/invoice/query/upd_invoice_retail.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invoice.add_bill_retail&event=upd';
			WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'iid=##attributes.iid##';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.iid#';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(upd_retail)";

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'invoice.emptypopup_upd_bill_retail&event=del&invoice_id=#attributes.iid#&iid=#attributes.iid#&del_invoice_id=#attributes.iid#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/invoice/query/upd_invoice_retail.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/invoice/query/upd_invoice_retail.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'invoice.list_bill';
			WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'active_period&old_process_type&del_invoice_id&invoice_number&department_id&location_id&process_cat';
		}
	
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			get_sale_det = caller.get_sale_det;
			if(len(get_sale_det.consumer_id))
			get_cons_name = caller.get_cons_name;
			else
			get_sale_det_comp = caller.get_sale_det_comp;

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			
			i = 0;
			if(session.ep.our_company_info.GUARANTY_FOLLOWUP)
			{	
				if(listgetat(attributes.fuseaction,1,'.') is 'invoice')
					modul_ = 'stock';
				else
					modul_ = listgetat(attributes.fuseaction,1,'.');
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main','Garanti',57717)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=#modul_#.list_serial_operations&is_filtre=1&invoice_number=#get_sale_det.invoice_number#";
			i = i + 1;
			}
			if(session.ep.our_company_info.guaranty_followup)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main','Garanti',57717)#-#getLang('main','Seri No lar',57718)#';	
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_add_serial_operations&is_filtre=1&belge_no=#caller.GET_WITH_SHIP_ALL.ship_number#&process_cat_id=#caller.GET_WITH_SHIP_ALL.ship_type#&process_id=#caller.GET_WITH_SHIP_ALL.ship_id#','list')";
				i++;
			}
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('invoice','Takipler',57325)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_pursuits_documents_plus&action_id=#attributes.iid#&pursuit_type=is_sale_invoice','page')";
			i = i + 1;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-table']['text'] = '#getLang('main','Muhasebe Hareketleri',59032)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-table']['onclick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_order_account_cards&invoice_id=#attributes.iid#','page','upd_bill')";
			 
			if((GET_SALE_DET.INVOICE_TYPE_CODE eq 'SATIS' or GET_SALE_DET.INVOICE_TYPE_CODE eq 'IADE') and (len(get_sale_det.company_id) and get_sale_det_comp.use_efatura eq 1 and datediff('d',get_sale_det_comp.efatura_date,get_sale_det.invoice_date) gte 0) or (len(get_sale_det.consumer_id) and get_cons_name.use_efatura eq 1 and datediff('d',get_cons_name.efatura_date,get_sale_det.invoice_date) gte 0))
			{
				transformations['#attributes.fuseaction#']['upd']['icons']['customTag'] = structNew();
				transformations['#attributes.fuseaction#']['upd']['icons']['customTag'] = '<cf_wrk_efatura_display action_id="#attributes.iid#" action_type="INVOICE" action_date="#get_sale_det.invoice_date#">';
			}
			else if(listfind('SATIS,IADE',get_sale_det.invoice_type_code) and session.ep.our_company_info.is_earchive eq 1 and datediff('d',session.ep.our_company_info.earchive_date,get_sale_det.invoice_date) gte 0)
            {
				transformations['#attributes.fuseaction#']['upd']['icons']['customTag'] = structNew();
				transformations['#attributes.fuseaction#']['upd']['icons']['customTag'] = '<cf_wrk_earchive_display action_id="#attributes.iid#" action_type="INVOICE" action_date="#get_sale_det.invoice_date#">';
			}
			 tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main','Ekle',57582)#';
			 tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_bill_retail";
			
			 tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main','Yazdır',57474)#';
			 tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#url.iid#&print_type=10','page')";				
			
			 tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'INVOICE';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'INVOICE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-member_name','item-address','item-location']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>