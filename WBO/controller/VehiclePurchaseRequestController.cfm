<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();

		WOStruct['#attributes.fuseaction#'] = structNew();

		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'assetcare.add_vehicle_purchase_request';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/assetcare/form/add_vehicle_purchase_request.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/assetcare/query/add_vehicle_purchase_request.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'assetcare.upd_vehicle_purchase_request&event=upd&request_row_id=';

		if(isdefined("attributes.request_row_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'assetcare.upd_vehicle_purchase_request&event=upd&request_row_id=';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/assetcare/form/upd_vehicle_purchase_request.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/assetcare/query/upd_vehicle_purchase_request.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.request_row_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'assetcare.upd_vehicle_purchase_request&event=upd&request_row_id=';

		}

		if(listFind('upd,del',attributes.event))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'assetcare.emptypopup_del_vehicle_purchase_request&request_row_id=#attributes.request_row_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/assetcare/query/del_vehicle_purchase_request.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/assetcare/query/del_vehicle_purchase_request.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'assetcare.vehicle_request_search';
		}
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=assetcare.vehicle_request_search";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main','Ekle',57582)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=assetcare.add_vehicle_purchase_request&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=assetcare.vehicle_request_search";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=request_id&action_id=#attributes.request_id#&wrkflow=1','Workflow')";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] =  '#getlang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] ="window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#attributes.request_row_id#&print_type=251','WOC');";
		}

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>

