<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	

		WOStruct['#attributes.fuseaction#']['list']					= structNew();
		WOStruct['#attributes.fuseaction#']['list']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'retail.emptypopup_import_sales';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/WBP/Retail/files/query/upload_sales_cards.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/WBP/Retail/files/query/upload_sales_cards.cfm';

	
	}
	else {
	}
</cfscript>