<cfscript>
	// Switch //
	if(attributes.tabMenuController eq 0)
	{	
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'invoice.list_sale_multi';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/invoice/display/list_sale_multi.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/invoice/display/list_sale_multi.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invoice.popup_form_add_sale_multi';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/invoice/form/add_sale_multi.cfm';		
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/invoice/query/add_sale_multi.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invoice.list_sale_multi';
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'INVOICE';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'INVOICE_ID';
</cfscript>