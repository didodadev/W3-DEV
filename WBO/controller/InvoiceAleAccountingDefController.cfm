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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invoice.sale_definition';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/invoice/display/saledefinitions.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/invoice/query/add_sale_def.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '';
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SETUP_INVOICE';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'INVOICE_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-a_disc','item-hizli_f','item-VERILEN_D_F','item-FARK_GELIR','item-FARK_GIDER','item-MONEY_CREDIT','item-GIFT_CARD']";
		
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
		if(isdefined("attributes.event") and (attributes.event is 'add'))
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
</cfscript>
