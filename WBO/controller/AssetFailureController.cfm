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
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'assetcare.list_asset_failure';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/assetcare/display/list_asset_failure.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/assetcare/display/list_asset_failure.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'assetcare.form_add_asset_failure';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/assetcare/form/form_add_asset_failure.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/assetcare/query/add_asset_failue.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'assetcare.list_asset_failure&event=upd&failure_id=';

        if (isdefined("attributes.failure_id"))
        {
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'assetcare.form_upd_asset_failure';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/assetcare/form/form_upd_asset_failure.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/assetcare/query/upd_asset_failure.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.failure_id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'assetcare.list_asset_failure&event=upd&failure_id=';

            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'assetcare.emptypopup_del_asset_failure&failure_id=#attributes.failure_id#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/assetcare/query/del_asset_failure.cfm';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/assetcare/query/del_asset_failure.cfm';

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
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=assetcare.list_asset_failure";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
        }
        if (caller.attributes.event is 'upd')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=assetcare.list_asset_failure";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main', 170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=assetcare.list_asset_failure&event=add";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_type=#attributes.failure_id#')";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onclick'] =  "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=failure_id&action_id=#attributes.failure_id#','Workflow')";


        }
        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

    }
    WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
    WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'ASSET_FAILURE_NOTICE';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'FAILURE_ID';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-document_no' , 'item-surecler' , 'item-assetp_name' , 'item-care_type' , 'item-failure_head']";
</cfscript>
