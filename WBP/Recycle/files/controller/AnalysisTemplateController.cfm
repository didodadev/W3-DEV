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
            WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'recycle.analysis_template';
            WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'WBP/Recycle/files/sample_analysis/display/analysis_template.cfm';	
            
            WOStruct['#attributes.fuseaction#']['add'] = structNew();
            WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'recycle.analysis_template&event=add';
            WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'WBP/Recycle/files/sample_analysis/form/analysis_template_add.cfm';
            WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'WBP/Recycle/files/sample_analysis/query/analysis_template_add.cfm';
            WOStruct['#attributes.fuseaction#']['add']['nextevent'] = 'recycle.analysis_template&event=upd&refinery_test_id=';

            if(IsDefined("attributes.event") && attributes.event is 'upd')
            {
                WOStruct['#attributes.fuseaction#']['upd'] = structNew();
                WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'recycle.analysis_template&event=upd';
                WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'WBP/Recycle/files/sample_analysis/form/analysis_template_upd.cfm';
                WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'WBP/Recycle/files/sample_analysis/query/analysis_template_upd.cfm';
                WOStruct['#attributes.fuseaction#']['upd']['nextevent'] = 'recycle.analysis_template&event=upd&refinery_test_id='; 
            }

                WOStruct['#attributes.fuseaction#']['del'] = structNew();
                WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'recycle.analysis_template&event=del';
                WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'WBP/Recycle/files/sample_analysis/query/analysis_template_del.cfm';
                WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'WBP/Recycle/files/sample_analysis/query/analysis_template_del.cfm';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=recycle.analysis_template";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=recycle.analysis_template&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=recycle.analysis_template";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
        
    }
    </cfscript>