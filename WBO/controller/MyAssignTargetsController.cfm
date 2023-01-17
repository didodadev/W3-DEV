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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.my_assign_targets';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/myhome/display/my_assign_targets.cfm';
		WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'myhome.my_assign_targets';

	}
	else
	{

	}
</cfscript>