<!---
File: AllowenceExpenseController.cfm
Description: Harcırah talebi controller sayfasıdır.
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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.allowance_expense';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/myhome/display/allowance_expense.cfm';

        WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.allowance_expense';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/myhome/form/add_allowance_expense.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/myhome/query/add_allowance_expense.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '';

		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'myhome.allowance_expense';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/myhome/form/upd_allowance_expense.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/myhome/query/upd_allowance_expense.cfm';
        WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '';

		WOStruct['#attributes.fuseaction#']['expense'] = structNew();
		WOStruct['#attributes.fuseaction#']['expense']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['expense']['fuseaction'] = 'myhome.allowance_expense';
		WOStruct['#attributes.fuseaction#']['expense']['filePath'] = 'V16/myhome/display/convert_expense_allowance.cfm';
        WOStruct['#attributes.fuseaction#']['expense']['nextEvent'] = '';

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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=myhome.allowance_expense";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=myhome.allowance_expense&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=myhome.allowance_expense";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['target'] = "_blank";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['href'] = '#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.request_id#&print_type=175';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=myhome.allowance_expense&action_name=request_id&action_id=#attributes.request_id#','Workflow')";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
</cfscript>