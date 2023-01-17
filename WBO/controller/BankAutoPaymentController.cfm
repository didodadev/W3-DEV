
<cfscript>
	// Switch //
	if(attributes.tabMenuController eq 0)
	{	
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.list_bank_autopayment_export';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/bank/display/list_bank_autopayment_export.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.popup_add_autopayment_export';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/bank/form/add_autopayment_export.cfm';		
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/bank/query/add_autopayment_export.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.list_bank_autopayment_export';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('add_form','add_form_row')";
		
		WOStruct['#attributes.fuseaction#']['file'] = structNew();
		WOStruct['#attributes.fuseaction#']['file']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['file']['fuseaction'] = 'bank.popup_open_multi_prov_file';
		WOStruct['#attributes.fuseaction#']['file']['filePath'] = '/V16/bank/form/open_multi_prov_file.cfm';		
		WOStruct['#attributes.fuseaction#']['file']['queryPath'] = '/V16/bank/query/open_multi_prov_file.cfm.cfm';
		WOStruct['#attributes.fuseaction#']['file']['nextEvent'] = 'bank.list_bank_autopayment_export';	
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_bank_autopayment_export";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}	
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CREDITCARD_PAYMENT_TYPE';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PAYMENT_TYPE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-source','item-start_date','item-pay_method','item-bank_name','item-bank','item-bank_name']";
</cfscript>