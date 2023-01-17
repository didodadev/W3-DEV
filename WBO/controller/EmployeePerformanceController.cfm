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
                WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.emp_perf_definition';
                WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/employee_performence.cfm';
                WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/hr/display/employee_performence.cfm';
                WOStruct['#attributes.fuseaction#']['list']['nextEvent'] = 'hr.emp_perf_definition';
                WOStruct['#attributes.fuseaction#']['list']['formName'] = 'search_target'; 

                WOStruct['#attributes.fuseaction#']['add'] = structNew();
                WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.emp_perf_definition';
                WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/form/form_add_emp_perf.cfm';
                WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/query/add_emp_perf_weight.cfm';
                WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_emp_perf';
                WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.emp_perf_definition';
        
                if(isdefined("attributes.weight_id"))
                {
                WOStruct['#attributes.fuseaction#']['upd'] = structNew();
                WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.emp_perf_definition';
                WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/form/form_upd_emp_perf.cfm';
                WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/query/upd_emp_perf_weight.cfm';
                WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.weight_id#';
                WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'upd_emp_perf';
                WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.emp_perf_definition&event=upd&weight_id=';
    
                WOStruct['#attributes.fuseaction#']['del'] = structNew();
    			WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
    			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=hr.emp_perf_definition&weight_id=';
    			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/query/del_emp_perf_weight.cfm';
    			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/query/del_emp_perf_weight.cfm';
    			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'assetcare.vehicle_allocate';
                }
            
        }
        else
        {
            fuseactController = caller.attributes.fuseaction;
            getLang = caller.getLang;
            
            tabMenuStruct = StructNew();
            tabMenuStruct['#fuseactController#'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
            if(caller.attributes.event is 'add')
            {
                tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
                tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
                tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = '_blank';
                tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
                tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.emp_perf_definition";
        
        
            }
            if(caller.attributes.event is 'upd')
            {
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.emp_perf_definition&event=add";
                
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = '_blank';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.emp_perf_definition";

                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
                
            }
            tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
        }
        
        
    </cfscript>