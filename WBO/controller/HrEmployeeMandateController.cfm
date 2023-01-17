<cfscript>
    if (attributes.tabMenuController eq 0) 
    {
        WOStruct = structNew();
        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if (not isDefined("attributes.event")) {
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];
        }

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.employee_mandate';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_employee_mandate.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.employee_mandate&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/form/add_employee_mandate.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/query/add_employee_mandate.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.employee_mandate&event=upd&id=';

        if (isDefined("attributes.id")) {

            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.employee_mandate&event=upd&id=';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/form/upd_employee_mandate.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/query/upd_employee_mandate.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.employee_mandate&event=upd&id='; 
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';    
        
        }
    } 
    else 
    {
        fuseactController = caller.attributes.fuseaction;
        getLang = caller.getLang;

        tabMenuStruct = structNew();
        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

        if (caller.attributes.event eq "add")
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = '_self';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main', 97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = '#request.self#?fuseaction=hr.employee_mandate';
            
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main', 49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = 'buttonClickFunction()';
        }
        else if (caller.attributes.event eq "upd") 
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();    
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = '_self';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main', 97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = '#request.self#?fuseaction=hr.employee_mandate';

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = '_self';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main', 97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = '#request.self#?fuseaction=hr.employee_mandate&event=add';

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main', 49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = 'buttonClickFunction()';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onclick'] =  "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=id&action_id=#attributes.id#&wrkflow=1','Workflow')";

        }
        else 
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['list']['icons'] = structNew();    
            tabMenuStruct['#fuseactController#']['tabMenus']['list']['icons']['add']['target'] = '_self';
            tabMenuStruct['#fuseactController#']['tabMenus']['list']['icons']['add']['text'] = '#getLang('main', 97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['list']['icons']['add']['href'] = '#request.self#?fuseaction=hr.employee_mandate&event=add';
        }
        tabMenuData = serializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
    }
</cfscript>