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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.update_positions';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/form/upd_positions.cfm';
		WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/hr/query/upd_positions.cfm';
		

	}
</cfscript>