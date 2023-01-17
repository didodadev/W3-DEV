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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.wizard';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/account/display/magicAccounter.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.wizard';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/account/form/add_wizard.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/account/query/add_wizard.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.wizard&event=upd&wizard_id=';

		if(isdefined("attributes.wizard_id")) {
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'account.wizard';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/account/form/add_wizard.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/account/query/add_wizard.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.wizard_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'account.wizard&event=upd&wizard_id=';
						
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=account.wizard&event=del&wizard_id=#attributes.wizard_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/account/query/add_wizard.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/account/query/add_wizard.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'account.wizard';
		}

		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_wizard';
	} else {
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		getLang = caller.getLang;
		
		// Upd //
		if(isdefined("attributes.event") and attributes.event neq 'list')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=account.wizard";
		}
		if(isdefined("attributes.event") and attributes.event is 'upd') {
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['x fa fa-random']['text'] = "#getLang('','Çalıştır',57911)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['x fa fa-random']['href'] = "#request.self#?fuseaction=account.wizard_run&wizard_id=#attributes.wizard_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['x fa fa-random']['target'] = "_blank";
		}

		if(isdefined("attributes.event") and attributes.event neq 'add') {
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=account.wizard&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['target'] = "_blank";
		}

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>
