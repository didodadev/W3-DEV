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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'salesplan.list_sales_team';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/salesplan/display/list_sales_team.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'salesplan.popup_add_sales_zones_team';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/salesplan/form/add_sales_zones_team.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/salesplan/query/add_sales_zones_team.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'salesplan.list_sales_team&event=upd&sz_id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'worker';

		if(isdefined("attributes.team_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'salesplan.popup_upd_sales_zones_team';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/salesplan/form/upd_sales_zones_team.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/salesplan/query/upd_sales_zones_team.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.team_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'salesplan.list_sales_team&event=upd&sz_id=#attributes.sz_id#&team_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=salesplan.emptypopup_del_sales_zone_team&team_id=#attributes.team_id#&sz_id=#attributes.sz_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16\salesplan/query/del_sales_zones_team.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16\salesplan/query/del_sales_zones_team.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'salesplan.list_sales_team';
			
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=salesplan.list_sales_team";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			get_sales_zone = caller.get_sales_zone;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=salesplan.list_sales_team";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=salesplan.list_sales_team&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main','Kopyala',57476)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['onclick'] = "windowopen('#request.self#?fuseaction=salesplan.list_sales_team&event=add&sz_id=#attributes.sz_id#&team_id=#attributes.team_id#&branch_id=#get_sales_zone.responsible_branch_id#')";

		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SALES_ZONES_TEAM';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'TEAM_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-team_name']";
</cfscript>
