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
            WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'process.general_processes';
            WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/process/display/general_processes.cfm';
    
	
		    WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'process.general_processes';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/process/form/add_main_process.cfm';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/process/query/add_main_process.cfm';
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'process.general_processes';
			WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_process'; 
	
            if(isdefined("attributes.process_id"))
            {
		    WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'process.general_processes';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/process/form/upd_main_process.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/process/query/upd_main_process.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.process_id#';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'process.general_processes&event=upd&process_id=';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=process.general_processes";

			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-delicious']['text'] = '#qpic#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-delicious']['href'] = "#request.self#?fuseaction=process.qpic-r";
            
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
 
	
        }
		if(caller.attributes.event is 'upd')
		{
		    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=process.general_processes&event=add";
            
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=process.general_processes";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-delicious']['text'] = '#qpic#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-delicious']['href'] = "#request.self#?fuseaction=process.qpic-r";
			
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-sitemap']['text'] = '#visual_designer#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-sitemap']['href'] = "#request.self#?fuseaction=process.designer&event=main&main_process_id=#attributes.process_id#";
            
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=process_id&action_id=#attributes.process_id#','Workflow')";
    
            
        }
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	
</cfscript>

