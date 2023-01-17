<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.list_departments';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/stock/display/list_department.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.popup_add_department';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/stock/display/add_department.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/stock/query/add_department.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.list_departments&event=upd&camp_id=';
		
		if(isdefined("attributes.department_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.popup_department_upd';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/stock/display/upd_department.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/stock/query/upd_department.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.department_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.list_departments&event=upd&camp_id=';
		}
		
		if(isdefined("attributes.department_id"))
		{
			WOStruct['#attributes.fuseaction#']['add_stock_location'] = structNew();
			WOStruct['#attributes.fuseaction#']['add_stock_location']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['add_stock_location']['fuseaction'] = 'stock.popup_add_stock_location';
			WOStruct['#attributes.fuseaction#']['add_stock_location']['filePath'] = 'V16/stock/display/add_stock_location.cfm';
			WOStruct['#attributes.fuseaction#']['add_stock_location']['queryPath'] = 'V16/stock/query/add_stock_location.cfm';
			WOStruct['#attributes.fuseaction#']['add_stock_location']['nextEvent'] = 'stock.list_departments';
		}
		
		if(isdefined("attributes.location_id") and isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['upd_stock_location'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd_stock_location']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['upd_stock_location']['fuseaction'] = 'stock.popup_upd_stock_location';
			WOStruct['#attributes.fuseaction#']['upd_stock_location']['filePath'] = 'V16/stock/display/upd_stock_location.cfm';
			WOStruct['#attributes.fuseaction#']['upd_stock_location']['queryPath'] = 'V16/stock/query/upd_stock_location.cfm';
			WOStruct['#attributes.fuseaction#']['upd_stock_location']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd_stock_location']['nextEvent'] = 'stock.list_departments';
		}	
		
		
		
		if(isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')){
			WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
			WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'DEPARTMENT';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'DEPARTMENT_ID';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-department_head','item-admin1']";
		}
		else if(isdefined("attributes.event") and (attributes.event is 'add_stock_location' or attributes.event is 'upd_stock_location')){
			WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
			WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add_stock_location,upd_stock_location';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'STOCKS_LOCATION';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ID';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-department_id','item-location_id','item-comment']";
		}
	}
	else
	{	
		getLang = caller.getLang;
		
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(isdefined("attributes.event") and (attributes.event is 'add'))
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_departments";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
		}
		else if(isdefined("attributes.event") and (attributes.event is 'add_stock_location'))
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add_stock_location'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add_stock_location']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add_stock_location']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add_stock_location']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['add_stock_location']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add_stock_location']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_departments";
			tabMenuStruct['#fuseactController#']['tabMenus']['add_stock_location']['icons']['list-ul']['target'] = "_blank";
		}
		else if(isdefined("attributes.event") and (attributes.event is 'upd'))
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_departments";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onclick'] = "windowopen('#request.self#?fuseaction=stock.list_departments&event=add','medium')";
		}
		else if(isdefined("attributes.event") and (attributes.event is 'upd_stock_location'))
		{
			get_det_stock_location = caller.get_det_stock_location;
			denied_pages = caller.denied_pages;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_stock_location'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_stock_location']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_stock_location']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_stock_location']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_stock_location']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_stock_location']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_departments";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_stock_location']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_stock_location']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_stock_location']['icons']['add']['onclick'] = "windowopen('#request.self#?fuseaction=stock.list_departments&event=add_stock_location&department_id=#get_det_stock_location.department_id#','medium')";
		
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_stock_location']['menus'] = structNew();
			
			if(not listfindnocase(denied_pages,'product.popup_list_stock_location_period')){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd_stock_location']['menus'][0]['text'] = '#getLang('main',1399)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd_stock_location']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=stock.popup_list_stock_location_period&id=#attributes.id#','list');";
			}
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
		
	}
</cfscript>