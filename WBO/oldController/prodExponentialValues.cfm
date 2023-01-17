<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.form_add_exponential_values';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'production_plan/form/add_exponential_values.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'production_plan/form/add_exponential_values.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'prod.form_add_exponential_values&event=add';
</cfscript>
