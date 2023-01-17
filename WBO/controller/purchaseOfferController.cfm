<cfsavecontent variable="update_record"><cf_get_lang dictionary_id="58494.Kaydı Güncelle"></cfsavecontent>
<cfsavecontent variable="deatils"><cf_get_lang dictionary_id="33077.Detaylar"></cfsavecontent>
<cfscript>	
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		WOStruct['#attributes.fuseaction#'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'purchase.list_offer';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/purchase/display/list_offer.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'purchase.form_add_offer';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/purchase/form/add_offer.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/purchase/query/add_offer.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'purchase.list_offer&event=upd';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(add_offer);";
	
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'purchase.detail_offer_ta';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/purchase/form/detail_offer_ta.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/purchase/query/upd_offer_ta.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'purchase.list_offer&event=upd';
		WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'offer_id=##attributes.offer_id##';
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.offer_id##';
		WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(detail_offer);";

		WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'purchase.details_offer_ta';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/purchase/display/details_offer_ta.cfm';
		WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'offer_id=##attributes.offer_id##';

		WOStruct['#attributes.fuseaction#']['tech_pnt'] = structNew();
		WOStruct['#attributes.fuseaction#']['tech_pnt']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['tech_pnt']['fuseaction'] = 'purchase.list_offer&event=tech_pnt';
		WOStruct['#attributes.fuseaction#']['tech_pnt']['filePath'] = 'V16/purchase/display/technical_point.cfm';
		WOStruct['#attributes.fuseaction#']['tech_pnt']['queryPath'] = 'V16/purchase/query/add_technical_point.cfm';
		WOStruct['#attributes.fuseaction#']['tech_pnt']['nextEvent'] = 'purchase.list_offer&event=tech_pnt';

		WOStruct['#attributes.fuseaction#']['get_tech_pnt'] = structNew();
		WOStruct['#attributes.fuseaction#']['get_tech_pnt']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['get_tech_pnt']['fuseaction'] = 'purchase.list_offer&event=get_tech_pnt';
		WOStruct['#attributes.fuseaction#']['get_tech_pnt']['filePath'] = 'V16/purchase/display/emptypopup_get_technical_average_point.cfm';
		
		if(isdefined("attributes.offer_id"))
        {
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
            WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'purchase.emptypopup_del_offer&offer_id=#attributes.OFFER_ID#';
            WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/purchase/query/del_offer.cfm';
            WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/purchase/query/del_offer.cfm';
		}
		
	}
	else
	{
		getLang = caller.getLang;
		// Tab Menus //
		tabMenuStruct = StructNew();
		tabMenuStruct['#attributes.fuseaction#'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
		//writedump(attributes);
		//caller.abort('nurada');
		// Add //	
		if(isdefined("attributes.event") and attributes.event is 'add')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
	
			my_str = "&from_where=6";
			if(isdefined('attributes.for_offer_id') and len(attributes.for_offer_id))
				my_str = '#my_str#&for_offer_id=#attributes.for_offer_id#';
			if( isdefined('attributes.partner_ids') and len(attributes.partner_ids))
				my_str = '#my_str#&partner_ids=#attributes.partner_ids#'; 
			if( isdefined('attributes.company_ids') and len(attributes.company_ids))
				my_str = '#my_str#&company_ids=#attributes.company_ids#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#getlang('main','Veri Aktarım',60009)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['href'] = '#request.self#?fuseaction=objects.add_order_from_file#my_str#';
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	
		}
            
		if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			get_offer_detail = caller.get_offer_detail;
				
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
	
			/* tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#getlang('main',345)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=purchase.detail_offer_ta&action_name=offer_id&action_id=#attributes.offer_id#&relation_papers_type=OFFER_ID','list');";
	 */
			
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#getlang('purchase',197)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_cost&id=#attributes.offer_id#&page_type=3&basket_id=#attributes.basket_id#','work');";
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#getlang('main',1034)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['href'] = "#request.self#?fuseaction=purchase.list_order&event=add&offer_id=#attributes.offer_id#";
		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#getlang('main',2591)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['href'] = "#request.self#?fuseaction=sales.list_offer&event=add&offer_id=#attributes.offer_id#&ref=offer";
	
			/* tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = '#getlang('purchase',31)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['onClick'] = "changePages('basket_main_div','other_details');"; */
				
			if(not len(get_offer_detail.for_offer_id))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#getlang('purchase',198)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=purchase.popup_list_coming_offer&offer_id=#attributes.offer_id#&basket_id=#attributes.basket_id#&is_popup=1','wwide');";
			}
		
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getlang('main',61)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_offer_history&offer_id=#attributes.offer_id#&portal_type=employee','work')";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=purchase.list_offer";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";	
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#getlang('main',170)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=purchase.list_offer&event=add";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['text'] = '#deatils#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=purchase.list_offer&event=det&offer_id=#attributes.offer_id#";
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#getlang('main',64)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=purchase.list_offer&event=add&offer_id=#attributes.offer_id#';
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] =  '#getlang('main',62)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] ="window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#attributes.offer_id#&print_type=90','WOC');";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=offer_id&action_id=#attributes.offer_id#&wrkflow=1','Workflow')";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-info-circle']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.offer_id#&type_id=-30','list');";
			
			
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		if(isdefined("attributes.event") and attributes.event is 'det')
		{
			get_offer_detail = caller.get_offer_detail;

			xml_accept_offer = caller.xml_accept_offer;
				
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'] = structNew();
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['text'] = '#getlang('purchase',197)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_cost&id=#attributes.offer_id#&page_type=3&basket_id=#attributes.basket_id#','work');";
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['text'] = '#getlang('main',1034)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][1]['href'] = "#request.self#?fuseaction=purchase.list_order&event=add&offer_id=#attributes.offer_id#";
		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['text'] = '#getlang('main',2591)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][2]['href'] = "#request.self#?fuseaction=sales.list_offer&event=add&offer_id=#attributes.offer_id#&ref=offer";
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][3]['text'] = '#getlang('salesplan',30)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=project.popup_add_workgroup&action_field=OFFER_ID&action_id=#attributes.offer_id#','work')";
			i=4;			
			if(not len(get_offer_detail.for_offer_id))
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getlang('purchase',198)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=purchase.popup_list_coming_offer&offer_id=#attributes.offer_id#&basket_id=#attributes.basket_id#&is_popup=1','wwide');";
				i++;
			}

			if( xml_accept_offer eq 1) {
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('','Gelen Teklif Kabulü',63126)#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['menus'][i]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=purchase.emptypopup_accept_coming_offer&offer_id=#attributes.offer_id#&basket_id=#attributes.basket_id#');";
			}

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons'] = structNew();

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-history']['text'] = '#getlang('main',61)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-history']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_offer_history&offer_id=#attributes.offer_id#&portal_type=employee','work')";

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=purchase.list_offer";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['text'] = '#getlang('main',170)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=purchase.list_offer&event=add";
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#update_record#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#attributes.offer_id#";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['text'] = '#getlang('main',64)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['href'] = '#request.self#?fuseaction=purchase.list_offer&event=add&offer_id=#attributes.offer_id#';
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['text'] =  '#getlang('main',62)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['print']['onClick'] ="window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.offer_id#&print_type=90','WOC');";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=offer_id&action_id=#attributes.offer_id#','Workflow')";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['fa fa-info-circle']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.offer_id#&type_id=-30','list');";
			
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		else if(attributes.event is 'add')
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=purchase.list_offer";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
			
		}
	}
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'OFFER';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'OFFER_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-offer_head','item-offer_date','item-deliverdate','item-startdate2']";
</cfscript>
