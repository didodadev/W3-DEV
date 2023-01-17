<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();	
		WOStruct['#attributes.fuseaction#']['default'] = 'add';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.evoucher_integration_definitions';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/account/form/evoucher_integration_definition.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/account/query/evoucher_integration_definition.cfm';	
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.evoucher_integration_definitions';
	}
</cfscript>