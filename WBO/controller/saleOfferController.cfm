<cfsavecontent variable="veriaktarim"><cf_get_lang dictionary_id="60009.Veri Aktarım"></cfsavecontent>
<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.list_offer';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/sales/display/list_offer.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'sales.form_add_offer';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/sales/form/add_offer.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/sales/query/add_offer.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'sales.list_offer&event=upd';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(add_offer);";
	
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'sales.detail_offer_tv';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/sales/form/detail_offer_tv.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/sales/query/upd_offer_tv.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'sales.list_offer&event=upd';
		WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'offer_id=##attributes.offer_id##';
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.offer_id##';
		WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(detail_offer);";

		WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'sales.detail_offer_tv';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/sales/form/detail_offer_form.cfm';
		WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'sales.list_offer&event=det';
		WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'offer_id=##attributes.offer_id##';
		WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.offer_id##';
		
		if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=sales.emptypopup_del_offer&offer_id=#attributes.offer_id#&head=##caller.head_##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/sales/query/del_offer.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/sales/query/del_offer.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'sales.list_offer';
		}
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		// Tab Menus //
		tabMenuStruct = StructNew();
		tabMenuStruct['#attributes.fuseaction#'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
		
		// Add //	
		if(isdefined("attributes.event") and attributes.event is 'add')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=sales.list_offer";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['download']['text'] = '#veriaktarim#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['download']['onclick'] = "open_phl()";
			
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		
		// Upd //	
		if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			get_offer = caller.get_offer;
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']= structNew();

			i = 0;

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',656)# #getlang('main',795)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=sales.list_order&event=add&offer_id=#attributes.offer_id#";
			i++;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',656)# #getlang('main',796)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=sales.list_order_instalment&event=add&offer_id=#attributes.offer_id#&company_id=#get_offer.company_id#";
			i++;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',368)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_cost&id=#url.offer_id#&page_type=3&basket_id=#attributes.basket_id#','page_horizantal');";
			/* i++;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('sales',62)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=sales.popup_list_pluses&offer_id=#attributes.offer_id#','medium');"; */
			i++;
			/* if (len(get_offer.company_id))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Üye Bilgileri',57575)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_offer.company_id#','medium');";
				i = i + 1;
			} 
			else if(len(get_offer.consumer_id))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',163)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_offer.consumer_id#','medium');";
				i = i + 1;
			}*/
	
			if (session.ep.our_company_info.workcube_sector is 'tersane')
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['text'] = '#getlang('main',2580)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=sales.form_add_relation_pbs&offer_id=#url.offer_id#";
				i = i + 1;
			}
		
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=sales.list_offer";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-envelope']['text'] = '#getLang('','Mailler',33402)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-envelope']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_mail_relation&relation_type=OFFER_ID&relation_type_id=#url.offer_id#','wide');";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getlang('main',170)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = '#request.self#?fuseaction=sales.list_offer&event=add';
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#getlang('sales',517)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=sales.list_offer&event=add&offer_id=#offer_id#&active_company_id=#session.ep.company_id#';
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] =  '#getlang('main',62)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] ="window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#url.offer_id#&print_type=70','WOC');";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['onclick'] ="window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=offer_id&action_id=#attributes.offer_id#&wrkflow=1','Workflow')";
				
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getlang('main',61)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_offer_history&offer_id=#url.offer_id#&portal_type=employee','project');";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-info-circle']['text'] = '#getlang('main',398)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-info-circle']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#url.offer_id#&type_id=-9','list');";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['text'] = '#getlang('main',359)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=sales.list_offer&event=det&offer_id=#attributes.offer_id#";

			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}

			// Det //	
			if(isdefined("attributes.event") and attributes.event is 'det')
			{
				get_offer = caller.get_offer;
				
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']= structNew();
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();

				i=0;
				/* tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('','Ek Sayfa Ekle',40862)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=sales.popup_form_add_page&offer_id=#offer_id#','','ui-draggable-box-medium');"; */

				if (len(get_offer.company_id))
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('','Üye Bilgileri',57575)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_offer.company_id#','medium');";
					i = i + 1;
				}
				else if(len(get_offer.consumer_id))
				{
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getlang('main',163)#';
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_offer.consumer_id#','medium');";
					i = i + 1;
				}
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getlang('sales',368)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_cost&id=#url.offer_id#&page_type=3&basket_id=#attributes.basket_id#','page_horizantal');";
				i++;	
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=sales.list_offer";
	
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['text'] = '#getlang('main',170)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['href'] = '#request.self#?fuseaction=sales.list_offer&event=add';
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['text'] = '#getlang('sales',517)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['href'] = '#request.self#?fuseaction=sales.list_offer&event=add&offer_id=#offer_id#&active_company_id=#session.ep.company_id#';
								
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['text'] =  '#getlang('main',62)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['onClick'] ="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#url.offer_id#&print_type=70','page');";
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('main',345)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['onclick'] ="window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=offer_id&action_id=#attributes.offer_id#&wrkflow=1','Workflow')";
				
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-history']['text'] = '#getlang('main',61)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-history']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_offer_history&offer_id=#url.offer_id#&portal_type=employee','project');";
	
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-info-circle']['text'] = '#getlang('main',398)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-info-circle']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#url.offer_id#&type_id=-9','list');";
	
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getLang('main',52,'güncelle')#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=sales.list_offer&event=upd&offer_id=#attributes.offer_id#";
	
				tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
			}

		/*WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
		WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'saleOfferController';
		WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'OFFER';
		WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-offer_head','item-partner_id','item-offer_date']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.*/
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'OFFER';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'OFFER_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-partner_name','item-offer_date','item-deliverdate']";
</cfscript>
