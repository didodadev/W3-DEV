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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.measurement_parameters';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/stock/display/measurement_parameters.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.measurement_parameters';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/stock/display/add_measurement_parameters.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/stock/query/add_measurement_parameters.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.measurement_parameters&evet_upd&measurement_id=';

		if(isdefined("attributes.measurement_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.measurement_parameters';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/stock/display/upd_measurement_parameters.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/stock/query/upd_measurement_parameters.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.measurement_parameters&event=upd&measurement_id=';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.measurement_id#';
		}
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'stock.measurement_parameters';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/stock/query/del_measurement_parameters.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'stock.measurement_parameters';
		
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
		getLang = caller.getLang;

		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
	}
</cfscript>