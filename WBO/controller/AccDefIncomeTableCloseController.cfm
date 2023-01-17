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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.account_closed_definition';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/account/form/account_closed_definition.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/account/query/add_account_closed_definition.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.account_closed_definition';

	}
	else
	{

	}
</cfscript>
