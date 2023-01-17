<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'training_management.definitions';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/training_management/display/definitions.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/training_management/display/definitions.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'training_management.form_add_training_section';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/training_management/form/add_training_section.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/training_management/query/add_training_section.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'training_management.definitions&event=upd&training_sec_id=';

        if(isdefined("attributes.training_sec_id"))
        {
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'training_management.form_upd_training_section';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/training_management/form/upd_training_section.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/training_management/query/upd_training_section.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.training_sec_id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'training_management.definitions&event=upd&training_sec_id=';


            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=training_management.emptypopup_del_training_section&training_sec_id=#attributes.TRAINING_SEC_ID#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/training_management/query/del_training_section.cfm';
            WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'training_sec_id';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/training_management/query/del_training_section.cfm';
            WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'training_management.definitions';


        }

    }
    else{
        fuseactController = caller.attributes.fuseaction;
        // Tab Menus //
        tabMenuStruck = StructNew();

        tabMenuStruck['fuseactController'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

        getLang = caller.getLang;

        if(isdefined("attributes.event") and attributes.event is 'add')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=training_management.definitions";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
        }
        else if(isdefined("attributes.event") and attributes.event is 'upd')
        {

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=training_management.definitions";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=training_management.definitions&event=add";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";


        }

        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
    }
</cfscript>