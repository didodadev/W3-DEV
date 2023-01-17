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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'cash.list_cashes';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/cash/display/list_cashes.cfm';
	
		if(isdefined("attributes.ID"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'cash.popup_upd_cash';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/cash/form/upd_cash.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/cash/query/upd_cash.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cash.list_cashes&event=upd&ID=';
			
			WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
			WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'upd_cash';
			WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_cash_detail';
			
			WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
			WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'kontrol() && validate().check()';
			WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
			WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteEvent'] = 'del';
			WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteFunction'] = '';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=cash.del_cash&id=#attributes.id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/cash/query/del_cash.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/cash/query/del_cash.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'cash.list_cashes';
		}
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'cash.form_add_cash';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/cash/form/add_cash.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/cash/query/add_cash.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'cash.list_cashes&event=upd&ID=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_cash';
		
		WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
		WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrol() && validate().check()';		
		
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=cash.list_cashes";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=cash.list_cashes&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=cash.list_cashes";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('','Uyarılar','57757')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['href'] = '#request.self#?fuseaction=objects.workflowpages&tab=3&action=myhome.my_extre&action_name=ID&action_id=#attributes.id#';

			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('','Yazdır','57474')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['href'] = '#request.self#?fuseaction=objects.popup_print_files&print_type=131&action_type=#attributes.id#&action_id=#attributes.id#';
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>

