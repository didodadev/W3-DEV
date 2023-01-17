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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'budget.list_tahakkuk';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/budget/display/list_tahakkuk.cfm';	
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'budget.list_tahakkuk';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/budget/form/add_tahakkuk_plan.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/budget/query/add_tahakkuk_plan.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'budget.list_tahakkuk&event=upd&tplan_id=';	
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('budget_plan','budget_plan_bask');";
		
		if(isdefined("attributes.tplan_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'budget.list_tahakkuk';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/budget/form/upd_tahakkuk_plan.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/budget/query/upd_tahakkuk_plan.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.tplan_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'budget.list_tahakkuk&event=upd&tplan_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('budget_plan','budget_plan_bask');";
		}
		
		if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=budget.emptypopup_del_tahakkuk_plan&tplan_id=#attributes.tplan_id#&old_process_type=##caller.get_tahakkuk_plan.process_type##&wrk_id=##caller.get_tahakkuk_plan.wrk_id##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/budget/query/del_tahakkuk_plan.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/budget/query/del_tahakkuk_plan.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'budget.list_tahakkuk';
		}
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'TAHAKKUK_PLAN';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'TAHAKKUK_PLAN_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-surec','item-employee_name','item-record_date','item-paper_number']";
		
	}else
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=budget.list_tahakkuk";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		else if(caller.attributes.event is 'upd')
		{
			get_tahakkuk_plan = caller.get_tahakkuk_plan;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=budget.list_tahakkuk&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=budget.list_tahakkuk&event=add&from_plan_list=1&tplan_id=#attributes.tplan_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=budget.list_tahakkuk";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.tplan_id#&print_type=331','page');";
			
			i = 0;			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.tplan_id#&action_table=TAHAKKUK_PLAN&process_cat='+upd_tahakkuk_plan.old_process_type.value,'page');";// Mahsup Fişi
			i = i + 1;
			
			if(len(get_tahakkuk_plan.paymethod_id)){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = "#getLang('invoice',324)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openVoucher();";
			}
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
<!--- Sevim Çelik --->