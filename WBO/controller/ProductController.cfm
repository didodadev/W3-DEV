<cfsavecontent  variable="karma"><cf_get_lang dictionary_id='37467.Karma Koli'></cfsavecontent>

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
			WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_product';
			WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/product/display/list_product.cfm';
			
			WOStruct['#attributes.fuseaction#']['add'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.form_add_product';
			WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/product/form/form_add_product.cfm';
			WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/product/query/add_product.cfm';
			WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_product&event=det&pid=';
			
			
				if(isdefined("attributes.pid"))
			{
				WOStruct['#attributes.fuseaction#']['det'] = structNew();
				WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
				WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'product.form_upd_product';
				WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/product/display/detail_product.cfm';
				WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '/V16/product/query/upd_product.cfm';
				WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.pid#';
				WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'product.list_product&event=det&pid=';
			}
			
			
			WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
			WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
			WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrolProduct() && validate().check()';
			
			WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
			WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'list,add,upd,det';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PRODUCT';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PRODUCT_ID';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-product_name','item-product_cat','item-unit_id','item-product_code','item-tax_purchase','item-process_stage']";
		}
		else
		{
			fuseactController = caller.attributes.fuseaction;
			// Tab Menus //
			tabMenuStruct = StructNew();
			getLang = caller.getLang;
			
			tabMenuStruct['#fuseactController#'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
			// Upd //
			if(isdefined("caller.attributes.event") and caller.attributes.event is 'det')
			{
				
				get_product = caller.get_product;
				get_stock = caller.get_stock;
				
				tabMenuStruct['#fuseactController#']['tabMenus']['det'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'] = structNew();
				
				i = 0;
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('stock',390)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=stock.list_stock&event=det&pid=#attributes.pid#";
				i=i+1;
	
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',105)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=product.list_price_change&event=det&pid=#attributes.pid#";
				i=i+1;
	
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main','Maliyet',58258)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=product.list_product_cost&event=det&pid=#attributes.pid#";
				i = i + 1;
	
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',266)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=product.popup_product_contract&pid=#attributes.pid#')";
				i=i+1;
	
				
	
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main','Muhasebe ve Bütçe Kodları',59414)#' ;
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=product.popup_list_period&pid=#attributes.pid#','','ui-draggable-box-large');";
				i=i+1;
	
				if(get_product.is_production and get_stock.recordcount)
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',93)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#get_stock.stock_id#";		
					i = i + 1;
				}
	
				if(get_stock.recordcount and (get_product.is_production or get_product.is_prototype))
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main','Spekt',57647)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_spect_main&stock_id=#get_stock.stock_id#','page')";		
					i = i + 1;
				} 
	
				if(session.ep.our_company_info.workcube_sector is 'tersane')
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',47)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=product.form_add_relation_pbs&pid=#attributes.pid#','list')";
					i = i + 1;
				}
				
				if(get_stock.recordcount)
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',1003)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_related_trees&stock_id=#get_stock.stock_id#')";		
					i = i + 1;
				} 
					   
				
				if (get_product.is_karma)
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#karma#';
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=product.dsp_karma_contents&pid=#attributes.pid#";
					i = i + 1;
				}
				
				if (caller.get_product_properties_rec.recordCount)
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',397)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=product.popup_form_upd_product_dt_property&pid=#attributes.pid#&product_catid=#get_product.product_catid#','','ui-draggable-box-large');";
					i=i+1;
				}else {
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',397)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=product.popup_form_add_product_dt_property&pid=#attributes.pid#&product_catid=#get_product.product_catid#','','ui-draggable-box-large')";
					i=i+1;
				}
	
				
	
				
	
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',95)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=product.detail_product_place&pid=#get_product.product_id#&popup_page=1')";
				i=i+1;
	
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',655)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=product.product_quality&pid=#attributes.pid#";
				i=i+1;
	
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',435)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=product.popup_product_guaranty&pid=#attributes.pid#')";
				i=i+1;
	
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',245)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=report.product_action_search&pid=#attributes.pid#";
				i=i+1;
	
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',283)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=product.popup_view_product_comment&product_id=#attributes.pid#')";
				i=i+1;
	
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main','Anketler',57947)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=product.popup_list_product_surveys&product_id=#attributes.pid#')";
				i=i+1;
	
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',527)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=product.popup_form_add_product_companies&pid=#attributes.pid#')";
				i=i+1;
	
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = "#getLang('product',212)#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=product.list_product_actions&id=#attributes.pid#&&is_from_product=1";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
				i=i+1;
	
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('correspondence',117)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=product.popup_form_add_detail_product_general_parameters&pid=#attributes.pid#&barcod=#get_product.barcod#');";
				i=i+1;
	
				
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main','Ekle',57582)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(fuseactController,1,'.')#.list_product&event=add";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['target'] = "_blank";
	
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['copy']['text'] = '#getLang('main','Kopyala',57476)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['copy']['href'] = "#request.self#?fuseaction=#listgetat(fuseactController,1,'.')#.list_product&event=add&pid=#attributes.pid#";
	
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main','Yazdır',57474)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onclick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.pid#&print_type=371','WOC');";
	
				//Uyarılar
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('main','Uyarılar',57757)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['href'] = "#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=pid&action_id=#attributes.pid#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['target'] ="_blank";
				//Tarihçe
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-history']['text'] = '#getlang('main','Tarihçe',57473)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-history']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=product.popup_product_history&product_id=#attributes.pid#')";
				//Ekbilgi
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-info-circle']['text'] = '#getLang('main','Ek Bilgi',57810)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-info-circle']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&product_catid=#get_product.product_catid#&info_id=#attributes.pid#&type_id=-5','list')";
	
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_product";
	
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] = "buttonClickFunction()";
				tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
			}
			else if(caller.attributes.event is 'add')
			{	
				tabMenuStruct['#fuseactController#']['tabMenus']['add'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_product";
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
				tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
			}
		}
	</cfscript>
	