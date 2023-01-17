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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction']	= 'myhome.health_expense_approve';
		WOStruct['#attributes.fuseaction#']['list']['filePath']		= '/V16/myhome/display/list_health_expense.cfm';	
		WOStruct['#attributes.fuseaction#']['list']['queryPath']	= '/V16/myhome/display/list_health_expense.cfm';	
	
		WOStruct['#attributes.fuseaction#']['add']					= structNew();
		WOStruct['#attributes.fuseaction#']['add']['window']		= 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction']	= 'myhome.health_expense_approve';
		WOStruct['#attributes.fuseaction#']['add']['filePath']		= '/V16/myhome/form/add_health_expense_form.cfm';
        WOStruct['#attributes.fuseaction#']['add']['queryPath']		= '/V16/myhome/query/add_health_expense_form.cfm';
		WOStruct['#attributes.fuseaction#']['add']['Xmlfuseaction']	= 'myhome.health_expense_form';
		
		if(isdefined("attributes.health_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd']					= structNew();
	  		WOStruct['#attributes.fuseaction#']['upd']['window']		= 'normal';
	  		WOStruct['#attributes.fuseaction#']['upd']['fuseaction']	= 'myhome.health_expense_approve';
	  		WOStruct['#attributes.fuseaction#']['upd']['filePath']		= '/V16/myhome/form/upd_health_expense_form.cfm';
	  		WOStruct['#attributes.fuseaction#']['upd']['queryPath']		= '/V16/myhome/query/upd_health_expense_form.cfm';
	  		WOStruct['#attributes.fuseaction#']['upd']['nextEvent']		= 'myhome.upd_health_expense_form&event=upd';

	  		if (ListFirst(attributes.fuseaction,'.') eq 'myhome'){
				WOStruct['#attributes.fuseaction#']['upd']['Identity']		= '#contentEncryptingandDecodingAES(isEncode:0,content:attributes.health_id,accountKey:'wrk')#'; 
			}
			else{
				WOStruct['#attributes.fuseaction#']['upd']['Identity']		= '#attributes.health_id#';
			}

			WOStruct['#attributes.fuseaction#']['del']					= structNew();
	  		WOStruct['#attributes.fuseaction#']['del']['window']		= 'emptypopup';
	  		WOStruct['#attributes.fuseaction#']['del']['fuseaction']	= 'myhome.health_expense_approve';
	  		WOStruct['#attributes.fuseaction#']['del']['filePath']		= '/V16/myhome/query/upd_health_expense_form.cfm';
	  		WOStruct['#attributes.fuseaction#']['del']['queryPath']		= '/V16/myhome/query/upd_health_expense_form.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent']		= 'myhome.upd_health_expense_form&event=upd';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	

			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=myhome.health_expense_approve";
		}
		
		if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=myhome.health_expense_approve&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.health_id#&print_type=489','page');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=myhome.health_expense_approve";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=myhome.health_expense_approve&action_name=health_id&action_id=#attributes.health_id#','Workflow')";
		}
		
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);		
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm']				= true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList']	= 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName']			= 'EXPENSE_ITEM_PLAN_REQUESTS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn']		= 'EXPENSE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings']				= "['item-expense_stage','item-expense_date']";
</cfscript>