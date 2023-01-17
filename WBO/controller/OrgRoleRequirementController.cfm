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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.list_position_req_type';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/hr/display/list_pos_req_type.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.add_pos_req_type';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/hr/form/add_pos_req_type.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/hr/query/add_pos_req_type.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_position_req_type&event=upd&req_type_id=';
		
		if(isdefined("attributes.req_type_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'hr.upd_pos_req_type';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/hr/form/upd_pos_req_type.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/hr/query/upd_pos_req_type.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.req_type_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_position_req_type&event=upd&req_type_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#request.self#?fuseaction=hr.emptypopup_del_pos_req_type&REQ_TYPE_ID=#attributes.REQ_TYPE_ID#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/hr/query/del_pos_req_type.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/hr/query/del_pos_req_type.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_position_req_type';
			
			WOStruct['#attributes.fuseaction#']['updChapter'] = structNew();
			WOStruct['#attributes.fuseaction#']['updChapter']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['updChapter']['fuseaction'] = 'hr.popup_form_upd_chapter';
			WOStruct['#attributes.fuseaction#']['updChapter']['filePath'] = 'V16/hr/form/form_upd_quiz_chapter.cfm';
			WOStruct['#attributes.fuseaction#']['updChapter']['queryPath'] = '/V16/hr/query/upd_quiz_chapter.cfm';
			WOStruct['#attributes.fuseaction#']['updChapter']['nextEvent'] = 'hr.list_position_req_type';
			
			WOStruct['#attributes.fuseaction#']['addChapter'] = structNew();
			WOStruct['#attributes.fuseaction#']['addChapter']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['addChapter']['fuseaction'] = 'hr.popup_form_add_chapter';
			WOStruct['#attributes.fuseaction#']['addChapter']['filePath'] = 'V16/hr/form/form_add_quiz_chapter.cfm';
			WOStruct['#attributes.fuseaction#']['addChapter']['queryPath'] = '/V16/hr/query/add_quiz_chapter.cfm';
			WOStruct['#attributes.fuseaction#']['addChapter']['nextEvent'] = 'hr.list_position_req_type';
			
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_position_req_type";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_position_req_type&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_position_req_type";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=hr.emptypopup_pos_req_type_copy&req_type_id=#attributes.req_type_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
			
			if (caller.GET_REQ_FILL.RECORDCOUNT eq 0)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('hr',763)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onclick'] = "windowopen('#request.self#?fuseaction=hr.list_position_req_type&event=addChapter&req_type_id=#attributes.req_type_id#','medium');";
			}
			
		}
		else if(caller.attributes.event is 'addChapter')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_position_req_type";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'updChapter')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_position_req_type";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'POSITION_REQ_TYPE';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'REQ_TYPE_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-REQ_TYPE']";

</cfscript>
