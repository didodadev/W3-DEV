<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.form_add_ship_open_fis';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/stock/form/form_stock_open_fis.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/stock/query/add_ship_open_fis.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.form_add_ship_open_fis&event=upd&upd_id=';
		WOStruct['#attributes.fuseaction#']['add']['js'] = 'javascript:gizle_goster_basket(add_ship_open_fis);';
		
		if(isdefined("attributes.upd_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.form_upd_open_fis';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/stock/form/form_upd_stock_open_fis.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/stock/query/upd_ship_open_fis.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.upd_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.form_add_ship_open_fis&event=upd&upd_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(stock_open_fis);";
			
			if(isdefined("attributes.event") and (attributes.event is "upd" or attributes.event is "del"))
			{
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=stock.emptypopup_upd_open_fis_process&upd_id=#attributes.upd_id#&del_id=#attributes.upd_id#&fis_number_=##caller.get_fis_det.fis_number##&fis_type=##caller.fis_type##';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/stock/query/upd_del_open_fis.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/stock/query/upd_del_open_fis.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'stock.list_purchase';
			}	
		}
	}
	else{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#attributes.fuseaction#'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
		
		
		if(caller.attributes.event is 'add')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['text'] = '#getLang('main',2758)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_from_file&from_where=6";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_purchase";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(attributes.event is 'upd')
		{
			get_fis_det = caller.get_fis_det;
			fis_type = caller.fis_type;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#getlang('main',345)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=stock.form_upd_open_fis&action_name=upd_id&action_id=#attributes.upd_id#','list');";
			
			if (session.ep.our_company_info.guaranty_followup)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#getlang('main',305)#-#getlang('main',306)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['href'] = "#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#get_fis_det.fis_number#&process_cat_id=#fis_type#&process_id=#get_fis_det.FIS_ID#";
			}
				
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#get_fis_det.FIS_ID#&print_type=31','page');";		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getlang('main',170)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=stock.form_add_ship_open_fis";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_purchase";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'STOCK_FIS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'FIS_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-fis_no_','item-location_in','item-deliver_date_frm','item-process_cat']";
</cfscript>
