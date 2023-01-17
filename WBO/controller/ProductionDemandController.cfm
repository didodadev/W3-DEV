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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.demands';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/production_plan/display/list_production_orders.cfm';	
		
		if(IsDefined("attributes.event") && attributes.event is 'upd')
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'prod.upd_prod_order';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/production_plan/form/upd_prod_order.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/production_plan/query/upd_production_order.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'upd=##attributes.upd##';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.upd##';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'prod.demands&event=upd&upd=';
		}
		
		if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=prod.emptypopup_del_production_order&p_order_id=##caller.get_det_po.p_order_id##&name=##caller.get_det_po.p_order_no##&PO_RELATED_ID=##caller.GET_DET_PO.PO_RELATED_ID##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/production_plan/query/del_production_order.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/production_plan/query/del_production_order.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'prod.demands';
		}
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.add_prod_order';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/production_plan/form/add_prod_order.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/production_plan/form/add_prod_order.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'prod.demands&event=upd&upd=';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('prod_order','prod_order_bask');";
		
		WOStruct['#attributes.fuseaction#']['multi-add'] = structNew();
		WOStruct['#attributes.fuseaction#']['multi-add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['multi-add']['fuseaction'] = 'prod.add_prod_order';
		WOStruct['#attributes.fuseaction#']['multi-add']['filePath'] = 'V16/production_plan/form/add_prod_order.cfm';
		WOStruct['#attributes.fuseaction#']['multi-add']['queryPath'] = '/V16/production_plan/query/add_production_order_all_sub.cfm';
		WOStruct['#attributes.fuseaction#']['multi-add']['nextEvent'] = 'prod.demands&event=list&is_submitted=1&keyword=';
		WOStruct['#attributes.fuseaction#']['multi-add']['js'] = "javascript:gizle_goster_ikili('prod_order','prod_order_bask');";
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=prod.demands";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "show_product_tree_info()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['text'] = '#getLang('prod',52)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['onClick'] = "open_product_tree(document.getElementById('stock_id').value);";
		}
		
		if(caller.attributes.event is 'multi-add')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['multi-add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['multi-add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['multi-add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['multi-add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=prod.demands";
			tabMenuStruct['#fuseactController#']['tabMenus']['multi-add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['multi-add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['multi-add']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['multi-add']['icons']['fa fa-download']['text'] = '#getLang('main',2576)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['multi-add']['icons']['fa fa-download']['onClick'] = "open_file();";
		}
		else if(caller.attributes.event is 'upd')
		{
			
			GET_DET_PO = caller.GET_DET_PO;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=prod.demands&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=prod.demands";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.upd#','page');";
			if(isdefined('is_demand'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=prod.order&event=multi-add&is_collacted=1&upd=#attributes.upd#";
			}
			if(not isdefined('is_demand'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#'; 
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=prod.order&event=add&upd=#attributes.upd#";
			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			i=0;
			if(len(GET_DET_PO.PO_RELATED_ID))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('prod',551)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=prod.order&event=upd&upd=#GET_DET_PO.PO_RELATED_ID#";	
				i=i+1;
			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=prod.form_upd_prod_order&action_name=upd&action_id=#attributes.upd#&relation_papers_type=P_ORDER_ID','list');";
			i = i+1;
			
			if(len(get_det_po.order_id))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('prod',71)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=prod.popup_list_prod_order&product_id=#get_det_po.product_id#&query_p_order_id=#attributes.upd#&order_no=#get_det_po.order_id#','page');";
				i = i+1;
			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',2252)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=prod.order&event=add&po_related_id=#attributes.upd#";
			i = i+1;
			
			if(len(get_det_po.quantity-get_det_po.result_amount gt 0 and not isdefined('is_demand')))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',1854)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=prod.add_prod_order_result&p_order_id=#attributes.upd#";
				i = i+1;
			}
			
			if(len(get_det_po.order_id))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('prod',51)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=prod.detail_order&order_id=#get_det_po.order_id#&order_row_id=#get_det_po.order_row_id#";
				i = i+1;
			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('prod',52)#'; 
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=prod.list_product_tree&event=add&stock_id=#get_det_po.stock_id#";
			i = i+1;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',2207)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=prod.popup_add_prod_order_asset&id=#attributes.upd#','list');";
			i = i+1;
			
			if(session.ep.our_company_info.guaranty_followup)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',306)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#URLEncodedFormat(get_det_po.p_order_no)#&process_id=#attributes.UPD#&process_cat_id=1194";
				i = i+1;
			}
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',61)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=prod.popup_list_production_order_history&upd=#attributes.upd#','large');";
			i = i+1;
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,multi-add';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'WORKSTATIONS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'STATION_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-product_name','item-quantity','item-start_date','item-finish_date']";	
</cfscript>