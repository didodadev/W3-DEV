<cfscript>
    if (attributes.tabMenuController eq 0)
    {

        WOStruct = structNew();

        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if (not isDefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];
        WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'production.order_operator';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/production/display/list_product_orders.cfm';
     
	
        if(isdefined("attributes.station_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = '';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'production.order_operator';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/production/form/order_operator.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.station_id#';
    	}
	}
		
</cfscript>