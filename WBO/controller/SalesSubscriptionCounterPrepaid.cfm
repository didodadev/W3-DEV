<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.subscription_counter_prepaid';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/sales/display/list_subscription_counter_prepaid.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'sales.subscription_counter_prepaid';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/sales/form/add_subscription_counter_prepaid.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/sales/query/add_subscription_counter_prepaid.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'sales.subscription_counter_prepaid&event=upd&scp_id=';

        if(isdefined("attributes.event") and listFind('del,upd',attributes.event))
        {	
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'sales.subscription_counter_prepaid';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/sales/form/upd_subscription_counter_prepaid.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/sales/query/upd_subscription_counter_prepaid.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'sales.subscription_counter_prepaid&event=upd&scp_id=';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.scp_id#';
            WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'scp_id=##attributes.scp_id##';

            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#.subscription_counter_prepaid&scp_id=#attributes.scp_id#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/sales/query/del_subscription_counter_prepaid.cfm';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/sales/query/del_subscription_counter_prepaid.cfm';
            WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'sales.subscription_counter_prepaid';
        }

    }
    else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		if((isdefined("attributes.event") and attributes.event is 'add') or (isdefined("attributes.event") and attributes.event is 'upd'))
        {
			if(attributes.event is 'upd'){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170,'ekle')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=sales.subscription_counter_prepaid&event=add";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=sales.subscription_counter_prepaid";

        }
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
    }
    WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
    WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SUBSCRIPTION_COUNTER_PREPAID';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'SCP_ID';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_stage' , 'item-subscription_no' , 'item-counter_type' , 'item-loading_price' , 'item-total_price' , 'item-loading_date' , 'item-emp_id' , 'item-islem_tur']";
</cfscript>