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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cash.form_add_cash_rate_valuation';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/cash/form/add_cash_rate_valuation.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/cash/form/add_cash_rate_valuation.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cash.form_add_cash_rate_valuation';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('add_due','add_due_bask');";	
				
	}
</cfscript>
