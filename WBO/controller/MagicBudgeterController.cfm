<cfsavecontent variable="run"><cf_get_lang dictionary_id='57911.Çalıştır'></cfsavecontent>
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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'budget.magic_budgeter';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/budget/display/magicBudgeter.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'budget.magic_budgeter';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/budget/form/add_budgeter.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/budget/query/add_budgeter.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'budget.magic_budgeter&event=upd&wizard_id=';

		if(isdefined("attributes.wizard_id")) {

			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'budget.magic_budgeter';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/budget/form/upd_budgeter.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/budget/query/upd_budgeter.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.wizard_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'budget.magic_budgeter&event=upd&wizard_id=';
						
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=budget.magic_budgeter&event=del&wizard_id=#attributes.wizard_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/budget/query/del_budgeter.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/budget/query/del_budgeter.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'budget.magic_budgeter';
		}

		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_budgeter';
	} else {
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		getLang = caller.getLang;
		
		if(isdefined("attributes.event") and attributes.event neq 'list')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=budget.magic_budgeter";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}

		if(isdefined("attributes.event") and attributes.event neq 'add') {
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=budget.magic_budgeter&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-random']['text'] = '#run#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-random']['href'] = "#request.self#?fuseaction=budget.MagicbudgeterRun&wizard_id=#attributes.wizard_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-random']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] = "buttonClickFunction()";
		}

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>
