<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_positions';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/hr/display/list_positions.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.form_add_position';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/hr/form/add_position.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/hr/query/add_position.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_positions&event=upd';
		
		if(isdefined("attributes.position_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.form_upd_position';
			WOStruct['#attributes.fuseaction#']['upd']['Xmlfuseaction'] = 'hr.form_add_position';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/hr/form/upd_position.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/hr/query/upd_position.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#listfirst(attributes.position_id,',')#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_positions&event=upd&position_id=';
		}
				
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EMPLOYEE_POSITIONS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'POSITION_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-department','item-position_cat_id','item-title_id']";
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		// Upd //
		if(isdefined("attributes.event") and not(attributes.event is 'add' or attributes.event is 'list'))
		{
			getLang = caller.getLang;
			get_position_detail = caller.get_position_detail;
			denied_page = caller.denied_page;
			denied_pages = caller.denied_pages;
			check = caller.check;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			i = 0;

			if (get_position_detail.employee_id neq 0 and len(get_position_detail.employee_id) and not listfindnocase(denied_pages,'hr.form_add_quiz'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main','Çalışan',57576)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#get_position_detail.employee_id#";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'hr.popup_list_up_position'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('hr',891)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_list_up_position&position_id=#get_position_detail.position_id#&position_cat_id=#get_position_detail.position_cat_id#','','ui-draggable-box-small');";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'hr.popup_upd_pos_requirement'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('hr',420)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_upd_pos_requirement&position_id=#get_position_detail.position_id#&position_cat_id=#get_position_detail.position_cat_id#','','ui-draggable-box-small');";
				i = i + 1;
			}
			if (listFindNoCase(session.ep.POWER_USER_LEVEL_ID,64))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main','Ayarlar',57435)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions_poweruser&employee_id=#get_position_detail.EMPLOYEE_ID#&position_id=#get_position_detail.position_id#&employee_name=#get_position_detail.employee_name# #get_position_detail.employee_surname#','','ui-draggable-box-large');";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'hr.popup_list_position_content'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('hr','Greöv Tanımları',47117)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_list_position_content&position_id=#get_position_detail.position_id#&position_cat_id=#get_position_detail.position_cat_id#','','ui-draggable-box-small');";
				i = i + 1;
			}
			if (listFindNoCase(session.ep.user_level,48) and (not listfindnocase(denied_pages,'hr.popup_position_money')))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main','Maliyet',58258)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_position_money&position_id=#get_position_detail.position_id#');";
				i = i + 1;
			}
			if (get_position_detail.position_code is check.position_code)
			{
				if (not listfindnocase(denied_pages,'hr.list_puantaj'))
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('hr','Yedekler ve Amirler',55166)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=hr.list_standby&event=upd&sb_id=#check.sb_id#";
					i = i + 1;
				}
			}
			else
			{
				if (not listfindnocase(denied_pages,'hr.form_add_standby'))
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('hr','Yedekler ve Amirler',55166)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=hr.list_standby";
					i = i + 1;
				}
			}
			if (session.ep.ehesap and not listfindnocase(denied_pages, 'hr.popup_form_add_emp_authority_codes'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('hr',910)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_form_add_emp_authority_codes&position_id=#get_position_detail.position_id#','medium');";
				i = i + 1;
			}
			if (get_position_detail.employee_id neq 0 and len(get_position_detail.employee_id) and listFindNoCase(session.ep.user_level,48))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('ehesap','Çalışan Giriş Çıkışları',53542)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=ehesap.popup_list_multi_in_out&employee_id=#get_position_detail.employee_id#');";
				i = i + 1;
			}
			if ( not listfindnocase(denied_pages,'report.report_transfer_work_position'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('report','Görev Değişiklikleri Pozisyon',39034)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=report.report_transfer_work_position&employee_id=#get_position_detail.employee_id#&employee_name=#get_position_detail.EMP_NAME_SURNAME#&is_submitted=1";
				i = i + 1;
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main','Uyarılar',57757)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=hr.list_positions&action_name=#attributes.position_id#&action_id=#attributes.position_id#&wrkflow=1','Workflow')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_positions";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main','Ekle',57582)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_positions&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main','Kopyala',57476)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=hr.emptypopup_position_copy&position_id=#get_position_detail.position_id#&position_code=#get_position_detail.position_code#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main','Yazdır',57474)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.position_id#&print_type=185','page','workcube_print');";
			if (not listfindnocase(denied_pages,'hr.popup_position_history'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = "#getLang('main',61,'Tarihçe')#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_position_history&position_id=#get_position_detail.position_id#');";
			}
			
		}
		else if (attributes.event is 'add')
		{
			getLang = caller.getLang;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_positions";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
	}
</cfscript>