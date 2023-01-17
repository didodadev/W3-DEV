<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'report';
		
		if(not isDefined("attributes.event"))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['report'] = structNew();
		WOStruct['#attributes.fuseaction#']['report']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['report']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.list_icmal';
		WOStruct['#attributes.fuseaction#']['report']['filePath'] = 'V16/hr/ehesap/display/list_icmal.cfm';
	}
</cfscript>