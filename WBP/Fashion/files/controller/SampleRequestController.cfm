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
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'WBP/Fashion/files/sales/display/list_sample_request.cfm';
		
		if(isdefined("attributes.req_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'textile.list_sample_request';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'WBP/Fashion/files/sales/form/upd_req.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'WBP/Fashion/files/sales/query/upd_req.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'textile.list_sample_request&event=det&req_id=';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.req_id#';
		}
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'textile.list_sample_request';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'WBP/Fashion/files/sales/form/add_request.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/WBP/Fashion/files/sales/query/add_req.cfm';
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
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'WBP/Fashion/files/sales/form/upd_req.cfm';
		WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'WBP/Fashion/files/sales/query/upd_req.cfm';
		WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'textile.list_sample_request&event=det&req_id=';
		WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.req_id##';
		
		
		WOStruct['#attributes.fuseaction#']['add_stock'] = structNew();
		WOStruct['#attributes.fuseaction#']['add_stock']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add_stock']['fuseaction'] = 'textile.add_stock';
		WOStruct['#attributes.fuseaction#']['add_stock']['filePath'] = 'WBP/Fashion/files/product/form/add_stock.cfm';
		WOStruct['#attributes.fuseaction#']['add_stock']['queryPath'] = 'WBP/Fashion/files/product/query/add_stock.cfm';
		WOStruct['#attributes.fuseaction#']['add_stock']['nextEvent'] = 'WBP/Fashion/files/product/query/add_stock.cfm';
		WOStruct['#attributes.fuseaction#']['add_stock']['Identity'] = '##attributes.req_id##';
		
		WOStruct['#attributes.fuseaction#']['add_profile'] = structNew();
		WOStruct['#attributes.fuseaction#']['add_profile']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['add_profile']['fuseaction'] = 'textile.add_profile';
		WOStruct['#attributes.fuseaction#']['add_profile']['filePath'] = 'WBP/Fashion/files/product/query/add_profile.cfm';
		WOStruct['#attributes.fuseaction#']['add_profile']['queryPath'] = 'WBP/Fashion/files/product/query/add_profile.cfm';
		WOStruct['#attributes.fuseaction#']['add_profile']['nextEvent'] = 'WBP/Fashion/files/product/query/add_profile.cfm';
		WOStruct['#attributes.fuseaction#']['add_profile']['Identity'] = '##attributes.req_id##';
		
		if (isdefined("attributes.req_id")) {
		
		WOStruct['#attributes.fuseaction#']['config'] = structNew();
		WOStruct['#attributes.fuseaction#']['config']['window'] = 'popup';
		WOStruct['#attributes.fuseaction#']['config']['fuseaction'] = 'textile.config';
		WOStruct['#attributes.fuseaction#']['config']['filePath'] = 'WBP/Fashion/files/objects/form/price_configurator.cfm';
		WOStruct['#attributes.fuseaction#']['config']['queryPath'] = 'WBP/Fashion/files/objects/query/price_configurator.cfm';
		WOStruct['#attributes.fuseaction#']['config']['nextEvent'] = '#attributes.fuseaction#&event=config&req_id=';
		WOStruct['#attributes.fuseaction#']['config']['Identity'] = '#attributes.req_id#';

		WOStruct['#attributes.fuseaction#']['critics'] = structNew();
		WOStruct['#attributes.fuseaction#']['critics']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['critics']['fuseaction'] = 'textile.list_sample_request';
		WOStruct['#attributes.fuseaction#']['critics']['filePath'] = 'WBP/Fashion/files/sales/form/add_critics.cfm';
		
		}
	
		WOStruct['#attributes.fuseaction#']['measurement'] = structNew();
        WOStruct['#attributes.fuseaction#']['measurement']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['measurement']['fuseaction'] = 'textile.stretching_test&event=measurement';
        WOStruct['#attributes.fuseaction#']['measurement']['filePath'] = '/WBP/Fashion/files/sales/view/measurement.cfm';
		WOStruct['#attributes.fuseaction#']['measurement']['queryPath'] = '/WBP/Fashion/files/sales/model/measurement.cfm';
		WOStruct['#attributes.fuseaction#']['measurement']['nextEvent'] = '/WBP/Fashion/files/sales/view/measurement.cfm';
		
		WOStruct['#attributes.fuseaction#']['dashboard'] = structNew();
        WOStruct['#attributes.fuseaction#']['dashboard']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['dashboard']['fuseaction'] = 'textile.stretching_test&event=measurement';
        WOStruct['#attributes.fuseaction#']['dashboard']['filePath'] = '/WBP/Fashion/files/report/dashboard.cfm';
		WOStruct['#attributes.fuseaction#']['dashboard']['queryPath'] = '/WBP/Fashion/files/report/dashboard.cfm';
        WOStruct['#attributes.fuseaction#']['dashboard']['nextEvent'] = '/WBP/Fashion/files/report/dashboard.cfm';

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
	
		
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['text'] = '#getLang('','Ölçü Tablosu',62630)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][0]['href'] = "#request.self#?fuseaction=textile.measurement&req_id=#req_id#&pid=#get_opportunity.product_id#";
		

		
			/* 
		    tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][1]['text'] = 'Konfigüratör';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=textile.list_sample_request&event=config&req_id=#req_id#','page')";
		
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][1]['text'] = 'Kur Listesi';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][1]['href'] = "#request.self#?fuseaction=textile.currencies";
			*/
		i=1;
			/*
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = 'Ürün Ağacı Oluştur';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=textile.product_plan&event=add_tree&pid=#get_opportunity.product_id#&req_id=#req_id#','page')";
				i = i+ 1;
				
			*/
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
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('','Proje detayı','40841')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=project.projects&event=det&id=#get_opportunity.project_id#";
				i = i+ 1;
			}
			else 
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('','Proje ekle','40840')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=project.projects&event=add&req_id=#get_opportunity.req_id#";
				i = i+ 1;
			}
		
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][3]['text'] = '#getLang('','Stok Oluştur',62705)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][3]['onClick'] = "window.open('#request.self#?fuseaction=textile.list_sample_request&event=add_stock&pid=#get_opportunity.product_id#&pcode=#get_opportunity.PRODUCT_CODE#&req_id=#req_id#')"; 

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][2]['text'] = '#getLang('','Sipariş Oluştur',41173)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][2]['onClick'] = "window.open('#request.self#?fuseaction=textile.product_plan&event=add_order_assortment&pid=#get_opportunity.product_id#&req_id=#req_id#&project_id=#get_opportunity.project_id#&company_id=#get_opportunity.invoice_company_id#&partner_id=#get_opportunity.invoice_partner_id#&head=#get_opportunity_type.opportunity_type#&pcode=&type_id=#get_opportunity.req_type_id#','page')";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][4]['text'] = '#getLang('','Kanban',38272)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][4]['onClick'] = "window.open('#request.self#?fuseaction=project.projects&event=kanban&id=#get_opportunity.project_id#')";
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
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('','EKLE','57582')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=textile.list_sample_request&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('','YAZDIR','57474')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&iid=#req_id#&print_type=#191#','woc');";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=textile.list_sample_request";
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['text'] = '#getLang('','Numuneyi kopyala','62711')#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['href'] = '#request.self#?fuseaction=textile.list_sample_request&event=add&req_id=#req_id#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['det']['icons']['copy']['target'] = "_blank";
						
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('','Kaydet','57461')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			//tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['extra']['text'] = 'Oklar';
			//tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['extra']['customTag'] = '<cf_np tablename="opportunities" primary_key="req_id" pointer="req_id=#req_id#,event=upd" dsn_var="DSN3">';
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		else if(attributes.event is 'add')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('','Liste','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=textile.list_sample_request";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('','Kaydet','57461')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}

</cfscript>