<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_personel_assign_form';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_personel_assign_form.cfm';
		
		if(isdefined("attributes.per_assign_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.from_upd_personel_assign_form';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/hr/form/upd_personel_assign_form.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/hr/query/upd_personel_assign_form.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.per_assign_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_personel_assign_form&event=upd&per_assign_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=hr.emptypopup_del_personel_assign_form&per_assign_id=#attributes.per_assign_id#&cat=##caller.get_per_req.per_assign_stage##&head=##caller.GET_PER_REQ.PERSONEL_assign_HEAD##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/query/del_personel_assign_form.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/query/del_personel_assign_form.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_personel_assign_form';
			
		}
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.from_add_personel_assign_form';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/hr/form/add_personel_assign_form.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/hr/query/add_personel_assign_form.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_personel_assign_form&event=upd&per_assign_id=';
		
	}
	
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		get_per_req = caller.get_per_req;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'add')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_personel_assign_form";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		else if(caller.attributes.event is 'upd')
		{
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_personel_assign_form&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_personel_assign_form";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.per_assign_id#&action=hr.list_personel_assign_form')";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			i=0;
			
			if (caller.get_per_req.work_started eq 0 or caller.get_per_req.work_finished eq 1)
			{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','İşe Başlat','55703')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_add_app_test_time&empapp_id=#get_per_req.related_cv_bank_id#&process_stage_=#get_per_req.cv_stage#');";
			i++;
			}
		
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=#attributes.fuseaction#&action_name=per_assign_id&action_id=#attributes.per_assign_id#','list');";
			i++;
			
			if (Len(caller.get_per_req.personel_req_id) and caller.get_relation_requirement.recordcount){
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('hr',1787)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=hr.list_personel_requirement_form&event=upd&per_req_id=#get_per_req.personel_req_id#";
			i++;
			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('hr',85)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=hr.list_hr&event=add&per_assign_id=#attributes.per_assign_id#";
			i++;
			
			
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = '';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = '';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-personel_assign_head','item-our_company','item-personel_name','item-personel_tc_identy_no','item-position_cat','item-work_start','item-work_finish']";
	
</cfscript>
