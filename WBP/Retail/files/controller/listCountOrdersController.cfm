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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'retail.list_stock_count_orders';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/WBP/Retail/files/display/list_stock_count_orders.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/WBP/Retail/files/display/list_stock_count_orders.cfm';

		WOStruct['#attributes.fuseaction#']['add']					= structNew();
		WOStruct['#attributes.fuseaction#']['add']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'retail.list_stock_count_orders';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= '/WBP/Retail/files/form/add_stock_count_order.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath']		= '/WBP/Retail/files/query/add_stock_count_order.cfm';

		WOStruct['#attributes.fuseaction#']['transfer']					= structNew();
		WOStruct['#attributes.fuseaction#']['transfer']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['transfer']['fuseaction']	= 'retail.list_stock_count_orders';
		WOStruct['#attributes.fuseaction#']['transfer']['filePath']		= '/WBP/Retail/files/form/transfer_stock_count_order.cfm';
		WOStruct['#attributes.fuseaction#']['transfer']['queryPath']	= '/WBP/Retail/files/form/transfer_stock_count_order.cfm';

		WOStruct['#attributes.fuseaction#']['compare']					= structNew();
		WOStruct['#attributes.fuseaction#']['compare']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['compare']['fuseaction']	= 'retail.list_stock_count_orders';
		WOStruct['#attributes.fuseaction#']['compare']['filePath']		= '/WBP/Retail/files/display/list_stock_count_orders_compare.cfm';
		WOStruct['#attributes.fuseaction#']['compare']['queryPath']		= '/WBP/Retail/files/display/list_stock_count_orders_compare.cfm';

		WOStruct['#attributes.fuseaction#']['compareOrders']				= structNew();
		WOStruct['#attributes.fuseaction#']['compareOrders']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['compareOrders']['fuseaction']	= 'retail.list_stock_count_orders';
		WOStruct['#attributes.fuseaction#']['compareOrders']['filePath']	= '/WBP/Retail/files/display/compare_orders.cfm';
		WOStruct['#attributes.fuseaction#']['compareOrders']['queryPath']	= '/WBP/Retail/files/display/compare_orders.cfm';

		WOStruct['#attributes.fuseaction#']['del']					= structNew();
		WOStruct['#attributes.fuseaction#']['del']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction']	= 'retail.list_stock_count_orders';
		WOStruct['#attributes.fuseaction#']['del']['filePath']		= '/WBP/Retail/files/query/del_stock_count_order.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath']	= '/WBP/Retail/files/query/del_stock_count_order.cfm';
		
		WOStruct['#attributes.fuseaction#']['upd']					= structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window']		= 'popup';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction']	= 'retail.list_stock_count_orders';
		WOStruct['#attributes.fuseaction#']['upd']['filePath']		= '/WBP/Retail/files/form/upd_stock_count_order.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath']		= '/WBP/Retail/files/query/upd_stock_count_order.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent']     = 'retail.list_stock_count_orders&event=upd&order_id=';
		WOStruct['#attributes.fuseaction#']['upd']['parameters']    = '&order_id=##attributes.order_id##';
		if(isdefined("attributes.order_id"))
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.order_id#';

		WOStruct['#attributes.fuseaction#']['delRow']					= structNew();
		WOStruct['#attributes.fuseaction#']['delRow']['window']			= 'popup';
		WOStruct['#attributes.fuseaction#']['delRow']['fuseaction']		= 'retail.list_stock_count_orders';
		WOStruct['#attributes.fuseaction#']['delRow']['filePath']		= '/WBP/Retail/files/query/delete_stock_count_order_products.cfm';
        WOStruct['#attributes.fuseaction#']['delRow']['queryPath']		= '/WBP/Retail/files/query/delete_stock_count_order_products.cfm';
		WOStruct['#attributes.fuseaction#']['delRow']['nextEvent']     = 'retail.list_stock_count_orders&event=upd&order_id=';
		WOStruct['#attributes.fuseaction#']['delRow']['parameters']    = '&order_id=##attributes.order_id##';
		if(isdefined("attributes.order_id"))
			WOStruct['#attributes.fuseaction#']['delRow']['Identity'] = '#attributes.order_id#';
		
	
	}
	else {
	}
</cfscript>