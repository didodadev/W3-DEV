<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.workstation_graph';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'production_plan/display/workstation_graph.cfm';
	WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'production_plan/display/workstation_graph.cfm';
	WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'prod.workstation_graph';
</cfscript>
