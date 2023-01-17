<cfscript>

    if (attributes.tabMenuController eq 0) 
    {

        WOStruct = structNew();

        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'add';
        if (not isDefined("attributes.event"))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        WOStruct['#attributes.fuseaction#']['edit'] = structNew();
        WOStruct['#attributes.fuseaction#']['edit']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['edit']['fuseaction'] = 'textile.product_tree&event=edit';
        WOStruct['#attributes.fuseaction#']['edit']['filePath'] = '/WBP/Fashion/files/product/form/edit_tree.cfm';
        WOStruct['#attributes.fuseaction#']['edit']['queryPath'] = '/WBP/Fashion/files/product/query/tree_copy.cfm';
        WOStruct['#attributes.fuseaction#']['edit']['nextEvent'] = WOStruct['#attributes.fuseaction#']['edit']['fuseaction'];

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'textile.product_tree';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/WBP/Fashion/files/product/form/add_tree.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/WBP/Fashion/files/product/query/tree_copy.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = WOStruct['#attributes.fuseaction#']['edit']['fuseaction'];

    }

</cfscript>