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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.list_headquarters';	
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/hr/display/list_headquarters.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'hr.form_add_headquarters';		
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/settings/query/add_headquarters.cfm';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_contract_cat';
		if(isdefined("attributes.hr"))
		{
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/hr/form/form_add_headquarters.cfm';
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'hr.list_headquarters&event=upd&head_id=&hr=1';
		}
		else
		{
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/settings/form/add_headquarters.cfm';
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.list_headquarters&event=upd&head_id=';
		}

		if(isdefined("attributes.head_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.form_upd_headquarters';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/settings/query/upd_headquarters.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.head_id#';
			if(isdefined("attributes.hr"))
			{
				WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/hr/form/form_upd_headquarters.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'hr.list_headquarters&event=upd&head_id=&hr=1';	
			}
			else
			{
				WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/settings/form/upd_headquarters.cfm';
				WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'settings.list_headquarters&event=upd&head_id=';
			}

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=settings.emptypopup_del_headquarters&is_hr=##caller.is_hr##&head_id=#attributes.head_id#&head=##caller.get_headquar.name##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/settings/query/del_headquarters.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/V16/settings/query/del_headquarters.cfm';
			if(isdefined("attributes.is_hr") and attributes.is_hr eq 1)
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'hr.list_headquarters&hr=1';
			else
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'settings.list_headquarters';

			WOStruct['#attributes.fuseaction#']['history'] = structNew();
			WOStruct['#attributes.fuseaction#']['history']['window'] = 'popup';
			WOStruct['#attributes.fuseaction#']['history']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.popup_headq_history';
			WOStruct['#attributes.fuseaction#']['history']['filePath'] = '/V16/#listgetat(attributes.fuseaction,1,'.')#/display/dsp_headq_history.cfm';
			
		}	
				
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SETUP_HEADQUARTERS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'HEADQUARTERS_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-name']";
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			if(isdefined("attributes.hr"))
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_headquarters&hr=1";
			else
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=settings.list_headquarters";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			if(isdefined("attributes.hr"))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_headquarters&event=add&hr=1";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=hr.list_headquarters&hr=1";
			}
			else
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=hr.list_headquarters&event=add&hr=1";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=settings.list_headquarters";
			}

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('main',61)#';
			if(isdefined("attributes.hr"))						
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=hr.list_headquarters&event=history&head_id=#attributes.head_id#&hr=1','large');";
			else
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=settings.list_headquarters&event=history&head_id=#attributes.head_id#','large');";
			
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>