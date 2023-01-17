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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.hr_offtime_approve';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/ehesap/display/list_offer_approve.cfm';		

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.hr_offtime_approve';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/form/add_employee_offtime_contract.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/query/add_employee_offtime_contract.cfm';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_emp_offtime_contract';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.hr_offtime_approve&event=upd&id=';

		if(isdefined("attributes.employees_offtime_contract_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.popup_upd_employee_offtime_contract';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/form/upd_employee_offtime_contract.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/query/upd_employee_offtime_contract.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'upd_emp_offtime_contract';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.employees_offtime_contract_id#';
			WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_contract';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.hr_offtime_approve&event=upd&employees_offtime_contract_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=hr.emptypopup_del_employee_offtime_contract&employees_offtime_contract_id=#attributes.employees_offtime_contract_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/query/del_employee_offtime_contract.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/query/del_employee_offtime_contract.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.hr_offtime_approve';
		}

		WOStruct['#attributes.fuseaction#']['batch'] = structNew();
		WOStruct['#attributes.fuseaction#']['batch']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['batch']['fuseaction'] = 'ehesap.hr_offtime_approve';
		WOStruct['#attributes.fuseaction#']['batch']['filePath'] = 'V16/hr/ehesap/display/batch_add_offer_approve.cfm';	
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.hr_offtime_approve";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-clone']['text'] = '#getLang('','Toplu Ekleme',55886)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-clone']['href'] = "#request.self#?fuseaction=ehesap.hr_offtime_approve&event=batch";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-clone']['target'] = "_blank";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('','Ekle','44630')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.hr_offtime_approve&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";		
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.hr_offtime_approve";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['href'] = "#request.self#?fuseaction=objects.popup_print_files&ACTION_ID=#attributes.employees_offtime_contract_id#&id=#attributes.employees_offtime_contract_id#&print_type=210";
		}
		else if(caller.attributes.event is 'batch')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['batch']['icons'] = structNew();

			tabMenuStruct['#fuseactController#']['tabMenus']['batch']['icons']['add']['text'] = '#getLang('','Ekle','44630')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['batch']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.hr_offtime_approve&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['batch']['icons']['add']['target'] = "_blank";		
			
			tabMenuStruct['#fuseactController#']['tabMenus']['batch']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['batch']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['batch']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.hr_offtime_approve";
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
