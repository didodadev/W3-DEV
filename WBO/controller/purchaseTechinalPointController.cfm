<cfscript>	
	if(attributes.tabMenuController eq 0)
	{
        WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'objects.technical_point';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/purchase/display/emptypopup_get_technical_average_point.cfm';
        
        WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'objects.technical_point&event=add';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/purchase/display/technical_point.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/purchase/query/add_technical_point.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'objects.technical_point&event=add';

		
    }
</cfscript>