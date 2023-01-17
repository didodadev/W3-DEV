<!---
    File: WodibaSetupRuleSetsController.cfm
    Author: Gramoni-Mahmut <mahmut.cifci@gramoni.com>
    Date: 29.07.2018
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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'settings.wodiba_bank_rule_set_definitions';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'AddOns/Gramoni/WoDiBa/display/setup_rule_sets.cfm';
		
		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'settings.wodiba_bank_rule_set_definitions';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'AddOns/Gramoni/WoDiBa/display/setup_view_rule_set.cfm';
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'AddOns/Gramoni/WoDiBa/query/setup_get_rule_set.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = attributes.id;
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'settings.wodiba_bank_rule_set_definitions&event=det&id=';
			
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.wodiba_bank_rule_set_definitions';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'AddOns/Gramoni/WoDiBa/form/setup_upd_rule_set.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'AddOns/Gramoni/WoDiBa/query/setup_upd_rule_set.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = attributes.id;
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'settings.wodiba_bank_rule_set_definitions&event=det&id=';

			WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.wodiba_bank_rule_set_definitions';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'AddOns/Gramoni/WoDiBa/form/setup_add_rule_set.cfm';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'AddOns/Gramoni/WoDiBa/query/setup_add_rule_set.cfm';
			WOStruct['#attributes.fuseaction#']['add']['Identity'] = attributes.id;
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.wodiba_bank_rule_set_definitions&event=det&id=';

			WOStruct['#attributes.fuseaction#']['def'] 					= structNew();
			WOStruct['#attributes.fuseaction#']['def']['window'] 		= 'normal';
			WOStruct['#attributes.fuseaction#']['def']['fuseaction'] 	= 'settings.wodiba_bank_rule_set_definitions';
			WOStruct['#attributes.fuseaction#']['def']['Identity']		= '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['def']['filePath']		= 'AddOns/Gramoni/WoDiBa/form/setup_rule_definition.cfm';
			WOStruct['#attributes.fuseaction#']['def']['queryPath'] 	= 'AddOns/Gramoni/WoDiBa/query/setup_add_definition.cfm';
			WOStruct['#attributes.fuseaction#']['def']['nextEvent'] 	= 'settings.wodiba_bank_rule_set_definitions&event=upd&id=';

			if(isDefined('attributes.row_id')){
				WOStruct['#attributes.fuseaction#']['row'] = structNew();
				WOStruct['#attributes.fuseaction#']['row']['window'] = 'popup';
				WOStruct['#attributes.fuseaction#']['row']['fuseaction'] = 'settings.wodiba_bank_rule_set_definitions';
				WOStruct['#attributes.fuseaction#']['row']['filePath'] = 'AddOns/Gramoni/WoDiBa/form/setup_add_rule_set.cfm';
				WOStruct['#attributes.fuseaction#']['row']['queryPath'] = 'AddOns/Gramoni/WoDiBa/query/setup_add_rule_set.cfm';
				WOStruct['#attributes.fuseaction#']['row']['Identity'] = attributes.row_id;
				WOStruct['#attributes.fuseaction#']['row']['nextEvent'] = 'settings.wodiba_bank_rule_set_definitions&event=det&id=';

				WOStruct['#attributes.fuseaction#']['del']					= structNew();
				WOStruct['#attributes.fuseaction#']['del']['window']		= 'popup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction']	= 'settings.wodiba_bank_rule_set_definitions';
				WOStruct['#attributes.fuseaction#']['del']['filePath']		= 'AddOns/Gramoni/WoDiBa/form/setup_add_rule_set.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath']		= 'AddOns/Gramoni/WoDiBa/query/setup_add_rule_set.cfm';
				WOStruct['#attributes.fuseaction#']['del']['Identity']		= attributes.row_id;
				WOStruct['#attributes.fuseaction#']['del']['nextEvent']		= 'settings.wodiba_bank_rule_set_definitions&event=det&id=';
			}
		}
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'add'){
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=settings.wodiba_bank_rule_set_definitions";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd'){
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=settings.wodiba_bank_rule_set_definitions";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('main',117)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['href'] = "javascript:openBoxDraggable('#request.self#?fuseaction=settings.wodiba_bank_rule_set_definitions&event=def&id=#attributes.id#','','ui-draggable-box-medium');";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,def';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'WODIBA_SETUP_RULE_SETS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'RULE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = '';

</cfscript>