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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'textile.list_sample_request';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'AddOns/N1-Soft/textile/sales/display/list_sample_request.cfm';
		
		if(isdefined("attributes.req_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'textile.list_sample_request';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'AddOns/N1-Soft/textile/sales/form/upd_req.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'AddOns/N1-Soft/textile/sales/query/upd_req.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'textile.list_sample_request&event=det&req_id=';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.req_id#';
		}
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'textile.list_sample_request';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'AddOns/N1-Soft/textile/sales/form/add_request.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/AddOns/N1-Soft/textile/sales/query/add_req.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'textile.list_sample_request&event=det&req_id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'upd_opp';
		
		WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
		WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'upd_kontrol() && validate().check()';

		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,det';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'TEXTILE_SAMPLE_REQUEST';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'req_id';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-opp_head','item-company','item-opp_stage','item-opportunity_type_id']";

		
		WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'textile.list_sample_request';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'AddOns/N1-Soft/textile/sales/form/upd_req.cfm';
		WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'AddOns/N1-Soft/textile/sales/query/upd_req.cfm';
		WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'textile.list_sample_request&event=det&req_id=';
		WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.req_id##';
		
		
		WOStruct['#attributes.fuseaction#']['add_stock'] = structNew();
		WOStruct['#attributes.fuseaction#']['add_stock']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add_stock']['fuseaction'] = 'textile.add_stock';
		WOStruct['#attributes.fuseaction#']['add_stock']['filePath'] = 'AddOns/N1-Soft/textile/product/form/add_stock.cfm';
		WOStruct['#attributes.fuseaction#']['add_stock']['queryPath'] = 'AddOns/N1-Soft/textile/product/query/add_stock.cfm';
		WOStruct['#attributes.fuseaction#']['add_stock']['nextEvent'] = 'AddOns/N1-Soft/textile/product/query/add_stock.cfm';
		WOStruct['#attributes.fuseaction#']['add_stock']['Identity'] = '##attributes.req_id##';
		
		WOStruct['#attributes.fuseaction#']['add_profile'] = structNew();
		WOStruct['#attributes.fuseaction#']['add_profile']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add_profile']['fuseaction'] = 'textile.add_profile';
		WOStruct['#attributes.fuseaction#']['add_profile']['filePath'] = 'AddOns/N1-Soft/textile/product/query/add_profile.cfm';
		WOStruct['#attributes.fuseaction#']['add_profile']['queryPath'] = 'AddOns/N1-Soft/textile/product/query/add_profile.cfm';
		WOStruct['#attributes.fuseaction#']['add_profile']['nextEvent'] = 'AddOns/N1-Soft/textile/product/query/add_profile.cfm';
		WOStruct['#attributes.fuseaction#']['add_profile']['Identity'] = '##attributes.req_id##';
		
				
		WOStruct['#attributes.fuseaction#']['config'] = structNew();
		WOStruct['#attributes.fuseaction#']['config']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['config']['fuseaction'] = 'textile.config';
		WOStruct['#attributes.fuseaction#']['config']['filePath'] = 'AddOns/N1-Soft/textile/objects/form/price_configurator.cfm';
		WOStruct['#attributes.fuseaction#']['config']['queryPath'] = 'AddOns/N1-Soft/textile/objects/query/price_configurator.cfm';
		WOStruct['#attributes.fuseaction#']['config']['nextEvent'] = 'AddOns/N1-Soft/textile/objects/query/price_configurator.cfm';
		WOStruct['#attributes.fuseaction#']['config']['Identity'] = '##attributes.req_id##';
		
	
		WOStruct['#attributes.fuseaction#']['measurement'] = structNew();
        WOStruct['#attributes.fuseaction#']['measurement']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['measurement']['fuseaction'] = 'textile.stretching_test&event=measurement';
        WOStruct['#attributes.fuseaction#']['measurement']['filePath'] = '/AddOns/N1-Soft/textile/sales/view/measurement.cfm';
		WOStruct['#attributes.fuseaction#']['measurement']['queryPath'] = '/AddOns/N1-Soft/textile/sales/model/measurement.cfm';
		WOStruct['#attributes.fuseaction#']['measurement']['nextEvent'] = '/AddOns/N1-Soft/textile/sales/view/measurement.cfm';
		
		WOStruct['#attributes.fuseaction#']['dashboard'] = structNew();
        WOStruct['#attributes.fuseaction#']['dashboard']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['dashboard']['fuseaction'] = 'textile.stretching_test&event=measurement';
        WOStruct['#attributes.fuseaction#']['dashboard']['filePath'] = '/AddOns/N1-Soft/textile/report/dashboard.cfm';
		WOStruct['#attributes.fuseaction#']['dashboard']['queryPath'] = '/AddOns/N1-Soft/textile/report/dashboard.cfm';
        WOStruct['#attributes.fuseaction#']['dashboard']['nextEvent'] = '/AddOns/N1-Soft/textile/report/dashboard.cfm';

		if(isdefined("attributes.event") and (attributes.event is "upd" or attributes.event is 'det' or attributes.event is "del") and isdefined("attributes.req_id"))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=sales.emptypopup_del_opportunity&req_id=#attributes.req_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/sales/query/del_opp.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/sales/query/del_opp.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'sales.list_opportunity';//
	
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
		if(isdefined("attributes.event") and not ListFind('addCurrencies,addCurrenciesHistory,add,list,add_stock,measurement',attributes.event)) //(attributes.event is 'add' or attributes.event is 'list' or attributes.event is 'add_stock'))
		{
			get_module_user = caller.get_module_user;
			get_opportunity = caller.get_opportunity;
			get_opportunity_type = caller.get_opportunity_type;

			tabMenuStruct = StructNew();
			tabMenuStruct['#fuseactController#'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
	
		
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['text'] = 'Ölçü Tablosu';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['href'] = "#request.self#?fuseaction=textile.stretching_test&event=measure_list&req_id=#req_id#&pid=#get_opportunity.product_id#";
		
			
		    tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][1]['text'] = 'Konfigüratör';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=textile.list_sample_request&event=config&req_id=#req_id#','page')";
		/* 
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][1]['text'] = 'Kur Listesi';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][1]['href'] = "#request.self#?fuseaction=textile.currencies";
		*/		
			i=2;
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = 'Ürün Ağacı Oluştur';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=textile.product_plan&event=add_tree&pid=#get_opportunity.product_id#&req_id=#req_id#','page')";
				i = i+ 1;
			/*if (IsDefined("get_opportunity.company_id"))
			
			
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main',163)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=member.form_list_company&event=det&cpid=#get_opportunity.company_id#";
				i = i+ 1;
			}
		
			else if (IsDefined("get_opportunity.consumer_id"))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main',163)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=call.list_callcenter&event=detConsumer&cid=#get_opportunity.consumer_id#";
				i = i+ 1;
			}
			*/
			
			if (IsDefined("get_opportunity.project_id") and len(get_opportunity.project_id) and get_opportunity.recordcount)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('sales',39)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=project.projects&event=det&id=#get_opportunity.project_id#";
				i = i+ 1;
			}
			else 
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('sales',38)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=project.projects&event=add&req_id=#get_opportunity.req_id#";
				i = i+ 1;
			}
			
			
		/*
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('sales',5)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=sales.list_offer&event=add&assorment=&req_id=#get_opportunity.req_id#";
			i = i+ 1;
				
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = 'Sipariş Oluştur';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=textile.product_plan&event=add_order_assortment&pid=#get_opportunity.product_id#&req_id=#req_id#&project_id=#get_opportunity.project_id#&company_id=#get_opportunity.invoice_company_id#&partner_id=#get_opportunity.invoice_partner_id#&pcode=','list');";
			i = i+ 1;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = 'Stok Oluştur';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=textile.list_sample_request&event=add_stock&pid=#get_opportunity.product_id#&pcode=#get_opportunity.PRODUCT_CODE#&req_id=#attributes.req_id#','page');";
			i = i+ 1;
	
		*/
			if((get_module_user(11)) and session.ep.our_company_info.subscription_contract eq 1)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main',	1420)# #getLang('main',	170)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "addSubscription();";
				i = i+ 1;
			}
	
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=textile.list_sample_request&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main',62)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#req_id#&print_type=#191#','page');";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=textile.list_sample_request";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['text'] = 'Numuneyi Kopyala';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['href'] = '#request.self#?fuseaction=textile.list_sample_request&event=add&req_id=#req_id#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['target'] = "_blank";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			//tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['extra']['text'] = 'Oklar';
			//tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['extra']['customTag'] = '<cf_np tablename="opportunities" primary_key="req_id" pointer="req_id=#req_id#,event=upd" dsn_var="DSN3">';
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		else if(attributes.event is 'add')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=textile.list_sample_request";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}

</cfscript>