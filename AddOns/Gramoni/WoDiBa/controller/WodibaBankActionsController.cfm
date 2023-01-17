<!---
    File: WodibaBankActionsController.cfm
    Author: Gramoni-Mahmut <mahmut.cifci@gramoni.com>
    Date: 15.10.2018
    Description:
		WoDiBa banka işlemlerinin listelendiği ve kayıt edildiği ekran controller
	History:
		29.10.2019 - Gramoni-Mahmut - Banka işlemleri sayfasında artı butonu çıktığı için add eventi add_action olarak değiştirildi
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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'bank.wodiba_bank_actions';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= 'AddOns/Gramoni/WoDiBa/display/bank_actions.cfm';

		WOStruct['#attributes.fuseaction#']['add_action']					= structNew();
		WOStruct['#attributes.fuseaction#']['add_action']['window']			= 'popup';
		WOStruct['#attributes.fuseaction#']['add_action']['fuseaction']		= 'bank.wodiba_bank_actions&event=add_action&id=';
		WOStruct['#attributes.fuseaction#']['add_action']['filePath']		= 'AddOns/Gramoni/WoDiBa/form/add_bank_action.cfm';
		WOStruct['#attributes.fuseaction#']['add_action']['queryPath']		= 'AddOns/Gramoni/WoDiBa/query/add_bank_action.cfm';
		WOStruct['#attributes.fuseaction#']['add_action']['nextEvent']		= '';

		WOStruct['#attributes.fuseaction#']['dashboard']					= structNew();
		WOStruct['#attributes.fuseaction#']['dashboard']['window']			= 'normal';
		WOStruct['#attributes.fuseaction#']['dashboard']['fuseaction']		= 'bank.wodiba_bank_actions&event=dashboard';
		WOStruct['#attributes.fuseaction#']['dashboard']['filePath']		= 'AddOns/Gramoni/WoDiBa/display/wodiba_dashboard.cfm';
		WOStruct['#attributes.fuseaction#']['dashboard']['queryPath']		= '';
		WOStruct['#attributes.fuseaction#']['dashboard']['nextEvent']		= '';

		WOStruct['#attributes.fuseaction#']['action']				= structNew();
		WOStruct['#attributes.fuseaction#']['action']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['action']['fuseaction']	= 'bank.wodiba_bank_actions&event=action&id=';
		WOStruct['#attributes.fuseaction#']['action']['filePath']	= 'AddOns/Gramoni/WoDiBa/display/list_counter_transaction.cfm';
	
		WOStruct['#attributes.fuseaction#']['money']					= structNew();
		WOStruct['#attributes.fuseaction#']['money']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['money']['fuseaction']	= 'bank.wodiba_bank_actions&event=money';
		WOStruct['#attributes.fuseaction#']['money']['filePath']	= 'AddOns/Gramoni/WoDiBa/display/list_expense_money.cfm';

		WOStruct['#attributes.fuseaction#']['history']					= structNew();
		WOStruct['#attributes.fuseaction#']['history']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['history']['fuseaction']	= 'bank.wodiba_bank_actions&event=history';
		WOStruct['#attributes.fuseaction#']['history']['filePath']	= 'AddOns/Gramoni/WoDiBa/display/list_history.cfm';
		
		WOStruct['#attributes.fuseaction#']['logs']					= structNew();
		WOStruct['#attributes.fuseaction#']['logs']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['logs']['fuseaction']	= 'bank.wodiba_bank_actions&event=logs';
		WOStruct['#attributes.fuseaction#']['logs']['filePath']		= 'AddOns/Gramoni/WoDiBa/display/list_log.cfm';


		if(isdefined("attributes.id"))
		{
			
			WOStruct['#attributes.fuseaction#']['det']					= structNew();
			WOStruct['#attributes.fuseaction#']['det']['window']		= 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction']	= 'bank.wodiba_bank_actions';
			WOStruct['#attributes.fuseaction#']['det']['filePath']		= 'AddOns/Gramoni/WoDiBa/display/setup_view_bank_account.cfm';
			WOStruct['#attributes.fuseaction#']['det']['queryPath']		= 'AddOns/Gramoni/WoDiBa/query/setup_get_bank_account.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity']		= '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent']		= 'bank.wodiba_bank_actions&event=det&id=';
			
			WOStruct['#attributes.fuseaction#']['upd']					= structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window']		= 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction']	= 'bank.wodiba_bank_actions';
			WOStruct['#attributes.fuseaction#']['upd']['filePath']		= 'AddOns/Gramoni/WoDiBa/form/setup_upd_bank_account.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath']		= 'AddOns/Gramoni/WoDiBa/query/setup_upd_bank_account.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity']		= '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent']		= 'bank.wodiba_bank_actions&event=det&id=';
			
			WOStruct['#attributes.fuseaction#']['log_detail']				= structNew();
			WOStruct['#attributes.fuseaction#']['log_detail']['window']		= 'popup';
			WOStruct['#attributes.fuseaction#']['log_detail']['fuseaction']	= 'bank.wodiba_bank_actions&event=log_detail&id=';
			WOStruct['#attributes.fuseaction#']['log_detail']['Identity']	= '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['log_detail']['filePath']	= 'AddOns/Gramoni/WoDiBa/display/get_log_detail.cfm';

			WOStruct['#attributes.fuseaction#']['delcon']				= structNew();
			WOStruct['#attributes.fuseaction#']['delcon']['window']		= 'popup';
			WOStruct['#attributes.fuseaction#']['delcon']['fuseaction']	= 'bank.wodiba_bank_actions&event=delcon&id=';
			WOStruct['#attributes.fuseaction#']['delcon']['Identity']	= '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['delcon']['filePath']	= 'AddOns/Gramoni/WoDiBa/query/del_connection.cfm';
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
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'WODIBA_BANK_ACTIONS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'WDB_ACTION_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = '';

</cfscript>