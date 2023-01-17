<cfsavecontent variable="detail"><cf_get_lang dictionary_id="57771.Detay"></cfsavecontent>
<cfsavecontent variable="assets_notes"><cf_get_lang dictionary_id="60734.Belgeler ve Notlar"></cfsavecontent>
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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.list_purchasedemand';
		if(listgetat(attributes.fuseaction,1,'.') is 'myhome')
			WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/myhome/display/list_my_internaldemands.cfm';
		else
			WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/correspondence/display/list_internaldemand.cfm';
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.add_purchasedemand';
		WOStruct['#attributes.fuseaction#']['add']['XmlFuseaction'] = 'correspondence.add_purchasedemand';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/correspondence/form/add_internaldemand.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/correspondence/query/add_internaldemand.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_purchasedemand&event=upd&id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'form_basket';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(internaldemand);";
		
		if(isdefined("attributes.id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.upd_purchasedemand';
			WOStruct['#attributes.fuseaction#']['upd']['XmlFuseaction'] = 'correspondence.add_purchasedemand';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/correspondence/form/upd_internaldemand.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/correspondence/query/upd_internaldemand.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_purchasedemand&event=upd&id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(detail_internaldemand);";

			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.upd_purchasedemand';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/correspondence/form/det_internaldemand.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.id#';

			if(isdefined("attributes.event") and (attributes.event is "upd" or attributes.event is "del"))
			{							
				WOStruct['#attributes.fuseaction#']['del'] = structNew();
				WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
				WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_del_internaldemand&id=#attributes.id#&head=##caller.get_internaldemand.subject##- ##caller.get_internaldemand.internal_number##&type_=##caller.get_internaldemand.demand_type##';
				WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/V16/correspondence/query/del_internaldemand.cfm';
				WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/V16/correspondence/query/del_internaldemand.cfm';
				WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'purchase.list_purchasedemand';
			}
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_purchasedemand";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-download']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-download']['text'] = '#getLang('main',2576)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['fa fa-download']['href'] = "#request.self#?fuseaction=objects.add_order_from_file&from_where=3&is_demand=#caller.is_demand#&frm_str_=#listgetat(attributes.fuseaction,1,'.')#";

		}
		else if(caller.attributes.event is 'det'){

			get_offer = caller.get_offer;
			GET_INTERNALDEMAND = caller.GET_INTERNALDEMAND;
			if(listgetat(attributes.fuseaction,2,'.') eq 'list_purchasedemand')is_demand = 1;else is_demand = 0;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_purchasedemand&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_purchasedemand";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getLang('main',52,'güncelle')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_purchasedemand&event=upd&id=#attributes.id#";
			if(is_demand eq 1)type_ = 'PURCHASEDEMAND';else type_ = 'INTERNALDEMAND';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&event=upd&action_name=id&action_id=#attributes.id#&relation_papers_type=#type_#&wrkflow=1','Workflow')";
			//Tarihçe
			if(isdefined('is_demand'))isDemand = '&is_demand=#is_demand#';else isDemand = '';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-history']['text'] = '#getlang('main',61)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-history']['onClick'] = "windowopen('#request.self#?fuseaction=correspondence.popup_list_internaldemand_history&offer_id=#get_offer.offer_id#&id=#attributes.id#&project_id=#get_internaldemand.project_id##isDemand#','page')";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#&print_type=92','page');";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-info-circle']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.id#&type_id=-28','list');";
		}
		else if(caller.attributes.event is 'upd')
		{
			get_offer = caller.get_offer;
			GET_INTERNALDEMAND = caller.GET_INTERNALDEMAND;
			if(listgetat(attributes.fuseaction,2,'.') eq 'list_purchasedemand')is_demand = 1;else is_demand = 0;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_purchasedemand&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_purchasedemand&event=add&id=#attributes.id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.id#','page');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_purchasedemand";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['text'] = '#detail#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_purchasedemand&event=det&id=#attributes.id#";
			if(is_demand eq 1)type_ = 'PURCHASEDEMAND';else type_ = 'INTERNALDEMAND';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&event=upd&action_name=id&action_id=#attributes.id#&relation_papers_type=#type_#&wrkflow=1','Workflow')";
			//Tarihçe
			if(isdefined('is_demand'))isDemand = '&is_demand=#is_demand#';else isDemand = '';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getlang('main',61)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] = "windowopen('#request.self#?fuseaction=correspondence.popup_list_internaldemand_history&offer_id=#get_offer.offer_id#&id=#attributes.id#&project_id=#get_internaldemand.project_id##isDemand#','page')";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.id#&type_id=-28','list');";
			i= 0;

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			
			if(is_demand eq 0 and isDefined('caller.xml_purchase_demand_button') and caller.xml_purchase_demand_button eq 1)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('correspondence',259)# #getLang('main',656)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=purchase.add_purchasedemand&internaldemand_id=#attributes.id#&is_from_internaldemand=1&internal_row_info=1";
				i=i+1;
			}
			if(listgetat(attributes.fuseaction,1,'.') neq 'myhome')
			{
				if(isDefined('caller.xml_sarf_fis_button') and caller.xml_sarf_fis_button eq 1)
				{
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',1831)# #getLang('main',656)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=stock.form_add_fis&internal_demand_id=#attributes.id#&from_position_code=#get_internaldemand.from_position_code#&from_company_id=#get_internaldemand.from_company_id#&from_partner_id=#get_internaldemand.from_partner_id#&from_consumer_id=#get_internaldemand.from_consumer_id#";
					i=i+1;
				}
			}
			else
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',1831)# #getLang('main',656)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=stock.form_add_fis&internal_demand_id=#attributes.id#&from_position_code=#get_internaldemand.from_position_code#&from_company_id=#get_internaldemand.from_company_id#&from_partner_id=#get_internaldemand.from_partner_id#&from_consumer_id=#get_internaldemand.from_consumer_id#";
				i=i+1;
			}
			
			
			if(isDefined('caller.xml_purch_order_button') and caller.xml_purch_order_button eq 1)
			{
				link = "#request.self#?fuseaction=purchase.form_add_internaldemand_order&id=#attributes.id#&project_id=#get_internaldemand.project_id#&is_demand=#is_demand#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',1034)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#link#";
				i=i+1;
			}
			
			if(isDefined('caller.xml_purch_offer_button') and caller.xml_purch_offer_button eq 1)
			{
				if(get_offer.recordcount)
				{
					link = "#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#get_offer.offer_id#";
					mesaj="Teklif Detay";
				}
				else
				{
					link = "#request.self#?fuseaction=purchase.list_offer&event=add&internaldemand_id=#attributes.id#&is_money_internal=1";
					mesaj="#getLang('main',1035)#";
				}
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#mesaj#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#link#";
				i=i+1;
			}
			if(listfirst(attributes.fuseaction,'.') is 'purchase')
				module_name_ = 'purchase';
			else
				module_name_ = 'correspondence';
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#assets_notes#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=#module_name_#.popup_dsp_internaldemand_asset&id=#attributes.id#','medium');";
			i=i+1;
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PAYROLL';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'ACTION_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-company_name','item-REVENUE_COLLECTOR','item-payroll_revenue_date']";

</cfscript>
