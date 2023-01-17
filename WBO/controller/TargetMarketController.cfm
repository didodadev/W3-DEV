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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'campaign.list_target_markets';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/campaign/display/list_target_markets.cfm';
	
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'campaign.form_add_target_market';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/V16/campaign/form/form_add_target_market.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/campaign/query/add_target_market.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'campaign.list_target_markets&event=upd&tmarket_id=';
		
		if(isdefined("attributes.tmarket_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'campaign.form_upd_target_market';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/V16/campaign/form/form_upd_target_market.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/campaign/query/upd_target_market.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.tmarket_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'campaign.list_target_markets&event=upd&tmarket_id=';
			
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=campaign.del_target_market&tmarket_id=#attributes.tmarket_id#&head=##caller.tmarket.tmarket_no## ##caller.tmarket.tmarket_name##';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/campaign/query/del_target_market.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/campaign/query/del_target_market.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'campaign.list_target_markets';
			
		}
		
		WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
		WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'TARGET_MARKETS';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'TMARKET_ID';
		WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-tmarket_name','item-cons_age','item-cons_child','item-cons_tmarket_membership_date']";
		
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		// Tab Menus //
		tabMenuStruct = StructNew();
	
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();
		
		getLang = caller.getLang;
		
		// Upd //
		if(isdefined("attributes.event") and attributes.event is 'upd')
		{
			denied_pages = caller.denied_pages;
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=campaign.list_target_markets&event=Add";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=campaign.list_target_markets";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";	
			

			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			
			i = 0;
			if(not listfindnocase(denied_pages,'campaign.list_target_list'))
			{
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('campaign',126)#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=campaign.list_target_list&tmarket_id=#attributes.tmarket_id#";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = '_blank';
			}
			


		}
		else
		{
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=campaign.list_target_markets";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";	
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
</cfscript>
