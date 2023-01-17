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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_odenek';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/ehesap/display/list_odenek.cfm';	
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_form_add_odenek';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/hr/ehesap/form/add_odenek.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/ehesap/query/add_odenek.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_odenek&event=upd&odkes_id=';	
		
		if(isdefined("attributes.odkes_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_form_upd_odenek';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/ehesap/form/upd_odenek.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/ehesap/query/upd_odenek.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.odkes_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_odenek&event=upd&odkes_id=';
			
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=ehesap.emptypopup_del_odenek&ODKES_ID=#ATTRIBUTES.ODKES_ID#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/ehesap/query/del_odenek.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/ehesap/query/del_odenek.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_odenek';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.list_odenek";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onclick'] = "windowopen('#request.self#?fuseaction=ehesap.list_odenek&event=add','project');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.list_odenek";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SETUP_PAYMENT_INTERRUPTION';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ODKES_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-comment','item-amount']";

</cfscript>
