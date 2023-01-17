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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ch.list_law_request';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/ch/display/list_law_request.cfm';
	
		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ch.form_upd_law_request';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/ch/form/upd_law_request.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/ch/query/upd_law_request.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ch.list_law_request&event=upd&id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('upd_law');";
			
			/*WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=ch.emptypopup_upd_law_request&isDelete=1&id=#attributes.id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/ch/query/upd_law_request.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/ch/query/upd_law_request.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ch.list_law_request';*/
		}
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ch.form_add_law_request';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/ch/form/add_law_request.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/ch/query/add_law_request.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ch.list_law_request&event=upd&id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_law_request';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ch.list_law_request";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			get_note = caller.get_note;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ch.list_law_request&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ch.list_law_request";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			if(get_note.recordcount)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['text'] = "#getLang('main',1040)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['onclick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#get_note.action_id#&process_cat=#get_note.action_type_id#','page','emptypopup_upd_debit_claim_note');";
			}
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'COMPANY_LAW_REQUEST';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'LAW_REQUEST_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-member_name','item-file_number']";

</cfscript>