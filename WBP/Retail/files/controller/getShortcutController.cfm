<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	

		WOStruct['#attributes.fuseaction#']['add']					= structNew();
		WOStruct['#attributes.fuseaction#']['add']['window']		= 'window';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'retail.emptypopup_get_short_cuts';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= '/WBP/Retail/files/form/get_short_cuts.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath']		= '/WBP/Retail/files/form/get_short_cuts.cfm';
		
	
	}
	else {
	}
</cfscript>