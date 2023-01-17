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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'worknet.list_demand';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/worknet/display/list_demand.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'worknet.add_demand';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/worknet/form/add_demand.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/worknet/query/add_demand.cfm';
		WOStruct['#attributes.fuseaction#']['add']['formAction'] = 'V16/worknet/query/worknet_demand.cfc?method=addDemand';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'worknet.list_demand&event=upd';
		
		if(isdefined("attributes.demand_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'worknet.detail_demand';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/worknet/form/detail_demand.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/worknet/query/upd_demand.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['formAction'] = 'V16/worknet/query/worknet_demand.cfc?method=updDemand';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.demand_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'worknet.list_demand&event=upd';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=worknet.del_demand&demand_id=#attributes.demand_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/worknet/query/del_demand.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/worknet/query/del_demand.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'worknet.list_demand';
			
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=worknet.list_demand";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=worknet.list_demand&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=worknet.list_demand";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
