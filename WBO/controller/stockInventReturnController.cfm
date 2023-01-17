<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.add_invent_return';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/stock/form/add_invent_return.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/stock/form/add_invent_return.cfm';
		WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'stock.add_invent_return';
		
		if(isdefined('get_system_inventory') and get_system_inventory.recordcount)
		{
			WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.add_invent_return';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'WBO/controller/stockPurchaseController.cfm';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'WBO/controller/stockPurchaseController.cfm';
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.form_add_purchase&event=upd';	
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.form_add_purchase&event=upd&ship_id=';
		}
		
		WOStruct['#attributes.fuseaction#']['addOther'] = structNew();
		WOStruct['#attributes.fuseaction#']['addOther']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['addOther']['fuseaction'] = 'stock.add_invent_return';
		WOStruct['#attributes.fuseaction#']['addOther']['filePath'] = 'WBO/controller/stockPurchaseController.cfm';
		WOStruct['#attributes.fuseaction#']['addOther']['queryPath'] = 'WBO/controller/stockPurchaseController.cfm';
		WOStruct['#attributes.fuseaction#']['addOther']['nextEvent'] = 'stock.form_add_purchase&event=upd&ship_id=';	
	}
</cfscript>
