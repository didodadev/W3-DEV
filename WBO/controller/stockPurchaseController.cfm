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
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.form_add_purchase';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/stock/form/form_upd_purchase.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/stock/query/upd_purchase.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.ship_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.form_add_purchase&event=upd&ship_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(form_upd_purchase);";

			WOStruct['#attributes.fuseaction#']['det'] = structNew();
			WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'stock.form_add_purchase';
			WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/stock/form/form_det_purchase.cfm';
			WOStruct['#attributes.fuseaction#']['det']['Identity'] = '#attributes.ship_id#';
			WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'stock.form_add_purchase&event=det&ship_id=';
		}

				
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.form_add_purchase';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/stock/form/form_add_purchase.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/stock/query/add_purchase.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.form_add_purchase&event=upd&ship_id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'add_purchase';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(add_purchase)";
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'SHIP';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'SHIP_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['form_ul_process_cat','form_ul_partner_name','form_ul_ship_number','form_ul_txt_departman_']";
		
		
		if(isdefined("attributes.event") and (attributes.event is "upd" or attributes.event is "del"))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_sale&active_period=#session.ep.period_id#&ship_id=#attributes.ship_id#&upd_id=#attributes.ship_id#';
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
	
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(isdefined("attributes.event") and (attributes.event is 'upd'))
		{
			
			get_upd_purchase = caller.get_upd_purchase;
			get_module_user = caller.get_module_user;
						
			tabMenuStruct['#fuseactController#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
						
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('main',2768	)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=stock.popup_list_ship_delivery&ship_id=#url.ship_id#','wwide');";

			i = 1;			
			if(session.ep.our_company_info.workcube_sector eq 'it'){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('main',2267)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_upd_ship_stock_rows&process_cat_id=#get_upd_purchase.ship_type#&upd_id=#attributes.UPD_ID#&in_or_out=1','list');";
				i=i+1;
			}		
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_purchase";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#url.ship_id#&type_id=-14','list');";
		
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getLang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=ship_id&action_id=#attributes.ship_id#&wrkflow=1','Workflow')";

			if(session.ep.our_company_info.guaranty_followup and listgetat(attributes.fuseaction,1,'.') is not 'service')
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-qrcode']['text'] = '#getLang('main',305)# #getLang('main',306)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-qrcode']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#";
			}
			else if(session.ep.our_company_info.guaranty_followup and listgetat(attributes.fuseaction,1,'.') is 'service')
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-qrcode']['text'] = '#getLang('main',305)# #getLang('main',306)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-qrcode']['href'] = "window.opener.location.href='#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#';self.close();";
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['text'] = '#getLang('main',359)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['detail']['href'] = "#request.self#?fuseaction=stock.form_add_purchase&event=det&ship_id=#attributes.ship_id#";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['text'] = '#getLang('main',61)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-history']['onClick'] ="windowopen('#request.self#?fuseaction=objects.popup_list_ship_history&ship_id=#attributes.ship_id#','project','popup_list_ship_history')";			
		
			if(listgetat(attributes.fuseaction,1,'.') is not 'service'){
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=stock.form_add_purchase&event=add";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = '#getLang('main',64)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=stock.form_add_purchase&event=add&is_ship_copy=1&ship_id=#attributes.UPD_ID#";
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#attributes.ship_id#&print_type=30','WOC');";

			
			
		}
		else if(attributes.event is 'add')
		{
							tabMenuStruct['#fuseactController#']['tabMenus']['add'] = structNew();
							tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
							tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
							tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_purchase";
							tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
							tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			//workcube_mode = caller.workcube_mode;
			if(listgetat(attributes.fuseaction,1,'.') is not 'service')
				{	
						//tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
						//						i=0;
						//						if(workcube_mode eq 0)
						//						{
						//							tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#getLang('main',2592)#';
						//							tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_workxml_data_service','small')";
						//							i=i+1;
						//						}
							tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['download']['text'] = '#veriaktarim#';
							tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['download']['onclick'] = "open_phl()";
							//tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	
				}
							
							

		}
		else if (isdefined("attributes.event") and attributes.event is 'det')
		{	
			get_upd_purchase = caller.get_upd_purchase;
			get_module_user = caller.get_module_user;
						
			tabMenuStruct['#fuseactController#']['tabMenus']['det'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
						
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['text'] = '#getLang('main',2768	)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=stock.popup_list_ship_delivery&ship_id=#url.ship_id#','wwide');";

			i = 1;
			if(session.ep.our_company_info.workcube_sector eq 'it'){
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main',2267)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_upd_ship_stock_rows&process_cat_id=#get_upd_purchase.ship_type#&upd_id=#attributes.UPD_ID#&in_or_out=1','list');";
			}		

			if(session.ep.our_company_info.guaranty_followup and listgetat(attributes.fuseaction,1,'.') is not 'service')
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-qrcode']['text'] = '#getLang('main',305)# #getLang('main',306)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-qrcode']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#";
			}
			else if(session.ep.our_company_info.guaranty_followup and listgetat(attributes.fuseaction,1,'.') is 'service')
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-qrcode']['text'] = '#getLang('main',305)# #getLang('main',306)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-qrcode']['href'] = "window.opener.location.href='#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#';self.close();";
			}

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=stock.list_purchase";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-info-circle']['text'] = '#getLang('main',398)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-info-circle']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#url.ship_id#&type_id=-14','list');";
		
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getLang('main',345)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['onclick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=ship_id&action_id=#attributes.ship_id#&wrkflow=1','Workflow')";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['text'] = '#getLang('main',52)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-pencil']['href'] = "#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=#attributes.ship_id#";
		
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-history']['text'] = '#getLang('main',61)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-history']['onClick'] ="windowopen('#request.self#?fuseaction=objects.popup_list_ship_history&ship_id=#attributes.ship_id#','project','popup_list_ship_history')";			
		
			if(listgetat(attributes.fuseaction,1,'.') is not 'service'){
				
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=stock.form_add_purchase&event=add";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['copy']['text'] = '#getLang('main',64)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['copy']['href'] = "#request.self#?fuseaction=stock.form_add_purchase&event=add&is_ship_copy=1&ship_id=#attributes.UPD_ID#";
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#attributes.ship_id#&print_type=30','WOC');";
			//tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['archive']['text'] = '#getLang('main',156)#';
			// tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['archive']['customTag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-24' module_id='13' action_section='SHIP_ID' action_id='#url.ship_id#'>";
			//tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['text'] = '#getLang('stock',268)#';
			//tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_ship_receive_rate&ship_id=#attributes.ship_id#&is_purchase=1','list','popup_list_ship_receive_rate');"; 
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
		
</cfscript>