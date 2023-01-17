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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invoice.form_add_bill_purchase';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/invoice/display/add_bill_purchase.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/invoice/query/add_invoice_purchase.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invoice.form_add_bill_purchase&event=upd&id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'form_basket';
		WOStruct['#attributes.fuseaction#']['add']['js'] = 'javascript:gizle_goster_basket(add_bill_purchase);';
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'INVOICE';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'INVOICE_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-partner_name','item-invoice_no','item-deliver_get','item-invoice_date','item-department_ID']";
		
		if(isdefined("attributes.iid")){
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invoice.detail_invoice_purchase';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/invoice/display/upd_bill_purchase.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/invoice/query/upd_invoice_purchase.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invoice.form_add_bill_purchase&event=upd&id=';
			WOStruct['#attributes.fuseaction#']['upd']['identity'] = '#attributes.iid#';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = 'javascript:gizle_goster_basket(upd_purchase);';

			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'invoice.form_add_bill_purchase';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/invoice/display/det_bill_purchase.cfm';
			WOStruct['#attributes.fuseaction#']['det']['identity'] = '#attributes.iid#';
			//WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '/V16/invoice/query/upd_invoice_purchase.cfm';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=invoice.emptypopup_upd_bill_purchase&event=del&iid=#attributes.iid#&del_invoice_id=#attributes.iid#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/invoice/query/upd_invoice_purchase.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/V16/invoice/query/upd_invoice_purchase.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'invoice.list_bill';

		}
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		dsn2 = caller.dsn2;
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'add' or caller.attributes.event is 'copy')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invoice.list_bill";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['search']['text'] = '#getlang('main',153)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['search']['onclick'] = "openSearchForm('find_invoice_number','#getlang('main',721)#','find_invoice_f')";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			get_efatura_det = caller.get_efatura_det;
			denied_pages = caller.denied_pages;
			get_sale_det = caller.get_sale_det;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=invoice.form_add_bill_purchase";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['search']['text'] = '#getlang('main',153)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['search']['onclick'] = "openSearchForm('find_invoice_number','#getlang('main',721)#','find_invoice_f')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invoice.list_bill";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&iid=#url.iid#&action_type=#GET_SALE_DET.invoice_cat#');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['history']['text'] = '#getlang('main','Tarihçe',57473)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['history']['customTag'] = "<cf_wrk_history act_type='7' act_id='#attributes.iid#' action_type='7' boxwidth='600' boxheight='500'>";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('invoice',262)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill_purchase&event=add&iid=#attributes.iid#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['href'] = "#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=iid&action_id=#attributes.iid#&relation_papers_type=INVOICE_ID";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['text'] = '#getLang('main',2577)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&invoice_id=#attributes.iid#','page','upd_bill');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-sitemap']['text'] = '#getLang('invoice',264)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-sitemap']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_upd_expensecenter_invoice&id=#url.iid#&sale_partner=#get_sale_det.SALE_PARTNER#&sales_emp=#get_sale_det.SALE_EMP#','horizontal');";
			if(not listfindnocase(denied_pages,'invoice.popup_form_add_info_plus')){
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.iid#&type_id=-8','list');";		
			} 
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['text'] = '#getLang('main',359)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=invoice.form_add_bill_purchase&event=det&iid=#attributes.iid#";
	

			i = 0;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			if(get_efatura_det.recordcount){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',2075)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_dsp_efatura_detail&receiving_detail_id=#get_efatura_det.receiving_detail_id#&type=1','wwide');";
				i = i + 1;
			}
			
			if(session.ep.our_company_info.guaranty_followup){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = "#getLang('main',305)# - #getLang('main',306)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&invoice_number=#get_sale_det.invoice_number#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				i = i + 1;
			}
			
			if(not listfindnocase(denied_pages,'#listgetat(attributes.fuseaction,1,'.')#.popup_list_invoice_orders')){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = "#getLang('invoice',258)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_invoice_orders&invoice_id=#url.iid#&is_purchase=1');";
				i = i + 1;
			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = "#getLang('invoice',217)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_cost&id=#url.iid#&page_type=1&basket_id=#attributes.basket_id#','horizantal');";
			i = i + 1;
			
			/* if(not listfindnocase(denied_pages,'#listgetat(attributes.fuseaction,1,'.')#.popup_get_contract_comparison')){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = "#getLang('main',1339)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_get_contract_comparison&iid=#url.iid#&type=0','wwide');";
				i = i + 1;
			} */

			if(len(get_sale_det.consumer_id))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',397)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=consumer&member_id=#get_sale_det.consumer_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				i = i + 1;
			}
			else if(len(get_sale_det.company_id))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',397)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=partner&member_id=#get_sale_det.company_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				i  = i + 1;
			}

			if(listfind('48,49,50,51,58,63',get_sale_det.invoice_cat,',')){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = "#getLang('invoice',322)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_form_add_product_cost_invoice&invoice_id=#attributes.iid#','horizantal');";
				i = i + 1;
			}
			
			if(get_sale_det.invoice_cat eq 591){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = "#getLang('main',1791)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_imports_invoice_comparison_list&invoice_id=#attributes.iid#','list');";
				i = i + 1;
			}

			if(len(get_sale_det.pay_method) and not listfindnocase(denied_pages,'objects.popup_payment_with_voucher')){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = "#getLang('invoice',324)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openVoucher();";
				i = i + 1;
			}

			if(not len(CALLER.isClosed('INVOICE',attributes.iid))){
				link = "";
				action_type_id = get_sale_det.invoice_cat;
				act_type = 3;
				if( len(get_sale_det.company_id) and get_sale_det.company_id neq 0)
					link = "#request.self#?fuseaction=finance.list_payment_actions_order&act_type=#act_type#&event=add&member_id=#get_sale_det.company_id#&row_action_id=#attributes.iid#&row_action_type=#action_type_id#";                         
				else if( len(get_sale_det.CONSUMER_ID) and get_sale_det.CONSUMER_ID neq 0)
					link = "#request.self#?fuseaction=finance.list_payment_actions_order&act_type=#act_type#&event=add&consumer_id=#get_sale_det.CONSUMER_ID#&row_action_id=#attributes.iid#&row_action_type=#action_type_id#";  
				else if( len(get_sale_det.EMPLOYEE_ID) and get_sale_det.EMPLOYEE_ID neq 0)
					link = "#request.self#?fuseaction=finance.list_payment_actions_order&act_type=#act_type#&event=add&employee_id_new=#get_sale_det.EMPLOYEE_ID#&row_action_id=#attributes.iid#&row_action_type=#action_type_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = "#getLang('cash',13,'Ödeme Emri Ver')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#link#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				i = i + 1;
				
				link = "";
				action_type_id = get_sale_det.invoice_cat;
				act_type = 2;
				if( len(get_sale_det.company_id) and get_sale_det.company_id neq 0)
					link = "#request.self#?fuseaction=finance.list_payment_actions_demand&act_type=#act_type#&event=add&member_id=#get_sale_det.company_id#&row_action_id=#attributes.iid#&row_action_type=#action_type_id#";                         
				else if( len(get_sale_det.CONSUMER_ID) and get_sale_det.CONSUMER_ID neq 0)
					link = "#request.self#?fuseaction=finance.list_payment_actions_demand&act_type=#act_type#&event=add&consumer_id=#get_sale_det.CONSUMER_ID#&row_action_id=#attributes.iid#&row_action_type=#action_type_id#";  
				else if( len(get_sale_det.EMPLOYEE_ID) and get_sale_det.EMPLOYEE_ID neq 0)
					link = "#request.self#?fuseaction=finance.list_payment_actions_demand&act_type=#act_type#&event=add&employee_id_new=#get_sale_det.EMPLOYEE_ID#&row_action_id=#attributes.iid#&row_action_type=#action_type_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = "#getLang('myhome',676,'Ödeme Talebi Ver')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#link#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				i = i + 1;
			}

		}
		else if(caller.attributes.event is 'det'){
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getLang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['href'] = "#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=iid&action_id=#attributes.iid#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invoice.list_bill";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['update']['text'] = '#getlang('main',1034)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['update']['href'] = "#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=#attributes.iid#";
		
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);	
	}
	
</cfscript>