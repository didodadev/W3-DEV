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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'campaign.list_campaign';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/campaign/display/list_campaign.cfm';
		
		if(isdefined("attributes.camp_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'campaign.form_upd_campaign';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/campaign/form/form_upd_campaign.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/campaign/query/upd_campaign.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.camp_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'campaign.list_campaign&event=upd&camp_id=';
		}
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'campaign.form_add_campaign';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/campaign/form/form_add_campaign.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/campaign/query/add_campaign.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'campaign.list_campaign&event=upd&camp_id=';
		
		WOStruct['#attributes.fuseaction#']['add']['formName'] = 'campaign';
		
		WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
		WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'kontrol() && validate().check()';
		
		if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
		{
			//WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=campaign.emptypopup_del_campaign&camp_id=#attributes.camp_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'campaign.list_campaign';
		}
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'CAMPAIGNS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'CAMPAIGN_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-camp_type','item-camp_startdate','item-camp_finishdate','item-camp_head']";
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		if(caller.attributes.event is 'add')
		{			
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('','list','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=campaign.list_campaign";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('','kaydet','57461')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		// Upd //
		else if(caller.attributes.event is 'upd')
		{
			getLang = caller.getLang;
			campaign = caller.campaign;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('','ekle','57582')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=campaign.list_campaign&event=add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('','list','57509')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=campaign.list_campaign";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('','kaydet','57461')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['text'] = '#getlang('','uyarılar','57757')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['bell']['onClick'] = "window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#&action_name=camp_id&action_id=#attributes.camp_id#','Workflow')";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-print']['text'] = '#getlang('','Yazdır','57474')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-print']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-print']['href'] = "#request.self#?fuseaction=objects.popup_print_files&id=#attributes.camp_id#&print_type=354";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['text'] = '#getLang('','liste yöneticisi','49382')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=campaign.list_campaign_target&camp_id=#camp_id#";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['text'] = '#getLang('','maillistesi','32440')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][1]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=campaign.popup_camp_maillist&camp_id=#campaign.camp_id#')";

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['text'] = '#getLang('','Yorumlar','58185')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][2]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=campaign.popup_view_campaign_comment&camp_id=#camp_id#')";
			
			controlParam = 3;
			if (len(attributes.project_id))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][controlParam]['text'] = '#getLang('','Proje','57416')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][controlParam]['href'] = "#request.self#?fuseaction=project.prodetail&id=#attributes.project_id#";	
				controlParam = controlParam + 1;
			}
	
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][controlParam]['text'] = '#getLang('','ödeme yöntemleri','32805')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][controlParam]['onClick'] = "openBoxDraggable('#request.self#?fuseaction=campaign.popup_list_campaign_paymethods&campaign_id=#attributes.camp_id#')";
			controlParam = controlParam + 1;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][controlParam]['text'] = '#getLang('','Kategori Segmentasyon Tanımları','49575')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=campaign.popup_add_conscat_segmentation&campaign_id=#attributes.camp_id#','list_horizantal')";
			controlParam = controlParam + 1;
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][controlParam]['text'] = '#getLang('campaign','Kategori Prim Tanımları','49574')#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][controlParam]['onClick'] = "windowopen('#request.self#?fuseaction=campaign.popup_add_conscat_premium&campaign_id=#attributes.camp_id#','horizantal')";	
			controlParam = controlParam + 1;
			
			
			//tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['extra']['customTag'] = '<cf_np tablename="campaigns" primary_key="camp_id" pointer="camp_id=#camp_id#,event=det" dsn_var="DSN3" ekstraUrlParams="event=det">';
	
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>