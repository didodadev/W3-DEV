
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'training_management.list_class_finished';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/training_management/display/list_class_finished.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;
	}
</cfscript>
