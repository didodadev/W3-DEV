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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_standby';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_standby.cfm';
		WOStruct['#attributes.fuseaction#']['list']['addButton'] = 0;
		
		if(isdefined("attributes.sb_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.form_upd_standby';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/form/form_upd_standby.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/hr/query/upd_standby.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.sb_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_standby&event=upd&sb_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=hr.emptypopup_del_standby&sb_id=#attributes.sb_id#&head=##caller.get_position.employee_name## ##caller.get_position.employee_surname##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/query/del_standby.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/query/del_standby.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_standby';
		}
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.form_add_standby';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/form/form_add_standby.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/query/add_standby.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_standby&event=upd&sb_id=';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_standby";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_standby&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_standby";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EMPLOYEE_POSITIONS_STANDBY';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'SB_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-position_name','item-chief1_emp']";

</cfscript>
