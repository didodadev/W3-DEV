<cfscript>
	// Switch //
	if(attributes.tabMenuController eq 0)
	{	
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined("attributes.event"))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'credit.list_credit_contract';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/credit/display/list_credit_contract.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'credit.add_credit_contract';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/credit/form/add_credit_contract.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/credit/query/add_credit_contract.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'credit.list_credit_contract&event=det';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('credit_contract','credit_contract_bask');";
		
		WOStruct['#attributes.fuseaction#']['contract'] = structNew();
		WOStruct['#attributes.fuseaction#']['contract']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['contract']['fuseaction'] = 'credit.list_credit_contract&event=contract';
		WOStruct['#attributes.fuseaction#']['contract']['filePath'] = 'AddOns/Gramoni/WoDiBa/display/list_wodiba_credit_contract.cfm';

		if(isdefined("attributes.credit_contract_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'credit.upd_credit_contract';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/credit/form/upd_credit_contract.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/credit/query/upd_credit_contract.cfm';

			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'credit.list_credit_contract&event=upd&credit_contract_id=';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.credit_contract_id#';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('credit_contract','credit_contract_bask');";

			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'credit.detail_credit_contract';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/credit/display/detail_credit_contract.cfm';
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = '';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.credit_contract_id##';

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=credit.emptypopup_del_credit_contract&credit_contract_id=#attributes.credit_contract_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/credit/query/del_credit_contract.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/credit/query/del_credit_contract.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'credit.list_credit_contract';
			
			WOStruct['#attributes.fuseaction#']['addPayment'] = structNew();
			WOStruct['#attributes.fuseaction#']['addPayment']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['addPayment']['fuseaction'] = 'credit.popup_add_credit_payment';
			WOStruct['#attributes.fuseaction#']['addPayment']['filePath'] = 'V16/credit/form/add_credit_payment.cfm';
			WOStruct['#attributes.fuseaction#']['addPayment']['queryPath'] = 'V16/credit/query/add_credit_payment.cfm';
			WOStruct['#attributes.fuseaction#']['addPayment']['nextEvent'] = 'credit.list_credit_contract&event=det';
			
			WOStruct['#attributes.fuseaction#']['addRevenue'] = structNew();
			WOStruct['#attributes.fuseaction#']['addRevenue']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['addRevenue']['fuseaction'] = 'credit.popup_add_credit_revenue';
			WOStruct['#attributes.fuseaction#']['addRevenue']['filePath'] = 'V16/credit/form/add_credit_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['addRevenue']['queryPath'] = 'V16/credit/query/add_credit_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['addRevenue']['nextEvent'] = 'credit.list_credit_contract&event=det';
		}
		if(isdefined("attributes.credit_contract_row_id"))
		{
			WOStruct['#attributes.fuseaction#']['updPayment'] = structNew();
			WOStruct['#attributes.fuseaction#']['updPayment']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['updPayment']['fuseaction'] = 'credit.popup_upd_credit_payment';
			WOStruct['#attributes.fuseaction#']['updPayment']['filePath'] = 'V16/credit/form/upd_credit_payment.cfm';
			WOStruct['#attributes.fuseaction#']['updPayment']['queryPath'] = 'V16/credit/query/upd_credit_payment.cfm';
			WOStruct['#attributes.fuseaction#']['updPayment']['nextEvent'] = 'credit.list_credit_contract&event=det';
			WOStruct['#attributes.fuseaction#']['updPayment']['Identity'] = '#attributes.credit_contract_row_id#';
			
			WOStruct['#attributes.fuseaction#']['updRevenue'] = structNew();
			WOStruct['#attributes.fuseaction#']['updRevenue']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['updRevenue']['fuseaction'] = 'credit.popup_upd_credit_revenue';
			WOStruct['#attributes.fuseaction#']['updRevenue']['filePath'] = 'V16/credit/form/upd_credit_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['updRevenue']['queryPath'] = 'V16/credit/query/upd_credit_revenue.cfm';
			WOStruct['#attributes.fuseaction#']['updRevenue']['nextEvent'] = 'credit.list_credit_contract&event=det';
			WOStruct['#attributes.fuseaction#']['updRevenue']['Identity'] = '#attributes.credit_contract_row_id#';
		}
		if(listFind('delPayment,updPayment,delRevenue,updRevenue',attributes.event))
		{
			WOStruct['#attributes.fuseaction#']['delPayment'] = structNew();
			WOStruct['#attributes.fuseaction#']['delPayment']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['delPayment']['fuseaction'] = '#request.self#?fuseaction=credit.emptypopup_del_credit_payment&credit_contract_payment_id=##caller.get_credit_contract_payment.credit_contract_payment_id##&old_process_type=##caller.get_credit_contract_payment.process_type##&bank_action_id=##caller.get_credit_contract_payment.bank_action_id##&temp_dsn=##caller.dsn##_##caller.get_period.period_year##_##caller.get_period.our_company_id##&period_id=##caller.get_period.period_id##&company_id=##caller.get_period.our_company_id##';
			WOStruct['#attributes.fuseaction#']['delPayment']['filePath'] = 'V16/credit/query/del_credit_payment.cfm';
			WOStruct['#attributes.fuseaction#']['delPayment']['queryPath'] = 'V16/credit/query/del_credit_payment.cfm';
			WOStruct['#attributes.fuseaction#']['delPayment']['nextEvent'] = 'credit.list_credit_contract&event=det&credit_contract_id=';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=credit.list_credit_contract";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['text'] = '#getlang('main','Detay',57771)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=credit.list_credit_contract&event=det&credit_contract_id=#attributes.credit_contract_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main','Ekle',57582)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=credit.list_credit_contract&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main','Kopyala',57476)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=#listGetAt(attributes.fuseaction,1,'.')#.list_credit_contract&event=add&credit_contract_id=#url.credit_contract_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=credit.list_credit_contract";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			if(caller.get_credit_contract.process_type eq 296){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('main','Mahsup Fişi',58452)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.credit_contract_id#&process_cat=#caller.get_credit_contract.process_type#','page','upd_gelenh');";
			}
			
		}
		else if(caller.attributes.event is 'det')
		{
			get_credit_contract = caller.get_credit_contract;
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getLang('main','Güncelle',57464)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=credit.list_credit_contract&event=upd&credit_contract_id=#get_credit_contract.credit_contract_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main','Ekle',57582)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=credit.list_credit_contract&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=credit.list_credit_contract";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-download']['text'] = '#getLang('main',1936)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-download']['onclick'] = "windowopen('index.cfm?fuseaction=objects.popup_convertpdf&module=stock&ispdf=1','medium','popup_convertpdf')";	
			
			i = 0;
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'] = structNew();
						
			if(get_credit_contract.process_type neq 296){
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main','Ödeme',57847)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=credit.list_credit_contract&event=addPayment&credit_contract_id=#get_credit_contract.credit_contract_id#&project_id=#get_credit_contract.project_id#','project');";
				i = i+1;
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main','Tahsilat',57845)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=credit.list_credit_contract&event=addRevenue&credit_contract_id=#get_credit_contract.credit_contract_id#&project_id=#get_credit_contract.project_id#','project');";
				i = i+1;
			}
			
			
			if(get_credit_contract.process_type eq 296)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main','Muhasebe',57447)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#caller.attributes.credit_contract_id#&process_cat=#get_credit_contract.process_type#','page','upd_gelenh');";
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=credit.detail_credit_contract&action_name=credit_contract_id&action_id=#attributes.credit_contract_id#','Workflow')";
			
							
		}
		else if(caller.attributes.event is 'updPayment')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['updPayment']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updPayment']['menus'][0]['text'] = '#getLang('main','Muhasebe',57447)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updPayment']['menus'][0]['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#caller.get_credit_contract_payment.credit_contract_payment_id#&process_cat=#caller.get_credit_contract_payment.process_type#','page','upd_gidenh');";				
		}
		else if(caller.attributes.event is 'updRevenue')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['updRevenue']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updRevenue']['icons']['add']['text'] = '#getLang('main','Ekle',57582)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updRevenue']['icons']['add']['href'] = "#request.self#?fuseaction=credit.list_credit_contract&event=addRevenue&CREDIT_CONTRACT_ID=#CREDIT_CONTRACT_ID#";

			tabMenuStruct['#fuseactController#']['tabMenus']['updRevenue']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updRevenue']['menus'][0]['text'] = '#getLang('main','Muhasebe',57447)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updRevenue']['menus'][0]['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#caller.get_credit_contract_payment.credit_contract_payment_id#&process_cat=#caller.get_credit_contract_payment.process_type#','page','upd_gidenh');";				
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CREDIT_CONTRACT';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CREDIT_CONTRACT_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-credit_date','item-credit_no']";
	
</cfscript>
