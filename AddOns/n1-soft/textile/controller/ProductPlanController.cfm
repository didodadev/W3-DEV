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
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'textile.product_plan';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/AddOns/N1-Soft/textile/sales/display/list_product_plan.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'textile.product_plan&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/AddOns/N1-Soft/textile/sales/form/add_product_plan.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/AddOns/N1-Soft/textile/sales/query/add_product_plan.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = WOStruct['#attributes.fuseaction#']['list']['fuseaction'];
		
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'textile.product_plan&event=upd';
        WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/AddOns/N1-Soft/textile/sales/form/upd_product_plan.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/AddOns/N1-Soft/textile/sales/query/upd_product_plan.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = WOStruct['#attributes.fuseaction#']['list']['fuseaction'];
		
			WOStruct['#attributes.fuseaction#']['add_order_assortment'] = structNew();
        WOStruct['#attributes.fuseaction#']['add_order_assortment']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['add_order_assortment']['fuseaction'] = 'textile.product_plan&event=add_order_assortment';
        WOStruct['#attributes.fuseaction#']['add_order_assortment']['filePath'] = '/AddOns/N1-Soft/textile/product/form/add_order_assortment.cfm';
        WOStruct['#attributes.fuseaction#']['add_order_assortment']['queryPath'] = '/AddOns/N1-Soft/textile/product/query/add_order_assortment.cfm';
        WOStruct['#attributes.fuseaction#']['add_order_assortment']['nextEvent'] = WOStruct['#attributes.fuseaction#']['list']['fuseaction'];

			WOStruct['#attributes.fuseaction#']['add_tree'] = structNew();
        WOStruct['#attributes.fuseaction#']['add_tree']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['add_tree']['fuseaction'] = 'textile.product_plan&event=add_tree';
        WOStruct['#attributes.fuseaction#']['add_tree']['filePath'] = '/AddOns/N1-Soft/textile/product/form/add_tree.cfm';
        WOStruct['#attributes.fuseaction#']['add_tree']['queryPath'] = '/AddOns/N1-Soft/textile/product/query/tree_copy.cfm';
        WOStruct['#attributes.fuseaction#']['add_tree']['nextEvent'] = WOStruct['#attributes.fuseaction#']['list']['fuseaction'];
		
		
    }

</cfscript>