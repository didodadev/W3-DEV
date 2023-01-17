<!---
File: hrAllowenceExpenseController.cfm
Description: Harcırah talebi hr controller sayfasıdır.
Author: Esma R. UYSAL
Date: 07/12/2019 
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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.allowance_expense';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/hr/display/allowance_expense.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.allowance_expense';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/myhome/form/add_allowance_expense.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/myhome/query/add_allowance_expense.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '';

		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.allowance_expense';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/myhome/form/upd_allowance_expense.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/myhome/query/upd_allowance_expense.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '';

		WOStruct['#attributes.fuseaction#']['expense'] = structNew();
		WOStruct['#attributes.fuseaction#']['expense']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['expense']['fuseaction'] = 'hr.allowance_expense';
		WOStruct['#attributes.fuseaction#']['expense']['filePath'] = 'V16/myhome/display/convert_expense_allowance.cfm';
        WOStruct['#attributes.fuseaction#']['expense']['nextEvent'] = '';
		if(isdefined("attributes.request_id"))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'objects.del_expense_plan_request&request_id=#attributes.request_id#&allowance_expense=1';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'objects/query/del_expense_plan_request.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'objects/query/del_expense_plan_request.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cost.list_expense_requests';
		}
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
		getLang = caller.getLang;

		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		if(caller.attributes.event is 'add')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.allowance_expense";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
        else if((isdefined("caller.attributes.event") and caller.attributes.event is 'upd') or (isdefined("caller.attributes.event") and caller.attributes.event is 'popupUpd'))
		{
			get_expense = caller.get_expense;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();

			i = 0;
			if (get_expense.expense_hr_allowance != '') {

				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang(dictionary_id : 35196)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=ehesap.list_travel_demands&event=upd&TRAVEL_DEMAND_ID=#get_expense.expense_hr_allowance#";

			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170,'ekle')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.allowance_expense&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',170,'ekle')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.allowance_expense&event=list";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#attributes.request_id#','WOC');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=request_id&action_id=#attributes.request_id#','Workflow')";

		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>