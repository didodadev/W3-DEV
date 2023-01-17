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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.flexible_worktime';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/myhome/display/list_flexible_worktime.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.flexible_worktime';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/myhome/form/add_flexible_worktime.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/myhome/query/add_flexible_worktime.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '';

		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'myhome.flexible_worktime';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/myhome/form/upd_flexible_worktime.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/myhome/query/upd_flexible_worktime.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '';

		WOStruct['#attributes.fuseaction#']['approve'] = structNew();
		WOStruct['#attributes.fuseaction#']['approve']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['approve']['fuseaction'] = 'myhome.flexible_worktime';
		WOStruct['#attributes.fuseaction#']['approve']['filePath'] = '/V16/myhome/display/flexible_worktime_approve.cfm';

		WOStruct['#attributes.fuseaction#']['ajaxApprove'] = structNew();
		WOStruct['#attributes.fuseaction#']['ajaxApprove']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['ajaxApprove']['fuseaction'] = 'myhome.flexible_worktime';
		WOStruct['#attributes.fuseaction#']['ajaxApprove']['filePath'] = 'V16/myhome/display/flexible_approve_ajax.cfm';

		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'myhome.flexible_worktime';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/myhome/query/del_flexible_worktime.cfm';
		
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=myhome.flexible_worktime";

			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.flexible_id#&print_type=122','WOC');";


			if(isdefined("caller.attributes.is_approve_page") and len(caller.attributes.is_approve_page)){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=myhome.flexible_worktime&is_approve_page=1";
			}else{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=myhome.flexible_worktime";
			}
				
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=myhome.flexible_worktime&action_name=flexible_id&action_id=#attributes.flexible_id#','Workflow')";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('ehesap',72)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['onClick'] = "window.location.href='#request.self#?fuseaction=myhome.flexible_worktime&event=add';";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>