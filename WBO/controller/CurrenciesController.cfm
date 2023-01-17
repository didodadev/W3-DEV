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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'finance.list_currencies';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/finance/display/list_currency_history.cfm';
	
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.popup_add_currency';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/finance/form/add_currency_info.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/finance/query/add_currency_info_act.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'finance.list_currencies';

		WOStruct['#attributes.fuseaction#']['addHistory'] = structNew();
		WOStruct['#attributes.fuseaction#']['addHistory']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['addHistory']['fuseaction'] = 'finance.popup_add_currency_hist';
		WOStruct['#attributes.fuseaction#']['addHistory']['filePath'] = 'V16/finance/form/add_currency_hist_info.cfm';
		WOStruct['#attributes.fuseaction#']['addHistory']['queryPath'] = 'V16/finance/query/add_currency_hist_info_act.cfm';
		WOStruct['#attributes.fuseaction#']['addHistory']['nextEvent'] = 'finance.list_currencies';
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'addCurrency,addCurrencyHist';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'MONEY_HISTORY';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'MONEY_HISTORY_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-rate1','item-amount2','item-amount','item-amountpp2','item-amountpp','item-amountww2','item-amountww']";
		
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		getLang = caller.getLang;
		
		if(isdefined("attributes.event") and (attributes.event is 'addCurrency'))
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['onClick'] = "windowopen('#request.self#?fuseaction=finance.list_currencies','medium');";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(isdefined("attributes.event") and (attributes.event is 'addCurrencyHist'))
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['onClick'] = "windowopen('#request.self#?fuseaction=finance.list_currencies','medium');";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
</cfscript>
