<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.list_prod_pause_type';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/production_plan/display/list_prod_pause_type.cfm';
		
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.popup_add_prod_pause_type';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/production_plan/display/add_prod_pause_type.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/production_plan/query/add_prod_pause_type.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'prod.list_prod_pause_type&event=upd&prod_pause_type_id';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'prod_pause_type';

	if(isdefined("attributes.prod_pause_type_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'prod.popup_upd_prod_pause_type';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/production_plan/display/upd_prod_pause_type.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/production_plan/query/upd_prod_pause_type.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'prod.list_prod_pause_type&event=upd&prod_pause_type_id';
			WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.prod_pause_type_id##';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.prod_pause_type_id##';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=prod.list_prod_pause_type";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=prod.list_prod_pause_type&event=add','medium');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=prod.list_prod_pause_type";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SETUP_PROD_PAUSE_TYPE';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PROD_PAUSE_CAT_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-pauseType_code','item-pauseType']";
	
</cfscript>
