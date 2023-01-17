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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#listfirst(attributes.fuseaction,'.')#.list_multi_provision';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/bank/display/list_multi_provision.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#listfirst(attributes.fuseaction,'.')#.popup_add_multi_provision';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/bank/form/add_multi_provision.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/bank/query/multi_provision_file.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('payroll_entry_return','payroll_entry_return_bask');";	
		
		WOStruct['#attributes.fuseaction#']['file'] = structNew();
		WOStruct['#attributes.fuseaction#']['file']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['file']['fuseaction'] = '#listfirst(attributes.fuseaction,'.')#.popup_open_multi_prov_file';
		WOStruct['#attributes.fuseaction#']['file']['filePath'] = 'V16/bank/form/open_multi_prov_file.cfm';
		WOStruct['#attributes.fuseaction#']['file']['queryPath'] = '';
		WOStruct['#attributes.fuseaction#']['file']['nextEvent'] = '';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_multi_provision";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);	
	}
	
</cfscript>
