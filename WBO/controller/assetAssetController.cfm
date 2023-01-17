<cfscript>
    if(attributes.tabMenuController eq 0){
        WOStruct = StructNew();

        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if(not isdefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'asset.list_asset';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/asset/display/list_asset.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/asset/display/list_asset.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'asset.form_add_asset';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/asset/form/form_add_asset.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/asset/query/add_asset.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'asset.list_asset&event=upd&asset_id=';

        if(isdefined("attributes.asset_id")){
			WOStruct['#attributes.fuseaction#']['updPopup'] = structNew();
            WOStruct['#attributes.fuseaction#']['updPopup']['window'] = 'popup';
            WOStruct['#attributes.fuseaction#']['updPopup']['fuseaction'] = 'objects.popup_form_upd_asset';
            WOStruct['#attributes.fuseaction#']['updPopup']['filePath'] = 'V16/objects/form/popup_upd_asset.cfm';
            WOStruct['#attributes.fuseaction#']['updPopup']['queryPath'] = 'V16/asset/query/upd_asset.cfm';
            WOStruct['#attributes.fuseaction#']['updPopup']['Identity'] = '#attributes.asset_id#';
            WOStruct['#attributes.fuseaction#']['updPopup']['nextEvent'] = 'asset.list_asset&event=upd&asset_id=';
			
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'asset.form_upd_asset';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/asset/form/form_upd_asset.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/asset/query/upd_asset.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.asset_id#';
            if(isdefined("attributes.assetcat_id"))
                WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'asset.list_asset&event=upd&assetcat_id=#attributes.assetcat_id#&asset_id=';
            else
                WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'asset.list_asset&event=upd&asset_id=';

            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'asset.del_asset&asset_id=#attributes.asset_id#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/asset/query/del_asset.cfm';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/asset/query/del_asset.cfm';
        }
    }else{
        fuseactController = caller.attributes.fuseaction;
        getLang = caller.getLang;

        tabMenuStruct = StructNew();
        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

        if (caller.attributes.event is 'add') {
             tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('sales', 154)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=asset.list_asset&list_type=changeListType&listTypeElement=list";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main', 49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
            tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-folder']['text'] = "#getLang('sales',154)#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-folder']['href'] = "#request.self#?fuseaction=asset.list_asset";
        }
        if (caller.attributes.event is 'upd')
        {
            asset = caller.asset_id;

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = "#getLang('main',170)#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=asset.list_asset&event=add";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = "#getLang('main',64)#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=asset.list_asset&event=add&asset_id=#attributes.asset_id#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = "#getLang('main',62)#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.asset_id#&print_type=74','page','workcube_print')";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = "#getLang('sales',154)#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=asset.list_asset&list_type=changeListType&listTypeElement=list";
            
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = "#getLang('main',52)#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=asset_id&action_id=#attributes.asset_id#','Workflow')";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-folder']['text'] = "#getLang('sales',154)#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-folder']['href'] = "#request.self#?fuseaction=asset.list_asset";
         /*    i=0;
            
            

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = "#getLang('asset',199)#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "revision();";
            i=i+1; */
            
            tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
        }
    }
    WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
    WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'ASSET';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ASSET_ID';
    WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-asset_no' , 'item-assetcat_id' , 'item-asset_file' , 'item-property_id' , 'item-asset_name']";

</cfscript>