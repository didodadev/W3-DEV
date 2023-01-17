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
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'retail.popup_add_bonus';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= '/WBP/Retail/files/form/add_bonus.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath']		= '/WBP/Retail/files/query/add_bonus.cfm';
		
	
	}
	else {
	}
</cfscript>