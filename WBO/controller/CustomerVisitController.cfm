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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.list_visit';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/sales/display/list_visit.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'sales.form_add_visit';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/sales/form/form_add_visit.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/sales/query/add_warning.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'sales.list_visit&event=upd&visit_id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_event';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('add_visit','add_visit_bask');";
	
		if(isdefined("attributes.visit_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'sales.form_upd_visit';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/sales/form/form_upd_visit.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/sales/query/upd_warning.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.visit_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'sales.list_visit&event=upd&visit_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('form_upd_visit','form_upd_visit_bask');";
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=sales.emptypopup_del_visit&id=##caller.get_event_plan.event_plan_id##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/sales/query/del_visit.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/sales/query/del_visit.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'sales.list_visit';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=sales.list_visit";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=sales.list_visit&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=sales.list_visit";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=sales.list_visit&event=add&visit_id=#attributes.visit_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EVENT_PLAN';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'EVENT_PLAN_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-warning_head','item-sales_zones','item-main_dates']";
	

</cfscript>