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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_catalog_promotion';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/product/display/list_catalog_promotion.cfm';	
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.form_add_catalog_promotion';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/product/form/add_catalog_promotion.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/product/query/add_catalog_promotion.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_catalog_promotion&event=upd';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('detail_catalog','detail_catalog_sepet');";
		
		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.form_upd_catalog_promotion';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/product/form/detail_catalog_promotion.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/product/query/upd_catalog_promotion.cfm';			
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_catalog_promotion&event=upd&id=';
			WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('detail_catalog','detail_catalog_basket');";
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=product.emptypopup_del_catalog_promotion&id=#attributes.id#&del_cat=#attributes.id#&module_name=##caller.module_name##&head=##caller.get_catalog_detail.cat_prom_no##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/product/query/del_catalog_promotion.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/product/query/del_catalog_promotion.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'product.list_catalog_promotion';
			
		}
	}
	else
	{
		getLang = caller.getLang;
		
		if(attributes.event is 'upd')
		{
			X_ACTIVE_FOR_BARCODE_FILE =caller.X_ACTIVE_FOR_BARCODE_FILE;
			get_catalog_detail = caller.get_catalog_detail;
			page_code = caller.page_code;
			DENIED_PAGES = caller.DENIED_PAGES;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			
					
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#getlang('','Stok Hareketleri',242)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=product.popup_list_action_condition_product_stocks&catalog_promotion_id=#attributes.id#');";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#getlang('product',455)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=product.popup_list_catalog_promotion_pluses&catalog_promotion_id=#attributes.id#');";
			
			
				
			i= 2;
			if(get_catalog_detail.is_applied neq 1)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('','Fiyatları Oluştur',64137)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=product.popup_cat_prom_actions&catalog_id=#get_catalog_detail.catalog_id#')";
				i = i + 1;
			}
			if(isdefined("is_conscat_segmentation") and is_conscat_segmentation eq 1)
			{
				if(not listfindnocase(denied_pages,'product.popup_add_conscat_segmentation'))
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('product',839)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_add_conscat_segmentation&catalog_id=#get_catalog_detail.catalog_id#','list_horizantal')";
					i = i + 1;
				}
			}
			if(isdefined("is_conscat_premium") and is_conscat_premium eq 1)
			{
				if(not listfindnocase(denied_pages,'product.popup_add_conscat_premium'))
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('product',838)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_add_conscat_premium&catalog_id=#get_catalog_detail.catalog_id#','horizantal')";
					i = i + 1;
				}
			}
			
		
			if(not listfindnocase(denied_pages,'product.popup_form_add_copy_catalog_prom'))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('product',825)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=product.popup_form_add_copy_catalog_prom&id=#get_catalog_detail.catalog_id#')";
				i = i + 1;
			}
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = "#getLang('main',62)#";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files#page_code#&action=product.list_catalog_promotion','page');";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getlang('main',61)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=product.popup_catalog_promotion_history&catalog_id=#attributes.id#')";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-barcode']['text'] = '#getlang('product',841)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-barcode']['href'] = "#request.self#?fuseaction=objects.emptypopup_save_action_barcodes&catalog_id=#attributes.id#&x_active_for_barcode_file=#x_active_for_barcode_file#";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=id&action_id=#attributes.id#&wrkflow=1','Workflow')";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = "#getLang('main',64)#";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=product.list_catalog_promotion&event=add&id=#get_catalog_detail.catalog_id#";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getlang('main',170)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=product.list_catalog_promotion&event=add";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_catalog_promotion";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";	
		}
		else if (attributes.event is 'add')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_catalog_promotion";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
			
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);		
	}
</cfscript>