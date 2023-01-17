<cfsavecontent variable="title"><cf_get_lang dictionary_id="47219.Stopajlı Alış Faturası"></cfsavecontent>
<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invoice.form_add_bill_other';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/invoice/display/add_bill_other.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/invoice/query/add_invoice_other.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invoice.form_add_bill_other&event=upd&iid=';
		WOStruct['#attributes.fuseaction#']['add']['js'] = 'javascript:gizle_goster_basket(add_bill_other);';
		
		if(isdefined("attributes.iid"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'invoice.detail_invoice_other';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/invoice/display/upd_bill_other.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/invoice/query/upd_invoice_other.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.iid#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'invoice.form_add_bill_other&event=upd&iid=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = 'javascript:gizle_goster_basket(upd_other_bill);';
			
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'invoice.form_add_bill_other';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/invoice/display/det_bill_other.cfm';
			WOStruct['#attributes.fuseaction#']['det']['identity'] = '#attributes.iid#';

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_bill_other&iid=#attributes.iid#&del_invoice_id=#attributes.iid#&active_period=#session.ep.period_id#&invoice_id=#attributes.iid#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/invoice/query/upd_invoice_other.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/invoice/query/upd_invoice_other.cfm';
			WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'old_process_type&invoice_number';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'invoice.list_bill';
		}
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'INVOICE';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'INVOICE_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-invoice_number','item-company','item-partner_name','item-deliver_get','item-process_cat','item-department_location']";

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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invoice.list_bill";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{
			get_efatura_det = caller.get_efatura_det;
			get_sale_det = caller.get_sale_det;
			denied_pages = caller.denied_pages;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=invoice.form_add_bill_other";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=invoice.form_add_bill_other&event=add&iid=#attributes.iid#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invoice.list_bill";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#attributes.iid#&print_type=10&action_type=#GET_SALE_DET.invoice_cat#','page');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['text'] = '#getLang('invoice',113)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_account_cards&invoice_id=#attributes.iid#','page','upd_bill');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=iid&action_id=#attributes.iid#','Workflow')";

			if(session.ep.our_company_info.GUARANTY_FOLLOWUP and get_sale_det.INVOICE_CAT eq 690){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-qrcode']['text'] = '#getLang('main',305)# - #getLang('main',306)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-qrcode']['href'] = "#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&invoice_number=#get_sale_det.invoice_number#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-qrcode']['target'] = "_blank";
			}
			if(not listfindnocase(denied_pages,'invoice.popup_form_add_info_plus')){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.iid#&type_id=-8','list');";
			}
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['text'] = '#getLang('main',359)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=invoice.form_add_bill_other&event=det&iid=#attributes.iid#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['MLM']['text'] = '#getLang('invoice',264)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['MLM']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_upd_expensecenter_invoice&id=#attributes.iid#','wide');";
			
			i = 0;
			
			if(get_efatura_det.recordcount){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang(dictionary_id:60063)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_dsp_efatura_detail&receiving_detail_id=#get_efatura_det.receiving_detail_id#&type=1','wwide');";
				i = i + 1;
			}
					
			
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('invoice',217)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_cost&id=#attributes.iid#&page_type=1&basket_id=#attributes.basket_id#','wide');";
			i = i + 1;			
		}
		else if(caller.attributes.event is 'det'){
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#title#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['onclick'] =  "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=iid&action_id=#attributes.iid#','Workflow')";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=invoice.list_bill";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getlang('main',1034)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=invoice.form_add_bill_other&event=upd&iid=#attributes.iid#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=invoice.form_add_bill_other";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>


