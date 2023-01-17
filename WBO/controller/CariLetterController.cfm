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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'finance.list_cari_letter';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/wutabakat/display/list_cari_letter.cfm';

		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.form_add_cari_letter';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/Wutabakat/form/form_add_cari_letter.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/Wutabakat/query/add_cari_letter.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'finance.list_cari_letter&event=upd&cari_letter_id=';
		
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'finance.form_upd_cari_letter';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/Wutabakat/form/form_upd_cari_letter.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/Wutabakat/query/add_cari_letter.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.cari_letter_id##';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'finance.list_cari_letter&event=upd&cari_letter_id=';
		
		if( attributes.event is not 'upd' && attributes.event is 'del' )
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=finance.del_cari_letter&cari_letter_id=##CALLER.cari_letter_id##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/Wutabakat/query/del_cari_letter.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/Wutabakat/query/del_cari_letter.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'finance.list_cari_letter';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=finance.list_cari_letter";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=finance.list_cari_letter";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=finance.list_cari_letter&event=add";

			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EMPLOYEES_TRAVEL_DEMAND';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'TRAVEL_DEMAND_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-company','item-place','item-departure_date','item-departure_of_date','item-start_date','item-entry_date','item-release_date']";
</cfscript>
