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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_emp_rel_healty';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/ehesap/display/list_emp_rel_healty.cfm';	
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.popup_ssk_healty';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/hr/ehesap/form/ssk_healty.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/ehesap/query/add_emp_relative_healty.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_emp_rel_healty&event=upd&doc_id=';	
		
		if(isdefined("attributes.doc_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.popup_ssk_healty_upd';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/ehesap/form/ssk_healty_upd.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/ehesap/query/upd_emp_rel_healty.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.doc_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_emp_rel_healty&event=upd&doc_id=';
			
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#fusebox.circuit#.emptypopup_emp_relative_healty_del&doc_id=#attributes.doc_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/ehesap/query/del_emp_rel_healty.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/ehesap/query/del_emp_rel_healty.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_emp_rel_healty';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_emp_rel_healty";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_emp_rel_healty&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_emp_rel_healty";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EMPLOYEES_RELATIVE_HEALTY';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'DOC_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-emp_name','item-ill_name','item-ill_surname','item-ill_relative','item-TC_IDENTY_NO']";		

</cfscript>
