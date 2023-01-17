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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'service.list_care';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/service/display/list_care.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'service.popup_add_service_care';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/service/form/add_service_care.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/service/query/add_service_care.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'service.list_care&event=upd&id=';

		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'service.popup_upd_service_care';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/service/form/upd_service_care.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/service/query/upd_service_care.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'service.list_care&event=upd&id=';

			if(isdefined("attributes.event") and (attributes.event is "upd" or attributes.event is "del"))
			{
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=service.emptypopup_del_service_care&id=#attributes.id#';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/asset/query/del_service_care.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/asset/query/del_service_care.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'service.list_care';
			}
			
		}
		

		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,del';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SERVICE_CARE';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PRODUCT_CARE_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-care_description','item-product_name','item-member_name','item-start_date']";
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		if(caller.attributes.event is 'add')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=service.list_care";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=service.list_care&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=service.list_care";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
