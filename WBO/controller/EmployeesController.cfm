<cfsavecontent variable="health_expenses"><cf_get_lang dictionary_id="41808.Sağlık Harcamaları"></cfsavecontent>
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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_hr';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/hr/display/list_hr.cfm';
		
		if(isdefined("attributes.employee_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.form_upd_emp';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/hr/form/form_upd_emp.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/hr/query/upd_emp_std.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.employee_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_hr&event=upd&employee_id=';
		}
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.form_add_emp';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/form/form_add_emp.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/query/add_emp.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_hr&event=add&employee_id=';

		WOStruct['#attributes.fuseaction#']['add_rapid'] = structNew();
		WOStruct['#attributes.fuseaction#']['add_rapid']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add_rapid']['fuseaction'] = 'hr.list_hr';
		WOStruct['#attributes.fuseaction#']['add_rapid']['filePath'] = 'V16/hr/form/form_add_rapid_emp.cfm';
		WOStruct['#attributes.fuseaction#']['add_rapid']['queryPath'] = 'V16/hr/query/add_rapid_emp.cfm';
		WOStruct['#attributes.fuseaction#']['add_rapid']['nextEvent'] = 'hr.list_hr';
	}
	else
	{	
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			get_module_user = caller.get_module_user;
			DENIED_PAGES = caller.DENIED_PAGES;
			employee = caller.employee;
			get_reqs = caller.get_reqs;
			get_module_power_user = caller.get_module_power_user;
			get_hr = caller.get_hr;
			get_position = caller.get_position;

			tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			i=0;

			if (not listfindnocase(denied_pages,'hr.popup_form_upd_emp_personal'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Kişisel Bilgiler',30236)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_form_upd_emp_personal&employee_id=#attributes.employee_id#','','ui-draggable-box-medium');";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'hr.popup_form_upd_emp_identy'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Kimlik Bilgileri',31234)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_form_upd_emp_identy&employee_id=#attributes.employee_id#','','ui-draggable-box-medium');";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'hr.popup_form_upd_emp_training'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Eğitim',57419)# - #getLang('','	İş Tecrübesi',31280)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_form_upd_emp_training&employee_id=#attributes.employee_id#','','ui-draggable-box-large');";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'hr.popup_form_upd_emp_com'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','İletişim',58143)# #getLang('','ve',57989)# #getLang('','Referans',58784)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_form_upd_emp_com&employee_id=#attributes.employee_id#','popup_form_upd_emp_com');";
				i = i + 1;
			}
			if (get_reqs.recordcount)
			{
				if (not listfindnocase(denied_pages,'hr.popup_upd_emp_requirement'))
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Yeterlilik',55471)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_upd_emp_requirement&employee_id=#attributes.employee_id#','req_box');";
					i = i + 1;
				}
			}
			else
			{
				if (not listfindnocase(denied_pages,'hr.popup_upd_emp_requirement'))
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Yeterlilik',55471)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_upd_emp_requirement&employee_id=#attributes.employee_id#');";
					i = i + 1;
				}
			}
			if (not listfindnocase(denied_pages,'hr.employee_relative'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Çalışan Yakınları',31276)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.employee_relative&event=list&employee_id=#attributes.employee_id#','popup_form_list_relative');";
				/* tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.employee_relative&employee_id=#attributes.employee_id#','relatives','popup_form_add_relative');"; */
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'hr.popup_list_employee_orientations'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Oryantasyon',32144)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_list_employee_orientations&event=orientations&employee_id=#attributes.employee_id#','','ui-draggable-box-large');";
				i = i + 1;
			}		
			if (not listfindnocase(denied_pages,'hr.popup_list_emp_test_time'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Deneme Süresi',29776)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_list_emp_test_time&emp_id=#attributes.employee_id#','trial_time','ui-draggable-box-large');";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'hr.popup_add_employee_contract'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Sözleşme',29522)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_list_employee_contract&employee_id=#attributes.employee_id#','contract_box','ui-draggable-box-large');";
				i = i + 1;
			}
			if (get_module_user(3) and not listfindnocase(denied_pages,'report.bsc_company'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Üye/Çalışan Raporu',55642)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=report.bsc_company&employee_id=#attributes.employee_id#&employee=#employee#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				i = i + 1;
			}
			/* if (not listfindnocase(denied_pages,'hr.popup_form_upd_emp_personal_certificate'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('hr',282)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_form_upd_emp_personal_certificate&employee_id=#attributes.employee_id#','page','popup_form_upd_emp_personal_certificate');";
				i = i + 1;
			} */
			if (not listfindnocase(denied_pages,'hr.popup_form_upd_emp_safeguard'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Teminat Bilgisi',55639)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_form_upd_emp_safeguard&employee_id=#attributes.employee_id#');";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'hr.popup_form_upd_emp_tools'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Kullandığı Araçlar',31308)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_form_upd_emp_tools&employee_id=#attributes.employee_id#','','ui-draggable-box-medium');";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'hr.popup_list_emp_trainings'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Eğitimler',29912)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_list_emp_trainings&emp_id=#attributes.employee_id#','','ui-draggable-box-large');";
				i = i + 1;
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Verdiği Eğitimler',46389)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_training_trainer&employee_id=#attributes.employee_id#');";
			i = i + 1;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',1709)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_password_maker&employee_id=#attributes.employee_id#','popup_list_password_maker');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Mail Hesapları',51123)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_list_mail_info&employee_id=#attributes.employee_id#', 'mail_accounts');";
		
			i = i+1;
			if (isdefined("is_gov_payroll") and is_gov_payroll eq 1 and not listfindnocase(denied_pages,'hr.popup_form_add_rank'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Derece',54179)# - #getLang('','Kademe Ekle',58703)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_form_add_rank&employee_id=#attributes.employee_id#');";
				i = i + 1;
			}
			if (len(get_hr.per_assign_id))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Atama Formu',56872)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=hr.from_upd_personel_assign_form&per_assign_id=#get_hr.per_assign_id#";
				i = i + 1;
			}

		
			if (get_module_user(3))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','İşçi Sağlığı',32168)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_list_employee_healty&employee_id=#attributes.employee_id#');";
				i = i + 1;
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','İşçi Sağlık Raporu',55828)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_list_emp_healty_report&employee_id=#attributes.employee_id#','healty_report_box');";
				i = i + 1;
			}
			if (get_module_user(70) and not listfindnocase(denied_pages,'hr.health_expense_approve'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#health_expenses#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=hr.health_expense_approve&expense_employee_id=#attributes.employee_id#&expense_employee=#employee#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'hr.popup_list_perf_remind_notes'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Performans Hatırlatma Notları',56344)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_list_perf_remind_notes&employee_id=#attributes.employee_id#');";
				i = i + 1;
			}
			if (get_module_user(48) and not listfindnocase(denied_pages,'report.report_transfer_work_position'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Görev Değişiklikleri',39149)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=report.report_transfer_work_position&employee_id=#attributes.employee_id#&employee_name=#employee#&is_submitted=1";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'hr.popup_form_emp_hobbies'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Hobiler',30648)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=hr.popup_form_emp_hobbies&employee_id=#attributes.employee_id#');";
				i = i + 1;
			}
		/* 	if (not listfindnocase(denied_pages,'hr.popup_form_upd_emp_employment_assets'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('hr',227)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_form_upd_emp_employment_assets&employee_id=#attributes.employee_id#','page','popup_form_upd_emp_employment_assets');";
				i = i + 1;
			} */
			
			
			
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();

			if (get_module_power_user(48))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['text'] = '#getLang('hr',36)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=employee&member_id=#attributes.employee_id#','wide2','popup_list_comp_extre');";
			} 
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['text'] = '#getLang('hr',44)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['onClick'] = "open_tab('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.employee_id#&type_id=-4','info');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getLang('main',61)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] = "open_tab('#request.self#?fuseaction=objects.popup_history_position&employee_id=#attributes.employee_id#','history');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=employee_id&action_id=#attributes.employee_id#','Workflow')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getlang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_hr&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['search']['text'] = '#getlang('main',153)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['search']['onclick'] = "openSearchForm('find_employee_number','#getlang('main',1075)#','find_employee_f')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_hr";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onclick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.employee_id#&print_type=173','WOC');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";	

			if(isdefined("attributes.x_employment_assets_pages_") and attributes.x_employment_assets_pages_ eq 0){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['archive']['text'] = '#getLang(dictionary_id:57568)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['archive']['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_form_emp_employment_assets&employee_id=#attributes.employee_id#','wide');";
			}
			else{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['archive']['text'] = '#getLang(dictionary_id:40770)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['archive']['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_form_upd_emp_employment_assets&employee_id=#attributes.employee_id#','wide');";

				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-archive']['text'] = '#getLang(dictionary_id:55367)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-archive']['onClick'] = "windowopen('#request.self#?fuseaction=hr.popup_form_upd_emp_personal_certificate&employee_id=#attributes.employee_id#','wide');";
			}
			
			tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
		}
		else if (attributes.event is 'add')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_hr";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
			
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EMPLOYESS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'EMPLOYEE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-employee_name','item-employee_surname','item-process_stage','item-employee_no']";

</cfscript>