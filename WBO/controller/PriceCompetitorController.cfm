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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_rival_product_prices';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/product/display/list_rival_product_price.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.popup_form_add_rival_product_price';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/product/form/add_rival_product_price.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/product/query/add_rival_product_price.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_rival_product_prices';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'price';
	
		if(isdefined("attributes.pr_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.popup_form_upd_rival_product_price';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/product/form/upd_rival_product_price.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/product/query/upd_rival_product_price.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.pr_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_rival_product_prices&event=upd&pr_id=&pid=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=product.emptypopup_del_rival_product_price&pr_id=#pr_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/product/query/del_rival_product_price.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/V16/product/query/del_rival_product_price.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'product.list_rival_product_prices';

				
		}

		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PRICE_RIVAL';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PR_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-txt_product','item-r_id','item-price','item-startdate']";
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_rival_product_prices";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=product.list_rival_product_prices&event=add','small');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_rival_product_prices";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>
