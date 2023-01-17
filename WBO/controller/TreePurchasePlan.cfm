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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.tree_purchase_plan';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/production_plan/display/tree_purchase_plan.cfm';

        if(attributes.event eq 'det'){ 
            WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'prod.tree_purchase_plan';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/production_plan/display/tree_purchase_plan_det.cfm';
        }

	}else
	{
        if( isdefined("attributes.event") and attributes.event is 'det' ){

            fuseactController = caller.attributes.fuseaction;
            GET_PRODUCT_SAMPLE = caller.GET_PRODUCT_SAMPLE;
            getLang = caller.getLang;
            get_product = caller.get_product;
            get_module_user = caller.get_module_user;

            tabMenuStruct = StructNew();
            tabMenuStruct['#fuseactController#'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

            tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('','Liste',57509)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=prod.tree_purchase_plan";
            if(len(get_product.PRODUCT_SAMPLE_ID)){
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('','Numune Kopyala',64001)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=product.product_sample&event=add&product_sample_id=#attributes.product_sample_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
            }
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main','Yazdır',57474)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&product_sample_id=#product_Sample_id#&print_type=#368#','WOC');";
			
            i = 0;

            if(get_module_user(5)){
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',245)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=product.list_product&event=det&pid=#get_product.PRODUCT_ID#&sid=#attributes.stock_id#";
            }else{
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('prod',56)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_product.product_id#&sid=#attributes.stock_id#','page')";
            }
            i++;
            
            if(len(get_product.PRODUCT_SAMPLE_ID)){
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Numune',62603)#';
                tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=product.product_sample&event=upd&product_sample_id=#get_product.PRODUCT_SAMPLE_ID#";
                i++;
            }
            if(len(caller.GET_PRODUCT_SAMPLE.opportunity_id))
			{
				GET_PRODUCT_SAMPLE = caller.GET_PRODUCT_SAMPLE;
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','İlişkili',38161)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=sales.list_opportunity&event=det&opp_id=#GET_PRODUCT_SAMPLE.opportunity_id#&product_sample_id=#product_sample_id#";
			i++;
			}

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',40)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=stock.list_stock&event=det&pid=#get_product.product_id#";
            i++;
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','','32064')#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=product.product_quality&pid=#caller.sample_relation.PRODUCT_ID#";
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
            i++;
            
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Fiyatlama',63947)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=prod.tree_purchase_plan_pricing&product_sample_id=#get_product.PRODUCT_SAMPLE_ID#&stock_id=#attributes.stock_id#','','ui-draggable-box-large')";
            i++;

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',846)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=prod.product_tree_costs&stock_id=#attributes.stock_id#";
            i++;

            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Ağaç',58901)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#attributes.stock_id#";
            i++;
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Ölçü ve Dağılım Tablosu',63452)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick']  = "openBoxDraggable('#request.self#?fuseaction=product.form_add_popup_sub_stock_code&pid=#get_product.product_id#&pcode=#get_product.product_code#&pcatid=#get_product.product_cat_id#&product_sample_id=#get_product.PRODUCT_SAMPLE_ID#&is_auto_barcode=1')";
            i++;

            tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
        }
    }

</cfscript>