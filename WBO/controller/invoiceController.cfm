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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'invoice.list_bill';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/invoice/display/list_bill.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/invoice/query/list_bill.cfm';
		WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'invoice.list_bill';
		
		WOStruct['#attributes.fuseaction#']['print'] = structNew();
		WOStruct['#attributes.fuseaction#']['print']['cfcName'] = 'invoiceControllerPrint';
		WOStruct['#attributes.fuseaction#']['print']['identity'] = 'invoice_id';
	}
	else
	{	
/*		WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
		WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'invoiceBill';
		WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'INVOICE';
		WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-process_stage','item-comp_name','item-partner_name','item-serial_no','item-invoice_date','item-location_id','item-adres']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.		
*/		
	}
</cfscript>
