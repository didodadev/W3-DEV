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
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'assetcare.list_asset_care';
		WOStruct['#attributes.fuseaction#']['list']['XmlFuseaction'] = 'assetcare.form_add_asset_care';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/assetcare/display/list_asset_care.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/assetcare/display/list_asset_care.cfm';


        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'assetcare.form_add_asset_care';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/assetcare/display/add_asset_care.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/assetcare/query/add_asset_care.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'assetcare.list_asset_care&event=upd&care_report_id=';
		
		WOStruct['#attributes.fuseaction#']['popupAdd'] = structNew();
        WOStruct['#attributes.fuseaction#']['popupAdd']['window'] = 'popup';
        WOStruct['#attributes.fuseaction#']['popupAdd']['fuseaction'] = 'assetcare.form_add_asset_care';
        WOStruct['#attributes.fuseaction#']['popupAdd']['filePath'] = 'V16/assetcare/display/add_asset_care.cfm';
        WOStruct['#attributes.fuseaction#']['popupAdd']['queryPath'] = 'V16/assetcare/query/add_asset_care.cfm';
        WOStruct['#attributes.fuseaction#']['popupAdd']['nextEvent'] = 'assetcare.list_asset_care&event=upd&care_report_id=';

        if(isdefined("attributes.care_report_id"))
        {
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'assetcare.form_upd_asset_care';
			WOStruct['#attributes.fuseaction#']['upd']['XmlFuseaction'] = 'assetcare.form_add_asset_care';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/assetcare/display/upd_asset_care.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/assetcare/query/upd_asset_care.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.care_report_id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'assetcare.list_asset_care&event=upd&care_report_id=';

            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'assetcare.emptypopup_del_asset_care&care_report_id=#attributes.care_report_id#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/assetcare/query/del_asset_care.cfm';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/assetcare/query/del_asset_care.cfm';
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

            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main', 97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=assetcare.list_asset_care";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main', 2783)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
           
        }
        if (caller.attributes.event is 'upd')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main', 170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=assetcare.list_asset_care&event=add";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main', 64)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=assetcare.list_asset_care&event=add&care_report_id=#attributes.care_report_id#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.care_report_id#&print_type=74')";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main', 1303)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=assetcare.list_asset_care";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main', 52)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";    
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onclick'] =  "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=care_report_id&action_id=#attributes.care_report_id#','Workflow')";
      
        }         
        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

    
        WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
        WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
        WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'ASSET_CARE_REPORT';
        WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CARE_REPORT_ID';
        WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-asset_id' , 'item-asset_name' , 'item-care_start_date' , 'item-care_type_id']";
        
    }
</cfscript>