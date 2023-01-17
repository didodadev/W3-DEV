<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ch.list_block_request';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/ch/display/list_block_request.cfm';
		
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ch.form_add_block_request';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/ch/form/add_block_request.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/ch/query/add_block_request.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ch.list_block_request&event=upd&block_id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_block_request';

		if(isdefined("attributes.block_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'ch.form_upd_block_request';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/ch/form/upd_block_request.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/ch/query/upd_block_request.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'ch.list_block_request&event=upd&block_id=';
			WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'block_id';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.block_id#';
			if(listFind('upd,del',attributes.event))
			{
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=ch.emptypopup_del_block_request&block_id=#attributes.block_id#';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/ch/query/del_block_request.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/ch/query/del_block_request.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'ch.list_block_request';
			}
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ch.list_block_request";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=ch.list_block_request&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=ch.list_block_request";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			if(caller.member_type is 'partner')
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = "#getLang('main',163)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=myhome.my_company_details&cpid=#caller.member_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['target'] = "_blank";
			}
			else
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = "#getLang('main',163)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=call.list_callcenter&event=det&cid=#caller.member_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['target'] = "_blank";
			}

		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,del';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'COMPANY_BLOCK_REQUEST';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'COMPANY_BLOCK_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-block_group','item-member_id','item-blocker_employee_id']";
	
</cfscript>

