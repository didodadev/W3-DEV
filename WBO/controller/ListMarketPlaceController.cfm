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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'invoice.marketplace_commands';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= 'V16/invoice/display/list_marketplace_commands.cfm';	
		WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '';	
	
	

	
	}
	else {
		
	}
	
</cfscript>