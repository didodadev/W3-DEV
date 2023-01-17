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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_assetp';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/myhome/display/list_assetp.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.list_assetp&event=add';
		WOStruct['#attributes.fuseaction#']['add']['filepath'] = '/V16/correspondence/form/add_assetp_demand.cfm';
		WOStruct['#attributes.fuseaction#']['add']['querypath'] = '/V16/correspondence/query/add_assetp_demand.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextevent'] = 'myhome.list_assetp';
		if(isdefined("attributes.demand_id")){
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'myhome.list_assetp&event=upd';
			WOStruct['#attributes.fuseaction#']['upd']['filepath'] = '/V16/myhome/form/form_upd_assetp_demand.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['querypath'] = '/V16/myhome/query/upd_assetp_demand.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextevent'] = 'myhome.list_assetp&event=upd&demand_id=';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.demand_id#';

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'assetcare.emptypopup_del_assetp_demand';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/assetcare/query/del_assetp_demand.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/assetcare/query/del_assetp_demand.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'assetcare.list_assetp_demands';
		}
		
	} else {
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		
		if(caller.attributes.event eq 'add')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_self";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=myhome.list_assetp";

			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if (caller.attributes.event eq 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_self";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=myhome.list_assetp";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=assetcare.list_assetp_demands&action_name=assetp_id&action_id=#attributes.demand_id#','Workflow')";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

			
		
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-result']['icons']['print']['target'] = '_blank';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-result']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd-result']['icons']['print']['href'] = "#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.demand_id#&print_type=186";
		
		}

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

	
</cfscript>
