<cfscript>	
	if(attributes.tabMenuController eq 0)
		{
			WOStruct = StructNew();
			WOStruct['#attributes.fuseaction#'] = structNew();
			WOStruct['#attributes.fuseaction#']['default'] = 'list';
			WOStruct['#attributes.fuseaction#']['list'] = structNew();
			WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.list_workstation_expense';
			WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/production_plan/display/list_workstation_expense.cfm';
			
			WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.list_workstation_expense';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/production_plan/display/list_workstation_expense.cfm';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/production_plan/display/list_workstation_expense.cfm';
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'prod.list_workstation_expense';
			
			
		}
	else
		{
			
		}
	

</cfscript>
