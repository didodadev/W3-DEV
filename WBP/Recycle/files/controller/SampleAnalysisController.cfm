<cfif isDefined('attributes.refinery_lab_test_id')>
    <cfset getLabTest = createObject("component","WBP/Recycle/files/sample_analysis/cfc/sample_analysis").getLabTest(
        refinery_lab_test_id: attributes.refinery_lab_test_id
    ) />
</cfif>
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
                            WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'lab.sample_analysis';
                            WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'WBP/Recycle/files/sample_analysis/display/sample_analysis.cfm';
                        
              if(IsDefined("attributes.event") && attributes.event is 'upd')
              {
                  WOStruct['#attributes.fuseaction#']['upd'] = structNew();
                  WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
                  WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'lab.sample_analysis&event=upd';
                  WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'WBP/Recycle/files/sample_analysis/form/sample_analysis_upd.cfm';
                  WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'WBP/Recycle/files/sample_analysis/query/sample_analysis_upd.cfm';
                  WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.refinery_lab_test_id#';
              }
                                    
                WOStruct['#attributes.fuseaction#']['add'] = structNew();
                WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'lab.sample_analysis&event=add';
                WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'WBP/Recycle/files/sample_analysis/form/sample_analysis_add.cfm';
                WOStruct['#attributes.fuseaction#']['add']['nextevent'] = 'lab.sample_analysis&event=upd&refinery_lab_test_id=';

                WOStruct['#attributes.fuseaction#']['del'] = structNew();
                WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
                WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'lab.sample_analysis&event=del';
                WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'WBP/Recycle/files/sample_analysis/query/sample_analysis_del.cfm';
                WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'WBP/Recycle/files/sample_analysis/query/sample_analysis_del.cfm';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=lab.sample_analysis";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=lab.sample_analysis&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=lab.sample_analysis";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onclick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.refinery_lab_test_id#&action=lab.sample_analysis','WOC');";

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('','',64423)#';
           
            if(isDefined('getLabTest.sampling_id') and len(getLabTest.sampling_id)) {
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=lab.sampling&event=upd&sampling_id=#caller.getLabTest.sampling_id#";
            } else {
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=lab.sampling&event=add&sample_analysis_id=#attributes.refinery_lab_test_id#";
            }
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['target'] = "_blank";
            
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
        
    }
    </cfscript>