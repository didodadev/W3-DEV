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
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'textile.pattern_plan';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/AddOns/N1-Soft/textile/sales/display/list_pattern_plan.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'textile.pattern_plan&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/AddOns/N1-Soft/textile/sales/form/add_pattern_plan.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/AddOns/N1-Soft/textile/sales/query/add_pattern_plan.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = WOStruct['#attributes.fuseaction#']['list']['fuseaction'];
		
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'textile.pattern_plan&event=upd';
        WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/AddOns/N1-Soft/textile/sales/form/upd_pattern_plan.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/AddOns/N1-Soft/textile/sales/query/upd_product_plan.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = WOStruct['#attributes.fuseaction#']['list']['fuseaction'];

    }
	else 
	{		
		fuseactController = attributes.fuseaction;
		
		
		tabMenuStruct = StructNew();
	    tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		getLang = caller.getLang;
		
		if(isdefined("attributes.event") and attributes.event is 'upd' )
		{
			plan_id = attributes.plan_id;
			req_id = caller.query_product_plan.req_id;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['text'] = 'Ölçü Tablosu';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['href'] = "#request.self#?fuseaction=textile.stretching_test&event=measure_list&req_id=#req_id#&pid=#plan_id#";
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>