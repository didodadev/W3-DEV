<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.product_cost_account_card';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/account/display/product_cost_account_card.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/account/display/product_cost_account_card.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.product_cost_account_card';						
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = '';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = '';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-dates']";
	}
</cfscript>