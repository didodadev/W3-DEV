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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'budget.list_scenarios';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/budget/display/list_scenarios.cfm';	
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.popup_form_add_scenarios';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/finance/form/add_scenarios.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/finance/query/add_scenario.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'budget.list_scenarios&event=upd&id=';	
		
		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'finance.popup_form_upd_scenarios';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/finance/form/upd_scenarios.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/finance/query/upd_scenario.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'budget.list_scenarios&event=upd&id=';

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=finance.emptypopup_del_scenario&id=#attributes.id#&detail=##caller.get_scenario.scenario_detail##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/finance/query/del_scenarios.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/finance/query/del_scenarios.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'budget.list_scenarios';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=budget.list_scenarios";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=budget.list_scenarios&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=budget.list_scenarios";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>

<!---
	<cfsavecontent variable="message"><cf_get_lang_main no='125.Say?? Mesaj?? Hatas??'></cfsavecontent> list maxrows
	<cfsavecontent variable="message"><cf_get_lang_main no='647.Ba??l??k Girmelisiniz'></cfsavecontent> add Konu
	<cfsavecontent variable="message"><cf_get_lang_main no='647.Baslik Girmelisiniz'></cfsavecontent> update ba??l??k
--->