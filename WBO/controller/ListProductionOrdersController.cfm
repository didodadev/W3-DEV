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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'production.list_production_orders';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/production/display/list_production_orders.cfm'; 	
		WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = '';
	
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.add_prod_order';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/production_plan/form/add_prod_order.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/production_plan/form/add_prod_order.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'production.list_production_orders&event=upd&upd=';

		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'prod.add_prod_order';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/production_plan/form/upd_prod_order.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/production_plan/query/upd_production_order.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'upd=##attributes.upd##';
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.upd##';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'production.list_production_orders&event=upd&upd=';

		WOStruct['#attributes.fuseaction#']['multi-add'] = structNew();
		WOStruct['#attributes.fuseaction#']['multi-add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['multi-add']['fuseaction'] = 'prod.add_prod_order';
		WOStruct['#attributes.fuseaction#']['multi-add']['filePath'] = 'V16/production_plan/form/add_prod_order.cfm';
		WOStruct['#attributes.fuseaction#']['multi-add']['queryPath'] = '/V16/production_plan/query/add_production_order_all_sub.cfm';
		WOStruct['#attributes.fuseaction#']['multi-add']['nextEvent'] = 'production.list_production_orders&event=list&is_submitted=1&keyword=';
	}
	
</cfscript>