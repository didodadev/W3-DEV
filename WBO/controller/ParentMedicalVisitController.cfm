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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#listGetAt(attributes.fuseaction,1,'.')#.list_visited_relative';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/ehesap/display/list_visited_relative.cfm';	
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#listGetAt(attributes.fuseaction,1,'.')#.popup_ssk_fee_relative';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/hr/ehesap/form/ssk_fee_relative.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/ehesap/query/add_ssk_fee_relative.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#listGetAt(attributes.fuseaction,1,'.')#.list_visited_relative&event=upd&fee_id=';	
	
		if(isdefined("attributes.fee_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = '#listGetAt(attributes.fuseaction,1,'.')#.popup_upd_ssk_fee_relative';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/ehesap/form/upd_ssk_fee_relative.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/ehesap/query/upd_ssk_fee_relative.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.fee_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#listGetAt(attributes.fuseaction,1,'.')#.list_visited_relative&event=upd&fee_id=';
			
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listGetAt(attributes.fuseaction,1,'.')#.emptypopup_del_ssk_fee_relative&fee_id=#attributes.fee_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/ehesap/query/del_ssk_fee_relative.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/ehesap/query/del_ssk_fee_relative.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#listGetAt(attributes.fuseaction,1,'.')#.list_visited_relative';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_visited_relative";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listGetAt(attributes.fuseaction,1,'.')#.list_visited_relative&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listGetAt(attributes.fuseaction,1,'.')#.list_visited_relative";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BRANCH';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'BRANCH_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-BIRTH_DATE','item-BIRTH_PLACE','item-emp_name','item-ill_name','item-ill_surname','item-ill_relative','item-ill_sex','item-TC_IDENTY_NO','item-DATE']";		

</cfscript>
