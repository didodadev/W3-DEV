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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'settings.warehouse_rates';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/settings/display/list_warehouse_rates.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.form_add_warehouse_rate';
		WOStruct['#attributes.fuseaction#']['add']['xmlfuseaction'] = 'settings.popup_add_warehouse_rate';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/settings/form/add_warehouse_rate.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/settings/query/add_warehouse_rate.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.list_warehouse_rates&event=upd&rate_id=';
		

		
		if(isdefined("attributes.rate_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.list_warehouse_rates';
			WOStruct['#attributes.fuseaction#']['upd']['xmlfuseaction'] = 'settings.popup_warehouse_rate';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/settings/form/upd_warehouse_rate.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/settings/query/upd_warehouse_rate.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.rate_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'settings.list_warehouse_rates&event=upd&rate_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=settings.list_warehouse_rates&event=upd&is_dlt=1&rate_id=#attributes.rate_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/settings/query/del_warehouse_rate.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/settings/query/del_warehouse_rate.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'settings.list_warehouse_rates';
		}
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'WAREHOUSE_RATES';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'RATE_ID';
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		getLang = caller.getLang;
		
		if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=settings.list_warehouse_rates&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "blank_";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "blank_";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=settings.list_warehouse_rates";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=settings.list_warehouse_rates&event=upd&is_copy=1&rate_id=#attributes.rate_id#";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onclick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.rate_id#&print_type=1001','page');";
		}
		else
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "blank_";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=settings.list_warehouse_rates";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
</cfscript>
