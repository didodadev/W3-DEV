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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.magic_auditor';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/account/display/magicAuditor.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.magic_auditor';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/account/form/add_auditor.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/account/query/add_auditor.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.magic_auditor&event=upd&wizard_id=';

		if(isdefined("attributes.wizard_id")) {

			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'account.magic_auditor';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/account/form/upd_auditor.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/account/query/upd_auditor.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.wizard_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'account.magic_auditor&event=upd&wizard_id=';
						
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=account.magic_auditor&event=del&wizard_id=#attributes.wizard_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/account/query/del_auditor.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/account/query/del_auditor.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'account.magic_auditor';
		}

		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_auditor';
	} else {
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		getLang = caller.getLang;
		
		if(caller.attributes.event is 'add')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=account.magic_auditor";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}

		if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=account.magic_auditor&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-magic']['text'] = '#run#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-magic']['href'] = "#request.self#?fuseaction=account.MagicAuditorRun&wizard_id=#attributes.wizard_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-magic']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=account.magic_auditor";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>
