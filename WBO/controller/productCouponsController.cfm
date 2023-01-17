<cfscript>
    if(attributes.tabMenuController eq 0){
        WOStruct = StructNew();

        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if(not isdefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_coupons';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/product/display/list_coupons.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/product/display/list_coupons.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.popup_add_coupon';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/product/form/add_coupon.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/product/query/add_coupon.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_coupons'; // Duzenlenecek.

        if(isdefined("attributes.coupon_id")){
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.popup_upd_coupon';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/product/form/upd_coupon.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/product/query/upd_coupons.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_coupons'; // Duzenlenecek.

            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'product.emptypopup_del_coupon&coupon_id=#attributes.coupon_id#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/product/query/del_coupon.cfm';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/product/query/del_coupon.cfm';
        }
    }

    WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
    WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,del';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'COUPONS';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'COUPON_ID';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "[]";

</cfscript>