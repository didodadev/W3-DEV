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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#ListFirst(attributes.fuseaction,'.')#.list_personel_requirement_form';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_personel_requirement_form.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#ListFirst(attributes.fuseaction,'.')#.from_add_personel_requirement_form';
		WOStruct['#attributes.fuseaction#']['add']['xmlfuseaction'] = 'hr.from_upd_personel_requirement_form';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/form/add_personel_requirement_form.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/hr/query/add_personel_requirement_form.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#ListFirst(attributes.fuseaction,'.')#.list_personel_requirement_form&event=upd&per_req_id=';	
		
		if(isdefined("attributes.per_req_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = '#ListFirst(attributes.fuseaction,'.')#.from_upd_personel_requirement_form';
			WOStruct['#attributes.fuseaction#']['upd']['xmlfuseaction'] = 'hr.from_upd_personel_requirement_form';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/form/upd_personel_requirement_form.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/query/upd_personel_requirement_form.cfm';
			if(ListFirst(attributes.fuseaction,'.') is 'myhome')
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#contentEncryptingandDecodingAES(isEncode:0,content:attributes.per_req_id,accountKey:'wrk')#';
			else
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.per_req_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#ListFirst(attributes.fuseaction,'.')#.list_personel_requirement_form&event=upd&per_req_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.emptypopup_del_personel_requirement_form&per_req_id=#attributes.per_req_id#&cat=##caller.get_per_req.per_req_stage##&head=##caller.get_per_req.personel_requirement_head##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/query/del_personel_requirement_form.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/query/del_personel_requirement_form.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#ListFirst(attributes.fuseaction,'.')#.list_personel_requirement_form';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.list_personel_requirement_form";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(caller.attributes.event is 'upd')
		{
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.list_personel_requirement_form";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.list_personel_requirement_form&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_print_personel_requirement&action=print&id=#attributes.per_req_id#&module=#ListFirst(attributes.fuseaction,'.')#&iframe=1&trail=0','page');return false;";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=per_req_id&action_id=#attributes.per_req_id#','Workflow')";
	
			i = 0;
			if(caller.get_module_user(3)){
				if(caller.get_relation_assign.recordcount){
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('hr',1786)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.list_personel_assign_form&event=upd&per_assign_id=#caller.get_relation_assign.personel_assign_id#";
					i = i + 1;
				}
				
			/* 	tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('hr',888)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=hr.popup_upd_per_form_autority&per_req_id=#attributes.per_req_id#','list');";
				i = i + 1; */
				if (ListFirst(caller.attributes.fuseaction,'.') is 'hr')
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('hr',1447)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=hr.list_notice&event=add&per_req_id=#attributes.per_req_id#";
					i = i + 1;
				}
			}
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PERSONEL_REQUIREMENT_FORM';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PERSONEL_REQUIREMENT_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-req_head','item-personel_count','item-vehicle_req','item-Gorus']";
</cfscript>
