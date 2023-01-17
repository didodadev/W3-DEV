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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_audits';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_audits.cfm';	
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.popup_add_audit';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/hr/form/add_audit.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/query/add_audit.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_audits&event=upd&audit_id=';	
		
		if(isdefined("attributes.audit_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.popup_upd_audit';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/form/upd_audit.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/query/upd_audit.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.audit_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_audits&event=upd&audit_id=';
			
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=hr.emptypopup_del_audit&audit_id=#attributes.audit_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/query/del_audit.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/query/del_audit.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_audits';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_audits";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_audits&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_audits";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BRANCH';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'BRANCH_NAME';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-AUDIT_BRANCH_ID','item-AUDITOR','item-AUDIT_DATE','item-AUDIT_TYPE','item-department']";		

</cfscript>
