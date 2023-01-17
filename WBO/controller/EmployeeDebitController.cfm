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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_inventory_zimmet';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_inventory_zimmet.cfm';
	
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.popup_add_inventory_zimmet';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/hr/form/add_inventory_zimmet.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/hr/query/add_inventory_zimmet.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_inventory_zimmet&event=upd&zimmet_id=';

		if(isdefined("attributes.zimmet_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.popup_upd_inventory_zimmet';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/hr/form/upd_inventory_zimmet.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/hr/query/upd_inventory_zimmet.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.zimmet_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_inventory_zimmet&event=upd&zimmet_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=ehesap.emptypopup_del_zimmet_rows&zimmet_id=#attributes.zimmet_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/hr/ehesap/query/del_zimmet_rows.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/V16/hr/ehesap/query/del_zimmet_rows.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_inventory_zimmet';
		}
		

		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EMPLOYEES_INVENT_ZIMMET';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ZIMMET_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-employee','item-process','item-company']";

	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		getLang = caller.getLang;
		
		// Upd //
		if(isdefined("attributes.event") and attributes.event is 'add')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_inventory_zimmet";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
		}
		else if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_inventory_zimmet";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onclick'] = "window.location.href = '#request.self#?fuseaction=hr.list_inventory_zimmet&event=add';";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";	
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
</cfscript>
