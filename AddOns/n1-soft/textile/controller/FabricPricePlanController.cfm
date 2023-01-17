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
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'textile.fabric_price';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/AddOns/N1-Soft/textile/sales/display/list_fabric_price.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'textile.fabric_price&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/AddOns/N1-Soft/textile/sales/form/add_fabric_price.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/AddOns/N1-Soft/textile/sales/query/add_fabric_price.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = WOStruct['#attributes.fuseaction#']['list']['fuseaction'];
		
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'textile.fabric_price&event=upd';
        WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/AddOns/N1-Soft/textile/sales/form/upd_fabric_price.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/AddOns/N1-Soft/textile/sales/query/upd_product_plan.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = WOStruct['#attributes.fuseaction#']['list']['fuseaction'];
		
		
    }
fuseactController = attributes.fuseaction;
		tabMenuStruct = StructNew();
	    tabMenuStruct['#fuseactController#'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
	
		 
		tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['text'] = 'Yeni Ürün Kayıt';
		tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=product.list_product&event=add','list');";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
</cfscript>