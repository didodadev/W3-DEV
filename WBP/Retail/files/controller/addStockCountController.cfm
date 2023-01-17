<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	

		WOStruct['#attributes.fuseaction#']['add']					= structNew();
		WOStruct['#attributes.fuseaction#']['add']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'retail.emptypopup_add_stocks_row_count_order';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= '/WBP/Retail/files/query/add_stocks_count.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath']		= '/WBP/Retail/files/query/add_stocks_count.cfm';
		
	
	}
	else {
	}
</cfscript>