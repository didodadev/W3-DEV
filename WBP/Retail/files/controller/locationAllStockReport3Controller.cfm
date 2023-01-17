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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'retail.depo_all_stock_report3';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/WBP/Retail/files/report/depo_all_stock_report3.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/WBP/Retail/files/report/depo_all_stock_report3.cfm';		
	
	}
	else {
	}
</cfscript>