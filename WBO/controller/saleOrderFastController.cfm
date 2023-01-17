

<cfscript> 
// yarıda kaldı sonra düzenlenecek
	// Switch //
	if(attributes.tabMenuController eq 0)
	{
	
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.list_order_instalment';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/sales/display/list_order_instalment.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'sales.add_fast_sale';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/sales/form/add_fast_sale.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/sales/query/add_fast_sale.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'sales.list_order_instalment&event=add';
	
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'sales.upd_fast_sale';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/sales/form/upd_fast_sale.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/sales/query/upd_fast_sale.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'sales.list_order_instalment&event=upd';
		WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'order_id=##attributes.order_id##';
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.order_id##';
	
		if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_fast_sale&del_order_id=#attributes.order_id#&order_id=#attributes.order_id#&active_period=#session.ep.period_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/stock/query/upd_fast_sale.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/stock/query/upd_fast_sale.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_order_instalment';
			//WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'process_cat&old_process_type&type_id&fis_no&cat';
		}
	}
	else
	{
		getLang = caller.getLang;
		if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			get_orders_ship = caller.get_orders_ship;
			get_order_detail = caller.get_order_detail;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			
			i = 0;
			if((not get_orders_ship.recordcount or GET_ORDERS_INVOICE.recordcount neq 0) and not len(get_order_detail.cancel_date)){
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',373)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['id'] = 'invoice_';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=stock.form_upd_packetship&ship_result_id=#get_ship_result.ship_result_id#";
			}
			if(len(get_order_detail.consumer_id)){
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',163)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=call.list_callcenter&event=det&cid=#get_order_detail.consumer_id#";
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',428)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=member.consumer_list&event=det&cid=#get_order_detail.consumer_id#";
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',429)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=contract.list_contracts&event=upd&consumer_id=#get_order_detail.consumer_id#";
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',397)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=consumer&member_id=#get_order_detail.consumer_id#','page')";
			}
			else{
				
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',163)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=myhome.my_company_details&cpid=#get_order_detail.company_id#";
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',428)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#get_order_detail.company_id#";
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',429)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=contract.list_contracts&event=upd&company_id=#get_order_detail.company_id#";
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',397)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=partner&member_id=#get_order_detail.company_id#','page')";
			
			}
						
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',47)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_order_history&order_id=#url.ORDER_ID#</cfoutput>&portal_type=employee','project')";
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',345)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_page_warnings&action=#listgetat(attributes.fuseaction,1,'.')#.upd_fast_sale&action_name=order_id&action_id=#attributes.order_id#&relation_papers_type=ORDER_ID</cfoutput>','list')";
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',62)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_pluses_order&order_id=#attributes.order_id#</cfoutput>','wide2')";
				i= i + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',65)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_order_receive_rate&is_sale=1&order_id=#attributes.order_id#</cfoutput>','list')";
				if( not len(get_order_detail.cancel_date) and get_pay_vouchers.recordcount eq 0 and get_pay_cheques.recordcount eq 0){
					i= i + 1;
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',430)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_order_cancel&order_id=#attributes.order_id#</cfoutput>','page')";
				}	
				else if(len(get_order_detail.cancel_date)){
					i= i + 1;
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',431)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_dsp_order_cancel&order_id=#attributes.order_id#</cfoutput>','small')";
				}
				if(get_module_user(22)){
					i= i + 1;
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',431)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_order_account_cards&order_id=#attributes.order_id#</cfoutput>','page','upd_bill')";
					
				}
		
		
		}
			
								<cfset fac_ = "purchase">
								<cfif not listfindnocase(denied_pages,'#fac_#.add_order_product_all_criteria')>
								<a href="<cfoutput>#request.self#?fuseaction=#fac_#.add_order_product_all_criteria&order_id=#url.order_id#&active_company_id=#session.ep.company_id#</cfoutput>&from_sale_order=1"><img src="/images/plus_branch.gif" alt="<cf_get_lang no ='372.Satınalma Siparişi Oluştur'>" title="<cf_get_lang no ='372.Satınalma Siparişi Oluştur'>" border="0"></a>
								</cfif>
								<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&action_id=#url.order_id#&print_type=73</cfoutput>','page');"><img src="/images/print.gif" border="0" title="<cf_get_lang no ='432.Sözleşme Yazdır'>"></a>
								<a href="javascript://"  onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&action_id=#url.order_id#&print_type=115</cfoutput>','page');"><img src="/images/print_plus.gif" title="<cf_get_lang no ='433.Senet Yazdır'>" border="0"></a>
							</td>
						</tr>
			
			denied_pages = caller.denied_pages;
			if(len(get_order_detail.paymethod) and not listfindnocase(denied_pages,'objects.popup_payment_with_voucher'))
			
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getlang('main',170)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_fast_sale&event=add";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] =  '#getlang('main',62)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] ="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&action_id=#url.order_id#&print_type=73</cfoutput>','page')";
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=sales.list_order";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

	
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		WOStruct['#attributes.fuseaction#']['print'] = structNew();
		WOStruct['#attributes.fuseaction#']['print']['cfcName'] = 'listOrderPrint';
		WOStruct['#attributes.fuseaction#']['print']['identity'] = 'order_id';
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'ORDER';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ORDER_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-order_head','item-company','item-member_name','item-order_employee','item-order_date','item-deliverdate']";

</cfscript>