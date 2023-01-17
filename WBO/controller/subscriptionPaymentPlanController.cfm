<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();

        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'add';
        if(not isdefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        if(isdefined("attributes.subscription_id"))
        {
            WOStruct['#attributes.fuseaction#']['add'] = structNew();
            WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'sales.subscription_payment_plan';
            WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/sales/form/add_subscription_payment_plan.cfm';
            WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/sales/query/add_subscription_payment_plan.cfm';
            WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'sales.subscription_payment_plan&event=add&subscription_id=';
        }
    }
    else 
    {
        fuseactController = caller.attributes.fuseaction;
        getLang = caller.getLang;

        tabMenuStruct = StructNew();
        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

        if (caller.attributes.event is 'add') {

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['text'] = '#getlang('main',359)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#subscription_id#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-history']['text'] = '#getLang('','settings',57473)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-history']['onclick'] ="windowopen('#request.self#?fuseaction=sales.popup_list_subs_payment_plan_history&subscription_id=#attributes.subscription_id#','medium')";
            tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
        }
        
    }


</cfscript>