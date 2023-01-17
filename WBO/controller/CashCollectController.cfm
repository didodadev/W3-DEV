<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		
		
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cash.form_add_cash_revenue';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/cash/form/add_cash_revenue.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/cash/form/add_cash_revenue.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_cash_revenue';



		
	}
</cfscript>
