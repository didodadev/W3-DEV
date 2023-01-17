<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'upd';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invent.upd_collacted_inventory';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/inventory/form/upd_collacted_inventory.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/inventory/query/add_inventory_history.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '';
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'INVENTORY_HISTORY';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'INVENTORY_HISTORY_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "";
	}
</cfscript>