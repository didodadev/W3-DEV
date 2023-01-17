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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ch.list_premium_payment';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/ch/display/list_premium_payment.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ch.form_add_premium_payment';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/ch/form/add_premium_payment.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/ch/query/add_premium_payment.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ch.list_premium_payment&event=upd&inv_payment_id=';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('add_law','add_law_row');";
			
		if(isdefined("attributes.inv_payment_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ch.form_upd_premium_payment';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/ch/form/upd_premium_payment.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/ch/form/upd_premium_payment.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.inv_payment_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ch.list_premium_payment&event=upd&inv_payment_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=ch.emptypopup_del_premium_payment&payment_id=#attributes.inv_payment_id#&process_type=#get_payment.process_type#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'ch/query/del_premium_payment.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'ch/query/del_premium_payment.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ch.list_premium_payment';
			
		}
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		getLang = caller.getLang;

		// Upd //
		if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			get_payment = caller.get_payment;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=ch.list_premium_payment&event=add','medium');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ch.list_premium_payment";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#get_payment.inv_payment_id#&process_cat=#get_payment.process_type#','page','emptypopup_upd_debit_claim_note');";

		}
		else
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ch.list_premium_payment";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
</cfscript>
