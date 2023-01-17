<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_fire';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/ehesap/display/list_fire.cfm';

		WOStruct['#attributes.fuseaction#']['addIn'] = structNew();
		WOStruct['#attributes.fuseaction#']['addIn']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['addIn']['fuseaction'] = 'ehesap.form_add_position_in';
		WOStruct['#attributes.fuseaction#']['addIn']['filePath'] = 'V16/hr/ehesap/form/add_position_in.cfm';
		WOStruct['#attributes.fuseaction#']['addIn']['queryPath'] = 'V16/hr/ehesap/query/add_position_in.cfm';
		WOStruct['#attributes.fuseaction#']['addIn']['nextEvent'] = 'ehesap.list_fire&event=upd&id=';
		
		WOStruct['#attributes.fuseaction#']['addmulti'] = structNew();
		WOStruct['#attributes.fuseaction#']['addmulti']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['addmulti']['fuseaction'] = 'ehesap.popup_work_whole_exit';
		WOStruct['#attributes.fuseaction#']['addmulti']['filePath'] = 'V16/hr/ehesap/display/work_whole_exit.cfm';
		WOStruct['#attributes.fuseaction#']['addmulti']['queryPath'] = 'V16/hr/ehesap/query/work_exit.cfm';
		WOStruct['#attributes.fuseaction#']['addmulti']['nextEvent'] = 'ehesap.list_fire';

		WOStruct['#attributes.fuseaction#']['executive'] = structNew();
		WOStruct['#attributes.fuseaction#']['executive']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['executive']['fuseaction'] = 'ehesap.list_fire';
		WOStruct['#attributes.fuseaction#']['executive']['filePath'] = 'V16/hr/ehesap/form/fire_execution_control.cfm';
		WOStruct['#attributes.fuseaction#']['executive']['nextEvent'] = 'ehesap.list_fire';

		if(isdefined("attributes.in_out_id"))
		{
			WOStruct['#attributes.fuseaction#']['updIn'] = structNew();
			WOStruct['#attributes.fuseaction#']['updIn']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['updIn']['fuseaction'] = 'ehesap.popup_view_unfired';
			WOStruct['#attributes.fuseaction#']['updIn']['filePath'] = 'V16/hr/ehesap/display/unfired.cfm';
			WOStruct['#attributes.fuseaction#']['updIn']['queryPath'] = 'V16/hr/ehesap/query/upd_unfired.cfm';
			WOStruct['#attributes.fuseaction#']['updIn']['Identity'] = '#attributes.in_out_id#';
			
			WOStruct['#attributes.fuseaction#']['updOut'] = structNew();
			WOStruct['#attributes.fuseaction#']['updOut']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['updOut']['fuseaction'] = 'ehesap.popup_view_fired';
			WOStruct['#attributes.fuseaction#']['updOut']['filePath'] = 'V16/hr/ehesap/display/fired.cfm';
			WOStruct['#attributes.fuseaction#']['updOut']['queryPath'] = 'V16/hr/ehesap/query/upd_fire.cfm';
			WOStruct['#attributes.fuseaction#']['updOut']['Identity'] = '#attributes.in_out_id#';
			
			WOStruct['#attributes.fuseaction#']['addOut'] = structNew();
			WOStruct['#attributes.fuseaction#']['addOut']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['addOut']['fuseaction'] = 'ehesap.popup_form_fire';
			WOStruct['#attributes.fuseaction#']['addOut']['filePath'] = 'V16/hr/ehesap/form/fire.cfm';
			WOStruct['#attributes.fuseaction#']['addOut']['queryPath'] = 'V16/hr/ehesap/form/fire_action.cfm';
			WOStruct['#attributes.fuseaction#']['addOut']['Identity'] = '#attributes.in_out_id#';
			WOStruct['#attributes.fuseaction#']['addOut']['nextEvent'] = 'ehesap.list_fire';

			WOStruct['#attributes.fuseaction#']['debit'] = structNew();
			WOStruct['#attributes.fuseaction#']['debit']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['debit']['fuseaction'] = 'ehesap.list_fire';
			WOStruct['#attributes.fuseaction#']['debit']['filePath'] = 'V16/hr/ehesap/display/fire_debits_control.cfm';
			WOStruct['#attributes.fuseaction#']['debit']['Identity'] = '#attributes.in_out_id#';
			WOStruct['#attributes.fuseaction#']['debit']['nextEvent'] = 'ehesap.list_fire';

			
			
			if(listFind('updOut,updIn,del',attributes.event))
			{
				head = '##caller.get_fire_detail.employee_name## ##caller.get_fire_detail.employee_surname##';
				
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=ehesap.emptypopup_del_fire&in_out_id=#attributes.in_out_id#&head=#head#';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/ehesap/query/del_fire.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/ehesap/query/del_fire.cfm';
				WOStruct['#attributes.fuseaction#']['del']['Identity'] = '#attributes.in_out_id#';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_fire';	
			}
		}
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'addIn')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['addIn']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['addIn']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['addIn']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addIn']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.list_fire";
			tabMenuStruct['#fuseactController#']['tabMenus']['addIn']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addIn']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'addmulti')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['addmulti']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['addmulti']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['addmulti']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addmulti']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.list_fire";
			tabMenuStruct['#fuseactController#']['tabMenus']['addmulti']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addmulti']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'addOut')
		{	
			get_in_out = caller.get_in_out;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addOut'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addOut']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addOut']['menus'][0]['text'] = '#getlang('ehesap',511)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['addOut']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_work_detail&employee_id=#get_in_out.employee_id#','medium');";
				
			tabMenuStruct['#fuseactController#']['tabMenus']['addOut']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['addOut']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['addOut']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addOut']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.list_fire";
			tabMenuStruct['#fuseactController#']['tabMenus']['addOut']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addOut']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		else if(caller.attributes.event is 'updOut')
		{	
			tabMenuStruct['#fuseactController#']['tabMenus']['updOut']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updOut']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['updOut']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updOut']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.list_fire";
			tabMenuStruct['#fuseactController#']['tabMenus']['updOut']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updOut']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['updOut']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updOut']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#url.in_out_id#&print_type=179&iid=#attributes.employee_id#','page');";
		}
		else if(caller.attributes.event is 'updIn')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['updIn']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updIn']['icons']['add']['text'] = '#getLang('ehesap',1030)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updIn']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_fire&event=addIn";
			tabMenuStruct['#fuseactController#']['tabMenus']['updIn']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['updIn']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['updIn']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updIn']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.list_fire";
			tabMenuStruct['#fuseactController#']['tabMenus']['updIn']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updIn']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['updIn']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updIn']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#url.in_out_id#&print_type=179&iid=#attributes.employee_id#','page');";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'addmulti';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BRANCH';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'BRANCH_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-branch','item-exitdate']";
</cfscript>
