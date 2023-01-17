<cfsavecontent  variable="visual_designer"><cf_get_lang dictionary_id='36170.Visual Designer'></cfsavecontent>
<cfsavecontent  variable="qpic"><cf_get_lang dictionary_id='48909.QPIC-RS'></cfsavecontent>
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
            WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'process.form_add_process_rows';
            WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/process/form/add_process_rows.cfm';
            WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/process/query/add_process_rows.cfm';
            WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'process.form_add_process_rows';
            WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_process_row'; 
  
            if(isdefined("attributes.process_row_id"))
            {
                WOStruct['#attributes.fuseaction#']['upd'] = structNew();
                WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'process.form_add_process_rows';
                WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/process/form/form_upd_process_rows.cfm';
                WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/process/query/upd_process_rows.cfm';
                WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'upd_process_row';
            }

    
        
    }
    else
    {
        fuseactController = caller.attributes.fuseaction;
        getLang = caller.getLang;
        
        tabMenuStruct = StructNew();
        tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
        attributes.process_name=caller.attributes.process_name;
        attributes.process_id=caller.attributes.process_id;
        if(caller.attributes.event is 'add')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
            
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=process.list_process&event=upd&process_id=#attributes.process_id#";
            
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
    
        }
        if(caller.attributes.event is 'upd')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
            
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=process.form_add_process_rows&process_id=#attributes.process_id#&process_name=#attributes.process_name#";
            
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=process.list_process&event=upd&process_id=#attributes.process_id#";
            
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-delicious']['text'] = '#qpic#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-delicious']['href'] = "#request.self#?fuseaction=process.qpic-r";

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

            if (not listfindnocase(caller.denied_pages,'process.emtypopup_dsp_process_file_history')){
                tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getlang('main',61)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] = "open_history('#request.self#?fuseaction=process.emtypopup_dsp_process_file_history&process_row_id=#attributes.process_row_id#','history')";
            }
            
        }
        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
    }
    
    
</cfscript>
    
    