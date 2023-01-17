<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_my_tranings';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/myhome/display/list_my_trainings.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
        WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.form_add_training_request';
        WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/training/form/form_add_training_request.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/training/query/add_training_request_emp.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'myhome.list_my_traning';
        

        if(isdefined("attributes.train_req_id"))
        {   
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'myhome.list_my_tranings';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/training/form/form_upd_training_request.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/training/query/upd_training_request_emp.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'myhome.list_my_tranings&event=upd&train_req_id=';
			
        }

    }
    else{
        fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
		getLang = caller.getLang;
		
		tabMenuStruct['#fuseactController#'] = structNew();
        tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
        if(caller.attributes.event is 'add')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=myhome.list_my_tranings";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
        else if(caller.attributes.event is 'upd')
		{
                

                tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();

                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=myhome.list_my_tranings&event=add";

                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=myhome.list_my_tranings";

                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			    tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.train_req_id#&print_type=371','page')";

			    //Uyarılar
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=train_req_id&action_id=#attributes.train_req_id#','Workflow')";
			
            
            }

        tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
    }
    WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm']				= true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList']	= 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName']			= 'TRAINING_REQUEST';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn']		= 'TRAIN_REQUEST_ID';
</cfscript>