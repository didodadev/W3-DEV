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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.production_result_account_card';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/account/display/production_result_account_card.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/account/display/production_result_account_card.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.production_result_account_card';				
	}	
</cfscript>
