<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['add']					= structNew();
		WOStruct['#attributes.fuseaction#']['add']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'retail.emptypopup_export_stock';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= '/WBP/Retail/files/query/export_stock.cfm';	
		WOStruct['#attributes.fuseaction#']['add']['queryPath']	= '/WBP/Retail/files/query/export_stock.cfm';	
	
	

	
	}
	else {
		
	}
	
</cfscript>