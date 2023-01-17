<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isDefined("attributes.event"))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.list_stock';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/stock/display/list_stock.cfm';
		
		if(isdefined("attributes.pid"))
		{
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'stock.detail_stock';
			WOStruct['#attributes.fuseaction#']['det']['xmlfuseaction'] = 'stock.detail_stock';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/stock/display/detail_stock.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.pid#';
		}
	}
	else
	{
		getLang = caller.getLang;
		
		if(attributes.event is 'det')
		{
			denied_pages = caller.denied_pages;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();
			if (not listfindnocase(denied_pages,'stock.detail_stock_popup'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['text'] = '#getlang('','Hareketler',57919)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=stock.detail_stock_popup&pid=#attributes.pid#')";

			}

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['text'] = '#getlang('','Ürünler',57657)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['href'] = "#request.self#?fuseaction=product.list_product&event=det&pid=#attributes.pid#";

			if (not listfindnocase(denied_pages,'stock.popup_list_product_spects'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['text'] = '#getlang('','Spekt',57647)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=stock.popup_list_product_spects&pid=#attributes.pid#&department_id=');";

			}

			if ( not listfindnocase(denied_pages,'stock.detail_store_stock_popup'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][3]['text'] = '#getlang('','Lokasyonlar',45221)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][3]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=stock.detail_store_stock_popup&pid=#pid#')";

			}
			if ( not listfindnocase(denied_pages,'product.form_add_product_cost'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][4]['text'] = '#getlang('','Maliyet',58258)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][4]['href'] = "#request.self#?fuseaction=product.list_product_cost&event=det&pid=#url.pid#";

			}
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][5]['text'] = '#getlang('','Fiyatlar',29411)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][5]['href'] = "#request.self#?fuseaction=product.list_price_change&event=det&pid=#attributes.pid#";


			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['chart']['text'] = '#getlang('','Toplam Stoklar',63826)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['chart']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=stock.popup_stock_graph_ajax&pid=#pid#&stock_code=#caller.get_product.product_code#')";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('','uyarılar',57757)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['href'] = "#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_id=#attributes.pid#";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['target'] ="_blank";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('','Liste',57509)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_stock";

		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>