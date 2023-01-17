<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'report';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['report'] = structNew();
		WOStruct['#attributes.fuseaction#']['report']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['report']['fuseaction'] = 'ehesap.list_icmal_personal';
		WOStruct['#attributes.fuseaction#']['report']['filePath'] = 'V16/hr/ehesap/display/price_compass.cfm';
		WOStruct['#attributes.fuseaction#']['report']['queryPath'] = 'V16/hr/ehesap/display/price_compass.cfm';
		WOStruct['#attributes.fuseaction#']['report']['nextEvent'] = 'ehesap.list_icmal_personal';

	}
</cfscript>