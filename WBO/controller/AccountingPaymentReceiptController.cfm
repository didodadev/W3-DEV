<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		
		if(not isDefined("attributes.event"))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.form_add_bill_payment';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/account/form/add_bill_payment.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/account/query/add_bill_payment.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.form_add_bill_payment&event=upd&card_id=';
		
		/*
		WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
		WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrol() && validate().check()';
		*/
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,copy';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'ACCOUNT_CARD';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CARD_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_date','item-process_cat','item-cash_acc_code']";

		
		if(isdefined("attributes.card_id") and attributes.event is 'upd'){
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'account.popup_upd_bill_payment';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/account/form/upd_bill_payment.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/account/query/upd_bill_payment.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'account.form_add_bill_payment&event=upd&card_id=';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.card_id#';
		}
		
		if(isdefined("attributes.card_id") and attributes.event is 'copy'){	


			WOStruct['#attributes.fuseaction#']['copy'] = structNew();
			WOStruct['#attributes.fuseaction#']['copy']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['copy']['fuseaction'] = 'account.form_add_bill_payment';
			WOStruct['#attributes.fuseaction#']['copy']['filePath'] = 'V16/account/form/upd_bill_payment.cfm';
			WOStruct['#attributes.fuseaction#']['copy']['queryPath'] = 'V16/account/query/add_bill_payment.cfm';
			WOStruct['#attributes.fuseaction#']['copy']['nextEvent'] = 'account.form_add_bill_payment&event=upd&card_id=';
			WOStruct['#attributes.fuseaction#']['copy']['Identity'] = '#attributes.card_id#';
		}
		/*
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'kontrol() && validate().check()';
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteEvent'] = 'del';
		WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteFunction'] = 'del_kontrol()';
		*/
		
		/*
		if(isdefined("attributes.service_id") and len(attributes.service_id))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=call.emptypopup_del_service&service_id=#attributes.service_id#"';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'call.list_service';
		}
		*/
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=account.list_cards";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		if(caller.attributes.event is 'copy')
		{	
			tabMenuStruct['#fuseactController#']['tabMenus']['copy']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['copy']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['copy']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['copy']['icons']['list-ul']['href'] = "#request.self#?fuseaction=account.list_cards";
		}
		else if(caller.attributes.event is 'upd')
		{
			
			link_str = caller.link_str;
			get_inv = caller.get_inv;
			GET_ACCOUNT_CARD = caller.GET_ACCOUNT_CARD;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=account.form_add_bill_payment";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('account',47)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=account.form_add_bill_payment&event=copy&card_id=#attributes.card_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=account.list_cards";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.card_id#&print_type=290','woc');";
			
			
			i=0;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			if(isdefined('link_str') and len(link_str)){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('account',199)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#link_str##GET_ACCOUNT_CARD.ACTION_ID#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
			}

			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

	

</cfscript>
