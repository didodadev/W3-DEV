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
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.list_subscription_payment_plan_import';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/sales/display/list_subscription_payment_plan_import.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/sales/display/list_subscription_payment_plan_import.cfm';


        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'sales.list_subscription_payment_plan_import';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/sales/form/add_subscription_payment_plan_import.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/sales/query/add_subscription_payment_plan_import.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'sales.list_subscription_payment_plan_import&event=upd&import_id=';


        if(isdefined("attributes.event") and listFind('del,upd',attributes.event))
        {   
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'sales.list_subscription_payment_plan_import';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/sales/form/upd_subscription_payment_plan_import.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/sales/query/upd_subscription_payment_plan_import.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.import_id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'sales.list_subscription_payment_plan_import&event=upd&import_id=';

            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'sales.list_subscription_payment_plan_import&event=del&import_id=#attributes.import_id#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/sales/query/del_subscription_payment_plan_import.cfm';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/sales/query/del_subscription_payment_plan_import.cfm';
        }
 
    }
    else  {
        fuseactController = caller.attributes.fuseaction;

        tabMenuStruct = StructNew();
        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

        if(caller.attributes.event is 'upd')
		{
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = 'Uyarılar';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['href'] = "#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=iid&action_id=#attributes.import_id#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = 'Liste';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#attributes.fuseaction#";
        }
        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);	
    }
    

    WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
    WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SUBSCRIPTION_PAYMENT_PLAN_IMPORT';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'IMPORT_ID';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-subscription_head' , 'item-form_ul_company_name' , 'item-form_ul_process_stage' , 'item-form_ul_subscription_type' , 'item-form_ul_start_date']";

</cfscript>