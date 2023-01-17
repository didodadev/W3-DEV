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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.form_add_budget_categories_import';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/settings/form/add_budget_categories_import.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/settings/query/add_budget_categories_import.cfm';
		
	}
	
    
    
</cfscript>