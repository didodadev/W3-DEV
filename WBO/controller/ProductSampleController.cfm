
<cfscript>
    if (attributes.tabMenuController eq 0)
    {

        WOStruct = structNew();

        WOStruct['#attributes.fuseaction#'] = structNew();

        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        if (not isDefined('attributes.event'))
            attributes.event = WOStruct['#attributes.fuseaction#']['default'];
        WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.product_sample';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/product/display/list_product_sample.cfm';
    
        WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.product_sample';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/product/form/add_product_sample.cfm';
	
        if(isdefined("attributes.product_sample_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = '';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.product_sample';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/product/form/add_product_sample.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.product_sample&event=upd&product_sample_id=#attributes.product_sample_id#';
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
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.product_sample";

			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			GET_PRODUCT_SAMPLE = caller.GET_PRODUCT_SAMPLE;
			data_product_sample = caller.data_product_sample;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=product.product_sample&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
            tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.product_sample";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('','Kopyala',64001)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.product_sample&event=add&product_sample_id=#attributes.product_sample_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
			i = 0;
			
			

			if(isDefined("caller.GET_PRODUCT.product_id") and len(caller.get_product.product_id)){
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Ölçü ve Dağılım Tablosu',63452)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick']  = "openBoxDraggable('#request.self#?fuseaction=product.form_add_popup_sub_stock_code&pid=#caller.get_product.product_id#&pcode=#caller.get_product.product_code#&pcatid=#caller.data_product_sample.product_cat_id#&product_sample_id=#caller.data_product_sample.product_sample_id#&is_auto_barcode=1')";
			i++;
			}
			
			
			if(isDefined("caller.GET_PRODUCT_SAMPLE.opportunity_id") and len(GET_PRODUCT_SAMPLE.opportunity_id))
			{
				GET_PRODUCT_SAMPLE = caller.GET_PRODUCT_SAMPLE;
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','İlişkili',38161)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=sales.list_opportunity&event=det&opp_id=#GET_PRODUCT_SAMPLE.opportunity_id#&product_sample_id=#product_sample_id#";
			i++;
			}

			if(isDefined("caller.get_stock.recordcount") and caller.get_stock.recordcount)
			{

				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Import',52718)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick']  = "openBoxDraggable('#request.self#?fuseaction=product.design_data&product_sample_id=#attributes.product_sample_id#&main_product_id=#caller.sample_relation.PRODUCT_ID#&stock_id=#caller.get_stock.stock_id#')";
				i++;

				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Ağaç','58901')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#caller.get_stock.stock_id#";		
				i++;
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','maliyet',58258)# #getLang('','ve',57989)# #getLang('','tedarik planı',64058)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=prod.tree_purchase_plan&event=det&stock_id=#caller.get_stock.stock_id#&product_sample_id=#product_sample_id#";	
				i++;
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','','32064')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=product.product_quality&pid=#caller.sample_relation.PRODUCT_ID#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				i++;
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main','Yazdır',57474)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&product_sample_id=#product_Sample_id#','WOC');";
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
	
		
	}
</cfscript>