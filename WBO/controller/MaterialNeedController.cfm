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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.list_materials_total';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/production_plan/display/list_materials_total.cfm';
	}
	
	
</cfscript>

<!---WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BUDGET';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'budget_id';--->