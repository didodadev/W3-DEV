<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();

        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.list_property';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/production_plan/display/list_property.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/production_plan/display/list_property.cfm';


        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.popup_add_property_main';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/production_plan/form/add_property_main.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/production_plan/query/add_property_main.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'prod.list_property&event=upd&prpt_id=';

        WOStruct['#attributes.fuseaction#']['padd'] = structNew();
        WOStruct['#attributes.fuseaction#']['padd']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['padd']['fuseaction'] = 'prod.popup_add_property';
        WOStruct['#attributes.fuseaction#']['padd']['filePath'] = 'V16/production_plan/form/add_property.cfm';
        WOStruct['#attributes.fuseaction#']['padd']['queryPath'] = 'V16/production_plan/query/add_property_act.cfm';
        WOStruct['#attributes.fuseaction#']['padd']['nextEvent'] = 'prod.list_property&event=upd&prpt_id=';

        WOStruct['#attributes.fuseaction#']['upd'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'prod.popup_upd_property_main';
        WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/production_plan/form/upd_property_main.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/production_plan/query/upd_property_main.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'prod.list_property';

        if(isdefined("attributes.PRPT_ID")){
            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'prod.emptypopup_del_property&property_id=#attributes.PRPT_ID#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/production_plan/query/del_product_property_main.cfm';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/production_plan/query/del_product_property_main.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'prod.list_property';
        }
    }

    WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
    WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,padd, del';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PRODUCT_PROPERTY';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PROPERTY_ID';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "[]";

</cfscript>