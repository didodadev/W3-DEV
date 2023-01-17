<cfscript>

	if(attributes.tabMenuController eq 0)
	{	
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'salesplan.list_sales_plan_quotas';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/salesplan/display/list_sales_plan_quotas.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'salesplan.form_add_sales_plan_quota';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/salesplan/form/add_sales_plan_quota.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/salesplan/query/add_sales_plan_quota.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'salesplan.list_sales_plan_quotas&event=upd';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('sales_plan','sales_plan_bask');";
		
		if(isdefined("attributes.plan_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'salesplan.form_upd_sales_plan_quota';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/salesplan/form/upd_sales_plan_quota.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/salesplan/query/upd_sales_plan_quota.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.plan_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'salesplan.list_sales_plan_quotas&event=upd&plan_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('sales_plan','sales_plan_bask');";
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=salesplan.emptypopup_del_sales_plan_quota&plan_id=#attributes.plan_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/salesplan/query/del_sales_plan_quota.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/salesplan/query/del_sales_plan_quota.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'salesplan.list_sales_plan_quotas';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=salesplan.list_sales_plan_quotas";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-download']['text'] = '#getLang('','',59030)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-download']['onClick'] = "open_file()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=salesplan.list_sales_plan_quotas&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=salesplan.list_sales_plan_quotas";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>