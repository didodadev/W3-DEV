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
			WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.interest_revenue';
			WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/bank/display/list_interest_revenue.cfm';

			WOStruct['#attributes.fuseaction#']['addPaymentRevenue'] = structNew();
			WOStruct['#attributes.fuseaction#']['addPaymentRevenue']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['addPaymentRevenue']['fuseaction'] = 'bank.interest_revenue';
			WOStruct['#attributes.fuseaction#']['addPaymentRevenue']['filePath'] = 'V16/bank/form/addpayment_interest_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['addPaymentRevenue']['queryPath'] = 'V16/bank/query/addpayment_interest_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['addPaymentRevenue']['nextEvent'] = 'bank.interest_revenue&event=updPaymentRevenue&id=';
		
		if(isdefined("attributes.event") and listFind('del,updPaymentRevenue',attributes.event))
		{

			WOStruct['#attributes.fuseaction#']['updPaymentRevenue'] = structNew();
			WOStruct['#attributes.fuseaction#']['updPaymentRevenue']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['updPaymentRevenue']['fuseaction'] = 'bank.interest_revenue';
			WOStruct['#attributes.fuseaction#']['updPaymentRevenue']['filePath'] = 'V16/bank/form/updpayment_interest_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['updPaymentRevenue']['queryPath'] = 'V16/bank/query/updpayment_interest_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['updPaymentRevenue']['nextEvent'] = 'bank.interest_revenue&event=updPaymentRevenue&id=';

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'bank.interest_revenue';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/bank/query/del_payment_interest_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/bank/query/del_payment_interest_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'bank.list_bank_actions';

        }

	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'updPaymentRevenue'){

			GET_PAYMENT_ROW = caller.GET_PAYMENT_ROW;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updPaymentRevenue'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updPaymentRevenue']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updPaymentRevenue']['icons']['fa fa-table']['text'] = '#getlang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updPaymentRevenue']['icons']['fa fa-table']['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#GET_PAYMENT_ROW.BANK_ACTION_ID#&process_cat=2313','page','upd_virman');";
			tabMenuStruct['#fuseactController#']['tabMenus']['updPaymentRevenue']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updPaymentRevenue']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['updPaymentRevenue']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updPaymentRevenue']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.interest_revenue";
		
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
/* 		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BANK_ACTIONS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACTION_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-from_account_id','item-to_account_id','item-ACTION_DATE','item-ACTION_VALUE']"; */
	
</cfscript>