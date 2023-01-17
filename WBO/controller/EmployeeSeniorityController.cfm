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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_emp_progress_payment';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/ehesap/display/list_emp_progress_payment.cfm';	
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_add_progress_payment';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/hr/ehesap/form/popup_add_progress_payment.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/hr/ehesap/query/add_progress_pay.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_emp_progress_payment&event=upd&progress_id=';	

		WOStruct['#attributes.fuseaction#']['popupAdd'] = structNew();
		WOStruct['#attributes.fuseaction#']['popupAdd']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['popupAdd']['fuseaction'] = 'ehesap.popup_add_progress_payment';
		WOStruct['#attributes.fuseaction#']['popupAdd']['filePath'] = '/V16/hr/ehesap/form/popup_add_progress_payment.cfm';
		WOStruct['#attributes.fuseaction#']['popupAdd']['queryPath'] = 'V16/hr/ehesap/query/add_progress_pay.cfm';
		WOStruct['#attributes.fuseaction#']['popupAdd']['nextEvent'] = 'ehesap.list_emp_progress_payment&event=popUpd&progress_id=';	
		
		if(isdefined("attributes.progress_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ehesap.popup_upd_progress_payment';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/ehesap/form/popup_upd_progress_payment.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/ehesap/query/upd_progress_pay.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.progress_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ehesap.list_emp_progress_payment&event=upd&progress_id=';
			
			WOStruct['#attributes.fuseaction#']['popupUpd'] = structNew();
			WOStruct['#attributes.fuseaction#']['popupUpd']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['popupUpd']['fuseaction'] = 'ehesap.popup_upd_progress_payment';
			WOStruct['#attributes.fuseaction#']['popupUpd']['filePath'] = 'V16/hr/ehesap/form/popup_upd_progress_payment.cfm';
			WOStruct['#attributes.fuseaction#']['popupUpd']['queryPath'] = 'V16/hr/ehesap/query/upd_progress_pay.cfm';
			WOStruct['#attributes.fuseaction#']['popupUpd']['Identity'] = '#attributes.progress_id#';
			WOStruct['#attributes.fuseaction#']['popupUpd']['nextEvent'] = 'ehesap.list_emp_progress_payment&event=popupUpd&progress_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=ehesap.emptypopup_del_progress_pay&progress_id=#attributes.progress_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/ehesap/query/del_progress_pay.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/ehesap/query/del_progress_pay.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ehesap.list_emp_progress_payment';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.list_emp_progress_payment";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ehesap.list_emp_progress_payment&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ehesap.list_emp_progress_payment";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EMPLOYEE_PROGRESS_PAYMENT';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PROGRESS_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-branch_id','item-emp_name','item-startdate','item-finishdate']";

</cfscript>
