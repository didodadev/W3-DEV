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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_product_cost';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/product/display/list_product_cost.cfm';
		
		
		if(isdefined("attributes.pid"))
		{
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'product.form_add_product_cost';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/product/form/form_add_product_cost.cfm';
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '/V16/product/query/add_product_cost.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.pid#';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'product.list_product_cost&event=det&pid=';
		}
		if(isdefined("attributes.pcid"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.popup_form_upd_product_cost';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/cheque/form/upd_payroll_entry_return.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/cheque/query/upd_payroll_entry_return.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.pcid#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_product_cost&event=det&pid=';
		}
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
			get_stock.recordcount = caller.get_stock.recordcount;
			denied_pages = caller.denied_pages;
						
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_product_cost";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'] = structNew();
			i=0;
			
			if (get_stock.recordcount)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('prod',52)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#caller.get_stock.STOCK_ID#";
				i++;
				
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',74)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=prod.popup_list_prod_tree_costs&stock_id=#caller.get_stock.stock_id#')";
				i++;
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',121)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=stock.list_stock&event=det&pid=#url.pid#";
			i++;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',105)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=product.list_price_change&event=det&pid=#url.pid#";
			i++;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main',1352)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=product.list_product&event=det&pid=#attributes.pid#";
			i++;
			
			if (not listfindnocase(denied_pages,'product.detail_product_price'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',281)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_list_product_cost_detail&pid=#attributes.pid#','horizantal')";
				i++;
			}
				
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'det,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PRODUCT_COST';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'COST_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "";
</cfscript>
