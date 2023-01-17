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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#fusebox.circuit#.list_interruption';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/ehesap/display/list_emp_interruption.cfm';	
		
		if (listgetat(attributes.fuseaction,1,'.') is 'ehesap')
		{
			WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_form_add_kesinti_all';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/ehesap/form/popup_form_add_kesinti_all.cfm';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/ehesap/query/add_kesinti_all.cfm';
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.popup_form_add_kesinti_all&event=upd&id=';
			
			if(isdefined("attributes.id"))
			{
				WOStruct['#attributes.fuseaction#']['upd'] = structNew();
				WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
				WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_upd_payments';
				WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/ehesap/form/upd_payment_detail.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/ehesap/query/popup_upd_payment.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_interruption&event=upd&id=';
				
				if (isdefined("attributes.is_payment"))
				{
					WOStruct['#attributes.fuseaction#']['del'] = structNew();
					WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
					WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=ehesap.emptypopup_del_payment&id=#attributes.id#&employee_id=##caller.get_payments.EMPLOYEE_ID##&is_payment=1';
					WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/ehesap/query/del_payment.cfm';
					WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/ehesap/query/del_payment.cfm';
					WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_interruption';
				}
				else if (isdefined("attributes.is_interruption"))
				{
					WOStruct['#attributes.fuseaction#']['del'] = structNew();
					WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
					WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=ehesap.emptypopup_del_payment&id=#attributes.id#&employee_id=##caller.get_payments.EMPLOYEE_ID##&is_interruption=1';
					WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/ehesap/query/del_payment.cfm';
					WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/ehesap/query/del_payment.cfm';
					WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_interruption';
					
				}
				else if (isdefined("attributes.is_tax_except"))
				{
					WOStruct['#attributes.fuseaction#']['del'] = structNew();
					WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
					WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=ehesap.emptypopup_del_payment&id=#attributes.id#&employee_id=##caller.get_payments.EMPLOYEE_ID##&is_tax_except=1';
					WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/ehesap/query/del_payment.cfm';
					WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/ehesap/query/del_payment.cfm';
					WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_interruption';
				}
				else if (isdefined("attributes.is_bes"))
				{
					WOStruct['#attributes.fuseaction#']['del'] = structNew();
					WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
					WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=ehesap.emptypopup_del_payment&id=#attributes.id#&employee_id=##caller.get_payments.EMPLOYEE_ID##&is_bes=1';
					WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/ehesap/query/del_payment.cfm';
					WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/ehesap/query/del_payment.cfm';
					WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_bes';
				}
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
		
		if(caller.attributes.event is 'add')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.list_interruption";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(attributes.event is 'upd')
		{
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getlang('main',170)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_interruption&event=add";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.list_interruption";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>