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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.list_command';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/stock/display/list_command.cfm';	
		
		WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'stock.detail_order';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/stock/display/detail_order.cfm';
		WOStruct['#attributes.fuseaction#']['det']['identity'] = '##attributes.order_id##';
		WOStruct['#attributes.fuseaction#']['det']['js'] = "javascript:gizle_goster_ikili('detail_order','detail_order_bask');";
		
		WOStruct['#attributes.fuseaction#']['detp'] = structNew();
		WOStruct['#attributes.fuseaction#']['detp']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['detp']['fuseaction'] = 'stock.detail_orderp';
		WOStruct['#attributes.fuseaction#']['detp']['filePath'] = 'V16/stock/display/detail_orderp.cfm';
		WOStruct['#attributes.fuseaction#']['detp']['identity'] = '##attributes.order_id##';
		WOStruct['#attributes.fuseaction#']['detp']['js'] = "javascript:gizle_goster_basket(detail_orderp);";	
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		

		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'det')
		{
			get_order_detail = caller.get_order_detail;
			GET_ORDERS_INVOICE = caller.GET_ORDERS_INVOICE;
			GET_ORDERS_SHIP = caller.GET_ORDERS_SHIP;
			denied_pages = caller.denied_pages;
			tabMenuStruct['#fuseactController#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'] = structNew();
			
			i=0;
			if (not GET_ORDERS_INVOICE.recordcount)
			{
				if (get_order_detail.order_zone eq 1)
				{
					if (get_order_detail.purchase_sales eq 0)
					{
						tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main',2597)#';
						tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=stock.form_add_purchase&order_id=#attributes.order_id#";
						i= i+1;
					}
				}else 
				{
					if (get_order_detail.purchase_sales eq 1)
					{
						tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('','Sevk Et',45593)#';
						tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=stock.form_add_sale&order_id=#attributes.order_id#";
						i= i+1;
					}
				}
			}
		
			if (not GET_ORDERS_SHIP.recordcount or GET_ORDERS_INVOICE.recordcount neq 0)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('','Fatura Kes',45595)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=invoice.form_add_bill&order_id=#attributes.order_id#";
				i= i+1;
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			if (not listfindnocase(denied_pages,'objects.popup_list_order_history'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-history']['text'] = '#getlang('main',61)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-history']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_history&order_id=#url.ORDER_ID#&portal_type=employee','project')";
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['archive']['text'] = '#getLang('main',156)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['archive']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_pursuits_documents_plus&action_id=#attributes.order_id#&pursuit_type=is_sale_order','medium');";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_command";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.order_id#&print_type=73','page');";
		
		}
		else if(caller.attributes.event is 'detp')
		{
			get_order_detail = caller.get_order_detail;
			GET_ORDERS_INVOICE = caller.GET_ORDERS_INVOICE;
			GET_ORDERS_SHIP = caller.GET_ORDERS_SHIP;
			denied_pages = caller.denied_pages;
			tabMenuStruct['#fuseactController#']['tabMenus']['detp'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['detp']['menus'] = structNew();
			
			i= 0;
			if (not GET_ORDERS_INVOICE.recordcount)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['detp']['menus'][i]['text'] = '#getLang('stock',156)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['detp']['menus'][i]['href'] = "#request.self#?fuseaction=stock.form_add_purchase&order_id=#attributes.order_id#";
				i= i+1;
			}
		
			if (not GET_ORDERS_SHIP.recordcount or GET_ORDERS_INVOICE.recordcount neq 0)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['detp']['menus'][i]['text'] = '#getLang('main',2596)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['detp']['menus'][i]['href'] = "#request.self#?fuseaction=invoice.form_add_bill&order_id=#attributes.order_id#";
				i= i+1;
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['detp']['icons'] = structNew();
			if (not listfindnocase(denied_pages,'objects.popup_list_order_purchase_history'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['detp']['icons']['fa fa-history']['text'] = '#getlang('main',61)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['detp']['icons']['fa fa-history']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_history&order_id=#url.ORDER_ID#&portal_type=employee','project')";
			}
			if(not listfindnocase(denied_pages,'purchase.popup_list_pluses_order') and session.ep.isBranchAuthorization eq 0)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['detp']['icons']['archive']['text'] = '#getLang('main',156)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['detp']['icons']['archive']['onClick'] = "windowopen('#request.self#?fuseaction=purchase.popup_list_pluses_order&order_id=#attributes.order_id#','medium');";
				
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['detp']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['detp']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['detp']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_command";
			tabMenuStruct['#fuseactController#']['tabMenus']['detp']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['detp']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['detp']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['detp']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.order_id#&print_type=91','page');";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>
