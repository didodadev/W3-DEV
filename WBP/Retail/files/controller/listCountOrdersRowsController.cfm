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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'retail.list_stock_count_orders_rows';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/WBP/Retail/files/display/list_stock_count_orders_rows.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/WBP/Retail/files/display/list_stock_count_orders_rows.cfm';

		WOStruct['#attributes.fuseaction#']['add']					= structNew();
		WOStruct['#attributes.fuseaction#']['add']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'retail.list_stock_count_orders_rows';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= '/WBP/Retail/files/form/add_stock_counts_row.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath']		= '/WBP/Retail/files/query/add_stock_counts_row.cfm';

		WOStruct['#attributes.fuseaction#']['del']					= structNew();
		WOStruct['#attributes.fuseaction#']['del']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction']	= 'retail.list_stock_count_orders_rows';
		WOStruct['#attributes.fuseaction#']['del']['filePath']		= '/WBP/Retail/files/query/del_stock_counts_row.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath']	= '/WBP/Retail/files/query/del_stock_counts_row.cfm';
		
		WOStruct['#attributes.fuseaction#']['upd']					= structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction']	= 'retail.list_stock_count_orders_rows';
		WOStruct['#attributes.fuseaction#']['upd']['filePath']		= '/WBP/Retail/files/form/upd_stock_counts_row.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath']		= '/WBP/Retail/files/query/upd_stock_counts_row.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent']     = 'retail.list_stock_count_orders_rows&event=upd&row_id=';
		WOStruct['#attributes.fuseaction#']['upd']['parameters']    = '&row_id=##attributes.row_id##';
		if(isdefined("attributes.row_id"))
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.row_id#';
		
	
	}
	else {
	}
</cfscript>