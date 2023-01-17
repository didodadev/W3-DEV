<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();	
		WOStruct['#attributes.fuseaction#']['default'] = 'add';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invent.popup_cancel_invent';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/inventory/form/cancel_invent.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/inventory/query/cancel_invent.cfm';	
	}
</cfscript>