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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'credit.list_stockbonds';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/credit/display/list_stockbonds.cfm';	

		WOStruct['#attributes.fuseaction#']['addPaymentRevenue'] = structNew();
		WOStruct['#attributes.fuseaction#']['addPaymentRevenue']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['addPaymentRevenue']['fuseaction'] = 'credit.detail_stockbond';
		WOStruct['#attributes.fuseaction#']['addPaymentRevenue']['filePath'] = 'V16/credit/form/addpayment_interest_revenue.cfm';
		WOStruct['#attributes.fuseaction#']['addPaymentRevenue']['queryPath'] = 'V16/credit/query/addpayment_interest_revenue.cfm';
		WOStruct['#attributes.fuseaction#']['addPaymentRevenue']['nextEvent'] = 'credit.detail_stockbond&event=updPaymentRevenue&yield_plan_row_id=';
		
		if(isdefined("attributes.event") and listFind('del,updPaymentRevenue',attributes.event))
		{
			WOStruct['#attributes.fuseaction#']['updPaymentRevenue'] = structNew();
			WOStruct['#attributes.fuseaction#']['updPaymentRevenue']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['updPaymentRevenue']['fuseaction'] = 'credit.detail_stockbond';
			WOStruct['#attributes.fuseaction#']['updPaymentRevenue']['filePath'] = 'V16/credit/form/updpayment_interest_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['updPaymentRevenue']['queryPath'] = 'V16/credit/query/updpayment_interest_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['updPaymentRevenue']['nextEvent'] = 'credit.detail_stockbond&event=updPaymentRevenue&yield_plan_row_id=';

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'credit.securities_list_interest';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/credit/query/del_payment_interest_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/credit/query/del_payment_interest_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'credit.securities_list_interest';
		}
		
		if(isdefined("attributes.stockbond_id"))
		{
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'credit.detail_stockbond';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/credit/display/detail_stockbond.cfm';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'credit.list_stockbonds&event=det&stockbond_id=';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.stockbond_id#';

			WOStruct['#attributes.fuseaction#']['yieldPayment'] = structNew();
			WOStruct['#attributes.fuseaction#']['yieldPayment']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['yieldPayment']['fuseaction'] = 'credit.detail_stockbond';
			WOStruct['#attributes.fuseaction#']['yieldPayment']['filePath'] = 'V16/credit/form/popup_upd_yield_payment.cfm';
			WOStruct['#attributes.fuseaction#']['yieldPayment']['queryPath'] = '/V16/credit/query/popup_upd_yield_payment.cfm';

		}
		else if(isDefined("attributes.yield_plan_row_id"))
		{
			WOStruct['#attributes.fuseaction#']['updPaymentRevenue'] = structNew();
			WOStruct['#attributes.fuseaction#']['updPaymentRevenue']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['updPaymentRevenue']['fuseaction'] = 'credit.detail_stockbond';
			WOStruct['#attributes.fuseaction#']['updPaymentRevenue']['filePath'] = 'V16/credit/form/updpayment_interest_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['updPaymentRevenue']['queryPath'] = 'V16/credit/query/updpayment_interest_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['updPaymentRevenue']['nextEvent'] = 'bank.detail_stockbond&event=updPaymentRevenue&yield_plan_row_id=';

		}
	
	}
	
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'det')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=credit.list_stockbonds";
			
		}
		else if(caller.attributes.event is 'updPaymentRevenue'){

			GET_PAYMENT_ROW = caller.GET_PAYMENT_ROW;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['updPaymentRevenue'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updPaymentRevenue']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updPaymentRevenue']['menus'][0]['text'] = '#getlang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updPaymentRevenue']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#GET_PAYMENT_ROW.YIELD_PLAN_ROWS_ID#&process_cat=2931','page','upd_virman');";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>


