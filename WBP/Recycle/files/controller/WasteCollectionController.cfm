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
                WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'recycle.waste_collection';
                WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'WBP/Recycle/files/waste_collection/display/waste_collection.cfm';	
                        
            if(IsDefined("attributes.event") && attributes.event is 'upd')
            {
                WOStruct['#attributes.fuseaction#']['upd'] = structNew();
                WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'recycle.waste_collection&event=upd';
                WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'WBP/Recycle/files/waste_collection/form/waste_collection_upd.cfm';
                WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'WBP/Recycle/files/waste_collection/query/waste_collection_upd.cfm';
                WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.waste_collection_id#';
                WOStruct['#attributes.fuseaction#']['upd']['nextevent'] = 'recycle.waste_collection&event=upd&waste_collection_id='; 
            }
                                    
            WOStruct['#attributes.fuseaction#']['add'] = structNew();
            WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'recycle.waste_collection&event=add';
            WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'WBP/Recycle/files/waste_collection/form/waste_collection_add.cfm';
            WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'WBP/Recycle/files/waste_collection/query/waste_collection_add.cfm';
            WOStruct['#attributes.fuseaction#']['add']['nextevent'] = 'recycle.waste_collection&event=upd&waste_collection_id=';

            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'recycle.waste_collection&event=del';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'WBP/Recycle/files/waste_collection/query/waste_collection_del.cfm';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'WBP/Recycle/files/waste_collection/query/waste_collection_del.cfm';
            WOStruct['#attributes.fuseaction#']['del']['nextevent'] = '';
                                        
      }
    else {
        fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'add')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=recycle.waste_collection";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=recycle.waste_collection&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=recycle.waste_collection";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onclick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_type=1902&iid=#attributes.waste_collection_id#&print_type=1902','WOC');";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
        
    }
    </cfscript>