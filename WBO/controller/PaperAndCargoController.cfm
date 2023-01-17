<cfscript>
    if( attributes.TabMenuController eq 0)
    {
        WoStruct=structnew();
        WOStruct['#attributes.fuseaction#'] = structNew();	
		
        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if(not isdefined('attributes.event')){
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];
        }   
        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] ='correspondence.paperandcargo';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/correspondence/display/list_paperandcargo.cfm';
        
        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'correspondence.paperandcargo';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/correspondence/form/add_paperandcargo.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/correspondence/cfc/paperandcargo.cfc';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'correspondence.paperandcargo&event=upd&cargo_id=';
        
        if(isdefined("attributes.cargo_id"))
        {
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'correspondence.paperandcargo';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] ='V16/correspondence/form/upd_paperandcargo.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'correspondence.paperandcargo&event=upd&cargo_id=';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.cargo_id#';
            
            
            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'correspondence.paperandcargo';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/correspondence/cfc/paperandcargo.cfc';
            WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'correspondence.paperandcargo';
            WOStruct['#attributes.fuseaction#']['del']['Identity'] = '#attributes.cargo_id#';
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
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=correspondence.paperandcargo";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-folder']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-folder']['href'] = "#request.self#?fuseaction=dev.tools";   				
        }
          if(caller.attributes.event is 'upd')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=correspondence.paperandcargo&event=add";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=correspondence.paperandcargo";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
        }
       if(caller.attributes.event is 'list')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['list']['icons'] = structNew();    
            tabMenuStruct['#fuseactController#']['tabMenus']['list']['icons']['add']['text'] = '#getLang('main', 97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['list']['icons']['add']['href'] = '#request.self#?fuseaction=correspondence.paperandcargo&event=add';
        }
        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
    }
</cfscript>