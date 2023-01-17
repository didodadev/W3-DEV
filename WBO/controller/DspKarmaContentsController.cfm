<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'upd';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.dsp_karma_contents';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/product/display/dsp_karma_contents.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/product/query/upd_karma_contents.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.pid#';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.dsp_karma_contents&pid=';
	
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(isdefined("caller.attributes.event") and caller.attributes.event is 'upd')
		{	
			
			get_product = caller.get_product;
			get_stock = caller.GET_KARMA_PRODUCT;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'] = structNew();
			
			i = 0;
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('stock',390)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=stock.list_stock&event=det&pid=#attributes.pid#";
			i=i+1;

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',105)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=product.list_price_change&event=det&pid=#attributes.pid#";
			i=i+1;

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main',846)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=product.list_product_cost&event=det&pid=#attributes.pid#";
			i = i + 1;

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',266)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=product.popup_product_contract&pid=#attributes.pid#','wide')";
			i=i+1;

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main',3665)#' ;
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=product.popup_list_period&pid=#attributes.pid#');";
			i=i+1;

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',435)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=product.popup_product_guaranty&pid=#attributes.pid#','longpage')";
			i=i+1;

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getlang('main',1352)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=product.list_product&event=det&pid=#attributes.pid#";
			i=i+1;

			if(get_product.is_production and get_stock.recordcount)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',93)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#get_stock.stock_id#";		
				i = i + 1;
			}

			if(session.ep.our_company_info.workcube_sector is 'tersane')
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('product',47)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=product.form_add_relation_pbs&pid=#attributes.pid#','list')";
				i = i + 1;
			}

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onclick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.pid#','WOC');";

			//Uyarılar
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['href'] = "#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=pid&action_id=#attributes.pid#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['target'] ="_blank";
			//Tarihçe
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-history']['text'] = '#getlang('main',61)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-history']['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_product_history&product_id=#attributes.pid#','list','popup_member_history')";
			//Ekbilgi
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-info-circle']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&product_catid=#get_product.product_catid#&info_id=#attributes.pid#&type_id=-5','list')";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuData = SerializeJSON(tabMenuStruct['#fuseactController#']['tabMenus']);
		}
		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
</cfscript>