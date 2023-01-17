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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'retail.list_order';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/WBP/Retail/files/display/list_order.cfm';	
		WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/WBP/Retail/files/display/list_order.cfm';	
	
		WOStruct['#attributes.fuseaction#']['add']					= structNew();
		WOStruct['#attributes.fuseaction#']['add']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'retail.list_order';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= '/WBP\Retail\files\form\add_order.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath']		= '/WBP\Retail\files\form\add_order.cfm';
		WOStruct['#attributes.fuseaction#']['add']['Xmlfuseaction']	= 'purchase.detail_order';

		WOStruct['#attributes.fuseaction#']['upd']					= structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction']	= 'retail.list_order';
		WOStruct['#attributes.fuseaction#']['upd']['filePath']		= 'V16\purchase\form\detail_order.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath']		= '/V16/query/upd_order.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['Xmlfuseaction']	= 'purchase.detail_order';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'member.form_list_company&event=upd&order_id=';
		WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'order_id=##attributes.order_id##';
		if(isdefined("attributes.order_id"))
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.order_id#';

	
	}
	else {
	}
</cfscript>