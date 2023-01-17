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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'textile.order';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'WBP/Fashion/files/production/display/list_production_orders_grup.cfm';	
		
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'textile.order';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'WBP/Fashion/files/production/form/upd_prod_order.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'WBP/Fashion/files/production/query/upd_production_order.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'party_id=##attributes.party_id##';
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.party_id##';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'textile.order&event=upd&party_id=';

		WOStruct['#attributes.fuseaction#']['updquery'] = structNew();
		WOStruct['#attributes.fuseaction#']['updquery']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['updquery']['fuseaction'] = 'textile.order';
		WOStruct['#attributes.fuseaction#']['updquery']['filePath'] = 'WBP/Fashion/files/production/query/upd_production_order.cfm';
		WOStruct['#attributes.fuseaction#']['updquery']['queryPath'] = 'WBP/Fashion/files/production/query/upd_production_order.cfm';
		WOStruct['#attributes.fuseaction#']['updquery']['parameters'] = 'party_id=##attributes.party_id##';
		WOStruct['#attributes.fuseaction#']['updquery']['Identity'] = '##attributes.party_id##';
		WOStruct['#attributes.fuseaction#']['updquery']['nextEvent'] = 'textile.order&event=upd&party_id=';
				
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.add_prod_order';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/production_plan/form/add_prod_order.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/production_plan/form/add_prod_order.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'prod.order&event=upd&upd=';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('prod_order','prod_order_bask');";
		
		WOStruct['#attributes.fuseaction#']['multi-add'] = structNew();
		WOStruct['#attributes.fuseaction#']['multi-add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['multi-add']['fuseaction'] = 'prod.add_prod_order';
		WOStruct['#attributes.fuseaction#']['multi-add']['filePath'] = 'V16/production_plan/form/add_prod_order.cfm';
		WOStruct['#attributes.fuseaction#']['multi-add']['queryPath'] = '/V16/production_plan/query/add_production_order_all_sub.cfm';
		WOStruct['#attributes.fuseaction#']['multi-add']['nextEvent'] = 'prod.order&event=list&is_submitted=1&keyword=';
		WOStruct['#attributes.fuseaction#']['multi-add']['js'] = "javascript:gizle_goster_ikili('prod_order','prod_order_bask');";
		
		if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=textile.emptypopup_del_production_order_tex&p_order_id=##caller.get_det_po.p_order_id##&name=##caller.get_det_po.p_order_no##&PO_RELATED_ID=##caller.GET_DET_PO.PO_RELATED_ID##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'WBP/Fashion/files/production/query/del_production_order.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'WBP/Fashion/files/production/query/del_production_order.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'textile.order';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=prod.order_tex";
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
			tabMenuStruct['#fuseactController#']['tabMenus']['multi-add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=prod.order_tex";
			tabMenuStruct['#fuseactController#']['tabMenus']['multi-add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['multi-add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['multi-add']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['multi-add']['menus'][0]['text'] = '#getLang('main',2576)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['multi-add']['menus'][0]['onClick'] = "open_file();";
		}
		else if(caller.attributes.event is 'upd')
		{
			
			GET_DET_PO = caller.GET_DET_PO;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			/*tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=prod.order_tex&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";*/
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=textile.order";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.party_id#&print_type=281','page');";
	
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			i=0;
			
	
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,multi-add';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'WORKSTATIONS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'STATION_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-product_name','item-quantity','item-start_date','item-finish_date']";
</cfscript>