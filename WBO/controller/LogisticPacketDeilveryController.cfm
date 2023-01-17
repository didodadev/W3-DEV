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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.list_packetship';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/stock/display/list_packetship.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.form_add_packetship';
		WOStruct['#attributes.fuseaction#']['add']['xmlfuseaction'] = 'stock.popup_add_packetship';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/stock/form/add_packetship.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/stock/query/add_packetship.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.list_packetship&event=upd&ship_result_id=';
		

		
		if(isdefined("attributes.ship_result_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.list_packetship';
			WOStruct['#attributes.fuseaction#']['upd']['xmlfuseaction'] = 'stock.popup_add_packetship';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/stock/form/upd_packetship.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/stock/query/upd_packetship.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.ship_result_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.list_packetship&event=upd&ship_result_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=stock.emptypopup_del_packetship&multi_packet_ship=0&ship_result_id=#attributes.ship_result_id#&head=##caller.get_ship_result.ship_fis_no##&is_type=##caller.get_ship_result.is_type##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/stock/query/del_packetship.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/stock/query/del_packetship.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'stock.list_packetship';
		}
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SHIP_RESULT';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'SHIP_RESULT_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-company','item-member_name','item-ship_method_id','item-transport_comp_id','item-transport_no1','item-location_id']";
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		getLang = caller.getLang;
		
		if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=stock.list_packetship&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.ship_result_id#','list');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_packetship";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main','Uyarılar',57757)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_page_warnings&action=#listgetat(attributes.fuseaction,1,'.')#.form_upd_packetship&action_name=ship_result_id&action_id=#attributes.ship_result_id#&wrkflow=1','Workflow')";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('main','İlişkili Belge ve Notlar',29763)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['customtag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-24' module_id='13' action_section='SHIP_RESULT_ID' action_id='#attributes.ship_result_id#'>";
		}
		else
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_packetship";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
</cfscript>
