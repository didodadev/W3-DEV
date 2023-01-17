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
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.set_product_manager';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/product/display/set_product_manager.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/product/query/set_product_manager.cfm';
        WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'product.set_product_manager';
    }
    WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
    WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'list';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PRODUCT';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PRODUCT_CATID';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-cat', 'item-product_manager_name']";

</cfscript>