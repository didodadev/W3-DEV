<cfscript>
	if(attributes.tabMenuController eq 0)
	{

		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'assetcare.list_spare_parts';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/assetcare/display/list_spare_parts.cfm';
		
		
		if(isdefined("attributes.event") and attributes.event is 'add')
		{
			WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'assetcare.list_spare_parts';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/assetcare/display/add_spare_parts.cfm';
		}
		
		
		if ( isdefined("attributes.event") and attributes.event is 'upd')
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'assetcare.list_spare_parts';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/assetcare/display/upd_spare_parts.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.asset_parts_id#';
			
		}
	}
</cfscript>


