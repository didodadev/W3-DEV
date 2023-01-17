<cfscript>
    // Switch //
    if(attributes.tabMenuController eq 0)
    {    
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        
        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_target_cat';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_target_cat.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/hr/display/list_target_cat.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.form_add_target_cat';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/form/form_add_target_cat.cfm';        
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/query/add_target_cat.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_target_cat&event=upd&targetcat_id=';


        if(isdefined("attributes.targetcat_id"))
        {    
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.form_upd_target_cat';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/hr/form/form_upd_target_cat.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/hr/query/upd_target_cat.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.targetcat_id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_target_cat&event=upd&targetcat_id=';
            
            
            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=hr.emptypopup_del_target_cat&target_cat_id=#attributes.targetcat_id#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/query/del_target_cat.cfm';
            WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'targetcat_id';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/query/del_target_cat.cfm';
            WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_target_cat';
        
         
        }
    
        
    }
    else
    {
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
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_target_cat";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";    
        }
        else if(isdefined("attributes.event") and attributes.event is 'upd')
        {
            
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_target_cat";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_target_cat&event=add";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";    
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=hr.list_target_cat&event=add&targetcat_id=#attributes.targetcat_id#";
            

        }

        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

    }
    
    
    WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
    WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add';


    </cfscript>
