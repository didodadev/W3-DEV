<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.add_department_cat';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/settings/form/add_department_cat.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/settings/cfc/department_cat.cfc';
		
		if(isdefined("attributes.cat_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.add_department_cat&event=upd';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/settings/form/upd_department_cat.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/settings/cfc/department_cat.cfc';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.cat_id#';
		}
	}
</cfscript>