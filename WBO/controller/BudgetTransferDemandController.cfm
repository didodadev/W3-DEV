<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['list']					= structNew();
		WOStruct['#attributes.fuseaction#']['list']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'budget.budget_transfer_demand';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/V16/budget/display/BudgetTransferDemand.cfm';
	
		WOStruct['#attributes.fuseaction#']['add']					= structNew();
		WOStruct['#attributes.fuseaction#']['add']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'budget.budget_transfer_demand';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= '/V16/budget/form/add_budget_transfer_form.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath']		= '/V16/budget/query/add_budget_transfer_form.cfm';
        WOStruct['#attributes.fuseaction#']['add']['nextEvent']     = 'budget.budget_transfer_demand&event=upd&demand_id=';
		
		if(isdefined("attributes.demand_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd']					= structNew();
	  		WOStruct['#attributes.fuseaction#']['upd']['window']		= 'normal';
	  		WOStruct['#attributes.fuseaction#']['upd']['fuseaction']	= 'budget.budget_transfer_demand';
	  		WOStruct['#attributes.fuseaction#']['upd']['filePath']		= '/V16/budget/form/upd_budget_transfer_form.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath']		= '/V16/budget/query/upd_budget_transfer_form.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['Identity']		= '#attributes.demand_id#';
	  		WOStruct['#attributes.fuseaction#']['upd']['nextEvent']		= 'budget.budget_transfer_demand&event=upd&demand_id=';

			WOStruct['#attributes.fuseaction#']['del']					= structNew();
	  		WOStruct['#attributes.fuseaction#']['del']['window']		= 'emptypopup';
	  		WOStruct['#attributes.fuseaction#']['del']['fuseaction']	= 'budget.budget_transfer_demand';
	  		WOStruct['#attributes.fuseaction#']['del']['filePath']		= '/V16/budget/query/del_budget_transfer_form.cfm';
	  		WOStruct['#attributes.fuseaction#']['del']['queryPath']		= '/V16/budget/query/del_budget_transfer_form.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent']		= 'budget.budget_transfer_demand';
		}
	
	}
	else {
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();

		if(caller.attributes.event is 'add')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-dashboard']['text'] = '#getLang('','',60994)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-dashboard']['href']  = "#request.self#?fuseaction=report.budget_costrevenue_dashboard";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-dashboard']['target'] = "_blank";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	

			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=budget.budget_transfer_demand";
		}
		
		if(caller.attributes.event is 'upd')
		{
			get_control = caller.get_kontrol;
			if(get_control.is_transfer eq 1)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-random']['text'] = '#getLang('','',61328)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-random']['href'] = "#request.self#?fuseaction=budget.list_plan_rows&event=upd&budget_plan_id=#get_control.budget_plan_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-random']['target'] = "_blank";
			}
			else 
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-random']['text'] = '#getLang('','',61328)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-random']['href'] = "#request.self#?fuseaction=budget.list_plan_rows&event=add&demand_id=#attributes.demand_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-random']['target'] = "_blank";
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-dashboard']['text'] = '#getLang('','',60994)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-dashboard']['href']  = "#request.self#?fuseaction=report.budget_costrevenue_dashboard";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-dashboard']['target'] = "_blank";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=budget.budget_transfer_demand&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=budget.budget_transfer_demand";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=budget.budget_transfer_demand&action_name=demand_id&action_id=#attributes.demand_id#','Workflow')";
		}
		
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);		
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm']				= true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList']	= 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName']			= 'budget_transfer_demand';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn']		= 'DEMAND_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings']				= "['item-demand_stage','item-demand_date']";
</cfscript>