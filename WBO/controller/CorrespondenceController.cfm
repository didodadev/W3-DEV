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
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'correspondence.list_correspondence';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/correspondence/display/list_correspondence.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'correspondence.list_correspondence&event=add';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/correspondence/form/add_correspondence.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/correspondence/query/add_correspondence.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'correspondence.list_correspondence';
  
        WOStruct['#attributes.fuseaction#']['upd'] = structNew();
        WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'correspondence.list_correspondence&event=upd';
        WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/correspondence/form/upd_correspondence.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/correspondence/query/upd_correspondence.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'correspondence.list_correspondence&event=upd&id=##attributes.id##';
        if (attributes.event eq "upd")
        WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
            
    
        
        WOStruct['#attributes.fuseaction#']['del'] = structNew();
        WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'correspondence.list_correspondence&event=del';
        WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/correspondence/form/upd_correspondence.cfm';
        WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/V16/correspondence/query/del_correspondence.cfm';
        WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'correspondence.list_correspondence';
    }
    else{
        fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
      
        if(caller.attributes.event eq 'add')
        {
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();

            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";

            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=correspondence.list_correspondence";
        }
        else if (caller.attributes.event eq 'upd')
		{
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=correspondence.list_correspondence&event=add";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=correspondence.list_correspondence";

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.id#&print_type=371','page')";

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['href'] = "#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=id&action_id=#attributes.id#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['target'] ="_blank"; 
        
        
        }
      

        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
    }
    
</cfscript>