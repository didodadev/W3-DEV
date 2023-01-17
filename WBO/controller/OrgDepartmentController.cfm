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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.list_depts';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/settings/display/list_depts.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.form_add_department';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/settings/form/add_department.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/settings/query/add_department.cfm';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'departman';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_depts&event=upd&id=';
		
		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.form_upd_department';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/settings/form/upd_department.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/settings/query/upd_department.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_depts&event=upd&id=';			
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_department_del&department_id=#attributes.id#&head=##caller.category.department_Head##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/settings/query/del_department.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/V16/settings/query/del_department.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'settings.list_depts';			
		}

		if(isdefined("attributes.branch_id") && IsDefined("department_id"))
		{
			WOStruct['#attributes.fuseaction#']['list-period'] = structNew();
			WOStruct['#attributes.fuseaction#']['list-period']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['list-period']['fuseaction'] = 'hr.popup_list_period';
			WOStruct['#attributes.fuseaction#']['list-period']['filePath'] = '/V16/hr/display/list_periods.cfm';
			WOStruct['#attributes.fuseaction#']['list-period']['queryPath'] = '/V16/hr/query/add_periods_account_definition.cfm';
			WOStruct['#attributes.fuseaction#']['list-period']['Identity'] = '#attributes.branch_id#';
			WOStruct['#attributes.fuseaction#']['list-period']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_depts&event=upd&id=';
		}

		if(isdefined("attributes.dept_id"))
		{
			WOStruct['#attributes.fuseaction#']['history'] = structNew();
			WOStruct['#attributes.fuseaction#']['history']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['history']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.popup_dept_history';
			if(listgetat(attributes.fuseaction,1,'.') is 'hr')
				WOStruct['#attributes.fuseaction#']['history']['filePath'] = '/V16/hr/display/dsp_dept_history.cfm';
			else
				WOStruct['#attributes.fuseaction#']['history']['filePath'] = '/V16/settings/display/dsp_dept_history.cfm';
		}
				
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'DEPARTMENT';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'DEPARTMENT_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-department_Head','item-branch_name']";
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_depts";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_depts&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_depts";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['text']  = '#getLang('main',61)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_depts&event=history&dept_id=#attributes.id#&x_change_date=#caller.x_change_date#');";			

			if(not listfindnocase(caller.denied_pages,'hr.popup_list_period'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('main',1399)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_depts&event=list-period&branch_id=#caller.category.branch_id#&department_id=#caller.category.department_id#','medium');";
			}
		}
		else if(caller.attributes.event is 'list-period')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['list-period']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['list-period']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['list-period']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_depts&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['list-period']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['list-period']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['list-period']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['list-period']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_depts";
			tabMenuStruct['#fuseactController#']['tabMenus']['list-period']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['list-period']['icons']['check']['onClick'] = "buttonClickFunction()";		
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>