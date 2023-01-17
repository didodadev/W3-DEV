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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_promotions';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/product/display/list_proms.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.form_add_prom';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/product/form/add_prom.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/product/query/add_prom.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_promotions&event=upd&prom_id=';

		if(isdefined("attributes.prom_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'budget.popup_upd_budget';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/product/form/upd_prom.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/product/query/upd_prom.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.prom_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_promotions&event=upd&prom_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=product.emptypopup_del_prom&prom_id=##caller.get_prom.prom_id##&head=##caller.get_prom.prom_head##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/product/query/del_prom.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/product/query/del_prom.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'product.list_promotions';
			
		}
		
		WOStruct['#attributes.fuseaction#']['addCollacted'] = structNew();
		WOStruct['#attributes.fuseaction#']['addCollacted']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['addCollacted']['fuseaction'] = 'product.form_add_collacted_prom';
		WOStruct['#attributes.fuseaction#']['addCollacted']['filePath'] = 'V16/product/form/add_collacted_prom.cfm';
		WOStruct['#attributes.fuseaction#']['addCollacted']['queryPath'] = 'V16/product/query/add_collacted_prom.cfm';
		WOStruct['#attributes.fuseaction#']['addCollacted']['nextEvent'] = 'product.list_promotions&event=updCollacted&prom_rel_id=';
		WOStruct['#attributes.fuseaction#']['addCollacted']['js'] = "javascript:gizle_goster_ikili('collected_prom_','collected_prom_bask_');";

		if(isdefined("attributes.prom_rel_id"))
		{
			WOStruct['#attributes.fuseaction#']['updCollacted'] = structNew();
			WOStruct['#attributes.fuseaction#']['updCollacted']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['updCollacted']['fuseaction'] = 'product.form_upd_collacted_prom';
			WOStruct['#attributes.fuseaction#']['updCollacted']['filePath'] = 'V16/product/form/upd_collacted_prom.cfm';
			WOStruct['#attributes.fuseaction#']['updCollacted']['queryPath'] = 'V16/product/query/upd_collacted_prom.cfm';
			WOStruct['#attributes.fuseaction#']['updCollacted']['Identity'] = '#attributes.prom_rel_id#';
			WOStruct['#attributes.fuseaction#']['updCollacted']['nextEvent'] = 'product.list_promotions&event=updCollacted&prom_rel_id=';
			WOStruct['#attributes.fuseaction#']['updCollacted']['js'] = "javascript:gizle_goster_ikili('cellacted_prom_','cellacted_prom_bask_');";
			
			WOStruct['#attributes.fuseaction#']['delCollacted'] = structNew();
			WOStruct['#attributes.fuseaction#']['delCollacted']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['delCollacted']['fuseaction'] = '#request.self#?fuseaction=product.emptypopup_del_collacted_prom&prom_rel_id=#attributes.prom_rel_id#';
			WOStruct['#attributes.fuseaction#']['delCollacted']['filePath'] = 'V16/product/query/del_collacted_prom.cfm';
			WOStruct['#attributes.fuseaction#']['delCollacted']['queryPath'] = 'V16/product/query/del_collacted_prom.cfm';
			WOStruct['#attributes.fuseaction#']['delCollacted']['nextEvent'] = 'product.list_promotions';
		}
		
		
		
		if(attributes.event is 'add' or attributes.event is 'upd')
		{
			WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
			WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PROMOTIONS';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PROM_ID';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-limit_type','item-prom_head','item-startdate','item-finishdate','item-price_catid']";
		}
		else if(attributes.event is 'addCollacted' or attributes.event is 'updCollacted')
		{
			WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
			WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'addCollacted,updCollacted';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PROMOTIONS';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PROM_ID';
			WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process']";
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_promotions";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('','kaydet','57461')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			if(isDefined("attributes.stock_id")){
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'] = structNew();
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['text'] = '#getLang('','Satınalma Koşulları','37478')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][0]['onClick'] = "sayfa_ac('1')";
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][1]['text'] = '#getLang('','maliyet','58258')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['add']['menus'][1]['onClick'] = "sayfa_ac('2')";

			}
		}
		// Upd //
		else if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			denied_pages = caller.denied_pages;
			is_conscat_segmentation = caller.is_conscat_segmentation;
			is_conscat_premium = caller.is_conscat_premium;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('','ekle','57582')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=product.list_promotions&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = '_blank';

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('','ekle','57461')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] =  '#getLang('','liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_promotions";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = '_blank';
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('','kopyala','57476')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=product.list_promotions&event=add&prom_id=#attributes.prom_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = '_blank';
			
			i = 0;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','','37590')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=product.popup_list_promotions_invoice&prom_id=#attributes.prom_id#');";
			i = i + 1;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Satınalma Koşulları','37478')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "sayfa_ac('1')";
			i = i + 1;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('','uyarılar','57757')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['href'] = "#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=prom_id&action_id=#attributes.prom_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['target'] ="_blank";

			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getLang('','','37504')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['onclick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_detail_promotion_history&prom_id=#attributes.prom_id#');";
			
			/* if(isdefined("is_conscat_segmentation") and is_conscat_segmentation eq 1)
			{
				if(not listfindnocase(denied_pages,'product.popup_add_conscat_segmentation')){ 
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Kategori Segmentasyon Tanımları','37851')#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=product.popup_add_conscat_segmentation&promotion_id=#attributes.prom_id#','list_horizantal')";
					i = i + 1;
				}
			} 
			 if(isdefined("is_conscat_premium") and is_conscat_premium eq 1){
				if(not listfindnocase(denied_pages,'product.popup_add_conscat_premium')){ 
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Kategori Prim Tanımları','37850')#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "openBoxDraggable('#request.self#?fuseaction=product.popup_add_conscat_premium&promotion_id=#attributes.prom_id#','horizantal')";
					i = i + 1;
				}
			} */ 
			
		}
		else if(isdefined("attributes.event") and attributes.event is 'addCollacted')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['addCollacted']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['addCollacted']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['addCollacted']['icons']['list-ul']['text'] =  '#getLang('','liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addCollacted']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_promotions";
			tabMenuStruct['#fuseactController#']['tabMenus']['addCollacted']['icons']['check']['text'] = '#getLang('','kaydet','57461')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['addCollacted']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		
		else if(isdefined("attributes.event") and attributes.event is 'updCollacted')
		{
			denied_pages = caller.denied_pages;
			is_conscat_premium = caller.is_conscat_premium;
			is_conscat_segmentation = caller.is_conscat_segmentation;
			tabMenuStruct['#fuseactController#']['tabMenus']['updCollacted']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['updCollacted']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['updCollacted']['icons']['list-ul']['text'] =  '#getLang('','liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updCollacted']['icons']['list-ul']['href'] = "#request.self#?fuseaction=product.list_promotions";
			tabMenuStruct['#fuseactController#']['tabMenus']['updCollacted']['icons']['check']['text'] = '#getLang('','kaydet','57461')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updCollacted']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['updCollacted']['icons']['add']['text'] = '#getLang('','ekle','57582')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['updCollacted']['icons']['add']['href'] = "#request.self#?fuseaction=product.list_promotions&event=addCollacted";
			tabMenuStruct['#fuseactController#']['tabMenus']['updCollacted']['icons']['add']['target'] = '_blank';
			
			i = 0;
			if(isdefined("is_conscat_segmentation") and is_conscat_segmentation eq 1){
                if(not listfindnocase(denied_pages,'product.popup_add_conscat_segmentation')){
					tabMenuStruct['#fuseactController#']['tabMenus']['updCollacted']['menus'][i]['text'] = '#getLang('','Kategori Segmentasyon Tanımları','37851')#';
					tabMenuStruct['#fuseactController#']['tabMenus']['updCollacted']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_add_conscat_segmentation&prom_rel_id=#attributes.prom_rel_id#','list_horizantal')";
					i = i + 1;
				}
			}
            if(isdefined("is_conscat_premium") and is_conscat_premium eq 1){
                if(not listfindnocase(denied_pages,'product.popup_add_conscat_premium')){
					tabMenuStruct['#fuseactController#']['tabMenus']['updCollacted']['menus'][i]['text'] = '#getLang('','Kategori Prim Tanımları','37850')#';
					tabMenuStruct['#fuseactController#']['tabMenus']['updCollacted']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=product.popup_add_conscat_premium&prom_rel_id=#attributes.prom_rel_id#','horizantal')";
					i = i + 1;
				}
			}
		}		
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
</cfscript>
