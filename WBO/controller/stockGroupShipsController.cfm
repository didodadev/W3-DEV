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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.list_group_ships';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/stock/display/list_group_ships.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.popup_add_ship_group_comp';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/stock/form/add_ship_group_comp_purchase.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/stock/query/add_ship_group_comp_purchase.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.list_group_ships&event=add&ship_id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_irs';
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SHIP';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ship_id';
	}
</cfscript>
