<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invoice.form_add_bill';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/invoice/display/add_bill.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/invoice/query/add_invoice_sale.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invoice.form_add_bill&event=upd&iid=';
		/* WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(add_bill);"; */
		
		WOStruct['#attributes.fuseaction#']['copy'] = structNew();
		WOStruct['#attributes.fuseaction#']['copy']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['copy']['fuseaction'] = 'invoice.form_add_bill';
		WOStruct['#attributes.fuseaction#']['copy']['filePath'] = '/V16/invoice/display/add_bill.cfm';
		WOStruct['#attributes.fuseaction#']['copy']['queryPath'] = 'V16/invoice/query/add_invoice_sale.cfm';
		WOStruct['#attributes.fuseaction#']['copy']['nextEvent'] = 'invoice.form_add_bill&event=upd&iid=';
		WOStruct['#attributes.fuseaction#']['copy']['js'] = "javascript:gizle_goster_basket(add_bill);";
		
		if(isdefined("attributes.iid"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invoice.detail_invoice_sale';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/invoice/display/upd_bill.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/invoice/query/upd_invoice.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.iid#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invoice.form_add_bill&event=upd&iid=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(upd_bill);";

			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'invoice.detail_invoice_sale';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/invoice/display/det_bill.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.iid#';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'invoice.form_add_bill&event=det&iid=';
		}
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,copy';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'INVOICE';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'INVOICE_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-partner_name','item-invoice_no','item-invoice_date','item-department_location','item-ship_address_id']";
		
	}else
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invoice.list_bill";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['search']['text'] = '#getlang('main',153)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['search']['onclick'] = "openSearchForm('find_invoice_number','#getlang('main',721)#','find_invoice_f')";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		else if(caller.attributes.event is 'det')
		{			
			get_sale_det = caller.get_sale_det;
			if(len(get_sale_det.company_id) and get_sale_det.company_id neq 0){
				get_sale_det_comp = caller.get_sale_det_comp;
				GET_CONS_NAME = 0;
			}
				
			else if(len(get_sale_det.consumer_id)){
				get_sale_det_comp = 0;
				GET_CONS_NAME = caller.GET_CONS_NAME;
			}
			else{
				GET_EMPLOYEES = caller.GET_EMPLOYEES;	
			}

			control_earchive = caller.control_earchive;
			control_einvoice = caller.control_einvoice;
			denied_pages = caller.denied_pages;

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=invoice.form_add_bill";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['search']['text'] = '#getlang('main',153)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['search']['onclick'] = "openSearchForm('find_invoice_number','#getlang('main',721)#','find_invoice_f')";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['copy']['href'] = "#request.self#?fuseaction=invoice.form_add_bill&event=copy&iid=#attributes.iid#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invoice.list_bill";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&iid=#url.iid#&print_type=10&action_type=#get_sale_det.invoice_cat#','WOC');";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-table']['text'] = '#getLang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-table']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&invoice_id=#attributes.iid#','page','upd_bill');";// Mahsup Fişi
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getLang('main',52)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=#attributes.fuseaction#&event=upd&iid=#attributes.iid#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=iid&action_id=#attributes.iid#&wrkflow=1','Workflow')";
			

			if(session.ep.our_company_info.guaranty_followup)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-qrcode']['text'] = '#getLang('main',305)# - #getLang('main',306)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-qrcode']['href'] = "#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&invoice_number=#get_sale_det.invoice_number#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-qrcode']['target'] = "_blank";
			}

			if(len(get_sale_det.consumer_id))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['icn-md wrk-uF0134']['text'] = '#getLang('main',397)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['icn-md wrk-uF0134']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=consumer&member_id=#get_sale_det.consumer_id#','page')";
			}else if(len(get_sale_det.company_id)){
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['icn-md wrk-uF0134']['text'] = '#getLang('main',397)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['icn-md wrk-uF0134']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=partner&member_id=#get_sale_det.company_id#','page')";
			}
			
			if(not listfindnocase(denied_pages,'invoice.popup_form_add_info_plus'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-info-circle']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.iid#&type_id=-32','list');";
			}

			if ((get_sale_det.invoice_type_code eq 'SATIS' or get_sale_det.invoice_type_code eq 'IADE') and (len(get_sale_det.company_id) and get_sale_det_comp.use_efatura eq 1 and datediff('d',get_sale_det_comp.efatura_date,get_sale_det.invoice_date) gte 0) or (len(get_sale_det.consumer_id) and get_cons_name.use_efatura eq 1 and datediff('d',get_cons_name.efatura_date,get_sale_det.invoice_date) gte 0))
			{
				transformations['#fuseactController#']['det']['icons']['customTag'] = structNew();
				if (control_earchive.recordcount)
					transformations['#fuseactController#']['det']['icons']['customTag'] = "<cf_wrk_earchive_display action_id='#attributes.iid#' action_type='INVOICE' action_date='#get_sale_det.invoice_date#'>";
				else
					transformations['#fuseactController#']['det']['icons']['customTag'] = "<cf_wrk_efatura_display action_id='#attributes.iid#' action_type='INVOICE' action_date='#get_sale_det.invoice_date#'>";
			}
			else if ((get_sale_det.invoice_type_code eq 'SATIS' or get_sale_det.invoice_type_code eq 'IADE') and session.ep.our_company_info.is_earchive eq 1 and datediff('d',session.ep.our_company_info.earchive_date,get_sale_det.invoice_date) gte 0)
			{
				transformations['#fuseactController#']['det']['icons']['customTag'] = structNew();
				if (control_einvoice.recordcount)
					transformations['#fuseactController#']['det']['icons']['customTag'] = "<cf_wrk_efatura_display action_id='#attributes.iid#' action_type='INVOICE' action_date='#get_sale_det.invoice_date#'>";
				else
					transformations['#fuseactController#']['det']['icons']['customTag'] = "<cf_wrk_earchive_display action_id='#attributes.iid#' action_type='INVOICE' action_date='#get_sale_det.invoice_date#'>";
			}
		}
		else if(caller.attributes.event is 'upd')
		{
			get_sale_det = caller.get_sale_det;
			if(len(get_sale_det.company_id) and get_sale_det.company_id neq 0){
				get_sale_det_comp = caller.get_sale_det_comp;
				GET_CONS_NAME = 0;
			}
				
			else if(len(get_sale_det.consumer_id)){
				get_sale_det_comp = 0;
				GET_CONS_NAME = caller.GET_CONS_NAME;
			}
			else{
				GET_EMPLOYEES = caller.GET_EMPLOYEES;	
			}

				
			control_earchive = caller.control_earchive;
			control_einvoice = caller.control_einvoice;
			denied_pages = caller.denied_pages;
			get_makbuz_det = caller.get_makbuz_info;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main','Ekle',57582)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=invoice.form_add_bill";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['search']['text'] = '#getlang('main','Ara',57565)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['search']['onclick'] = "openSearchForm('find_invoice_number','#getlang('main','Fatura No',58133)#','find_invoice_f')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main','Kopyala',57476)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=invoice.form_add_bill&event=copy&iid=#attributes.iid#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invoice.list_bill";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main','Yazdır',57474)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&iid=#url.iid#&print_type=10&action_type=#get_sale_det.invoice_cat#','WOC');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['history']['text'] = '#getlang('main','Yazdır',57473)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['history']['customTag'] = "<cf_wrk_history act_type='7' act_id='#attributes.iid#' action_type='7' boxwidth='600' boxheight='500'>";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-ship']['text'] = '#getLang('invoice',259)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-ship']['onclick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_upd_income_center_invoice&id=#url.iid#&sale_emp=#get_sale_det.sale_emp#');";
				 
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['text'] = '#getLang('main','Mahsup Fişi',58452)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&invoice_id=#attributes.iid#','page','upd_bill');";// Mahsup Fişi
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['text'] = '#getlang('main','Detay',57771)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=#attributes.fuseaction#&event=det&iid=#attributes.iid#";
			i = 0;
			if(session.ep.our_company_info.is_earchive eq 1)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main','Fatura İptal',58750)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=invoice.popup_cancel_invoice&invoice_id=#attributes.iid#','','ui-draggable-box-small');";
				
				i = i + 1;
			} 
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main','Uyarılar',57757)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=iid&action_id=#attributes.iid#&wrkflow=1','Workflow')";
			
			if(session.ep.our_company_info.guaranty_followup)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-qrcode']['text'] = '#getLang('main','Garanti',57717)# - #getLang('main','Seri Nolar',57718)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-qrcode']['href'] = "#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&invoice_number=#get_sale_det.invoice_number#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-qrcode']['target'] = "_blank";
			}
			
			if(not listfindnocase(denied_pages,'#listgetat(attributes.fuseaction,1,'.')#.popup_list_invoice_orders'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('invoice',258)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_invoice_orders&invoice_id=#url.iid#&is_sale=1');";
				 
				i = i + 1;
			}
			if(session.ep.our_company_info.guaranty_followup)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',305)#-#getLang('main',306)#';	
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_add_serial_operations&is_filtre=1&belge_no=#caller.GET_WITH_SHIP_ALL.ship_number#&process_cat_id=#caller.GET_WITH_SHIP_ALL.ship_type#&process_id=#caller.GET_WITH_SHIP_ALL.ship_id#','list')";
				i++;
			}
			if(len(get_sale_det.consumer_id))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['icn-md wrk-uF0134']['text'] = '#getLang('main','Hesap Ekstresi',57809)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['icn-md wrk-uF0134']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=consumer&member_id=#get_sale_det.consumer_id#','page')";
			}else if(len(get_sale_det.company_id)){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['icn-md wrk-uF0134']['text'] = '#getLang('main','Hesap Ekstresi',57809)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['icn-md wrk-uF0134']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=partner&member_id=#get_sale_det.company_id#','page')";
			}
			
			if(not listfindnocase(denied_pages,'invoice.popup_form_add_info_plus'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['text'] = '#getLang('main','Ek Bilgi',57810)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.iid#&type_id=-32','list');";
			}
                  	  
			if(listfind('48,49,50,51,58,63',get_sale_det.invoice_cat,','))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('invoice',322)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_form_add_product_cost_invoice&invoice_id=#url.iid#','horizantal');";
				 
				i = i + 1;
			}
			
			 
			
			if(len(get_sale_det.pay_method) and not listfindnocase(denied_pages,'objects.popup_payment_with_voucher'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('invoice',324)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openVoucher();";
				 
				i = i + 1;
			} 
			if(get_sale_det.invoice_cat eq 531)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main','Gümrük İşlemi - İhracat',60303)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=invoice.list_bill_FTexport&event=add&export_invoice_id=#attributes.iid#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				i = i + 1;
			}
			if ((get_sale_det.invoice_type_code eq 'SATIS' or get_sale_det.invoice_type_code eq 'IADE' or get_sale_det.invoice_type_code eq 'IHRACKAYITLI') and (not listfind('640,680',get_sale_det.invoice_cat,',')) and (len(get_sale_det.company_id) and get_sale_det_comp.use_efatura eq 1 and datediff('d',get_sale_det_comp.efatura_date,get_sale_det.invoice_date) gte 0) or (len(get_sale_det.consumer_id) and get_cons_name.use_efatura eq 1 and datediff('d',get_cons_name.efatura_date,get_sale_det.invoice_date) gte 0))
			{
				transformations['#fuseactController#']['upd']['icons']['customTag'] = structNew();
				if (control_earchive.recordcount)
					transformations['#fuseactController#']['upd']['icons']['customTag'] = "<cf_wrk_earchive_display action_id='#attributes.iid#' action_type='INVOICE' action_date='#get_sale_det.invoice_date#'>";
				else
					transformations['#fuseactController#']['upd']['icons']['customTag'] = "<cf_wrk_efatura_display action_id='#attributes.iid#' action_type='INVOICE' action_date='#get_sale_det.invoice_date#'>";
			}
			else if ((get_sale_det.invoice_type_code eq 'SATIS' or get_sale_det.invoice_type_code eq 'IADE' or get_sale_det.invoice_type_code eq 'IHRACKAYITLI') and (not listfind('640,680',get_sale_det.invoice_cat,',')) and session.ep.our_company_info.is_earchive eq 1 and datediff('d',session.ep.our_company_info.earchive_date,get_sale_det.invoice_date) gte 0)
			{
				transformations['#fuseactController#']['upd']['icons']['customTag'] = structNew();
				if (control_einvoice.recordcount)
					transformations['#fuseactController#']['upd']['icons']['customTag'] = "<cf_wrk_efatura_display action_id='#attributes.iid#' action_type='INVOICE' action_date='#get_sale_det.invoice_date#'>";
				else
					transformations['#fuseactController#']['upd']['icons']['customTag'] = "<cf_wrk_earchive_display action_id='#attributes.iid#' action_type='INVOICE' action_date='#get_sale_det.invoice_date#'>";
			}
			if(get_sale_det.INVOICE_CAT eq 640 and get_makbuz_det.IS_EPRODUCER_RECEIPT eq 1){
				transformations['#fuseactController#']['upd']['icons']['customTag'] = structNew();
				transformations['#fuseactController#']['upd']['icons']['customTag'] = "<cf_wrk_emakbuz_display action_id='#attributes.iid#' action_type='MM' action_date='#get_sale_det.invoice_date#'>";
			}else if(get_sale_det.INVOICE_CAT eq 680 and get_makbuz_det.IS_EVOUCHER eq 1){
				transformations['#fuseactController#']['upd']['icons']['customTag'] = structNew();
				transformations['#fuseactController#']['upd']['icons']['customTag'] = "<cf_wrk_emakbuz_display action_id='#attributes.iid#' action_type='SMM' action_date='#get_sale_det.invoice_date#'>";
			}
		}
		else if(caller.attributes.event is 'copy')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['copy']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['copy']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['copy']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invoice.list_bill";
			tabMenuStruct['#fuseactController#']['tabMenus']['copy']['icons']['search']['text'] = '#getlang('main',153)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['copy']['icons']['search']['onclick'] = "openSearchForm('find_invoice_number','#getlang('main',721)#','find_invoice_f')";
			tabMenuStruct['#fuseactController#']['tabMenus']['copy']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['copy']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>