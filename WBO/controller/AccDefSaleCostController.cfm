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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.form_add_cost_table_def';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/account/form/add_cost_table_def.cfm';	
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/account/query/add_cost_table_def.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '';
		
	}
	
</cfscript>
