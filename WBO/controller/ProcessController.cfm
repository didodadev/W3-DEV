<cfsavecontent  variable="visual_designer"><cf_get_lang dictionary_id='36170.Visual Designer'></cfsavecontent>
<cfsavecontent  variable="qpic"><cf_get_lang dictionary_id='48909.QPIC-RS'></cfsavecontent>
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
            WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'process.list_process';
            WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/process/display/list_process.cfm';
    
	
		    WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'process.list_process';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/process/form/add_process.cfm';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/process/query/add_process.cfm';
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'process.list_process';
			WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_process'; 
	
            if(isdefined("attributes.process_id"))
            {
		    WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'process.list_process';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/process/form/upd_process.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/process/query/upd_process.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.process_id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'process.list_process&event=upd&process_id=';
            WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'upd_process';}

	
		
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
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=process.list_process";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-delicious']['text'] = '#qpic#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-delicious']['href'] = "#request.self#?fuseaction=process.qpic-r";
            
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
 
	
        }
		if(caller.attributes.event is 'upd')
		{
		    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=process.list_process&event=add";
            
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=process.list_process";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-delicious']['text'] = '#qpic#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-delicious']['href'] = "#request.self#?fuseaction=process.qpic-r";

            if(not listfindnocase(caller.denied_pages,'process.emtypopup_dsp_process_type_history')){
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getlang('main',61)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] = "open_history('#request.self#?fuseaction=process.emtypopup_dsp_process_type_history&process_id=#attributes.process_id#','history');";
            }
          
            if(not listfindnocase(caller.denied_pages,'process.emtypopup_dsp_process_file_history')){
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-folder']['text'] = '#getlang('main',61)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-folder']['onClick'] ="open_history('#request.self#?fuseaction=process.emtypopup_dsp_process_file_history&process_id=#attributes.process_id#','folder')";
            }
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-sitemap']['text'] = '#visual_designer#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-sitemap']['href'] = "#request.self#?fuseaction=process.visual_designer&process_id=#attributes.process_id#";
            
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=process_id&action_id=#attributes.process_id#','Workflow')";
    
            
        }
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	
</cfscript>

