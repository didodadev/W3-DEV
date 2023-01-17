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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'mlm.promotions';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/product/display/list_mlm_proms.cfm';

	
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.form_add_detail_prom';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/product/form/form_add_detail_prom.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/product/query/add_detail_prom.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'mlm.promotions&event=upd&prom_id=';

		if(isdefined("attributes.prom_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.form_upd_detail_prom';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/product/form/form_upd_detail_prom.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/product/query/upd_detail_prom.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.prom_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'mlm.promotions&event=upd&prom_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=product.emptypopup_del_detail_prom&prom_id=##caller.get_prom.prom_id##&head=##caller.get_prom.prom_head##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/product/query/del_detail_prom.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/product/query/del_detail_prom.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'mlm.promotions';
			
		}
		if(attributes.event is 'add' or attributes.event is 'upd')
		{
			WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
			WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PROMOTIONS';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PROM_ID';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-prom_head','item-startdate','item-finishdate','item-condition_price_catid','item-control_date']";
		}
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		getLang = caller.getLang;
	
		if(isdefined("attributes.event") and attributes.event is 'add')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] =  '#getLang('','liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=mlm.promotions";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('','kaydet','57461')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			denied_pages = caller.denied_pages;
			is_conscat_premium = caller.is_conscat_premium;
			is_conscat_segmentation = caller.is_conscat_segmentation;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] =  '#getLang('','liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=mlm.promotions";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('','kaydet','57461')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('','ekle','57582')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=mlm.promotions&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = '_blank';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('','kopyala','57476')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=mlm.promotions&event=upd&prom_id=#attributes.prom_id#&is_copy=1";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = '_blank';
			
			i = 0;
			if(isdefined("is_conscat_segmentation") and is_conscat_segmentation eq 1){
                if(not listfindnocase(denied_pages,'product.popup_add_conscat_segmentation')){
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Kategori Segmentasyon Tanımları','37851')#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_add_conscat_segmentation&promotion_id=#attributes.prom_id#','list_horizantal')";
					i = i + 1;
				}
			}
            if(isdefined("is_conscat_premium") and is_conscat_premium eq 1){
                if(not listfindnocase(denied_pages,'product.popup_add_conscat_premium')){
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Kategori Prim Tanımları','37850')#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('windowopen('#request.self#?fuseaction=product.popup_add_conscat_premium&promotion_id=#attributes.prom_id#','horizantal')";
					i = i + 1;
				}
			}
		}		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
</cfscript>
