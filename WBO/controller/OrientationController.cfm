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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_orientation';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_orientation.cfm';	
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.popup_add_training_orientation';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/hr/form/add_orientation.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/query/add_orientation.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_orientation&event=upd&orientation_id=';	
		
		if(isdefined("attributes.orientation_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.popup_upd_training_orientation';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/form/upd_orientation.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/hr/query/upd_orientation.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.orientation_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_orientation&event=upd&orientation_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=hr.emptypopup_del_orientation&orientation_id=#attributes.orientation_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/query/del_orientation.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/query/del_orientation.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_orientation';
			
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_orientation";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.list_orientation&event=add');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_orientation";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'TRAINING_ORIENTATION';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ORIENTATION_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-ORIENTATION_HEAD','item-emp_name','item-start_date','item-finish_date']";

</cfscript>
