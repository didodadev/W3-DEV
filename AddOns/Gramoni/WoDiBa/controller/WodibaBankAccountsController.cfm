<!---
    File: WodibaBankAccountsController.cfm
    Author: Gramoni-Cagla <cagla.kara@gramoni.com>
    Date: 20.11.2019
    Description:
		Wodiba banka hesapları ile ilgili işlemler için ekran controller
	History:
        29.10.2019 - Gramoni-Cagla - Banka hesapları ile Wodiba banka hesapları arasındaki fark tutarı bilgilerinin
        alınması için gerekli event tanımlandırıldı.
--->


<cfscript>

	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];

		WOStruct['#attributes.fuseaction#']['list']					= structNew();
		WOStruct['#attributes.fuseaction#']['list']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'bank.wodiba_bank_accounts';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= 'AddOns/Gramoni/WoDiBa/display/bank_accounts.cfm';	
	
		if(isdefined("attributes.account_id"))
		{
			
			WOStruct['#attributes.fuseaction#']['diff']					    =  structNew();
			WOStruct['#attributes.fuseaction#']['diff']['window']			= 'popup';
			WOStruct['#attributes.fuseaction#']['diff']['fuseaction']		= 'bank.wodiba_bank_accounts&event=diff&account_id=';
			WOStruct['#attributes.fuseaction#']['diff']['filePath']		    = 'AddOns/Gramoni/WoDiBa/display/bank_account_diff.cfm';
			WOStruct['#attributes.fuseaction#']['diff']['queryPath']		= 'AddOns/Gramoni/WoDiBa/query/bank_account_diff.cfm';
			WOStruct['#attributes.fuseaction#']['diff']['nextEvent']		= '';
		}
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=bank.wodiba_bank_actions&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.wodiba_bank_actions";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = '';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = '';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = '';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = '';

</cfscript>