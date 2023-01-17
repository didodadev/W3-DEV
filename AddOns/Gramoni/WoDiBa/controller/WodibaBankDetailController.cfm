<!---
    File: WodibaBankDetailController.cfm
    Author: Gramoni-Mahmut <mahmut.cifci@gramoni.com>
    Date: 15.10.2018
    Description:
		
--->
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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'wodiba.setup_bank_accounts';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'AddOns/Gramoni/WoDiBa/display/setup_bank_accounts.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'wodiba.setup_add_bank_accounts';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'AddOns/Gramoni/WoDiBa/form/setup_add_bank_account.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'AddOns/Gramoni/WoDiBa/query/setup_add_bank_account.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'wodiba.setup_bank_accounts&event=det&id=';
		
		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'wodiba.setup_add_bank_accounts';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'AddOns/Gramoni/WoDiBa/display/setup_view_bank_account.cfm';
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'AddOns/Gramoni/WoDiBa/query/setup_get_bank_account.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'wodiba.setup_bank_accounts&event=det&id=';
			
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'wodiba.setup_add_bank_accounts';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'AddOns/Gramoni/WoDiBa/form/setup_upd_bank_account.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'AddOns/Gramoni/WoDiBa/query/setup_upd_bank_account.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'wodiba.setup_bank_accounts&event=det&id=';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=wodiba.setup_add_bank_accounts";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=finance.wodiba_setup_add_bank_accounts&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=wodiba.setup_add_bank_accounts";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'ACCOUNTS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACCOUNT_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = '';

</cfscript>