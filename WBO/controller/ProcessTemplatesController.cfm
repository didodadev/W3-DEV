<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        
        WOStruct['#attributes.fuseaction#'] = structNew();
        
        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        
        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'dev.process_templates';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'WDO/modalProcessTemplates.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'dev.process_templates&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'WDO/modalProcessTemplatesAdd.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/WDO/development/query/add_process_templates.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'dev.process_templates';

        

        if(isdefined("attributes.id"))
        {
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'dev.process_templates';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'WDO/development/query/upd_process_templates.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'WDO/modalProcessTemplatesUpd.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'dev.process_templates&event=upd&id=';
            
            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'dev.process_templates';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'WDO/development/query/upd_process_templates.cfm';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'WDO/modalProcessTemplatesUpd.cfm';
            WOStruct['#attributes.fuseaction#']['del']['Identity'] = '#attributes.id#';
            WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'dev.process_templates&event=upd&id=';
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
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=dev.process_templates";
            
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";

            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-folder']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-folder']['href'] = "#request.self#?fuseaction=dev.tools";
 
	
        }
		if(caller.attributes.event is 'upd')
		{
		    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=dev.process_templates&event=add";
            
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=dev.process_templates";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=id&action_id=#attributes.id#','Workflow')";
    
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-folder']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-folder']['href'] = "#request.self#?fuseaction=dev.tools";
        }
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>