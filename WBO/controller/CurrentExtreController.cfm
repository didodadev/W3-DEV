<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'liste';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['liste'] = structNew();
		WOStruct['#attributes.fuseaction#']['liste']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['liste']['fuseaction'] = '#attributes.fuseaction#';
		WOStruct['#attributes.fuseaction#']['liste']['Xmlfuseaction'] = 'objects.popup_list_extre';
		WOStruct['#attributes.fuseaction#']['liste']['filePath'] = 'V16/objects/display/list_comp_extre.cfm';
		WOStruct['#attributes.fuseaction#']['liste']['queryPath'] = 'V16/objects/display/list_comp_extre.cfm';
		WOStruct['#attributes.fuseaction#']['liste']['nextEvent'] = '#attributes.fuseaction#';	
	}
	else
	{
		if(isdefined("attributes.form_submit"))
		{
			fuseactController = caller.attributes.fuseaction;
			getLang = caller.getLang;
			
			if(attributes.event is 'liste')
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['liste'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['liste']['menus'] = structNew();
				
				tabMenuStruct['#fuseactController#']['tabMenus']['liste']['menus'][0]['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['liste']['menus'][0]['text'] = '#getlang('correspondence',5)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['liste']['menus'][0]['href'] = "#request.self#?fuseaction=finance.list_payment_actions&event=add&act_type=2&correspondence_info=1&member_id=#attributes.company_id#&consumer_id=#attributes.consumer_id#&employee_id_new=#attributes.employee_id#";	
				
				tabMenuStruct['#fuseactController#']['tabMenus']['liste']['menus'][1]['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['liste']['menus'][1]['text'] = '#getlang('finance',265)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['liste']['menus'][1]['href'] = "#request.self#?fuseaction=finance.list_payment_actions&event=add&act_type=3&correspondence_info=1&member_id=#attributes.company_id#&consumer_id=#attributes.consumer_id#&employee_id_new=#attributes.employee_id#";	
	
				i=2;
				if(not(isdefined("attributes.is_collacted") and attributes.is_collacted eq 1))
				{
					if(isdefined("attributes.company_id") and len(attributes.company_id) and not (isdefined("attributes.employee_id") and len(attributes.employee_id)))
					{
						tabMenuStruct['#fuseactController#']['tabMenus']['liste']['menus'][i]['text'] = '#getlang('main',981)#';
						tabMenuStruct['#fuseactController#']['tabMenus']['liste']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#attributes.company_id#','medium');";	
						i++;
					}
					else if(isdefined("attributes.consumer_id") and len(attributes.consumer_id))
					{
						tabMenuStruct['#fuseactController#']['tabMenus']['liste']['menus'][i]['text'] = '#getlang('main',981)#';
						tabMenuStruct['#fuseactController#']['tabMenus']['liste']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#attributes.consumer_id#','medium');";	
						i++;
					}
					else if(isdefined("attributes.employee_id") and len(attributes.employee_id) and listlen(attributes.employee_id,'_') eq 2)
					{
						tabMenuStruct['#fuseactController#']['tabMenus']['liste']['menus'][i]['text'] = '#getlang('main',752)#';
						tabMenuStruct['#fuseactController#']['tabMenus']['liste']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#listfirst(attributes.employee_id,'_')#','medium');";							
						i++;
					}
					else if(isdefined("attributes.employee_id") and len(attributes.employee_id))
					{
						tabMenuStruct['#fuseactController#']['tabMenus']['liste']['menus'][i]['text'] = '#getlang('main',752)#';
						tabMenuStruct['#fuseactController#']['tabMenus']['liste']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#attributes.employee_id#','medium');";				
						i++;
					}
				}
				
				tabMenuStruct['#fuseactController#']['tabMenus']['liste']['icons']['fileAction']['text'] = '';
				tabMenuStruct['#fuseactController#']['tabMenus']['liste']['icons']['fileAction']['customTag'] = "<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' tag_module='list_extre_content' is_ajax='1' isAjaxPage='1' noShow='noShow1'>";	
	
				if(isdefined("attributes.company_id"))
					cmp_id_info = "&action_id=#attributes.company_id#";
				else
					cmp_id_info = "";
				tabMenuStruct['#fuseactController#']['tabMenus']['liste']['icons']['print']['text'] = '#getLang('main',62)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['liste']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_date1=#dateformat(attributes.date1,'dd/mm/yyyy')#&action_date2=#dateformat(attributes.date2,'dd/mm/yyyy')##cmp_id_info#&keyword=#caller.extra_params#&print_type=214','page');";
				
				tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
			}
		}
	}
</cfscript>