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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'budget.list_budgets';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/budget/display/list_budgets.cfm';
	
		if(isdefined("attributes.budget_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'budget.popup_upd_budget';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/budget/form/upd_budget.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/budget/query/upd_budget.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.budget_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'budget.list_budgets&event=upd&budget_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=budget.emptypopup_del_budget&budget_id=#attributes.budget_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/budget/query/del_budget.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/budget/query/del_budget.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'budget.list_budgets';
			
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'budget.list_budgets';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/budget/display/detail_budget.cfm';
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '/V16/budget/display/detail_budget.cfm';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'budget.list_budgets&event=det&budget_id=';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.budget_id#';
	}
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'budget.popup_add_budget';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/budget/form/add_budget.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/budget/query/add_budget.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'budget.list_budgets&event=det&budget_id=';
		WOStruct['#attributes.fuseaction#']['add']['nextEventTarget'] = '_blank';

		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_budget';
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BUDGET';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'budget_id';
		
	
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		getLang = caller.getLang;
		
		// Upd //
		if(isdefined("attributes.event") and (attributes.event is 'det'))
		{
	
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['text'] = '#getLang('main',1648)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['href'] = "#request.self#?fuseaction=report.detail_budget_report&general_budget_id=#attributes.budget_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][1]['text'] = '#getLang('budget',80)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][1]['href'] = "#request.self#?fuseaction=budget.list_budget_plan_row&budget_id=#attributes.budget_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][2]['text'] = '#getLang('budget',78)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][2]['href'] = "#request.self#?fuseaction=budget.list_plan_rows&event=add&budget_id=#attributes.budget_id#";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=budget.list_budgets&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.budget_id#&print_type=330','WOC')";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=budget_id&action_id=#attributes.budget_id#','Workflow')";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getLang('main',52,'güncelle')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=budget.list_budgets&event=upd&budget_id=#attributes.budget_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=budget.list_budgets";
			
		}
		else if(isdefined("attributes.event") and (attributes.event is 'add')) 
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=budget.list_budgets";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
		}

		else if(isdefined("attributes.event") and (attributes.event is 'upd'))
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=budget.list_budgets";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=budget.list_budgets&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['text'] = '#getLang("","",33077)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=budget.list_budgets&event=det&budget_id=#attributes.budget_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=budget_id&action_id=#attributes.budget_id#','Workflow')";			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
</cfscript>
