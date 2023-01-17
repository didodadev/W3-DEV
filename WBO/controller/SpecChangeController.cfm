<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		
		if(not isDefined("attributes.event"))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.form_add_spec_exchange';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/stock/form/form_add_spec_exchange.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/stock/query/add_spec_exchange.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.form_add_spec_exchange&event=upd&exchange_id=';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('spec_exchange','spec_exchange_bask')";
		
		if(isdefined("attributes.exchange_id"))				
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.form_upd_spec_exchange';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/stock/form/form_upd_spec_exchange.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/stock/query/upd_spec_exchange.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.form_add_spec_exchange&event=upd&exchange_id=';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.exchange_id#';	
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('spec_exchange','spec_exchange_bask');";
			
			if(listFind('upd,del',attributes.event))
				{
					WOStruct['#attributes.fuseaction#']['del'] = structNew();
					WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
					WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#fusebox.circuit#.emptypopup_del_spec_exchange&exchange_id=#attributes.exchange_id#&process_type=##caller.GET_STOCK_EXCHANGE.PROCESS_CAT##';
					WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/stock/query/del_spec_exchange.cfm';
					WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/stock/query/del_spec_exchange.cfm';
					WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'stock.form_add_spec_exchange';
				}
		}
	}
	else
	{
		getLang = caller.getLang;
		
		if(attributes.event is 'add')
		{
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		if(attributes.event is 'upd')
		{
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=stock.form_add_spec_exchange";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'STOCK_EXCHANGE';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'exchange_id';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-exchange_no_','item-product_name','item-location_id']";
</cfscript>