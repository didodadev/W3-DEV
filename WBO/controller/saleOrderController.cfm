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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.list_order';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/sales/display/list_order.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'sales.form_add_order';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/sales/form/add_order.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/sales/query/add_order.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'sales.list_order&event=upd';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(detail_inv_menu);";
	
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'sales.form_add_order';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/sales/form/detail_order.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/sales/query/upd_order.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'sales.list_order&event=upd';
		WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'order_id=##attributes.order_id##';
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.order_id##';
		WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(detail_order);";

		WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'sales.form_add_order';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/sales/form/detail_sale_order_form.cfm';
		WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'sales.list_order&event=det';
		WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'order_id=##attributes.order_id##';
		WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.order_id##';
		WOStruct['#attributes.fuseaction#']['det']['js'] = "javascript:gizle_goster_basket(detail_order_form);";
	
		if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=sales.emptypopup_del_order&order_id=#order_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/sales/query/del_order.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/sales/query/del_order.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'sales.list_order';
		}
	}
	else
	{
		getLang = caller.getLang;
		
		//Add//
		if(isdefined("attributes.event") and attributes.event is 'add')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons'] = structNew();
					
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#getlang('sales',149)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['id'] = 'member_page';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['onClick'] = "open_member_page();";
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][1]['text'] = '#getlang('sales',607)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][1]['id'] = 'member_page_1';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][1]['onClick'] = "open_contract_page();";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['download']['text'] = '#veriaktarim#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['download']['onclick'] = "open_phl();";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['search']['text'] = '#getlang('main',153)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['search']['onclick'] = "openSearchForm('find_order_number','#getLang("main",799)#','find_order_f')";	

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=sales.list_order";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['fa fa-shopping-basket']['text'] = '#getLang('','',35366)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['fa fa-shopping-basket']['onclick'] = "openmodal()";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
	
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		// Upd //	
		if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			get_order_detail = caller.get_order_detail;
			get_ship_result = caller.get_ship_result;
			/* orderControl = caller.orderControlQuery; */
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			 
			 i = 0;
			if(get_ship_result.recordcount and  session.ep.isBranchAuthorization neq 1)
			{
				if(not len(get_ship_result.main_ship_fis_no))
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',364)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=stock.list_packetship&event=upd&ship_result_id=#get_ship_result.ship_result_id#";					
				}
				else
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',596)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "goto_page('#get_ship_result.main_ship_fis_no#')";
				}
				i = i +1;
			 }
			 else if(session.ep.isBranchAuthorization neq 1)
			 {
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('','Sevkiyat Planla	',65452)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=stock.popup_add_packetship&order_id=#attributes.order_id#&is_type=2','modal1','ui-draggable-box-large');";		
				i = i +1;
			 }
			
			 
			if(len(get_order_detail.offer_id)
			 and session.ep.isBranchAuthorization neq 1)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',133)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=sales.list_offer&event=upd&offer_id=#get_order_detail.offer_id#";
				i = i + 1;
				
			}	
			
			if(session.ep.isBranchAuthorization neq 1)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',366)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=credit.list_credit_contract&event=add&order_no=#get_order_detail.order_number#";
				i = i + 1;
			}	
			
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',368)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_cost&id=#url.order_id#&page_type=2&basket_id=#attributes.basket_id#','page_horizantal');";
			i = i + 1;
			
			
			denied_pages = caller.denied_pages;
			if(len(get_order_detail.paymethod) and not listfindnocase(denied_pages,'objects.popup_payment_with_voucher'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',306)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "openVoucher();";
				i = i + 1;
			}
			
			if(not listfindnocase(denied_pages,'purchase.add_order_product_all_criteria'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',372)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=purchase.add_order_product_all_criteria&order_id=#attributes.order_id#&active_company_id=#session.ep.company_id#&from_sale_order=1";
				i = i + 1;
			}
			if(IsDefined("get_order_detail.company_id") and len(get_order_detail.company_id))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',163)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_order_detail.company_id#','medium')";
				i = i + 1;
			}
			else if(IsDefined("get_order_detail.consumer_id") and len(get_order_detail.consumer_id))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',163)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_order_detail.consumer_id#','medium')";
				i = i + 1;
			}

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('','Paketleme',63751)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=stock.packeting&event=add&order_id=#url.order_id#";
			i = i + 1;
			
			fuse_ = "invoice";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',373)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=#fuse_#.form_add_bill&order_id=#attributes.order_id#";
			/* if(isdefined("orderControl.status") and orderControl.status gt 0)
			{
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "orderControl('#orderControl.SHIP_NUMBER#')";
			}
			else
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=#fuse_#.form_add_bill&order_id=#attributes.order_id#";
			} */
			i = i + 1;
			
			if(session.ep.our_company_info.workcube_sector is 'it' and get_order_detail.is_processed eq 1)
			{
				if(get_ship_result.ozel_kod_2 eq 'YURTICI KARGO')
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',369)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_cargo_information&cargo_type=1&order_number=#get_order_detail.order_number#','horizantal','popup_cargo_information');";
					i = i + 1;
				}
				else if( get_ship_result.ozel_kod_2 eq 'UPS')
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',370)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('http://www.ups.com.tr/PMusteriRefSorguSonuc.asp?musterikodu=#get_our_company_info.cargo_customer_code#&referansNo=#get_ship_result.ship_fis_no#&g1=#g1#&a1=#a1#&y1=#y1#&g2=#g2#&a2=#a2#&y2=#y2#','horizantal','popup_cargo_information');";
					i = i + 1;
				}
			}
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getlang('main',170)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_order&event=add";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#getlang('main',1578)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=sales.list_order&event=add&order_id=#url.order_id#&active_company_id=#session.ep.company_id#';
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] =  '#getlang('main',62)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] ="window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#url.order_id#&print_type=73','WOC');";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=sales.list_order";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-shopping-basket']['text'] = '#getLang('','',35366)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-shopping-basket']['onclick'] = "openmodal()";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=order_id&action_id=#attributes.order_id#&wrkflow=1','Workflow')";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-info-circle']['text'] = '#getlang('main',398)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-info-circle']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#get_order_detail.order_id#&type_id=-7','list');";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getlang('main',61)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_history&order_id=#url.ORDER_ID#&portal_type=employee','project')";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['text'] = '#getlang('main',359)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_order&event=det&order_id=#attributes.order_id#";

			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}

		if(isdefined("attributes.event") and attributes.event is 'det')
		{
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();
			 
		
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['text'] = '#getlang('main',170)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_order&event=add";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['text'] = '#getlang('main',1578)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['href'] = '#request.self#?fuseaction=sales.list_order&event=add&order_id=#url.order_id#&active_company_id=#session.ep.company_id#';
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['text'] =  '#getlang('main',62)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['onClick'] ="window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#url.order_id#&print_type=73','WOC');";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=sales.list_order";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=order_id&action_id=#attributes.order_id#&wrkflow=1','Workflow')";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-info-circle']['text'] = '#getlang('main',398)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-info-circle']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#url.ORDER_ID#&type_id=-7','list');";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-history']['text'] = '#getlang('main',61)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-history']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_history&order_id=#url.ORDER_ID#&portal_type=employee','project')";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getLang('main',52)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_order&event=upd&order_id=#attributes.order_id#";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		/*WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
		WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'saleOrderController';
		WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'list,add,upd';
		WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ORDERS';
		WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-order_head','item-company_id','item-order_date']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
		*/
		WOStruct['#attributes.fuseaction#']['print'] = structNew();
		WOStruct['#attributes.fuseaction#']['print']['cfcName'] = 'listOrderPrint';
		WOStruct['#attributes.fuseaction#']['print']['identity'] = 'order_id';
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'ORDER';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ORDER_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-order_head','item-member_name','item-order_employee','item-order_date','item-deliverdate']";

</cfscript>