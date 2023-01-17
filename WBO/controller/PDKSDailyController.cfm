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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.day_pdks_table';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/day_pdks_table.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/hr/display/day_pdks_table.cfm';
		WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'hr.day_pdks_table';

		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'list';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = '';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = '';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-dates']";

	}
</cfscript>
