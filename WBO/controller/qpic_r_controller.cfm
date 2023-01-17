<cfscript>
    if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'process.qpic-r';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/process/display/qpic_r_main.cfm';
			
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'process.qpic-r';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/process/display/qpic_r_process.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/process/query/add_process_qpic.cfm';
	
		
	}
</cfscript>