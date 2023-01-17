
<cfscript>
	// Switch //
	if(attributes.tabMenuController eq 0)
	{	
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'finance.list_credit_payment_types';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/finance/display/list_credit_payment_types.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.popup_form_add_credit_payment';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/finance/form/form_add_credit_payment.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/finance/query/add_credit_payment.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'finance.list_credit_payment_types&event=upd';	
		
		if(isdefined("attributes.id"))
		{
	  		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	  		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	  		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'finance.popup_form_upd_credit_payment';
	  		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/finance/form/form_upd_credit_payment.cfm';
	  		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/finance/query/upd_credit_payment.cfm';
	  		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'finance.list_credit_payment_types&event=upd';
	  		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##'; 
		
				/*credit_control = caller.CREDIT_CONTROL;	hata veriyor! */	
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=finance.emptypopup_del_credit_payment&id=#attributes.id#&detail=##caller.credit_control.card_no##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/finance/query/del_credit_payment.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/V16/finance/query/del_credit_payment.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'finance.list_credit_payment_types';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=finance.list_credit_payment_types";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}

		//Upd//	
		else if(caller.attributes.event is 'upd')
		{
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main','Ekle',57582)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=finance.list_credit_payment_types&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=finance.list_credit_payment_types";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#getlang('main','Üyeler',57417)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['id'] = 'open_page_1';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=finance.popup_add_payment_for_member&cc_payment_type_id=#attributes.id#','','ui-draggable-box-small')";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['target'] = "_blank";
            tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
            tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['href'] = '#request.self#?fuseaction=objects.popup_print_files&print_type=153&action_type=#attributes.id#&action_id=#attributes.id#';        
		

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['href'] = '#request.self#?fuseaction=objects.workflowpages&tab=3&action=myhome.my_extre&action_name=id&action_id=#attributes.id#';		
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CREDITCARD_PAYMENT_TYPE';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PAYMENT_TYPE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-card_no','item-payment_means_code','item-account_id','item-passingday_to_instalment_account','item-account_code_name']";

</cfscript>