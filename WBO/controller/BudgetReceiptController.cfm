<cfsavecontent variable="veriaktarim"><cf_get_lang dictionary_id="60009.Veri Aktarım"></cfsavecontent>
	<cfsavecontent variable="Detay"><cf_get_lang dictionary_id="57771.Detay"></cfsavecontent>
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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'budget.list_plan_rows';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/budget/display/list_plan_rows.cfm';	
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'budget.add_budget_plan';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/budget/form/add_budget_plan.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/budget/query/add_budget_plan.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'budget.list_plan_rows&event=upd&budget_plan_id=';	
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('budget_plan','budget_plan_bask');";
		
		if(isdefined("attributes.budget_plan_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'budget.upd_budget_plan';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/budget/form/upd_budget_plan.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/budget/query/upd_budget_plan.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.budget_plan_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'budget.list_plan_rows&event=upd&budget_plan_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('budget_plan','budget_plan_bask');";

			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'budget.upd_budget_plan';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/budget/form/det_budget_plan.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.budget_plan_id#';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'budget.list_plan_rows&event=det&budget_plan_id=';
		}
		
		if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=budget.emptypopup_del_budget_plan&budget_plan_id=#attributes.budget_plan_id#&old_process_type=##caller.get_budget_plan.process_type##&budget_id=##caller.get_budget_plan.budget_id##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/budget/query/del_budget_plan.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/budget/query/del_budget_plan.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'budget.list_plan_rows';
		}

		WOStruct['#attributes.fuseaction#']['wizard'] = structNew();
		WOStruct['#attributes.fuseaction#']['wizard']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['wizard']['fuseaction'] = 'budget.list_plan_rows&event=wizard';
		WOStruct['#attributes.fuseaction#']['wizard']['filePath'] = 'V16/budget/display/plan_wizard.cfm';
		WOStruct['#attributes.fuseaction#']['wizard']['queryPath'] = 'V16/budget/query/plan_wizard.cfm';
		WOStruct['#attributes.fuseaction#']['wizard']['nextEvent'] = 'budget.list_plan_rows&event=wizard';
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'BUDGET_PLAN';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'BUDGET_PLAN_ID';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=budget.list_plan_rows";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-magic']['text'] = '#getLang('',4170)#';//Planlama Sihirbazı
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-magic']['onClick'] = "open_wizard()";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['download']['text'] = '#veriaktarim#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['download']['onClick'] = "open_file()";
			
		}
		else if(caller.attributes.event is 'upd')
		{
			get_budget_plan = caller.get_budget_plan;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=budget.list_plan_rows&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=budget.list_plan_rows&event=add&from_plan_list=1&budget_plan_id=#attributes.budget_plan_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=budget.list_plan_rows";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.budget_plan_id#&print_type=331','woc');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-magic']['text'] = '#getLang('',4170)#';//Planlama Sihirbazı
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-magic']['onClick'] = "open_wizard()";
	
			if(len(get_budget_plan.BUDGET_ID))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['MLM']['text'] = '#getLang('budget',29)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['MLM']['href'] = "#request.self#?fuseaction=budget.list_budgets&event=det&budget_id=#get_budget_plan.BUDGET_ID#";// Bütçe Detay
			} 
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['text'] = '#getLang('main',1040)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.budget_plan_id#&action_table=BUDGET_PLAN&process_cat='+upd_budget_plan.old_process_type.value,'page');";// Mahsup Fişi

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&event=upd&action_name=budget_plan_id&action_id=#attributes.budget_plan_id#&wrkflow=1','Workflow')";//Uyarılar

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['text'] = '#detay#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=budget.list_plan_rows&event=det&budget_plan_id=#attributes.budget_plan_id#";
		}
		else if(caller.attributes.event is 'det')
		{
			get_budget_plan = caller.get_budget_plan;

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=budget.list_plan_rows&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['copy']['href'] = "#request.self#?fuseaction=budget.list_plan_rows&event=add&from_plan_list=1&budget_plan_id=#attributes.budget_plan_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=budget.list_plan_rows";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.budget_plan_id#&print_type=331','woc');";
									
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getLang('main',52,'güncelle')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=budget.list_plan_rows&event=upd&budget_plan_id=#attributes.budget_plan_id#";

			if(len(get_budget_plan.BUDGET_ID))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['MLM']['text'] = '#getLang('budget',29)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['MLM']['href'] = "#request.self#?fuseaction=budget.list_budgets&event=det&budget_id=#get_budget_plan.BUDGET_ID#";// Bütçe Detay
			} 
			
			//tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-table']['text'] = '#getLang('main',1040)#';
			//tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-table']['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.budget_plan_id#&action_table=BUDGET_PLAN&process_cat='+upd_budget_plan.old_process_type.value,'page');";// Mahsup Fişi

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&event=upd&action_name=budget_plan_id&action_id=#attributes.budget_plan_id#&wrkflow=1','Workflow')";//Uyarılar
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>