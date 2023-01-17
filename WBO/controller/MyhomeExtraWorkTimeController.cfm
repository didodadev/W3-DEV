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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_my_extra_times';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/myhome/display/list_my_extra_worktimes.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.form_add_ext_worktime_popup';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/myhome/form/form_add_ext_worktime.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/myhome/query/add_ext_worktime.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'myhome.list_my_extra_times&event=upd&EWT_ID=';

		if(isdefined("attributes.EWT_ID"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_form_upd_ext_worktime';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/ehesap/form/upd_ext_worktime.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/ehesap/query/upd_ext_worktime.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '';

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_del_ext_worktime&EWT_ID=#attributes.EWT_ID#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/ehesap/query/del_ext_worktime.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/ehesap/query/del_ext_worktime.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'myhome.list_my_extra_times';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=myhome.list_my_extra_times";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(caller.attributes.event is 'addMultiSingle')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['addMultiSingle']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['addMultiSingle']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['addMultiSingle']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addMultiSingle']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.list_ext_worktimes";
			tabMenuStruct['#fuseactController#']['tabMenus']['addMultiSingle']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addMultiSingle']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(caller.attributes.event is 'addMulti')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.list_ext_worktimes";
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addMulti']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(caller.attributes.event is 'upd')
		{
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.EWT_ID#&print_type=121','page');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=myhome.list_my_extra_times";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=id&action_id=#attributes.EWT_ID#','Workflow')";
			if (caller.fusebox.circuit != 'myhome')
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('ehesap',72)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onClick'] = "window.location.href='#request.self#?fuseaction=ehesap.list_ext_worktimes&event=add';";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			}
			else
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('ehesap',72)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onClick'] = "window.location.href='#request.self#?fuseaction=myhome.list_my_extra_times&event=add';";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			
			if (caller.fusebox.circuit != 'myhome')
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('main',61)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_ext_worktimes&event=history&ewt_id=#attributes.ewt_id#','wide');";
			}
			
		}
		
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

	

	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,list';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BRANCH';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'BRANCH_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-employee_id','item-startdate']";
</cfscript>