<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invoice.purchase_definition';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/invoice/display/purchasedefinitions.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/invoice/query/add_purchase_def.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invoice.purchase_definition';
		
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SETUP_INVOICE_purchase';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'INVOICE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-a_disc','item-Perakende_S_I_F','item-M_MAKBUZU','item-ALINAN_D_F','item-YUVARLAMA_GELIR','item-YUVARLAMA_GIDER','item-FARK_GELIR','item-FARK_GIDER']";
</cfscript>
