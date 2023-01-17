<cfsavecontent variable="veriaktarim"><cf_get_lang dictionary_id="60009.Veri Aktarım"></cfsavecontent>
<cfscript>
	if(attributes.tabMenuController eq 0)
	{
				// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		if(isdefined("attributes.ship_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.form_upd_sale';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/stock/form/form_upd_sale.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/stock/query/upd_sale.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.ship_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.form_add_sale&event=upd&ship_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(upd_sale)";
			
			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.form_upd_sale';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/stock/form/form_det_sale.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.ship_id#';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.form_add_sale&event=det&ship_id=';

		}
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.form_add_sale';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/stock/form/form_add_sale.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/stock/query/add_sale.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.form_add_sale&event=upd&ship_id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'form_basket';
        WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(detail_inv_purchase_ship)";        

		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SHIP';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'SHIP_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-process_cat','item-partner_name','item-ship_number','item-ship_date','item-deliver_date_frm','item-txt_departman_']";
		
		if(isdefined("attributes.event") and (attributes.event is "upd" or attributes.event is "del"))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_sale&active_period=#session.ep.period_id#&ship_id=#attributes.ship_id#&upd_id=#attributes.ship_id#&process_cat=##caller.get_upd_purchase.process_cat##&del_ship=1&ship_number=##caller.get_upd_purchase.ship_number##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/stock/query/upd_sale.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/stock/query/upd_sale.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_purchase';
		}
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		// Upd //
		getLang = caller.getLang;
		if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			get_module_user = caller.get_module_user;
			get_upd_purchase = caller.get_upd_purchase;
			x_add_dispatch_ship = caller.x_add_dispatch_ship;
			control_ship_result = caller.control_ship_result;
			tabMenuStruct = StructNew();
			tabMenuStruct['#fuseactController#'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
	
			if(listgetat(attributes.fuseaction,1,'.') is not 'service')
			{
			 //   <cfinclude template="../query/get_find_ship_js.cfm">
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
		
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('stock',479)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=stock.popup_ship_package_detail&process_id=#attributes.upd_id#','project')";

			counter_ = 0;
	
			if(session.ep.our_company_info.guaranty_followup and listgetat(attributes.fuseaction,1,'.') is not 'service')
			{
				counter_ = counter_ + 1;
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][#counter_#]['text'] = '#getLang('main',305)#-#getLang('main',306)#-#getLang('main',170)#';	
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][#counter_#]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_add_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#','list')";

				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-qrcode']['text'] = '#getLang('main',305)#-#getLang('main',306)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-qrcode']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#";
			}
			if (session.ep.our_company_info.guaranty_followup and listgetat(attributes.fuseaction,1,'.') is 'service')
			{
				counter_ = counter_ + 1;
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][#counter_#]['text'] = '#getLang('main',305)#-#getLang('main',306)#-#getLang('main',170)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][#counter_#]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_add_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#','list')";
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-qrcode']['text'] = '#getLang('main',305)#-#getLang('main',306)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-qrcode']['href'] = "javascript:window.opener.location.href='#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#';self.close();";
			}
			if(session.ep.our_company_info.workcube_sector eq 'it')
			{
				counter_ = counter_ + 1;
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][#counter_#]['text'] = '#getLang('main',2267)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][#counter_#]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_upd_ship_stock_rows&process_cat_id=#get_upd_purchase.ship_type#&upd_id=#attributes.UPD_ID#&in_or_out=0','list')";
			}

			if(listgetat(attributes.fuseaction,1,'.') is not 'service')
			{
				if( x_add_dispatch_ship eq 1 and get_upd_purchase.ship_type eq 72)//konsinye çıkış irsaliyesiyse ve xmlde depo sevke donustur secilmişse 
				{
					counter_ = counter_ + 1;
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][#counter_#]['text'] = '#getLang('main',567)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][#counter_#]['onClick'] = "#request.self#?fuseaction=stock.add_ship_dispatch&ship_id=#url.ship_id#&from_sale_ship=3";
				}
				if(not control_ship_result.recordcount)
				{
					counter_ = counter_ + 1;
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][#counter_#]['text'] = '#getLang('','Paketleme ve Sevkiyat Ekle',45492)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][#counter_#]['onClick'] = "javascript:add_packetship.submit();";
				}
				else 
				{
					counter_ = counter_ + 1;
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][#counter_#]['text'] = '#getLang('','Paketleme ve Sevkiyat Güncelle',45496)#';
					tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][#counter_#]['onClick'] = "javascript:get_packetship();";
				}
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_purchase";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_sale&event=add";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_sale&is_ship_copy=1&event=add&ship_id=#url.ship_id#";
				
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#url.ship_id#&type_id=-14','list')";

				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['text'] = '#getLang('main',359)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_sale&event=det&ship_id=#url.ship_id#";

				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getLang('main',61)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] ="windowopen('#request.self#?fuseaction=objects.popup_list_ship_history&ship_id=#attributes.ship_id#','project','popup_list_ship_history')";			
			
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('main',345)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] ="window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=ship_id&action_id=#attributes.ship_id#&wrkflow=1','Workflow')";
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			if(fuseaction contains 'service')
				faction = "window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#attributes.ship_id#&print_type=30&keyword=service','WOC')";
			else
				faction = "window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#attributes.ship_id#&print_type=30','WOC')";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "#faction#";

			if( get_upd_purchase.IS_WITH_SHIP neq 1 ) {
				transformations['#fuseactController#']['upd']['icons']['customTag'] = structNew();
				transformations['#fuseactController#']['upd']['icons']['customTag'] = "<cf_wrk_eshipment_display action_id='#attributes.ship_id#' action_type='SHIP' action_date='#get_upd_purchase.ship_date#'>";
			}

			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		else if(isdefined("attributes.event") and attributes.event is 'det')
		{
			get_module_user = caller.get_module_user;
			get_upd_purchase = caller.get_upd_purchase;
			tabMenuStruct = StructNew();
			tabMenuStruct['#fuseactController#'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
	
			if(listgetat(attributes.fuseaction,1,'.') is not 'service')
			{
			 //   <cfinclude template="../query/get_find_ship_js.cfm">
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();

			counter_ = 0;
	
			if(session.ep.our_company_info.guaranty_followup and listgetat(attributes.fuseaction,1,'.') is not 'service')
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][#counter_#]['text'] = '#getLang('main',305)#-#getLang('main',306)#-#getLang('main',170)#';	
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][#counter_#]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_add_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#','list')";

				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-qrcode']['text'] = '#getLang('main',305)#-#getLang('main',306)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-qrcode']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#";
			}
			if (session.ep.our_company_info.guaranty_followup and listgetat(attributes.fuseaction,1,'.') is 'service')
			{
				counter_ = counter_ + 1;
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][#counter_#]['text'] = '#getLang('main',305)#-#getLang('main',306)#-#getLang('main',170)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][#counter_#]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_add_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#','list')";
				
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-qrcode']['text'] = '#getLang('main',305)#-#getLang('main',306)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-qrcode']['href'] = "javascript:window.opener.location.href='#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#';self.close();";
			}
			if(session.ep.our_company_info.workcube_sector eq 'it')
			{
				counter_ = counter_ + 1;
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][#counter_#]['text'] = '#getLang('main',2267)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][#counter_#]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_upd_ship_stock_rows&process_cat_id=#get_upd_purchase.ship_type#&upd_id=#attributes.UPD_ID#&in_or_out=0','list')";
			}

			if(listgetat(attributes.fuseaction,1,'.') is not 'service')
			{	
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_purchase";
				
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_sale&event=add";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['copy']['text'] = '#getLang('main',64)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['copy']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_sale&is_ship_copy=1&event=add&ship_id=#url.ship_id#";
				
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-info-circle']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#url.ship_id#&type_id=-14','list')";

				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getLang('main',359)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_sale&event=upd&ship_id=#url.ship_id#";

				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-history']['text'] = '#getLang('main',61)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-history']['onClick'] ="windowopen('#request.self#?fuseaction=objects.popup_list_ship_history&ship_id=#attributes.ship_id#','project','popup_list_ship_history')";			
			
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getLang('main',345)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['onClick'] ="window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=ship_id&action_id=#attributes.ship_id#&wrkflow=1','Workflow')";
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main',62)#';
			if(fuseaction contains 'service')
				faction = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.ship_id#&print_type=30&keyword=service','page')";
			else
				faction = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.ship_id#&print_type=30','page')";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "#faction#";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		else if(attributes.event is 'add' and listgetat(attributes.fuseaction,1,'.') is not 'service')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['search']['text'] = '#getlang('main',153)#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['search']['onclick'] = "openSearchForm('find_ship_number','#getLang("main",726)#','find_ship_f')";

			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_purchase";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	

			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['download']['text'] = '#veriaktarim#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['download']['onclick'] = "open_phl()";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}
</cfscript>