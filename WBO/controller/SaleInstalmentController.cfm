<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.list_order_instalment';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/sales/display/list_order.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'sales.add_fast_sale';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/sales/form/add_fast_sale.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/sales/query/add_fast_sale.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#request.self#?fuseaction=sales.list_order_instalment&event=upd&order_id';

		if(isdefined("attributes.order_id") and attributes.event is 'upd' || attributes.event is 'del' || attributes.event is 'det')
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'sales.upd_fast_sale';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/sales/form/upd_fast_sale.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/sales/query/upd_fast_sale.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.order_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#request.self#?fuseaction=sales.list_order_instalment&event=upd&order_id';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket();";

			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'sales.list_order_instalment';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/sales/form/det_fast_sale.cfm';
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'V16/sales/form/det_fast_sale.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.order_id#';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = '#request.self#?fuseaction=sales.list_order_instalment&event=det&order_id';
	
			
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=sales.emptypopup_upd_fast_sale&cheque_payroll_id=##caller.get_sale_cheques.action_id##&payroll_id=##caller.get_sale_vouchers.action_id##&cheque_id_list=##caller.cheque_id_list_##&voucher_id_list=##caller.voucher_id_list##&order_number=##caller.get_order_detail.order_number##&del_order_id=#attributes.order_id#&order_id=#attributes.order_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/sales/query/upd_fast_sale.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/sales/query/upd_fast_sale.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'sales.list_order_instalment';
		}
	
	

	}
	else
	{
		getLang = caller.getLang;
		if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			get_orders_ship = caller.get_orders_ship;
			get_order_detail = caller.get_order_detail;
			GET_ORDERS_INVOICE = caller.GET_ORDERS_INVOICE;
            GET_PAY_VOUCHERS = caller.GET_PAY_VOUCHERS;
            GET_PAY_CHEQUES = caller.GET_PAY_CHEQUES;
            GET_MODULE_USER = caller.GET_MODULE_USER;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			
			i = -1;
			if( (not get_orders_ship.recordcount or GET_ORDERS_INVOICE.recordcount neq 0) and not len(get_order_detail.cancel_date) ){
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',373)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['id'] = 'invoice_';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=invoice.form_add_bill&order_id=#attributes.order_id#";
			}
			
			if(len(get_order_detail.consumer_id)){
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',163)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=call.list_callcenter&event=det&cid=#get_order_detail.consumer_id#";
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',428)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=member.consumer_list&event=det&cid=#get_order_detail.consumer_id#";
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',429)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=contract.list_contracts&event=upd&consumer_id=#get_order_detail.consumer_id#";
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['icn-md wrk-uF0134']['text']  = '#getlang('main',397)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['icn-md wrk-uF0134']['onClick']  = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=consumer&member_id=#get_order_detail.consumer_id#','page')";
			}
			else{
				
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',163)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=call.list_callcenter&event=det&cpid=#get_order_detail.company_id#";
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',428)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#get_order_detail.company_id#";
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',429)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=contract.list_contracts&event=upd&company_id=#get_order_detail.company_id#";
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['icn-md wrk-uF0134']['text']   = '#getlang('main',397)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['icn-md wrk-uF0134']['onClick']  = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=partner&member_id=#get_order_detail.company_id#','page')";
			
			}
						
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getlang('sales',47)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_order_history&order_id=#url.ORDER_ID#&portal_type=employee')";
	
				if( not len(get_order_detail.cancel_date) and get_pay_vouchers.recordcount eq 0 and get_pay_cheques.recordcount eq 0){
					i= i + 1;
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',430)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_order_cancel&order_id=#attributes.order_id#')";
				}	
				else if(len(get_order_detail.cancel_date)){
					i= i + 1;
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',431)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_order_cancel&order_id=#attributes.order_id#','small')";
				}
				if(get_module_user(22)){
					i= i + 1;
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-table']['text'] = '#getlang('','Muhasebe Fişi','58215')#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-table']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_order_account_cards&order_id=#attributes.order_id#')";
					
				}

				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getlang('main',170)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_order_instalment&event=add";
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['text'] = '#getlang('','Detay',57771)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_order_instalment&event=det&order_id=#attributes.order_id#";

				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] =  '#getlang('main',62)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] ="window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#url.order_id#&print_type=73','woc');";
		
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=purchase.list_internaldemand&action_name=order_id&action_id=#url.order_id#&relation_papers_type=ORDER_ID','Workflow')"

				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=sales.list_order_instalment";
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		
		
		}

		if(isdefined("attributes.event") and attributes.event is 'det')
		{
			get_orders_ship = caller.get_orders_ship;
			get_order_detail = caller.get_order_detail;
			GET_ORDERS_INVOICE = caller.GET_ORDERS_INVOICE;
            GET_PAY_VOUCHERS = caller.GET_PAY_VOUCHERS;
            GET_PAY_CHEQUES = caller.GET_PAY_CHEQUES;
            GET_MODULE_USER = caller.GET_MODULE_USER;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();
			
			i = -1;
			if( (not get_orders_ship.recordcount or GET_ORDERS_INVOICE.recordcount neq 0) and not len(get_order_detail.cancel_date) ){
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getlang('sales',373)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['id'] = 'invoice_';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=invoice.form_add_bill&order_id=#attributes.order_id#";
			}
			
			if(len(get_order_detail.consumer_id)){
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getlang('main',163)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=call.list_callcenter&event=det&cid=#get_order_detail.consumer_id#";
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getlang('sales',428)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=member.consumer_list&event=det&cid=#get_order_detail.consumer_id#";
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getlang('sales',429)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=contract.list_contracts&event=upd&consumer_id=#get_order_detail.consumer_id#";
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['icn-md wrk-uF0134']['text']  = '#getlang('main',397)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['icn-md wrk-uF0134']['onClick']  = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=consumer&member_id=#get_order_detail.consumer_id#','page')";
			}
			else{
				
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getlang('main',163)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=call.list_callcenter&event=det&cpid=#get_order_detail.company_id#";
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getlang('sales',428)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#get_order_detail.company_id#";
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getlang('sales',429)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=contract.list_contracts&event=upd&company_id=#get_order_detail.company_id#";
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['icn-md wrk-uF0134']['text']   = '#getlang('main',397)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['icn-md wrk-uF0134']['onClick']  = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=partner&member_id=#get_order_detail.company_id#','page')";
			
			}
						
			
				/* i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',345)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=#listgetat(attributes.fuseaction,1,'.')#.upd_fast_sale&action_name=order_id&action_id=#attributes.order_id#&relation_papers_type=ORDER_ID','list')"; */
				
				if( not len(get_order_detail.cancel_date) and get_pay_vouchers.recordcount eq 0 and get_pay_cheques.recordcount eq 0){
					i= i + 1;
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getlang('sales',430)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_order_cancel&order_id=#attributes.order_id#')";
				}	
				else if(len(get_order_detail.cancel_date)){
					i= i + 1;
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getlang('sales',431)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_order_cancel&order_id=#attributes.order_id#','small')";
				}
				if(get_module_user(22)){
					i= i + 1;
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-table']['text'] = '#getlang('','Muhasebe Fişi','58215')#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-table']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_order_account_cards&order_id=#attributes.order_id#')";
					
				}

				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['text'] = '#getlang('main',170)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_order_instalment&event=add";
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['target'] = "_blank";
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getLang('main',52)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_order_instalment&event=upd&order_id=#attributes.order_id#";

				/* tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] =  '#getlang('main',62)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] ="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#url.order_id#&print_type=73','page')"; */

				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['text'] =  '#getlang('main',62)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['onClick'] ="window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#url.order_id#&print_type=73','woc');";
		
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('main',345)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=purchase.list_internaldemand&action_name=order_id&action_id=#url.order_id#&relation_papers_type=ORDER_ID','Workflow')"

				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=sales.list_order_instalment";
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main',49)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['check']['onClick'] = "buttonClickFunction()";
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-history']['text'] = '#getlang('sales',47)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-history']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_order_history&order_id=#url.ORDER_ID#&portal_type=employee')";
		
		}
		if(caller.attributes.event is 'add')
		{			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=sales.list_order_instalment";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	
	}
	
</cfscript>