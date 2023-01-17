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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'retail.list_manage_stocks';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/WBP/Retail/files/display/list_manage_stocks.cfm';	
		WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/WBP/Retail/files/display/list_manage_stocks.cfm';	
	
        WOStruct['#attributes.fuseaction#']['add']					= structNew();
		WOStruct['#attributes.fuseaction#']['add']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'retail.list_manage_stocks';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= '/WBP/Retail/files/form/manage_stocks.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath']		= '/WBP/Retail/files/query/manage_stocks.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent']     = '';

        WOStruct['#attributes.fuseaction#']['upd']					= structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction']	= 'retail.list_manage_stocks';
		WOStruct['#attributes.fuseaction#']['upd']['filePath']		= '/WBP/Retail/files/form/manage_stocks.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath']		= '/WBP/Retail/files/query/manage_stocks.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent']     = '';

		WOStruct['#attributes.fuseaction#']['del']					= structNew();
		WOStruct['#attributes.fuseaction#']['del']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction']	= 'retail.list_manage_stocks';
		WOStruct['#attributes.fuseaction#']['del']['filePath']		= '/WBP/Retail/files/query/delete_manage_stocks.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath']		= '/WBP/Retail/files/query/delete_manage_stocks.cfm';
	
	
	}
	else {
		
	}
	
</cfscript>