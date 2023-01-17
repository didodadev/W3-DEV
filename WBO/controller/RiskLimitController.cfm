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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'finance.list_credits';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/finance/display/list_credits.cfm';
		
		if(isdefined("attributes.company_id") OR isdefined("attributes.consumer_id") OR isdefined("attributes.our_company_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'contract.detail_contract_company';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/contract/query/detail_contract_company.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/contract/query/upd_company_credit.cfm';
			if(isdefined("attributes.company_id") and len(attributes.company_id))
			{
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.company_id#';
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'finance.list_credits&event=upd&our_company_id=#attributes.our_company_id#&consumer_id=&company_id=';
			}
			else if(isdefined("attributes.consumer_id") and len(attributes.consumer_id))
			{
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.consumer_id#';
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'finance.list_credits&event=upd&our_company_id=#attributes.our_company_id#&company_id=&consumer_id=';
			}

		}
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'contract.popup_add_company_credit';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/contract/form/add_company_credit.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/contract/query/add_company_credit.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'finance.list_credits&event=upd&company_id=&consumer_id=&our_company_id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_credit';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=finance.list_credits";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=finance.list_credits&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=finance.list_credits";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

			if (isdefined("attributes.company_id") and len(attributes.company_id))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('contract',257)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=product.conditions&get_company_id=#attributes.company_id#&purchase_sales=1&form_varmi=1";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['text'] = '#getLang('contract',91)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['href'] = "#request.self#?fuseaction=product.conditions&get_company_id=&purchase_sales=2";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['text'] = '#getLang('main',171)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['href'] = "#request.self#?fuseaction=product.list_promotions&supplier_id=#attributes.company_id#&is_submitted=1";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['target'] = "_blank";
			}
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'COMPANY_CREDIT';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'COMPANY_CREDIT_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "[]";
	
	
</cfscript>