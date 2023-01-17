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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_price_change';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/product/display/list_price_change.cfm';

        if(isdefined("attributes.pid"))
        {
            WOStruct['#attributes.fuseaction#']['add'] = structNew();
            WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
            WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.popup_add_price_request';
            WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/product/form/add_price_change_request.cfm';
            WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/product/query/add_price_change.cfm';
            WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_price_change&event=det&pid=';
            WOStruct['#attributes.fuseaction#']['add']['formName'] = 'price';
        }

		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.popup_form_upd_price_request';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/product/form/upd_price_change_request.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/product/query/upd_price_change.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_price_change&event=upd&id=&pid=';
		}

		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PRICE_CHANGE';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PRICE_CHANGE_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-unit_id','item-date']";

        WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'product.detail_product_price';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/product/display/detail_product_price.cfm';	
		WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.pid##';
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'add')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_price_change";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=product.list_price_change&event=add&pid=#attributes.pid#','page');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_price_change";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
        else if(caller.attributes.event is 'det')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=product.list_price_change&event=add&pid=#attributes.pid#','page');";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_price_change";

            tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['text'] = '#getLang('','main',44019)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['href'] = "#request.self#?fuseaction=product.list_product&event=det&pid=#attributes.pid#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][1]['text'] = '#getLang('','main',57452)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][1]['href'] = "#request.self#?fuseaction=stock.list_stock&event=det&pid=#attributes.pid#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][2]['text'] = '#getLang('main',846)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][2]['href'] = "#request.self#?fuseaction=product.list_product_cost&event=det&pid=#attributes.pid#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][3]['text'] = '#getLang('product',188)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][3]['onClick'] = "javascript:openBoxDraggable('#request.self#?fuseaction=product.popup_std_sale&pid=#attributes.pid#');";

		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>
