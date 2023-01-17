<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		// Switch //
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		
		if(not isdefined("attributes.event"))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invoice.whops';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/invoice/display/retail.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/invoice/query/add_invoice_retail.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invoice.add_bill_retail&event=upd';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(add_bill_retail)";
	
	}

</cfscript>