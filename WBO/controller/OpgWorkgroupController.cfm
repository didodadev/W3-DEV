<cfscript>

	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.list_workgroup';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_workgroup.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.popup_form_add_workgroup';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/form/form_add_workgroups.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/query/add_workgroup.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_workgroup&event=upd&workgroup_id=';
		
		if(isdefined("attributes.workgroup_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.form_upd_workgroup';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/form/form_upd_workgroups.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/query/upd_workgroup.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.workgroup_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_workgroup&event=upd&workgroup_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_workgroup&GROUP_ID=##caller.attributes.workgroup_id##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/query/del_workgroup.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/query/del_workgroup.cfm';
			WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'workgroup_id';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_workgroup';
				
			WOStruct['#attributes.fuseaction#']['addWorker'] = structNew();
			WOStruct['#attributes.fuseaction#']['addWorker']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['addWorker']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.popup_form_add_worker2';
			WOStruct['#attributes.fuseaction#']['addWorker']['filePath'] = 'V16/hr/form/form_add_worker2.cfm';
			WOStruct['#attributes.fuseaction#']['addWorker']['queryPath'] = 'V16/hr/query/add_worker2.cfm';
			WOStruct['#attributes.fuseaction#']['addWorker']['Identity'] = '#attributes.workgroup_id#';
			WOStruct['#attributes.fuseaction#']['addWorker']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_workgroup&event=upd&workgroup_id=';
		}
			
		else if(isdefined("attributes.wrk_row_id"))
		{	
			WOStruct['#attributes.fuseaction#']['updWorker'] = structNew();
			WOStruct['#attributes.fuseaction#']['updWorker']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['updWorker']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.popup_form_upd_worker2';
			WOStruct['#attributes.fuseaction#']['updWorker']['filePath'] = 'V16/hr/form/form_upd_worker2.cfm';
			WOStruct['#attributes.fuseaction#']['updWorker']['queryPath'] = 'V16/hr/query/upd_worker2.cfm';
			WOStruct['#attributes.fuseaction#']['updWorker']['Identity'] = '#attributes.wrk_row_id#';
			WOStruct['#attributes.fuseaction#']['updWorker']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_workgroup&event=upd&workgroup_id=';
			
			WOStruct['#attributes.fuseaction#']['delWorker'] = structNew();
			WOStruct['#attributes.fuseaction#']['delWorker']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['delWorker']['fuseaction'] = '#fusebox.circuit#.emptypopup_worker_del&wrk_row_id=##caller.category.wrk_row_id##';
			WOStruct['#attributes.fuseaction#']['delWorker']['filePath'] = 'V16/hr/query/del_worker_emp.cfm';
			WOStruct['#attributes.fuseaction#']['delWorker']['queryPath'] = 'V16/hr/query/del_worker_emp.cfm';
			WOStruct['#attributes.fuseaction#']['delWorker']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_workgroup&event=upd&workgroup_id=';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_workgroup";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(caller.attributes.event is 'addWorker')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['addWorker']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['addWorker']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addWorker']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_workgroup&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_workgroup";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			if (caller.fusebox.circuit is not 'service')
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('hr',1302)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_draw_workgroup&workgroup_id=#attributes.workgroup_id#','list');";
			}
		
		}
		else if(caller.attributes.event is 'updWorker')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['updWorker']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updWorker']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updWorker']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,copy,addWorker,updWorker,copyWorker';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'WORK_GROUP';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'WORKGROUP_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-group_name','item-hierarchy','item-manager_position','item-role_head','item-member_name','item-hierarchy']";
	
</cfscript>
