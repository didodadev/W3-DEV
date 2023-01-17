<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();

	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'dev.pageDesigner';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'development/form/addPageDesigner.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'development/query/addPageDesigner.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'dev.pageDesigner&event=upd';

	WOStruct['#attributes.fuseaction#']['default'] = structNew();
	WOStruct['#attributes.fuseaction#']['default']['fuseaction'] = 'dev.pageDesigner';
	WOStruct['#attributes.fuseaction#']['default']['filePath'] = 'development/display/pageDesigner.cfm';
</cfscript>
