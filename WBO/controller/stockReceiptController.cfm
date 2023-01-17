<cfscript>
	if(attributes.tabMenuController eq 0)
	{
				// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		
		if(isdefined("attributes.upd_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.form_upd_fis';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/stock/form/form_upd_fis.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/stock/query/upd_fis.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.upd_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.form_add_fis&event=upd&upd_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(upd_fis)";
			
		}

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.form_add_fis';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/stock/form/form_add_fis.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/stock/query/add_ship_fis.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.form_add_fis&event=upd&upd_id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'form_basket';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(add_fis_process)";
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'upd_id';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'STOCK_FIS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['form_ul_fis_no_','form_ul_process_cat','form_ul_fis_date','form_ul_member_name']";
		
		if(isdefined("attributes.event") and (attributes.event is "upd" or attributes.event is "del"))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_fis_process&upd_id=#attributes.upd_id#&active_period=#session.ep.period_id#&del_fis=1';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/stock/query/upd_fis.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/stock/query/upd_fis.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_purchase';
			WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'process_cat&old_process_type&type_id&fis_no&cat';
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
			get_fis_det = caller.get_fis_det;
			CONTROL_DISPOSAL = caller.CONTROL_DISPOSAL;
			tabMenuStruct = StructNew();
			tabMenuStruct['#fuseactController#'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
	
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('main',1966)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['customTag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-24' module_id='13' action_section='FIS_ID' action_id='#url.upd_id#'>";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['text'] = '#getLang('main',623)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_upd_expensecenter_invoice&id=#GET_FIS_DET.FIS_ID#&is_stock_fis=1','horizantal')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['text'] = '#getLang('main',2577)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#upd_id#&process_cat='+form_basket.old_process_type.value,'page','form_upd_fis')";
			if(get_fis_det.fis_type eq 112){
				if(not control_disposal.recordcount)
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][3]['text'] = '#getLang('main',2586)#';//ek bilgi
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_add_disposal_report&action_id=#upd_id#','page','workcube_print')";
				}
				else if(control_disposal.recordcount)
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][3]['text'] = '#getLang('main',2586)#';//ek bilgi
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_add_disposal_report&action_id=#upd_id#','page','workcube_print')";
				}
				if(session.ep.our_company_info.guaranty_followup)
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][4]['text'] = '#getLang('main',305)#-#getLang('main',306)#';//ek bilgi
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][4]['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations&is_filtre=1&belge_no=#get_fis_det.fis_number#&process_cat_id=#get_fis_det.fis_type#&process_id=#url.upd_id#";
				}
	
			}
			else
			{
				if(session.ep.our_company_info.guaranty_followup)
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][3]['text'] = '#getLang('main',305)#-#getLang('main',306)#';//ek bilgi
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][3]['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations&is_filtre=1&belge_no=#get_fis_det.fis_number#&process_cat_id=#get_fis_det.fis_type#&process_id=#url.upd_id#";
				}
			}

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_purchase";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=stock.form_upd_fis&action_name=upd_id&action_id=#attributes.upd_id#&wrkflow=1','Workflow')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=stock.form_add_fis&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=stock.form_add_fis&event=add&upd_id=#url.upd_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#attributes.upd_id#','WOC')";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
			}
			else if(attributes.event is 'add')
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['add'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['download']['text'] = '#getLang('Veri Aktarım','Veri Aktarım',60009)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['download']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_from_file&from_where=4')";
				
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_purchase";
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
				
				tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		
	}
</cfscript>
