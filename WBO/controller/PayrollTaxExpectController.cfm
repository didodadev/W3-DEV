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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_tax_exception';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/ehesap/display/list_tax_exception.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_add_tax_exception';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/ehesap/form/add_tax_exception.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/hr/ehesap/query/add_tax_exception.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_tax_exception';

		
		if(isdefined("attributes.tax_exception_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_upd_tax_exception';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/ehesap/form/upd_tax_exception.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/ehesap/query/upd_tax_exception.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.tax_exception_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_tax_exception';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=ehesap.emptypopup_del_tax_exception&tax_exception_id=#attributes.tax_exception_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/ehesap/query/del_tax_exception.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/ehesap/query/del_tax_exception.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_tax_exception';
			
		}
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'TAX_EXCEPTION';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'TAX_EXCEPTION_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-tax_exc_head','item-yuzde_sinir']";

	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		getLang = caller.getLang;
		
		if(isdefined("attributes.event") and attributes.event is 'add')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.list_tax_exception";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";		
		}
		else if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.list_tax_exception";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onClick'] = "window.location.href='#request.self#?fuseaction=ehesap.list_tax_exception&event=Add'";	
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

	}
</cfscript>
