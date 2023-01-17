<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.add_demand_assemption';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/production_plan/form/add_demand_assemption.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/production_plan/form/add_demand_assemption.cfm';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('demand_assemption','demand_assemption_bask');";
		
	}
	
</cfscript>

