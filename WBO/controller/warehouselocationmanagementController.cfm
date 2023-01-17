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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.location_management';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'v16/stock/display/warehouse_location_management.cfm';
		
		WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'stock.form_add_location_management';
		WOStruct['#attributes.fuseaction#']['det']['xmlfuseaction'] = 'stock.popup_location_management';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'v16/stock/display/warehouse_location_management_locations.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.form_add_location_management';
		WOStruct['#attributes.fuseaction#']['add']['xmlfuseaction'] = 'stock.popup_add_location_management';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'v16/stock/form/add_location_management.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'v16/stock/query/add_location_management.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.location_management&event=upd&management_id=';
		
		WOStruct['#attributes.fuseaction#']['upd_from_task'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd_from_task']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd_from_task']['fuseaction'] = 'stock.form_add_location_management';
		WOStruct['#attributes.fuseaction#']['upd_from_task']['xmlfuseaction'] = 'stock.popup_add_location_management';
		WOStruct['#attributes.fuseaction#']['upd_from_task']['filePath'] = 'v16/stock/query/add_location_management_from_task.cfm';
		
			
		if(isdefined("attributes.management_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.location_management';
			WOStruct['#attributes.fuseaction#']['upd']['xmlfuseaction'] = 'stock.popup_location_management';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'v16/stock/form/upd_location_management.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'v16/stock/query/upd_location_management.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.management_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.location_management&event=upd&management_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=stock.emptypopup_del_location_management&management_id=#attributes.management_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'v16/stock/query/del_location_management.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'v16/stock/query/del_location_management.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'stock.location_management';
		}
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'WAREHOUSE_TASKS_LOCATION_MANAGEMENT';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'MANAGEMENT_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-company','item-member_name','item-ship_method_id','item-transport_comp_id','item-transport_no1','item-location_id']";
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		getLang = caller.getLang;
		
		if(isdefined("attributes.event"))
		{
			if(attributes.event is 'upd')
			{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.location_management";
			}
			if(attributes.event is 'add')
			{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.location_management";
			}
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
</cfscript>
