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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_ext_worktimes';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/ehesap/display/list_ext_worktimes.cfm';
		
		if(listgetat(attributes.fuseaction,1,'.') is 'ehesap')
		{
			WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_form_add_ext_worktime';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/ehesap/form/add_ext_worktime.cfm';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/hr/ehesap/query/add_ext_worktime.cfm';
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_ext_worktimes&event=upd&EWT_ID=';
		}
		
		WOStruct['#attributes.fuseaction#']['addMulti'] = structNew();
		WOStruct['#attributes.fuseaction#']['addMulti']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['addMulti']['fuseaction'] = 'ehesap.popup_add_ext_worktimes_all';
		WOStruct['#attributes.fuseaction#']['addMulti']['filePath'] = '/V16/hr/ehesap/form/add_ext_worktimes_all.cfm';
		WOStruct['#attributes.fuseaction#']['addMulti']['queryPath'] = '/V16/hr/ehesap/query/add_ext_worktimes_all.cfm';
		WOStruct['#attributes.fuseaction#']['addMulti']['nextEvent'] = 'ehesap.list_ext_worktimes';	
		
		WOStruct['#attributes.fuseaction#']['addMultiSingle'] = structNew();
		WOStruct['#attributes.fuseaction#']['addMultiSingle']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['addMultiSingle']['fuseaction'] = 'ehesap.popup_add_ext_worktimes_personal';
		WOStruct['#attributes.fuseaction#']['addMultiSingle']['filePath'] = 'V16/hr/ehesap/form/add_ext_worktimes_personal.cfm';
		WOStruct['#attributes.fuseaction#']['addMultiSingle']['queryPath'] = '/V16/hr/ehesap/query/add_ext_worktimes_personal.cfm';
		WOStruct['#attributes.fuseaction#']['addMultiSingle']['nextEvent'] = 'ehesap.list_ext_worktimes';
		
		if(isdefined("attributes.EWT_ID"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_form_upd_ext_worktime';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/ehesap/form/upd_ext_worktime.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/ehesap/query/upd_ext_worktime.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.EWT_ID#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_ext_worktimes&event=upd&EWT_ID=';

			WOStruct['#attributes.fuseaction#']['history'] = structNew();
			WOStruct['#attributes.fuseaction#']['history']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['history']['fuseaction'] = 'ehesap.popup_dsp_employees_ext_worktimes_history';
			WOStruct['#attributes.fuseaction#']['history']['filePath'] = 'V16/hr/ehesap/display/dsp_employees_ext_worktimes_history.cfm';
			WOStruct['#attributes.fuseaction#']['history']['queryPath'] = '';
			WOStruct['#attributes.fuseaction#']['history']['Identity'] = '#attributes.EWT_ID#';
			WOStruct['#attributes.fuseaction#']['history']['nextEvent'] = '';

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'ehesap.emptypopup_del_ext_worktime';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/ehesap/query/del_ext_worktime.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/ehesap/query/del_ext_worktime.cfm';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.list_ext_worktimes";
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
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.list_ext_worktimes";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			if (caller.fusebox.circuit != 'myhome')
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('ehesap',72)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onClick'] = "window.location.href='#request.self#?fuseaction=ehesap.list_ext_worktimes&event=add';";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			}
			else
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('ehesap',72)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onClick'] = "window.location.href='#request.self#?fuseaction=ehesap.list_ext_worktimes&event=add';";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			}

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=ewt_id&action_id=#attributes.EWT_ID#','Workflow')";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			
			if (caller.fusebox.circuit != 'myhome')
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getLang('main',61)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_ext_worktimes&event=history&ewt_id=#attributes.ewt_id#');";
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
