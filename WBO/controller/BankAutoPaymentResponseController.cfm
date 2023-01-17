
<cfscript>
	// Switch //
	if(attributes.tabMenuController eq 0)
	{	
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.list_bank_autopayment_import';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/bank/display/list_bank_autopayment_import.cfm';
 
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.popup_add_autopayment_import_file';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/bank/form/add_autopayment_import_file.cfm';		
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/bank/query/add_autopayment_import_file.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.list_bank_autopayment_import';
		
		if(isdefined("attributes.i_id"))
		{
			WOStruct['#attributes.fuseaction#']['import'] = structNew();
			WOStruct['#attributes.fuseaction#']['import']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['import']['fuseaction'] = 'bank.popup_add_autopayment_import';
			WOStruct['#attributes.fuseaction#']['import']['filePath'] = 'V16/bank/form/add_autopayment_import.cfm';
			WOStruct['#attributes.fuseaction#']['import']['queryPath'] = '/V16/bank/query/add_autopayment_import.cfm';
			WOStruct['#attributes.fuseaction#']['import']['Identity'] = '#attributes.i_id#';
			WOStruct['#attributes.fuseaction#']['import']['nextEvent'] = 'bank.list_bank_autopayment_import';
	  	}
		
		if(isdefined("attributes.export_import_id"))
		{
			WOStruct['#attributes.fuseaction#']['revImport'] = structNew();
			WOStruct['#attributes.fuseaction#']['revImport']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['revImport']['fuseaction'] = 'bank.popup_open_multi_prov_file';
			WOStruct['#attributes.fuseaction#']['revImport']['filePath'] = 'V16/bank/form/open_multi_prov_file.cfm';
			WOStruct['#attributes.fuseaction#']['revImport']['queryPath'] = '/V16/bank/query/add_autopayment_import.cfm';
			WOStruct['#attributes.fuseaction#']['revImport']['Identity'] = '#attributes.export_import_id#';
			WOStruct['#attributes.fuseaction#']['revImport']['nextEvent'] = 'bank.list_bank_autopayment_import';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_bank_autopayment_import";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(caller.attributes.event is 'import')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['import']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['import']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['import']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['import']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_bank_autopayment_import";
			tabMenuStruct['#fuseactController#']['tabMenus']['import']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['import']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(caller.attributes.event is 'revImport')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['revImport']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['revImport']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['revImport']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['revImport']['icons']['list-ul']['href'] = "#request.self#?fuseaction=bank.list_bank_autopayment_import";
			tabMenuStruct['#fuseactController#']['tabMenus']['revImport']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['revImport']['icons']['check']['onClick'] = "buttonClickFunction()";
		}	
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,import';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CREDITCARD_PAYMENT_TYPE';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PAYMENT_TYPE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_date','item-bank','item-bank_type','item-uploaded_file','item-key_type','item-process_cat','item-key_type','item-process_date','bank_sistem','item-key_type']";	
		
</cfscript>
