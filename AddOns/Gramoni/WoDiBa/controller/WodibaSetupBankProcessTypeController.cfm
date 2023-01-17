<!---
    File: WodibaSetupBankProcessTypeController.cfm
    Author: Ahmet Yolcu <ahmetyolcu@workcube.com>
    Date: 26.03.2019
    Description:

--->
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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'settings.wodiba_bank_process_type_definitions';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'AddOns/Gramoni/WoDiBa/form/setup_bank_process_type_definitions.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.wodiba_bank_process_type_definitions';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'AddOns/Gramoni/WoDiBa/form/setup_add_process_type_definitions.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'AddOns/Gramoni/WoDiBa/query/setup_add_process_type_definitions.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.wodiba_bank_process_type_definitions&id=';

		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.wodiba_bank_process_type_definitions';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'AddOns/Gramoni/WoDiBa/form/setup_upd_process_type_definitions.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'AddOns/Gramoni/WoDiBa/query/setup_upd_process_type_definitions.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
			/* WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'wodiba.setup_bank_accounts&event=det&id='; */
		}
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=wodiba.setup_rule_sets&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=wodiba.setup_rule_sets";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

</cfscript>