<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'budget.popup_add_budget';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'budget/form/add_budget.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'budget/query/add_budget.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'budget.detail_budget&event=add';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'budget.detail_budget';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'budget/form/detail_budget.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'budget/query/upd_budget.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'budget.detail_budget&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'budget_id=##attributes.budget_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.budget_id##';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.list_account_plan';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'account/display/list_account_plan.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;
	
	WOStruct['#attributes.fuseaction#']['default'] = structNew();
	WOStruct['#attributes.fuseaction#']['default']['fuseaction'] = 'account.list_account_plan';
	WOStruct['#attributes.fuseaction#']['default']['filePath'] = 'account/display/list_account_plan.cfm';
	
	WOStruct['#attributes.fuseaction#']['pageParams']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['pageParams']['upd']['size'] = '12';
	
	
	// type'lar include,box,custom tag şekline dönüşecek.
	WOStruct['#attributes.fuseaction#']['pageObjects'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['pageObjects']['upd']['type'][0][0] = 0;
	WOStruct['#attributes.fuseaction#']['pageObjects']['upd']['file'][0][0] = 'budget/display/detail_budget.cfm';
	WOStruct['#attributes.fuseaction#']['pageObjects']['upd']['id'][0][0] = 'mainObject';
	WOStruct['#attributes.fuseaction#']['pageObjects']['upd']['title'][0][0] = 'Ana Obje;mainObject';
	
	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	// Upd //
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=budget.detail_budget&action_name=budget_id&action_id=#attributes.budget_id#','list','popup_page_warnings')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array_main.item[1648]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=budget.detail_budget_report&general_budget_id=#attributes.budget_id#','wide','detail_budget_report')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array.item[80]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=budget.list_budget_plan_row&budget_id=#attributes.budget_id#','wide')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = '#lang_array.item[78]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['onClick'] = "windowopen('#request.self#?fuseaction=budget.add_budget_plan&budget_id=#attributes.budget_id#','wide','add_budget_plan')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['text'] = '#lang_array_main.item[52]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['onClick'] = "windowopen('#request.self#?fuseaction=budget.popup_upd_budget&budget_id=#attributes.budget_id#','wide','popup_upd_budget')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['onClick'] = "windowopen('#request.self#?fuseaction=budget.popup_add_budget','popup','popup_add_budget')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][7]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.budget_id#&print_type=330','popup','popup_add_budget')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
