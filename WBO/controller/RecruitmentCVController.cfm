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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_cv';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_cv.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.form_add_cv';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/form/add_cv.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/hr/query/add_cv.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_cv&event=upd&empapp_id=';
		
		if(isdefined("attributes.empapp_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.form_upd_cv';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/form/upd_cv.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/query/upd_cv.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.empapp_id#';
			if(isdefined("attributes.selected_menu_info") && len(attributes.selected_menu_info))
			{
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_cv&event=upd&last_area=''#attributes.selected_menu_info#''&empapp_id=';
			}
			else
			{
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_cv&event=upd&empapp_id=';
			}

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=hr.emptypopup_del_cv&empapp_id=##caller.attributes.empapp_id##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/query/del_cv.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/query/del_cv.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_cv';
		}
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_cv";
		}
		
		else if(caller.attributes.event is 'upd')
		{
			get_app_pos = caller.get_app_pos;
			get_app = caller.get_app;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_cv";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_cv&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['href'] = "#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.empapp_id#&print_type=170";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['href'] = "#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=empapp_id&action_id=#attributes.empapp_id#&wrkflow=1','Workflow')";



			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			i = 0;
			if (caller.xml_is_isebaslat eq 1)
			{
				if (!caller.get_app.work_started eq 1 or caller.get_app.work_finished eq 1)
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('hr',618)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_add_app_test_time&empapp_id=#attributes.empapp_id#&process_stage_=#caller.get_app.cv_stage#','medium');";
					i++;
				}
			
			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Başvuru Ekle','55172')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = '_blank';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=hr.apps&event=add&app_pos_id=#get_app_pos.app_pos_id#&empapp_id=#get_app.empapp_id#";
			i++;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getLang('','Seçim Listesi Seç','55146')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_list_app_history&empapp_id=#empapp_id#');";
			i++;
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,list';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EMPLOYEES_APP';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'EMPAPP_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-name_','item-surname']";

</cfscript>
