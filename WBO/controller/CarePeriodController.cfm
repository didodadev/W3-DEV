<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();

        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if (not isdefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'assetcare.list_assetp_period';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/assetcare/display/list_assetp_period.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/assetcare/display/list_assetp_period.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'assetcare.list_assetp_period';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/assetcare/form/add_care_period.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/assetcare/query/add_care_period.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'assetcare.list_assetp_period&event=upd&care_id=';

        if (isdefined("attributes.care_id"))
        {
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'assetcare.form_upd_care_period';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/assetcare/form/upd_care_period.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/assetcare/query/upd_care_period.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.care_id#';
			if(isdefined("attributes.failure_id") and len(attributes.failure_id))
	            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'assetcare.list_asset_failure&event=upd&failure_id=';
			else
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'assetcare.list_assetp_period&event=upd&care_id=';

            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'assetcare.emptypopup_del_asset_report&care_id=#attributes.care_id#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/assetcare/query/del_asset_report.cfm';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/assetcare/query/del_asset_report.cfm';

        }
    }
    else  {
        fuseactController = caller.attributes.fuseaction;
        getLang = caller.getLang;

        tabMenuStruct = StructNew();
        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
        if (caller.attributes.event is 'add')
        {

            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',1885)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=assetcare.list_assetp_period";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('assetcare',786)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
        }
        if (caller.attributes.event is 'upd')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',1885)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=assetcare.list_assetp_period";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main', 170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=assetcare.list_assetp_period&event=add";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main', 62)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_type=#attributes.care_id#','WOC')";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',52)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=order_id&action_id=#attributes.care_id#&wrkflow=1','Workflow')";

        }
        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

    }
    WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
    WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CARE_STATES';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CARE_ID';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-assetp_name' , 'item-care_type' , 'item-care_date']";


</cfscript>