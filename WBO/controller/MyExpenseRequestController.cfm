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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_my_expense_requests';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/myhome/display/list_my_expense_requests.cfm';
		
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.form_add_expense_plan_request';
		WOStruct['#attributes.fuseaction#']['add']['Xmlfuseaction'] = 'objects.expense_request';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/objects/form/form_add_expense_plan_request.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/objects/query/add_expense_plan_request.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'myhome.list_my_expense_requests&event=upd&request_id=';	
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('expense_plan_request','expense_plan_request_bask');";
		
		if(isdefined("attributes.request_id") and listfind('upd,del',attributes.event))
		{
			if(attributes.event is 'upd')
			{
				WOStruct['#attributes.fuseaction#']['upd'] = structNew();
				WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
				WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'myhome.form_upd_expense_plan_request';
				WOStruct['#attributes.fuseaction#']['upd']['Xmlfuseaction'] = 'objects.expense_request';
				WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/objects/form/form_upd_expense_plan_request.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/objects/query/upd_expense_plan_request.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#contentEncryptingandDecodingAES(isEncode:0,content:request_id,accountKey:'wrk')#';
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'myhome.list_my_expense_requests&event=upd&request_id=';
				WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('upd_expense','upd_expense_bask');";
			}
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			if(attributes.event is 'del')
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=objects.del_expense_plan_request&cost_type=1&request_id=##caller.contentEncryptingandDecodingAES(isEncode:0,content:attributes.request_id,accountKey:"wrk")##';
			else
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=objects.del_expense_plan_request&request_id=#contentEncryptingandDecodingAES(isEncode:0,content:attributes.request_id,accountKey:'wrk')#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/objects/query/del_expense_plan_request.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/objects/query/del_expense_plan_request.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'myhome.list_my_expense_requests';
		}
	}
	else{
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=myhome.list_my_expense_requests";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=myhome.list_my_expense_requests&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=myhome.list_my_expense_requests";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=myhome.list_my_expense_requests&action_name=request_id&action_id=#attributes.request_id#','Workflow')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=myhome.list_my_expense_requests&event=add&request_id=#attributes.request_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onclick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#attributes.request_id#','WOC');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['history']['text'] = '#getlang('main',61)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['history']['customTag'] = "<cf_wrk_history act_type='6' act_id='#attributes.request_id#' boxwidth='600' boxheight='500'>";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['archive']['text'] = '#getlang('main',1966)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['archive']['customtag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='49' action_section='REQUEST_ID' action_id='#attributes.request_id#'>"; 
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'EXPENSE_ITEM_PLAN_REQUESTS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'EXPENSE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-expense_stage','item-expense_date']";
</cfscript>