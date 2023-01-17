<cfsavecontent  variable="woc"><cf_get_lang dictionary_id='61577.WOC'></cf_get_lang> </cfsavecontent>
<cfsavecontent variable="detail"><cf_get_lang dictionary_id="57771.Detaylar"></cfsavecontent>
	<cfsavecontent variable="veriaktarim"><cf_get_lang dictionary_id="60009.Veri Aktarım"></cfsavecontent>
<cfscript>
	// Switch //
	if(attributes.tabMenuController eq 0)
	{
	
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'purchase.list_order';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/purchase/display/list_order.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'purchase.form_add_order';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/purchase/form/add_order.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/purchase/query/add_order.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'purchase.list_order&event=upd&order_id=';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(add_order);";
		WOStruct['#attributes.fuseaction#']['add']['xmlfuseaction'] = 'purchase.detail_order';

		WOStruct['#attributes.fuseaction#']['fromSaleOrder'] = structNew();
		WOStruct['#attributes.fuseaction#']['fromSaleOrder']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['fromSaleOrder']['fuseaction'] = 'purchase.add_product_all_order';
		WOStruct['#attributes.fuseaction#']['fromSaleOrder']['filePath'] = 'V16/purchase/form/add_all_of_product_order.cfm';
		WOStruct['#attributes.fuseaction#']['fromSaleOrder']['queryPath'] = 'V16/purchase/query/add_order.cfm';
		WOStruct['#attributes.fuseaction#']['fromSaleOrder']['nextEvent'] = 'purchase.list_order&event=upd&order_id=';
		WOStruct['#attributes.fuseaction#']['fromSaleOrder']['js'] = "javascript:gizle_goster_basket(add_order);";
	
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'purchase.detail_order';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/purchase/form/detail_order.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/purchase/query/upd_order.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'purchase.list_order&event=upd&order_id=';
		WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'camp_id=##attributes.order_id##';
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.order_id##';
		WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(detail_order);";
		WOStruct['#attributes.fuseaction#']['upd']['xmlfuseaction'] = 'purchase.detail_order';

		WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'purchase.detail_order';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/purchase/form/form_detail_order.cfm';
		WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'V16/purchase/cfc/get_order_list.cfc';
		WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'purchase.list_order&event=det&order_id=';
		WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.order_id##';
		WOStruct['#attributes.fuseaction#']['det']['js'] = "javascript:gizle_goster_basket(detail_order);";
	
		if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
		{
			//WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=purchase.emptypopup_del_order&order_id=#attributes.order_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/purchase/query/del_order.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/purchase/query/del_order.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'purchase.list_order';
		}
		
			
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,det';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'ORDERS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ORDER_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-order_head','item-partner','item-deliverdate','item-order_date','item-process','item-deliver_loc_id']";
		
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		//Add//
		// Tab Menus //
			tabMenuStruct = StructNew();
			tabMenuStruct['#attributes.fuseaction#'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
			//Add//
			if(isdefined("attributes.event") and attributes.event is 'add')
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
				
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=purchase.list_order";
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['download']['text'] = '#veriaktarim#';
			    tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['download']['onClick'] = "open_phl()";
				
				if( session.ep.isBranchAuthorization eq 0)
				{
				   //<cfinclude template="../query/get_find_order_js.cfm">
				}
						
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#getlang('main',163)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['id'] = 'member_page';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['onClick'] = "open_member_page();";
			
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][1]['text'] = '#getlang('purchase',27)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][1]['id'] = 'member_page_1';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][1]['onClick'] = "open_contract_page();";
				tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
			}
			
						// Upd //	
			if(isdefined("attributes.event") and attributes.event is 'upd')
			{
				get_order_detail = caller.get_order_detail;
				denied_pages = caller.denied_pages;
				get_ship_result = caller.get_ship_result;
				get_invoice_control = caller.get_invoice_control;

				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
				
				if( session.ep.isBranchAuthorization eq 0 )
				{
                	//<cfinclude template="../query/get_find_order_js.cfm">
				}
                                       
				i = 0;
				if(not listfindnocase(denied_pages,'credit.add_credit_contract') and session.ep.isBranchAuthorization neq 1)
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('purchase',200)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=credit.list_credit_contract&event=add&order_no=#get_order_detail.order_number#";
					i = i + 1;
				}
		
				if(get_ship_result.recordcount and session.ep.isBranchAuthorization eq 0)
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('purchase',201)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=stock.list_packetship&event=upd&ship_result_id=#get_ship_result.ship_result_id#";
					i = i + 1;
				}
				else if (session.ep.isBranchAuthorization eq 0)
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('purchase',201)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=stock.popup_add_packetship&order_id=#attributes.order_id#&is_type=2','list');";
					i = i + 1;
				}
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('purchase',197)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_cost&id=#attributes.order_id#&page_type=2&basket_id=#attributes.basket_id#','wide');";
				i = i + 1;
				
				if(len(get_order_detail.paymethod) and not listfindnocase(denied_pages,'objects.popup_payment_with_voucher'))
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('purchase',230)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "openVoucher();";
					i = i + 1;
				}
				
				
				if(len(get_order_detail.company_id))
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',172)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_order_detail.company_id#','medium');";
					i = i + 1;
				}
				else if(len(get_order_detail.consumer_id))
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',172)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_order_detail.consumer_id#','medium');";
					i = i + 1;
				}
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('purchase',18)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=purchase.add_order_product_all_criteria&active_company_id=#session.ep.company_id#&from_purchase_order=1&order_id=#url.order_id#";
				i = i + 1;
		
				if(Get_Invoice_Control.recordcount)
				{
					if(session.ep.isBranchAuthorization eq 1)
					{
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('purchase',202)#';
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=store.form_add_bill_purchase&order_id=#attributes.order_id#&is_rate_extra_cost_to_incoice=#caller.x_is_rate_extra_cost_convert_to_incoice#";
						i = i + 1;
					}
					else
					{
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('purchase',202)#';
						tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=invoice.form_add_bill_purchase&order_id=#attributes.order_id#&is_rate_extra_cost_to_incoice=#caller.x_is_rate_extra_cost_convert_to_incoice#";
						i = i + 1;
					}
				}
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('purchase',27)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_basket_contract&order_id=#attributes.order_id#&company_id=#get_order_detail.company_id#&consumer_id=#get_order_detail.consumer_id#','wide');";
				
				
			
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',1577)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=purchase.list_order&event=add";
				
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',1578)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=purchase.list_order&event=add&order_id=#url.order_id#&active_company_id=#session.ep.company_id#';
					
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] =  '#woc#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] ="window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#attributes.order_id#&print_type=91','WOC');";

				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=purchase.list_order";

				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
				if(not listfindnocase(denied_pages,'sales.popup_form_add_info_plus')){
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-info-circle']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.order_id#&type_id=-12','list');";
				}
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('main',345)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['onclick'] =  "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=order_id&action_id=#attributes.order_id#','Workflow')";

				if(not listfindnocase(denied_pages,'objects.popup_list_order_purchase_history')){
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getLang('main',61)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_history&order_id=#url.ORDER_ID#&portal_type=employee','project')";
				}
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-upload']['text'] = '#getLang('purchase',203)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-upload']['href'] = "#request.self#?fuseaction=purchase.emptypopup_export_order_excel&order_id=#attributes.order_id#";
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['text'] = '#detail#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=purchase.list_order&event=det&order_id=#attributes.order_id#";
		
				tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
			}
			// Det //	
			if(isdefined("attributes.event") and attributes.event is 'det')
			{
				
				denied_pages = caller.denied_pages;

				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();

				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',1577)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=purchase.list_order&event=add";
				
			
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['text'] = '#getLang('main',1578)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['href'] = '#request.self#?fuseaction=purchase.list_order&event=add&order_id=#url.order_id#&active_company_id=#session.ep.company_id#';
					
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['text'] =  '#getLang('main',62)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['onClick'] ="window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#attributes.order_id#&print_type=91','WOC');";

				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=purchase.list_order";

				if(not listfindnocase(denied_pages,'sales.popup_form_add_info_plus')){
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-info-circle']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.order_id#&type_id=-12','list');";
				}
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['text'] = '#getLang('main',345)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['onclick'] =  "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=order_id&action_id=#attributes.order_id#','Workflow')";

				if(not listfindnocase(denied_pages,'objects.popup_list_order_purchase_history')){
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-history']['text'] = '#getLang('main',61)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-history']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_history&order_id=#url.ORDER_ID#&portal_type=employee','project')";
				}
			
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getLang('main',52)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#attributes.order_id#";

				tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
			}
	}
</cfscript>