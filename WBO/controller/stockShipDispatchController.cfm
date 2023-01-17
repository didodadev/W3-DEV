<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();	
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch';
		WOStruct['#attributes.fuseaction#']['add']['XmlFuseaction'] = 'stock.upd_ship_dispatch';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/stock/form/add_dispatch_ship.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/stock/query/add_dispatch_ship.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.add_ship_dispatch&event=upd&ship_id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'form_basket';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(dispatch_ship);";
		
		if(isdefined("attributes.ship_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.upd_ship_dispatch';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/stock/form/upd_dispatch_ship.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/stock/query/upd_dispatch_ship.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.ship_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.add_ship_dispatch&event=upd&ship_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(d_ship);";
		}
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SHIP';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'SHIP_ID';
		
		
		if(isdefined("attributes.event") and (attributes.event is "upd" or attributes.event is "del"))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_dispatch_sale&active_period=#session.ep.period_id#&ship_id=#attributes.ship_id#&upd_id=#attributes.ship_id#&process_cat=##caller.get_upd_purchase.process_cat##&del_ship=1&ship_number=##caller.get_upd_purchase.ship_number##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/stock/query/upd_dispatch_ship.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/stock/query/upd_dispatch_ship.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_purchase';	
			WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'old_process_type';
		}
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		// Upd //
		getLang = caller.getLang;
		if(isdefined("attributes.event") and not(attributes.event is 'add' or attributes.event is 'list'))
		{
			control_ship_result = caller.control_ship_result;
			get_module_user = caller.get_module_user;
			get_upd_purchase = caller.get_upd_purchase;
			tabMenuStruct = StructNew();
			tabMenuStruct['#fuseactController#'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('main',1966)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['customTag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-24' module_id='13' action_section='SHIP_ID' action_id='#attributes.ship_id#'>";
			if(not control_ship_result.recordcount)
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['text'] = '#getLang('stock',500)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['onClick'] = "javascript:add_packetship.submit();";
				}
				else 
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['text'] = '#getLang('stock',500)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['onClick'] = "javascript:get_packetship();";
				}
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['text'] = '#getLang('stock',358)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_cost&id=#url.ship_id#&page_type=5&basket_id=#attributes.basket_id#','work');";
			
			
			transformations['#fuseactController#']['upd']['icons']['customTag'] = structNew();
			transformations['#fuseactController#']['upd']['icons']['customTag'] = "<cf_wrk_eshipment_display action_id='#attributes.ship_id#' action_type='SHIP_SEVK' action_date='#get_upd_purchase.ship_date#'>";
			

			i = 3;
			if(session.ep.our_company_info.guaranty_followup)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',305)#-#getLang('main',306)#';	
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_add_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#','list')";

				i = i + 1;
			}

			if(len(get_upd_purchase.dispatch_ship_id))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','İlişkili',49564)# #getLang('','Sevk Talebi',45525)#';	
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=stock.add_dispatch_internaldemand&event=upd&ship_id=#get_upd_purchase.dispatch_ship_id#";

				i = i + 1;
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch&ship_id=#attributes.ship_id#&is_ship_copy=1&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#attributes.ship_id#&print_type=30','WOC')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_purchase";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] ="window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=ship_id&action_id=#attributes.ship_id#&relation_papers_type=dispatch_ship&wrkflow=1','Workflow')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getLang('main',61)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] ="windowopen('#request.self#?fuseaction=objects.popup_list_ship_history&ship_id=#attributes.ship_id#','project','popup_list_ship_history')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-qrcode']['text'] = '#getLang('main',305)#-#getLang('main',306)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-qrcode']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#";

			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		else if (attributes.event is 'add')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['download']['text'] = '#getLang('','Veri Aktarım',60009)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['download']['onclick'] = "openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_from_file&from_where=1')";
		
		
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_purchase";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
			
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SHIP';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'SHIP_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['form_ul_process_cat','add_dispatch_ship','form_ul_ship_number','form_ul_ship_date','form_ul_deliver_date_frm','form_ul_txt_departman_','form_ul_location_in_id','form_ul_deliver_get']";
</cfscript>