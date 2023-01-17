<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'bank.list_bank_actions';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/bank/display/list_bank_actions.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath'] = '/V16/bank/display/list_bank_actions.cfm';
	
	}
	
</cfscript>