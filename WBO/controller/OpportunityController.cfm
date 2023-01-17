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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.list_opportunity';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/sales/display/list_opportunities.cfm';
		
		if(isdefined("attributes.opp_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'sales.form_upd_opportunity';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/sales/form/upd_opportunity.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/sales/query/upd_opportunity.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'sales.list_opportunity&event=det&opp_id=';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.opp_id#';
		}
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'sales.form_add_opportunity';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/sales/form/add_opportunity.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/sales/query/add_opportunity.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'sales.list_opportunity&event=det&opp_id=';
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'upd_opp';
		
		WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
		WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'upd_kontrol() && validate().check()';

		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd,det';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'OPPORTUNITIES';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'OPP_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-opp_head','item-company','item-opp_stage','item-opportunity_type_id']";

		
		WOStruct['#attributes.fuseaction#']['det'] = structNew();
		WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'sales.form_upd_opportunity';
		WOStruct['#attributes.fuseaction#']['det']['filePath'] = '/V16/sales/form/upd_opportunity.cfm';
		WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '/V16/sales/query/upd_opportunity.cfm';
		WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'sales.list_opportunity&event=det&opp_id=';
		/* WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.opp_id##';  */
		
		if(isdefined("attributes.event") and (attributes.event is "upd" or attributes.event is 'det' or attributes.event is "del"))
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=sales.emptypopup_del_opportunity&opp_id=#attributes.opp_id#';
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
		if(isdefined("attributes.event") and not(attributes.event is 'add' or attributes.event is 'list'))
		{
			get_module_user = caller.get_module_user;
			get_opportunity = caller.get_opportunity;
			get_opportunity_type = caller.get_opportunity_type;

			tabMenuStruct = StructNew();
			tabMenuStruct['#fuseactController#'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
			
			i=0;
			if (IsDefined("get_opportunity.company_id"))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main','Üye Bilgileri',57575)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=member.form_list_company&event=det&cpid=#get_opportunity.company_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
				i = i+ 1;
			}
			else if (IsDefined("get_opportunity.consumer_id"))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main','Üye Bilgileri',57575)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=call.list_callcenter&event=det&cid=#get_opportunity.consumer_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
				i = i+ 1;
			}

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('','Etkileşimler',58729)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=call.list_callcenter&event=det&cpid=#get_opportunity.company_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
			i = i+ 1;

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] =  '#getLang('main','İş Ekle',57933)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=project.works&event=add&work_fuse=#attributes.fuseaction#&opp_id=#opp_id#&company_id=#get_opportunity.company_id#&partner_id=#get_opportunity.partner_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
			i = i+ 1;

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('sales','Teklif Ver',40807)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=sales.list_offer&event=add&opp_id=#opp_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
			i = i+ 1;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main','Harcama Talebi',58987)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=myhome.list_my_expense_requests&event=add&opp_id=#opp_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
			i = i+ 1;

			if (IsDefined("get_opportunity.project_id") and len(get_opportunity.project_id) and get_opportunity.recordcount)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('sales','Proje Detayı',40841)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=project.projects&event=det&id=#get_opportunity.project_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
				i = i+ 1;
			}
			else 
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('sales','Proje Ekle',40840)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=project.projects&event=add&opp_id=#get_opportunity.opp_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['target'] = "_blank";
				i = i+ 1;
			}
			
			if((get_module_user(11)) and session.ep.our_company_info.subscription_contract eq 1)
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main','Abone Ekle',30284)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "addSubscription();";
				i = i+ 1;
			}
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] =  '#getLang('sales','Proje Grubu',41438)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=sales.popup_add_workgroup&opp_id=#attributes.opp_id#','list');";
			i = i+ 1;
			if(session.ep.our_company_info.workcube_sector is 'tersane')
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['text'] = '#getLang('main','PBS Kodları',59035)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['det']['menus'][i]['href'] = "#request.self#?fuseaction=sales.form_add_relation_pbs&opp_id=#get_opportunity.opp_id#";
				i = i+ 1;
			}

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['text'] = '#getLang('main','Ekle',57582)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['href'] = "#request.self#?fuseaction=sales.list_opportunity&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['add']['target'] = "_blank";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['text'] = '#getLang('main','Uyarılar',57757)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=id&action_id=#attributes.opp_id#&wrkflow=1','Workflow')";

			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['text'] = '#getLang('main','Yazdır',57474)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['print']['onClick'] = "window.open('#request.self#?fuseaction=objects.popup_print_files&iid=#opp_id#','WOC');";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['list-ul']['href'] = "#request.self#?fuseaction=sales.list_opportunity";
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['check']['onClick'] = "buttonClickFunction()";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-history']['text'] = '#getLang('main','Tarihçe',57473)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['fa fa-history']['onClick'] = "openBoxDraggable('#request.self#?fuseaction=sales.popup_list_opportunity_history&opp_id=#opp_id#')";

			//tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['extra']['text'] = 'Oklar';
			//tabMenuStruct['#fuseactController#']['tabMenus']['det']['icons']['extra']['customTag'] = '<cf_np tablename="opportunities" primary_key="opp_id" pointer="opp_id=#opp_id#,event=upd" dsn_var="DSN3">';
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
		else if(attributes.event is 'add')
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main','Liste',57509)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=sales.list_opportunity";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main','Kaydet',57461)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	}

</cfscript>