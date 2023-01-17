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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ch.list_due_diff_actions';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/ch/display/list_due_diff_actions.cfm';
		
		if(isdefined("attributes.due_diff_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ch.form_upd_due_diff_action';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/ch/form/upd_due_diff_action.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/ch/form/upd_due_diff_action.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.due_diff_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=ch.emptypopup_del_due_diff_action&due_diff_id=##caller.attributes.due_diff_id##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/ch/query/del_due_diff_action.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/ch/query/del_due_diff_action.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ch.list_due_diff_actions';
		}
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ch.form_add_due_diff_action';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/ch/form/add_due_diff_action.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/ch/query/add_due_diff_action.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ch.list_due_diff_actions&event=add';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('add_due','add_due_row');";
		
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ch.list_due_diff_actions";
			
			
		}
		else if(caller.attributes.event is 'upd')
		{
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ch.list_due_diff_actions&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ch.list_due_diff_actions";
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CARI_DUE_DIFF_ACTIONS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'DUE_DIFF_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "";
</cfscript>
