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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.list_branches';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/settings/display/list_branches.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.form_add_branch';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/settings/form/add_branch.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/settings/query/add_branch.cfm';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'branch';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_branches&event=upd&id=';

		WOStruct['#attributes.fuseaction#']['googleMap'] = structNew();
		WOStruct['#attributes.fuseaction#']['googleMap']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['googleMap']['fuseaction'] = 'hr.list_branches';
		WOStruct['#attributes.fuseaction#']['googleMap']['filePath'] = '/V16/settings/form/google_map.cfm';
		
		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.form_upd_branch';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/settings/form/upd_branch.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/settings/query/upd_branch.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_branches&event=upd&id=';

			WOStruct['#attributes.fuseaction#']['upd_ssk'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd_ssk']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['upd_ssk']['fuseaction'] = 'settings.popup_upd_branch_ssk';
			WOStruct['#attributes.fuseaction#']['upd_ssk']['filePath'] = '/V16/settings/form/upd_branch_ssk.cfm';
			WOStruct['#attributes.fuseaction#']['upd_ssk']['queryPath'] = '/V16/settings/query/add_branch_ssk.cfm';
			WOStruct['#attributes.fuseaction#']['upd_ssk']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd_ssk']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_branches';

			WOStruct['#attributes.fuseaction#']['history'] = structNew();
			WOStruct['#attributes.fuseaction#']['history']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['history']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.popup_detail_branch';
			WOStruct['#attributes.fuseaction#']['history']['filePath'] = '/V16/settings/display/detail_branch.cfm';
			WOStruct['#attributes.fuseaction#']['history']['Identity'] = '#attributes.id#';

			if(listgetat(attributes.fuseaction,1,'.') is 'settings')
			{
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=settings.emptypopup_branch_del&branch_id=#attributes.id#&head=##caller.category.branch_fullname##';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/settings/query/del_branch.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/V16/settings/query/del_branch.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'settings.list_branches';
			}
		}

		if(isdefined("attributes.branch_id"))
		{
			WOStruct['#attributes.fuseaction#']['addPeriod'] = structNew();
			WOStruct['#attributes.fuseaction#']['addPeriod']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['addPeriod']['fuseaction'] = 'hr.popup_list_period';
			WOStruct['#attributes.fuseaction#']['addPeriod']['filePath'] = '/V16/hr/display/list_periods.cfm';
			WOStruct['#attributes.fuseaction#']['addPeriod']['queryPath'] = '/V16/hr/query/add_periods_account_definition.cfm';
			WOStruct['#attributes.fuseaction#']['addPeriod']['Identity'] = '#attributes.branch_id#';
		}
				
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BRANCH';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'BRANCH_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-branch_fullname','item-branch_name']";
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_branches";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_branches&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_branches";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=129','WOC')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getLang('','settings',57473)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_branches&event=history&id=#attributes.id#');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('','settings',42354)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=settings.list_branches&event=upd_ssk&id=#attributes.id#&upd_control=1');";
			if(not listfindnocase(caller.denied_pages,'hr.popup_list_period'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['text'] = '#getLang('','main',57447)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.list_branches&event=addPeriod&branch_id=#attributes.id#');";
			}
		}
		else if(caller.attributes.event is 'upd_ssk')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_ssk']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_ssk']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_ssk']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_branches&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_ssk']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_ssk']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_ssk']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_ssk']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_branches";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_ssk']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd_ssk']['icons']['check']['onClick'] = "buttonClickFunction()";		
		}
		else if(caller.attributes.event is 'addPeriod')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['addPeriod']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['addPeriod']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addPeriod']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_branches&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['addPeriod']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['addPeriod']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['addPeriod']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addPeriod']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_branches";
			tabMenuStruct['#fuseactController#']['tabMenus']['addPeriod']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addPeriod']['icons']['check']['onClick'] = "buttonClickFunction()";		
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>