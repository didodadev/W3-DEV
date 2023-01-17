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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.list_workstation';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/production_plan/display/list_workstation.cfm';
		
		if(isdefined("attributes.station_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'prod.upd_workstation';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/production_plan/display/upd_workstation.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/production_plan/query/upd_workstation.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.station_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'prod.list_workstation&event=upd&station_id=';
			
		}
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.popup_add_workstation';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/production_plan/display/add_workstation.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/production_plan/query/add_workstation.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'prod.list_workstation&event=upd&station_id=';
		
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
			tabMenuStruct['#fuseactController#']['tabMenus']['popup_add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['popup_add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['popup_add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['popup_add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=prod.list_workstation";
			tabMenuStruct['#fuseactController#']['tabMenus']['popup_add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['popup_add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		else if(caller.attributes.event is 'upd')
		{
			
			denied_pages = caller.denied_pages;
			GET_WORKSTATION_DETAIL.STATION_NAME =caller.GET_WORKSTATION_DETAIL.STATION_NAME;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=prod.list_workstation&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=prod.list_workstation";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['href'] = '#request.self#?fuseaction=objects.popup_print_files&print_type=250&action_type=#attributes.station_id#&action_id=#attributes.station_id#';
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['href'] = '#request.self#?fuseaction=objects.workflowpages&tab=3&action=myhome.my_extre&action_name=station_id&action_id=#attributes.station_id#';

			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			i=0;
			
			
			if (not listfindnocase(denied_pages,'product.popup_list_product_workstations'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('prod',1)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=prod.popup_list_product_workstations&station_id=#attributes.station_id#&station_name=#GET_WORKSTATION_DETAIL.STATION_NAME#','page');";
				i++;
			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('prod',339)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=prod.popup_list_workstation_orders&station_id=#attributes.station_id#','list');";
			i++;
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'WORKSTATIONS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'STATION_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-STATION_NAME','item-branch_id','item-department_id','item-exit_location_id','item-energy','item-production_location_id','item-workstation',]";
	
</cfscript>

<!---<cf_np tablename="WORKSTATIONS" primary_key = "STATION_ID" pointer="STATION_ID=#attributes.station_id#" dsn_var="DSN3">--->