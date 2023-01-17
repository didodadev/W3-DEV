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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'service.list_service_report';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/service/display/list_service_report.cfm';
	
		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'service.form_upd_service_care_report';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/service/form/upd_service_care_report.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/service/query/upd_care_report.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'service.list_service_report&event=upd&id=';
		}
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'service.list_service_report';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/service/form/add_service_care_report.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/service/query/add_service_care_contract.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'service.list_service_report&event=upd&id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'service_contract';

		if(isdefined("attributes.event") and (attributes.event is "upd" or attributes.event is "del"))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=service.emptypopup_del_service_care_contract&id=#attributes.id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/service/query/del_service_care_contract.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/V16/service/query/del_service_care_contract.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'service.list_service_report';//
		}		
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SERVICE_CARE_REPORT';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PRODUCT_CARE_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-contract_head','item-product_name','item-contract_head','item-serial_no','item-start_clock']";
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=service.list_service_report";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=service.list_service_report&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=service.list_service_report";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>

<!---<cfsavecontent variable="img"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=service.form_add_service_care_report"><img src="/images/plus1.gif" title="<cf_get_lang_main no='170.Ekle'>"></a></cfsavecontent>--->