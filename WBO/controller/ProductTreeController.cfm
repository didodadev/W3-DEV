<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.list_product_tree';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/production_plan/display/list_product_tree.cfm';

		if(attributes.event eq 'upd'){
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'prod.add_product_tree';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/production_plan/display/add_product_tree.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/production_plan/query/add_sub_product.cfm';

			if(isdefined('attributes.stock_id'))
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.stock_id#';
			else if(isdefined('attributes.main_stock_id'))
				WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.main_stock_id#';

			if(isdefined('attributes.operation_main_stock_id')){
				if(isdefined('attributes.PRODUCT_TREE_ID') and len(attributes.PRODUCT_TREE_ID))
					WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'prod.list_product_tree&event=upd&product_tree_id=#attributes.PRODUCT_TREE_ID#&main_stock_id=#attributes.operation_main_stock_id#&';
				else
					WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'prod.list_product_tree&event=upd&main_stock_id=#attributes.operation_main_stock_id#&stock_id=';
			}else{
				if(isdefined('attributes.PRODUCT_TREE_ID') and len(attributes.PRODUCT_TREE_ID))
					WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'prod.list_product_tree&event=upd&product_tree_id=#attributes.PRODUCT_TREE_ID#&';
				else
					WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'prod.list_product_tree&event=upd&stock_id=';
			}
		}

		if(attributes.event eq 'det'){
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'prod.add_product_tree';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/production_plan/display/det_product_tree.cfm';
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
		if(isdefined("attributes.event") and not(attributes.event is 'add' or attributes.event is 'list' or attributes.event is 'det'))
		{
			if(attributes.stock_id gt 0)
			{
				getLang = caller.getLang;
				get_product = caller.get_product;
				get_module_user = caller.get_module_user;
				get_product_conf = caller.get_product_conf;
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = "#getLang('main',61)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=prod.popup_product_tree_history&stock_id=#attributes.stock_id#')";
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('','Liste',57509)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=prod.list_product_tree";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";

				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('main',345)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onclick'] =  "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=product_id&action_id=#get_product.product_id#','Workflow')";

				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['text'] = '#getLang('','Detay',57771)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=prod.list_product_tree&event=det&product_id=#get_product.product_id#&stock_id=#attributes.stock_id#";

				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] =  '#getLang('main',62)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] ="window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#attributes.stock_id#&print_type=371','WOC');";

				if(get_module_user(5)){
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('main',245)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=product.list_product&event=det&pid=#get_product.PRODUCT_ID#&sid=#attributes.stock_id#";
				}else{
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('prod',56)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_product.product_id#&sid=#attributes.stock_id#','page')";
				}

				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['text'] = '#getLang('main',40)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['href'] = "#request.self#?fuseaction=stock.list_stock&event=det&pid=#get_product.product_id#";

				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['text'] = "#getLang('main',235)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_spect_main&stock_id=#attributes.stock_id#','page')";
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][3]['text'] = '#getLang('prod',337)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][3]['href'] = "#request.self#?fuseaction=product.product_quality&pid=#get_product.product_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][3]['target'] = "_blank";
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][4]['text'] = '#getLang('main',305)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_product_guaranty&pid=#get_product.product_id#','medium')";
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][5]['text'] = '#getLang('main',846)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][5]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=prod.product_tree_costs&stock_id=#attributes.stock_id#')";
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.stock_id#&type_id=-6','list')";
			
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][6]['text'] = '#getLang('prod',519)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][6]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_related_trees&stock_id=#attributes.stock_id#','project')";
				if (len(get_product.product_sample_id)){
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][7]['text'] = '#getLang('','Tedarik',63564)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][7]['href'] = "#request.self#?fuseaction=prod.tree_purchase_plan&event=det&stock_id=#attributes.stock_id#&product_sample_id=#get_product.product_sample_id#";
				}
				

				if(get_product_conf.recordcount){
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][6]['text'] = '#getLang('prod',57)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][6]['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_upd_product_configuration&id=#get_product_conf.PRODUCT_CONFIGURATOR_ID#','longpage')";
				}
	
				tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
			}
		}else if( isDefined("attributes.event") and attributes.event is 'det' ){
			if(attributes.stock_id gt 0){
				getLang = caller.getLang;
				get_product = caller.get_product;
				get_module_user = caller.get_module_user;
				get_product_conf = caller.get_product_conf;

				tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = "#getLang('main',61)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] = "windowopen('#request.self#?fuseaction=prod.popup_product_tree_history&stock_id=#attributes.stock_id#','medium','popup_member_history')";
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('','Liste',57509)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=prod.list_product_tree";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";

				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('main',345)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onclick'] =  "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=product_id&action_id=#get_product.product_id#','Workflow')";

				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-pencil']['text'] = '#getLang('main',52)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=prod.list_product_tree&event=upd&product_id=#attributes.product_id#&stock_id=#attributes.stock_id#";

				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] =  '#getLang('main',62)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] ="window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#attributes.stock_id#&print_type=91','WOC');";
				
				if(get_module_user(5)){
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('main',245)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=product.list_product&event=det&pid=#get_product.PRODUCT_ID#&sid=#attributes.stock_id#";
				}else{
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('prod',56)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_product.product_id#&sid=#attributes.stock_id#','page')";
				}

				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['text'] = '#getLang('main',40)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['href'] = "#request.self#?fuseaction=stock.list_stock&event=det&pid=#get_product.product_id#";

				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['text'] = "#getLang('main',235)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_spect_main&stock_id=#attributes.stock_id#','page')";
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][3]['text'] = '#getLang('prod',337)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][3]['href'] = "#request.self#?fuseaction=product.product_quality&pid=#get_product.product_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][3]['target'] = "_blank";
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][4]['text'] = '#getLang('main',305)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_product_guaranty&pid=#get_product.product_id#','medium')";
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][5]['text'] = '#getLang('main',846)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][5]['href'] = "#request.self#?fuseaction=prod.product_tree_costs&stock_id=#attributes.stock_id#";
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.stock_id#&type_id=-6','list')";
			
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][6]['text'] = '#getLang('prod',519)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][6]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_related_trees&stock_id=#attributes.stock_id#','project')";

				
				

				tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
			}
		}
	}
</cfscript>