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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.list_warehouse_tasks';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'v16/stock/display/list_warehouse_tasks.cfm';
		
		WOStruct['#attributes.fuseaction#']['monthly_report'] = structNew();
		WOStruct['#attributes.fuseaction#']['monthly_report']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['monthly_report']['fuseaction'] = 'stock.list_warehouse_tasks_monthly_report';
		WOStruct['#attributes.fuseaction#']['monthly_report']['filePath'] = 'v16/stock/display/list_warehouse_tasks_monthly_report.cfm';
		
		WOStruct['#attributes.fuseaction#']['monthly_report2'] = structNew();
		WOStruct['#attributes.fuseaction#']['monthly_report2']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['monthly_report2']['fuseaction'] = 'stock.list_warehouse_tasks_monthly_report2';
		WOStruct['#attributes.fuseaction#']['monthly_report2']['filePath'] = 'v16/stock/display/list_warehouse_tasks_monthly_report2.cfm';
		
		WOStruct['#attributes.fuseaction#']['get_services'] = structNew();
		WOStruct['#attributes.fuseaction#']['get_services']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['get_services']['fuseaction'] = 'stock.form_add_warehouse_task';
		WOStruct['#attributes.fuseaction#']['get_services']['xmlfuseaction'] = 'stock.popup_add_warehouse_task';
		WOStruct['#attributes.fuseaction#']['get_services']['filePath'] = 'v16/stock/form/add_warehouse_task_services.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.form_add_warehouse_task';
		WOStruct['#attributes.fuseaction#']['add']['xmlfuseaction'] = 'stock.popup_add_warehouse_task';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'v16/stock/form/add_warehouse_task.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'v16/stock/query/add_warehouse_task.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.list_warehouse_tasks&event=upd&task_id=';
		
		
		
		if(isdefined("attributes.task_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.list_warehouse_tasks';
			WOStruct['#attributes.fuseaction#']['upd']['xmlfuseaction'] = 'stock.popup_warehouse_task';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'v16/stock/form/upd_warehouse_task.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'v16/stock/query/upd_warehouse_task.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.task_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.list_warehouse_tasks&event=upd&task_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=stock.emptypopup_del_warehousetask&task_id=#attributes.task_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'v16/stock/query/del_warehouse_task.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'v16/stock/query/del_warehouse_task.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'stock.list_warehouse_tasks';
		}
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'WAREHOUSE_TASKS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'TASK_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-company','item-member_name','item-ship_method_id','item-transport_comp_id','item-transport_no1','item-location_id']";
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		getLang = caller.getLang;
		
		if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=stock.list_warehouse_tasks&action_type=copy&event=add&task_id=#attributes.task_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.task_id#&print_type=1002','WOC');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_warehouse_tasks";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['chart']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['chart']['text'] = '#getLang('','3PL Depo İçi İşlem',63840)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['chart']['href'] = "#request.self#?fuseaction=stock.location_management&event=upd_from_task&task_id=#attributes.task_id#";
		}
		else
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['file']['text'] = '#getLang('assetcare',493)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['file']['onClick'] = "UploadFromFile()";	
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_warehouse_tasks";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
</cfscript>
