<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	

		WOStruct['#attributes.fuseaction#']['list']					= structNew();
		WOStruct['#attributes.fuseaction#']['list']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'retail.emptypopup_budget_codes_transfer';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/WBP/Retail/files/query/budget_codes_transfer.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/WBP/Retail/files/query/budget_codes_transfer.cfm';


	
	}
	else {
	}
</cfscript>