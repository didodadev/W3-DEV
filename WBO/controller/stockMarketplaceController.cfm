<cfsavecontent variable="veriaktarim"><cf_get_lang dictionary_id="60009.Veri Aktarım"></cfsavecontent>
<cfscript>
	if(attributes.tabMenuController eq 0)
	{
				// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		
		if(isdefined("attributes.ship_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.add_marketplace_ship';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/stock/form/upd_marketplace_ship.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/stock/query/upd_marketplace_ship.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.ship_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.add_marketplace_ship&event=upd&ship_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(marketplace_ship);";
		}

				
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.add_marketplace_ship';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/stock/form/add_marketplace_ship.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/stock/query/add_marketplace_ship.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.add_marketplace_ship&event=upd&ship_id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_purchase';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(marketplace_ship)";
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SHIP';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'SHIP_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-partner_name','item-ship_number','item-location_id']";
		
		if(isdefined("attributes.ship_id"))
		{
		WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'stock.add_marketplace_ship';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/stock/form/form_det_purchase.cfm';
		WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.ship_id#';
		WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'stock.add_marketplace_ship&event=det&ship_id=';
		}
		if(isdefined("attributes.event") and (attributes.event is "upd" or attributes.event is "del"))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_marketplace_ship&active_period=#session.ep.period_id#&ship_id=#attributes.ship_id#&upd_id=#attributes.ship_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/stock/query/upd_marketplace_ship.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/stock/query/upd_marketplace_ship.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_purchase';
	
		}
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		// Upd //
		getLang = caller.getLang;
	
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

		if(caller.attributes.event is 'add' )
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_purchase";
		}
		if(isdefined("attributes.event") and attributes.event is 'upd')
		{

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_purchase";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main','62')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.ship_id#&print_type=30','page','workcube_print');";	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_marketplace_ship&is_ship_copy=1&event=add&ship_id=#url.ship_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['text'] = '#getLang('main',359)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=stock.add_marketplace_ship&event=det&ship_id=#attributes.ship_id#";	
		}
		
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
		
</cfscript>