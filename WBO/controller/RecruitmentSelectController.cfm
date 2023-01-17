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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.emp_app_select_list';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_emp_app_select_list.cfm';	
		
		if(isdefined("attributes.list_id"))
		{
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'hr.upd_emp_app_select_list';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/hr/form/upd_emp_app_select_list.cfm';
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'V16/hr/query/upd_emp_app_select_list_rows.cfm';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'hr.emp_app_select_list&event=det&list_id=';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.list_id#';
			
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.popup_upd_select_list';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/form/upd_select_list.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/query/upd_emp_app_select_list.cfm';			
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.emp_app_select_list&event=det&list_id';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.list_id#';
			
			if(listfind('det',attributes.event) or (attributes.event is 'del' and isdefined('attributes.del')))
			{
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.emptypopup_upd_select_list_rows&list_id=#attributes.list_id#&del=1';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/query/upd_emp_app_select_list_rows.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/query/upd_emp_app_select_list_rows.cfm';
				WOStruct['#attributes.fuseaction#']['del']['extraParams'] = '_list_row_id_';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.emp_app_select_list&event=det&list_id=#attributes.list_id#';
			}
			else if(listfind('upd,del',attributes.event))
			{
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.emptypopup_del_emp_app_select_list&list_id=#attributes.list_id#';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/query/del_emp_app_select_list.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/query/del_emp_app_select_list.cfm';
				WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'list_id';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.emp_app_select_list';
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
		
		if(caller.attributes.event is 'det')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'] = structNew();

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['text'] = '#getLang('hr',957)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_list_del_select_list_empapp&list_id=#attributes.list_id#','list');";

			/*tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][2]['text'] = '#getLang('main',1966)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][2]['customTag'] = "<cf_workcube_file_action is_ajax='1' pdf='1' mail='1' doc='1' print='1' tag_module='select_list_div'>";
			*/
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getLang('main',52,'güncelle')#';

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=hr.emp_app_select_list&event=upd&list_id=#attributes.list_id#";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.emp_app_select_list";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] = "buttonClickFunction()";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=myhome.upd_emp_app_select_list&action_name=list_id&action_id=#attributes.list_id#&wrkflow=1','Workflow')";

			
		}
		if(caller.attributes.event is 'upd')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.emp_app_select_list";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
