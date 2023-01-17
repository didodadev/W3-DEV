
<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        
        WOStruct['#attributes.fuseaction#'] = structNew();
        
        WOStruct['#attributes.fuseaction#']['default'] = 'add';
        if(not isdefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];
    
    
            WOStruct['#attributes.fuseaction#']['add'] = structNew();
            WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'assetcare.vehicle_allocate';
            WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/assetcare/form/vehicle_allocate.cfm';
            WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/assetcare/query/add_vehicle_allocate.cfm';
            WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'assetcare.vehicle_allocate';
            WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_allocate'; 
    
            if(isdefined("attributes.km_control_id"))
            {
                WOStruct['#attributes.fuseaction#']['upd'] = structNew();
                WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'assetcare.vehicle_allocate';
                WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/assetcare/form/upd_vehicle_allocate_frame.cfm';
                WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/assetcare/query/upd_vehicle_allocate.cfm';
                WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'upd_allocate'; 
                WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'assetcare.vehicle_allocate&event=upd&km_control_id=';
                WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.km_control_id#';
            

                WOStruct['#attributes.fuseaction#']['del'] = structNew();
                WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
                WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'assetcare.vehicle_allocate';
                WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/assetcare/query/del_vehicle_allocate.cfm';
                WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/assetcare/query/del_vehicle_allocate.cfm';
                WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'assetcare.vehicle_allocate';
                WOStruct['#attributes.fuseaction#']['del']['Identity'] = '#attributes.km_control_id#';
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
    
    
        }
        if(caller.attributes.event is 'upd')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=assetcare.vehicle_allocate&event=add";
            
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
            
        }
        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
    }
    
    
</cfscript>

