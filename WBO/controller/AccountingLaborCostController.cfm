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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.product_labor_cost_paper';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/account/display/product_cost_rate_paper.cfm';		
	}
</cfscript>
