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
                            WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'training_management.list_training_management_cost';
                            WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/training_management/display/list_training_management_cost.cfm';	
                        
              if(IsDefined("attributes.event") && attributes.event is 'upd')
              {
                  WOStruct['#attributes.fuseaction#']['upd'] = structNew();
                  WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
                  WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'training_management.list_training_management_cost&event=upd';
                  WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/training_management/form/upd_training_cost.cfm';
                  WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/training_management/query/upd_training_cost.cfm';
                  WOStruct['#attributes.fuseaction#']['upd']['nextevent'] = 'training_management.list_training_management_cost&event=upd&BRANCH_ID'; 
              }
                                    
                                WOStruct['#attributes.fuseaction#']['add'] = structNew();
                                WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
                                WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'training_management.list_training_management_cost&event=add';
                                WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/training_management/form/add_training_cost.cfm';
                                WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/training_management/query/add_training_cost.cfm';
                                WOStruct['#attributes.fuseaction#']['add']['nextevent'] = 'training_management.list_training_management_cost&event=upd&BRANCH_ID';
                                        
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=training_management.list_training_management_cost";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=training_management.list_training_management_cost&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=training_management.list_training_management_cost";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onclick'] =  "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=training_class_cost_id&action_id=#attributes.training_class_cost_id#','Workflow')";
    
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&print_type=231&action_type=#attributes.training_class_cost_id#&action_id=#attributes.training_class_cost_id#')";        
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
        
    }
    </cfscript>