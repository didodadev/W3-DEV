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
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/WBP/Fashion/files/sales/display/list_pattern_plan.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'textile.pattern_plan&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/WBP/Fashion/files/sales/form/add_pattern_plan.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/WBP/Fashion/files/sales/query/add_pattern_plan.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = WOStruct['#attributes.fuseaction#']['list']['fuseaction'];
		
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'textile.pattern_plan&event=upd';
        WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/WBP/Fashion/files/sales/form/upd_pattern_plan.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/WBP/Fashion/files/sales/query/upd_product_plan.cfm';
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
			product_id = caller.query_product_plan.product_id;
			req_id = caller.query_product_plan.req_id;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['text'] = 'Ölçü Tablosu';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['href'] = "#request.self#?fuseaction=textile.stretching_test&event=measure_list&req_id=#req_id#&pid=#product_id#";
			
            i = 1;
            
            

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = 'Fermuar Ekle';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=textile.product_tree&event=edit&pid=#caller.get_opportunity.product_id#&req_id=#req_id#','page')";
                i = i+ 1;
                
            
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>