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
                WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'recycle.sampling_points';
                WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'WBP/Recycle/files/sample_analysis/display/sampling_points.cfm';	
                        
            if(IsDefined("attributes.event") && attributes.event is 'upd')
            {
                WOStruct['#attributes.fuseaction#']['upd'] = structNew();
                WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'recycle.sampling_points&event=upd';
                WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'WBP/Recycle/files/sample_analysis/form/sampling_points_upd.cfm';
                WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'WBP/Recycle/files/sample_analysis/query/sampling_points_upd.cfm';
                WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.sampling_id#';
                WOStruct['#attributes.fuseaction#']['upd']['nextevent'] = 'recycle.sampling_points&event=upd&sampling_id='; 
            }
                
            WOStruct['#attributes.fuseaction#']['add'] = structNew();
            WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'recycle.sampling_points&event=add';
            WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'WBP/Recycle/files/sample_analysis/form/sampling_points_add.cfm';
            WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'WBP/Recycle/files/sample_analysis/query/sampling_points_add.cfm';
            WOStruct['#attributes.fuseaction#']['add']['nextevent'] = 'recycle.sampling_points&event=upd&sampling_id=';
            
            WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'recycle.sampling_points&event=del';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'WBP/Recycle/files/sample_analysis/query/sampling_points_del.cfm';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'WBP/Recycle/files/sample_analysis/query/sampling_points_del.cfm';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=recycle.sampling_points";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=recycle.sampling_points&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=recycle.sampling_points";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
        
    }
    </cfscript>