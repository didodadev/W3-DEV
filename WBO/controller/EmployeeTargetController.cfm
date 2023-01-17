<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
	
			WOStruct['#attributes.fuseaction#']['default'] = 'list';
			if(not isdefined('attributes.event')){
				attributes.event = WOStruct['#attributes.fuseaction#']['default'];
			}
			WOStruct['#attributes.fuseaction#']['list'] = structNew();
			WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.targets';
			WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_targets.cfm';
		
		
	
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.targets&event=add';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/objects/form/form_add_target.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/objects/query/add_target.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.targets&event=upd&target_id=';
	
		if(isdefined("attributes.target_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.targets&event=upd';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/objects/form/form_upd_target.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/objects/query/upd_target.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.target_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.targets&event=upd&target_id=';

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.targets';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/objects/query/del_target.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/objects/query/del_target.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.targets';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.targets";
		}
		else if(caller.attributes.event is 'upd')
		{

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.targets&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.targets";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>