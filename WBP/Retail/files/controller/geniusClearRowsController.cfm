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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'retail.genius_clear_rows';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= '/WBP/Retail/files/form/genius_clear_rows.cfm';	
		WOStruct['#attributes.fuseaction#']['add']['queryPath']	= '/WBP/Retail/files/query/genius_clear_rows.cfm';	
		WOStruct['#attributes.fuseaction#']['add']['nextEvent']	= 'retail.genius_clear_rows';	
	
	
	}
	else {
		
	}
	
</cfscript>