<cfsavecontent variable="degerleme"><cf_get_lang dictionary_id='48777.Degerleme'></cfsavecontent>
<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'add';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'credit.add_stockbond_purchase';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/credit/form/add_stockbond_purchase.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/V16/credit/query/add_stockbond_purchase.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'credit.add_stockbond_purchase&event=upd&action_id=';
		WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_ikili('add_stockbond','add_stockbond_bask');";
		
		if(isdefined("attributes.action_id"))
		{
			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'credit.upd_stockbond_purchase';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/credit/form/upd_stockbond_purchase.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/V16/credit/query/upd_stockbond_purchase.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.action_id#';
			WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'credit.add_stockbond_purchase&event=upd&action_id=';
			WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_ikili('add_stockbond','add_stockbond_bask');";	

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'credit.del_stockbond_purchase&action_id=#attributes.action_id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/credit/query/del_stockbond_purchase.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/credit/query/del_stockbond_purchase.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'credit.list_stockbond_actions';
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
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['list-ul']['href'] = "#request.self#?fuseaction=credit.list_stockbond_actions";
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['add']['icons']['check']['onClick'] = "buttonClickFunction()";
		}
		else if(caller.attributes.event is 'upd')
		{		
		
			get_bond_action = caller.GET_BOND_ACTION;
			get_stockbond_id = caller.GET_STOCKBOND_ROWS;
				
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['text'] = '#getLang('main',170)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=credit.add_stockbond_purchase";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=credit.list_stockbond_actions";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['text'] = '#getLang('main',49)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['check']['onClick'] = "buttonClickFunction()";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['text'] = '#getLang('main',97)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['list-ul']['href'] = "#request.self#?fuseaction=credit.list_stockbond_actions";
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['text'] = '#getLang('main',2577)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-table']['onClick'] = "windowopen('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.action_id#&process_cat=#get_bond_action.process_type#','page');";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['text'] = '#getLang('main',1966)#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['fa fa-info-circle']['customTag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-17' module_id='51' action_section='ACTION_ID' action_id='#attributes.action_id#'>";// Belgeler
			
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['text'] = "#getLang('main',64)#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=credit.add_stockbond_purchase&event=add&stockbond_id=#get_stockbond_id.stockbond_id#";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";

			i =0 ;
			if( get_stockbond_id.YIELD_TYPE eq 2) {
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'] = structNew();
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#degerleme#';
			tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['onclick'] = "connectAjax(#get_stockbond_id.stockbond_id#);";
			i++;
			}

			if( get_stockbond_id.YIELD_TYPE eq 1) {
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['target'] = "_blank";
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['text'] = '#getLang('','Getiri Listesi','64589')#';
				tabMenuStruct['#fuseactController#']['tabMenus']['upd']['menus'][i]['href'] = "#request.self#?fuseaction=credit.list_stockbonds&event=yieldPayment&stockbond_id=#get_stockbond_id.stockbond_id#";
			}
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'STOCKBONDS';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'STOCKBOND_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-islem','item-paper_no','item-company_id','item-partner_id','item-account_id']";

</cfscript>
