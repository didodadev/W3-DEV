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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'retail.list_stock_export';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/WBP/Retail/files/display/list_stock_export.cfm';	
		WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/WBP/Retail/files/display/list_stock_export.cfm';	
	
		WOStruct['#attributes.fuseaction#']['add']					= structNew();
		WOStruct['#attributes.fuseaction#']['add']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'retail.list_stock_export';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= '/WBP/Retail/files/form/export_stock.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath']		= '/WBP/Retail/files/query/export_stock.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent']     = 'retail.list_pos_equipment';

		WOStruct['#attributes.fuseaction#']['delRow']					= structNew();
		WOStruct['#attributes.fuseaction#']['delRow']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['delRow']['fuseaction']	= 'retail.list_pos_equipment';
		WOStruct['#attributes.fuseaction#']['delRow']['filePath']		= '/WBP/Retail/files/query/del_stock_export_file.cfm';
        WOStruct['#attributes.fuseaction#']['delRow']['queryPath']		= '/WBP/Retail/files/query/del_stock_export_file.cfm';
		WOStruct['#attributes.fuseaction#']['delRow']['nextEvent']     = 'retail.list_pos_equipment';
	
	}
	else {
		
	}
	
</cfscript>