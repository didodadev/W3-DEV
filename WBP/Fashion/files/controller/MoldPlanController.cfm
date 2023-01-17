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
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'textile.mold_plan';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/WBP/Fashion/files/sales/display/list_mold_plan.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'textile.mold_plan&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/WBP/Fashion/files/sales/form/add_mold_plan.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/WBP/Fashion/files/sales/query/add_mold_plan.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = WOStruct['#attributes.fuseaction#']['list']['fuseaction'];
		
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'textile.mold_plan&event=upd';
        WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/WBP/Fashion/files/sales/form/upd_mold_plan.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/WBP/Fashion/files/sales/query/upd_product_plan.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = WOStruct['#attributes.fuseaction#']['list']['fuseaction'];

    }

</cfscript>