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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.list_salary';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/ehesap/display/list_salary.cfm';

		if(isdefined("attributes.in_out_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.form_upd_salary';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/ehesap/form/upd_salary.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/ehesap/query/upd_emp_work.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = IIf(IsDefined("attributes.empName"), "attributes.empName", DE(attributes.in_out_id));
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_salary&event=upd&employee_id=';

			
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'hr.list_emp_work_info';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/hr/display/list_emp_work_info.cfm';
			WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'V16/hr/query/upd_emp_work_info.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = IIf(IsDefined("attributes.empName"), "attributes.empName", DE(attributes.in_out_id));
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_salary&event=det&employee_id=';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'] = structNew();
			if (not (fuseaction contains "popup_"))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['text'] = '#getLang('ehesap',511)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['href'] = "#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#";
			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_salary";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			get_module_power_user = caller.get_module_power_user;
			denied_pages = caller.denied_pages;
			get_worktimes_xml = caller.get_worktimes_xml;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			
			i = 0;
			if (get_module_power_user(48))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('ehesap',350)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=ehesap.popup_list_salary_plan&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id# ','','ui-draggable-box-large');";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'ehesap.popup_list_remote_plan'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Uzaktan Çalışma Planla',63056)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=ehesap.popup_list_remote_plan&employee_id=#attributes.employee_id#&&in_out_id=#attributes.in_out_id#','','ui-draggable-box-large');";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'ehesap.popup_list_period'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main','Muhasebe Kodu',58811)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=ehesap.popup_list_period&event=upd&in_out_id=#attributes.in_out_id#');";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'ehesap.popup_form_upd_fuse'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('ehesap',508)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_form_upd_fuse&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#','project');";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'ehesap.popup_form_upd_odenek_hr'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('ehesap',453)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=ehesap.popup_form_upd_odenek_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#&use_ssk=#caller.get_emp_ssk.use_ssk#','','ui-draggable-box-large');";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'ehesap.popup_form_upd_kesinti_hr'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('ehesap',327)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=ehesap.popup_form_upd_kesinti_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#','','ui-draggable-box-large');";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'ehesap.popup_form_upd_vergi_istisna_hr'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('ehesap',139)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=ehesap.popup_form_upd_vergi_istisna_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#','','ui-draggable-box-large');";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'ehesap.popup_form_upd_bes_hr'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Otomatik BES Tanımları',62859)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=ehesap.popup_form_upd_bes_hr&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#','','ui-draggable-box-large');";
				i = i + 1;
			}

			if (get_module_power_user(48))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('','İcra Dosyaları','39036')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=ehesap.list_executions&employee_id=#employee_id#&employee=#attributes.empName#";
				i = i + 1;
			}

			if (get_worktimes_xml.PROPERTY_VALUE eq 1)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('ehesap',24)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=ehesap.popup_add_emp_ext_worktimes&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#','','ui-draggable-box-large');";
				i = i + 1;
			}
			else if (not listfindnocase(denied_pages,'ehesap.popup_form_upd_ext_worktimes'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('ehesap',24)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=ehesap.popup_form_upd_ext_worktimes&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#','medium');";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'ehesap.popup_pay_history'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('ehesap',281)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=ehesap.popup_pay_history&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#','horizantal')";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'ehesap.popup_in_out_history'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('ehesap',725)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=ehesap.popup_in_out_history&employee_id=#attributes.employee_id#&in_out_id=#attributes.in_out_id#','horizantal')";
				i = i + 1;
			}
			if (not listfindnocase(denied_pages,'ehesap.popup_list_multi_in_out'))
			{
				if (not (fuseaction contains "popup_"))
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('ehesap',596)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=ehesap.popup_list_multi_in_out&employee_id=#attributes.employee_id#','list');";
					i = i + 1;
				}else 
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('ehesap',596)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=ehesap.popup_list_multi_in_out&employee_id=#attributes.employee_id#";	
					i = i + 1;
				}
			}
			if (not (fuseaction contains "popup_"))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('ehesap',511)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#";
				i = i + 1;
			}

			if(isdefined("caller.get_emp_ssk.use_ssk") and caller.get_emp_ssk.use_ssk eq 2)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Memur Kıdem Tarihçe',63810)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.widget_loader&widget_load=officerHistory&in_out_id=#attributes.in_out_id#');";
				i = i + 1;
			}
			
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main','liste',57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_salary";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-download']['text'] = '#getLang('','Veri Aktarım',60009)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-download']['onclick'] = "open_tab('#request.self#?fuseaction=ehesap.import_monthly_average_net','monthly_average_net');";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>