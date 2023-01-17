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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'pos.list_sayimlar';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/pos/display/list_sayimlar.cfm'; 	
		WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = '';
		
	}
	
</cfscript>