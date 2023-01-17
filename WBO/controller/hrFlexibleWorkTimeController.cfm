<!---
File: FlexibleWorkTimeController.cfm
Description: Esnek çalışma saatleri controller sayfasıdır.
--->
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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.flexible_worktime';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_flexible_worktime.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.flexible_worktime';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/myhome/form/add_flexible_worktime.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/myhome/query/add_flexible_worktime.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '';

		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.flexible_worktime';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/myhome/form/upd_flexible_worktime.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/myhome/query/upd_flexible_worktime.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '';
		
		WOStruct['#attributes.fuseaction#']['ajaxApprove'] = structNew();
		WOStruct['#attributes.fuseaction#']['ajaxApprove']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['ajaxApprove']['fuseaction'] = 'hr.flexible_worktime';
		WOStruct['#attributes.fuseaction#']['ajaxApprove']['filePath'] = 'V16/myhome/display/flexible_approve_ajax.cfm';


		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'hr.flexible_worktime';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/myhome/query/del_flexible_worktime.cfm';

	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
		getLang = caller.getLang;
		dsn = caller.dsn;
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		if(isdefined("caller.attributes.event") and caller.attributes.event is 'add'){

			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";

			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.flexible_worktime";

		}

		
        if((isdefined("caller.attributes.event") and caller.attributes.event is 'upd') or (isdefined("caller.attributes.event") and caller.attributes.event is 'popupUpd'))
		{
    
			tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			
		
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('main',578,'E-profil')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#caller.attributes.emp_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['target'] = "_blank";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['text'] = '#getLang('main',2382,'Çalışan icmal')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['href'] = "#request.self#?fuseaction=ehesap.list_icmal_personal&employee_id=#caller.attributes.emp_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['target'] = "_blank";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['text'] = '#getLang('myhome',63,'İzinler')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['href'] = "#request.self#?fuseaction=ehesap.offtimes&employee_id=#caller.attributes.emp_id#&startdate=#caller.attributes.request_date#&branch_id=#caller.attributes.branch_id#&keyword=#caller.get_emp_info(caller.attributes.emp_id,0,0)#&form_submit=1";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['target'] = "_blank";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][3]['text'] = '#getLang('ehesap',24,'Fazla mesailer')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][3]['href'] = "#request.self#?fuseaction=ehesap.list_ext_worktimes&employee_id=#caller.attributes.emp_id#&date1=#caller.attributes.request_date#&keyword=#caller.get_emp_info(caller.attributes.emp_id,0,0)#&form_submit=1";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][3]['target'] = "_blank";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170,'ekle')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.flexible_worktime&event=add";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.flexible_id#&print_type=122','page');";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.flexible_worktime";
            
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
	}
</cfscript>